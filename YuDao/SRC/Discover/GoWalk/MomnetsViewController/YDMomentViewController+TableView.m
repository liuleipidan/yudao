//
//  YDMomentViewController+TableView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMomentViewController+TableView.h"
#import "YDUserFilesController.h"
#import "WWAVPlayerView.h"


@implementation YDMomentViewController (TableView)

- (void)registerCellToTableView:(UITableView *)tableView{
    [tableView registerClass:[YDMomentImagesCell class] forCellReuseIdentifier:@"YDMomentImagesCell"];
    [tableView registerClass:[YDMomentVideoCell class] forCellReuseIdentifier:@"YDMomentVideoCell"];
    [tableView registerClass:[YDTableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}
#pragma mark - 跳转到动态详情
/**
 跳转到动态详情

 @param model 动态
 @param row 动态所在行
 @param imageIndex 图片索引
 @param scrollToComent 是否滑动到评论
 */
- (void)pushDynamicVCWith:(YDMoment *)model
              selectedRow:(NSInteger )row
       selectedImageIndex:(NSInteger )imageIndex
      needScrollToComment:(BOOL )scrollToComent{
    YDDynamicDetailViewModel *dyViewModel = [[YDDynamicDetailViewModel alloc] initWithMoment:model];
    [dyViewModel setImageIndex:imageIndex];
    [dyViewModel setScrollToComment:scrollToComent];
    YDDynamicDetailsController *detailVC = [[YDDynamicDetailsController alloc] initWithViewModel:dyViewModel];
    detailVC.delegate = self;
    YDWeakSelf(self);
    [detailVC setNeedRefreshBlock:^{
        [weakself.momentProxy.moments removeObjectAtIndex:row];
        [weakself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - YDDynamicDetailsControllerDelegate
- (void)momentHadDeleted:(YDMoment *)moment{
    if (moment) {
        NSUInteger index = [self.momentProxy.moments indexOfObject:moment];
        [self.momentProxy.moments removeObjectAtIndex:index];
        NSLog(@"index = %lu",index);
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)moment:(YDMoment *)moment commentCountChanged:(NSInteger )count{
    if (moment) {
        moment.commentnum = @(count);
        NSInteger row = [self.momentProxy.moments indexOfObject:moment];
        YDMomentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [cell.bottomView setLeftButtonCount:moment.taplikenum centerBtnCount:moment.commentnum likeState:moment.state];
    }
}
- (void)moment:(YDMoment *)moment likeCountChanged:(NSInteger )count isLike:(BOOL)isLike{
    if (moment) {
        moment.taplikenum = @(count);
        moment.state = isLike ? @2 : @0;
        NSInteger row = [self.momentProxy.moments indexOfObject:moment];
        YDMomentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [cell.bottomView setLeftButtonCount:moment.taplikenum centerBtnCount:moment.commentnum likeState:moment.state];
    }
}

#pragma mark - YDMomentCellDelegate
//点击头像
- (void)momentHedaerViewClickUserAvatar:(YDMoment *)moment{
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:moment.ub_id];
    viewM.userName = moment.ub_nickname;
    viewM.userHeaderUrl = moment.ud_face;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    [self.parentViewController.navigationController pushViewController:userVC animated:YES];
}

//点击添加好友
- (void)momentHedaerViewClickRightButton:(UIButton *)btn moment:(YDMoment *)moment{
    if (!YDHadLogin) {
        [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        return;
    }
    if ([btn.titleLabel.text isEqualToString:@"加好友"]) {
        [YDMBPTool showNoBackgroundViewInView:btn];
        [YDNetworking GET:kAddFriendURL parameters:@{@"access_token":YDAccess_token,@"f_ub_id":moment.ub_id} success:^(NSNumber *code, NSString *status, id data) {
            if ([code isEqual:@200]) {
                [btn setTitle:@"已申请" forState:0];
                [YDDBSendFriendRequestStore insertSenderFriendRequestSenderID:[YDUserDefault defaultUser].user.ub_id receiverID:moment.ub_id];
            }
            else{
                [YDMBPTool showText:status.length > 0 ? status : @"请求发送失败"];
            }
        } failure:^(NSError *error) {
            [YDMBPTool showText:@"请求发送失败"];
        }];
    }
}

//点击图片
- (void)momentImagesViewClickImageMoment:(YDMoment *)moment atIndex:(NSInteger )index{
    [self pushDynamicVCWith:moment selectedRow:[self.momentProxy.moments indexOfObject:moment] selectedImageIndex:index needScrollToComment:NO];
}

//点击播放视频
- (void)momentImagesViewClickVideoCell:(YDMomentVideoCell *)cell imageView:(UIImageView *)imageView{
    [[WWAVPlayerView sharedPlayerView] showInView:imageView videoURL:YDURL(cell.moment.d_video) placeholderImage:imageView.image];
    self.tableView.playingCell = cell;
}
//点击赞
- (void)momentBottomViewClickLeftButton:(UIButton *)btn moment:(YDMoment *)moment{
    if (!YDHadLogin) {
        [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
            [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        }];
        return;
    }
    btn.selected = !btn.selected;
    
    NSInteger count = moment.taplikenum.integerValue;
    if (btn.selected) {
        moment.state = @2;
        count++;
    }else{
        moment.state = @1;
        count--;
    }
    moment.taplikenum = @(count);
    if (moment.taplikenum.integerValue != 0) {
        [btn setTitle:[NSString stringWithFormat:@"点赞·%@",moment.taplikenum] forState:0];
    }else{
        [btn setTitle:@"点赞" forState:0];
    }
    
    NSDictionary *param = @{@"d_id":moment.d_id,
                            @"access_token":YDAccess_token,
                            @"tl_type":@1};
    [YDNetworking POST:kAddLikedynamicURL parameters:param success:nil failure:nil];
    
}
//点击评论
- (void)momentBottomViewClickCenterButton:(UIButton *)btn moment:(YDMoment *)moment{
    if (!YDHadLogin) {
        [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
            [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        }];
        return;
    }
    [self pushDynamicVCWith:moment selectedRow:[self.momentProxy.moments indexOfObject:moment] selectedImageIndex:0 needScrollToComment:YES];
}
//点击分享
- (void)momentBottomViewClickRightButton:(UIButton *)btn moment:(YDMoment *)moment{
    __block NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:moment.d_image.count];
    [moment.d_image enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *url = [(NSString *)obj componentsSeparatedByString:@","];
        [imageUrls addObject:url.firstObject];
    }];
    NSString *title = nil;
    NSString *content = nil;
    if (YDHadLogin) {
        title = [NSString stringWithFormat:@"%@发布了新的动态：%@",moment.ub_nickname,moment.d_label];
        content = moment.d_details.length == 0 ? @"分享 @遇道" : moment.d_details;
    }else{
        title = [NSString stringWithFormat:@"分享一条来自遇道的新动态 #%@#",moment.d_label];
        content = [NSString stringWithFormat:@"分享自%@的动态，一起来看~",moment.ub_nickname];
    }
#pragma mark - 动态分享 - 逛一逛
    NSString *shareUrl = [NSString stringWithFormat:@"http://%@/app-share/dynamic.html?did=%@",kHtmlEnvironmentalKey,moment.d_id];
    AWActionSheet *sheet = [AWActionSheet actionSheetWithTouchItemBlock:^(YDClickSharePlatformType index) {
        [YDShareManager shareToPlatform:index
                                  title:title
                                content:content
                                    url:shareUrl
                             thumbImage:imageUrls.firstObject
                                  image:imageUrls
                           musicFileURL:nil
                                extInfo:nil
                               fileData:nil
                           emoticonData:nil
                               latitude:0.0
                              longitude:0.0
                               objectID:nil];
    }];
    [sheet show];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.momentProxy.moments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YDMomentCell *cell;
    YDMoment *moment = [self.momentProxy.moments objectAtIndex:indexPath.row];
    if ([moment.d_type isEqual:@1]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"YDMomentImagesCell"];
        [cell setMoment:moment];
        [cell setDelegate:self];
        return cell;
    }
    else if ([moment.d_type isEqual:@2]){
        YDMomentVideoCell *videoCell = (YDMomentVideoCell *)cell;
        videoCell = [tableView dequeueReusableCellWithIdentifier:@"YDMomentVideoCell"];
        [videoCell setMoment:moment];
        [videoCell setDelegate:self];
        videoCell.indexPath = indexPath;
        videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.tableView.maxNumCannotPlayVideoCells > 0) {
            if (indexPath.row <= self.tableView.maxNumCannotPlayVideoCells-1) {
                // 上不可及
                videoCell.cellStyle = YDMomentVideoUnreachCellStyleUp;
            }
            else if (indexPath.row >= self.self.momentProxy.moments.count-self.tableView.maxNumCannotPlayVideoCells){
                // 下不可及
                videoCell.cellStyle = YDMomentVideoUnreachCellStyleDown;
            }
            else{
                videoCell.cellStyle = YDMomentVideoUnreachCellStyleNone;
            }
        }
        else{
            videoCell.cellStyle = YDMomentVideoUnreachCellStyleNone;
        }
        return videoCell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDMoment *moment = [self.momentProxy.moments objectAtIndex:indexPath.row];
    //若出现动态类型d_type ==nil或0时高度为0
    if (moment.d_type == nil || [moment.d_type isEqual:@0]) {
        return 0;
    }
    return moment.frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell isKindOfClass:[YDMomentCell class]]) {
//        YDMomentCell *momentCell = (YDMomentCell *)cell;
//        YDMoment *moment = [self.momentProxy.moments objectAtIndex:indexPath.row];
//        [momentCell setMoment:moment];
//        [momentCell setDelegate:self];
//    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.momentProxy.moments.count) {
        YDMoment *moment = [self.momentProxy.moments objectAtIndex:indexPath.row];
        [self pushDynamicVCWith:moment selectedRow:[self.momentProxy.moments indexOfObject:moment] selectedImageIndex:0 needScrollToComment:NO];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.tableView.offsetY_last = scrollView.contentOffset.y;
}

/**
 * Called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
 * 松手时已经静止, 只会调用scrollViewDidEndDragging
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (decelerate == NO)
        // scrollView已经完全静止
        [self.tableView handleScrollStop];
}

/**
 * Called on tableView is static after finger up if the user dragged and tableView is scrolling.
 * 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // scrollView已经完全静止
    [self.tableView handleScrollStop];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(momentViewController:didScrollOffsetY:)]) {
//        [self.delegate momentViewController:self didScrollOffsetY:scrollView.contentOffset.y];
//    }

#pragma mark - 开启或关闭视频的判断
    // 处理滚动方向
    [self.tableView handleScrollDerectionWithOffset:scrollView.contentOffset.y];
    
    // Handle cyclic utilization
    // 处理循环利用
    [self.tableView handleQuickScroll];
    
#pragma mark - //上拉自动加载，x是触发操作的阀值
    CGFloat x = 0;
    if (!self.momentProxy.noMore && (scrollView.contentOffset.y >= fmaxf(.0f, scrollView.contentSize.height - scrollView.frame.size.height) + x))
    {
        //触发上拉刷新
        if (!self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer beginRefreshing];
        } 
    }
}

@end

//
//  YDUserFilesController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 16/12/29.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUserFilesController+Delegate.h"



@implementation YDUserFilesController (Delegate)

- (void)registerCellClass{
    
    //基础信息(ID,爱车,常出没地点)
    [self.tableView registerClass:[YDUserBaseInfoCell class] forCellReuseIdentifier:@"YDUserBaseInfoCell"];
    //认证信息(头像，视频，支付宝，车辆，OBD)
    [self.tableView registerClass:[YDUserBaseAuthCell class] forCellReuseIdentifier:@"YDUserBaseAuthCell"];
    //兴趣信息(最多五个)
    [self.tableView registerClass:[YDUserBaseInterestCell class] forCellReuseIdentifier:@"YDUserBaseInterestCell"];
    
}

- (void)pushDynamicVCWith:(YDMoment *)model
              selectedRow:(NSInteger )row
       selectedImageIndex:(NSInteger )imageIndex
      needScrollToComment:(BOOL )scrollToComent{
    YDDynamicDetailViewModel *dyViewModel = [[YDDynamicDetailViewModel alloc] initWithMoment:model];
    [dyViewModel setImageIndex:imageIndex];
    [dyViewModel setScrollToComment:scrollToComent];
    YDDynamicDetailsController *detailVC = [[YDDynamicDetailsController alloc] initWithViewModel:dyViewModel];
    detailVC.delegate = self;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - YDDynamicDetailsControllerDelegate
- (void)momentHadDeleted:(YDMoment *)moment{
    if (moment) {
        NSUInteger index = [self.viewModel.dynamics indexOfObject:moment];
        [self.viewModel.dynamics removeObjectAtIndex:index];
        [self.dynamicTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)moment:(YDMoment *)moment commentCountChanged:(NSInteger )count{
    if (moment) {
        moment.commentnum = @(count);
        NSInteger row = [self.viewModel.dynamics indexOfObject:moment];
        YDMomentCell *cell = [self.dynamicTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [cell.bottomView setLeftButtonCount:moment.taplikenum centerBtnCount:moment.commentnum likeState:moment.state];
    }
}
- (void)moment:(YDMoment *)moment likeCountChanged:(NSInteger )count isLike:(BOOL)isLike{
    if (moment) {
        moment.taplikenum = @(count);
        moment.state = isLike ? @2 : @0;
        NSInteger row = [self.viewModel.dynamics indexOfObject:moment];
        YDMomentCell *cell = [self.dynamicTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [cell.bottomView setLeftButtonCount:moment.taplikenum centerBtnCount:moment.commentnum likeState:moment.state];
    }
}

#pragma mark  - YDUFHeaderViewDelegate
- (void)UFHeaderView:(YDUFHeaderView *)headerView didSelectedHeaderImageView:(UIImageView *)headerImageV{
    YDPictureBrowseTransitionParameter *param = [YDPictureBrowseTransitionParameter new];
    param.transitionImage = headerImageV.image;
    CGRect imageFrame = [headerImageV.superview convertRect:headerImageV.frame toView:nil];
    param.firstVCImgFrames = [NSArray arrayWithObject:[NSValue valueWithCGRect:imageFrame]];
    param.transitionImgIndex = 0;
    
    self.animatedTransition = nil;
    self.animatedTransition.transitionParameter = param;
    
    YDPictureBrowseViewController *picVC = [YDPictureBrowseViewController new];
    YDPictureBrowseSouceModel *model = [YDPictureBrowseSouceModel new];
    model.image = headerImageV.image;
    picVC.dataSouceArray = [NSArray arrayWithObject:model];
    picVC.animatedTransition = self.animatedTransition;
    picVC.transitioningDelegate = self.animatedTransition;
    
    [self presentViewController:picVC animated:YES completion:nil];
}

#pragma mark - YDUserFilesBottomViewDelegate
//MARK:点击底部Button
- (void)userFilesBottomView:(YDUserFilesBottomView *)bottomView didSelectedButton:(UIButton *)sender{
    if (!YDHadLogin) {
        [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
            [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        }];
        return;
    }
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"喜欢"] || [title isEqualToString:@"已喜欢"]) {
        NSString *url = nil;
        if ([title isEqualToString:@"喜欢"]) {
            url = kAddLikeUserURL;
        }
        if (sender.selected) {
            url = kDeleteEnjoyUrl;
        }
        sender.selected = !sender.selected;
        NSDictionary *parameters = @{@"access_token":YDAccess_token,
                                     @"ub_id":self.userInfo.ub_id,
                                     @"type":@1
                                     };
        [YDNetworking POST:url parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
            YDLog(@"%s like success",__func__);
        } failure:^(NSError *error) {
            YDLog(@"%s like failure",__func__);
        }];
        
    }else if ([title isEqualToString:@"加好友"]){
        NSLog(@"sender = %@",sender);
        [YDMBPTool showNoBackgroundViewInView:sender offset:CGPointMake(65, 0)];
        NSDictionary *param = @{
                                @"access_token":YDAccess_token,
                                @"f_ub_id":_viewModel.uid
                                };
        [YDNetworking GET:kAddFriendURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
            if ([code isEqual:@200]) {
                [sender setTitle:@"已申请" forState:0];
                sender.enabled = NO;
                [YDDBSendFriendRequestStore insertSenderFriendRequestSenderID:[YDUserDefault defaultUser].user.ub_id receiverID:self.viewModel.uid];
                [YDMBPTool showSuccessImageWithMessage:@"请求成功" hideBlock:nil];
            }
            else{
                [YDMBPTool showInfoImageWithMessage:@"请求失败" hideBlock:nil];
            }
        } failure:^(NSError *error) {
            NSLog(@"error = %@",error);
            [YDMBPTool showInfoImageWithMessage:@"请求失败" hideBlock:nil];
        }];
    }
    else if ([title isEqualToString:@"发消息"]){
        NSInteger currentVCLevel = [self.navigationController currentLevelWithClassName:NSStringFromClass(self.class)];
        id lastVC = [self.navigationController findViewControllerWithLevel:currentVCLevel-1];
        //如果前一个界面时聊天界面直接pop
        if ([lastVC isKindOfClass:NSClassFromString(@"YDChatController")]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            YDChatController *chatVC = [YDChatController shareChatVC];
            YDChatPartner *partner = YDCreateChatPartner(_viewModel.uid, _viewModel.userName, _viewModel.userHeaderUrl, 0);
            [chatVC setPartner:partner];
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    }
}

#pragma mark - YDDynamicsTableViewDelegate
- (void)momentImagesViewClickImageMoment:(YDMoment *)moment atIndex:(NSInteger )index{
    [self pushDynamicVCWith:moment selectedRow:[self.viewModel.dynamics indexOfObject:moment] selectedImageIndex:index needScrollToComment:NO];
}
- (void)dynamicsTableView:(YDDynamicsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YDMoment *moment = [self.viewModel.dynamics objectAtIndex:indexPath.row];
    [self pushDynamicVCWith:moment selectedRow:[self.viewModel.dynamics indexOfObject:moment] selectedImageIndex:0 needScrollToComment:NO];
}
- (void)momentBottomViewClickLeftButton:(UIButton *)btn moment:(YDMoment *)moment{
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

- (void)momentBottomViewClickCenterButton:(UIButton *)btn moment:(YDMoment *)moment{
    [self pushDynamicVCWith:moment selectedRow:[self.viewModel.dynamics indexOfObject:moment] selectedImageIndex:0 needScrollToComment:YES];
}

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
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 3) {
        YDUserBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUserBaseInfoCell"];
        cell.model = self.userInfoArray[indexPath.row];
        if (indexPath.row == 2) {
            cell.bottomLine.hidden = YES;
        }
        return cell;
    }
    if (indexPath.row == 3) {
        YDUserBaseAuthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUserBaseAuthCell"];
        cell.authArray = self.userInfoArray[indexPath.row];
        return cell;
    }
    if (indexPath.row == 4) {
        YDUserBaseInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUserBaseInterestCell"];
        cell.f_tags = self.f_tags;
        cell.interestArray = self.userInfoArray[indexPath.row];
        
        return cell;
    }
    
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 3) {
        return 45.f;
    }
    if (indexPath.row == 3) {
        return 210.f;
    }
    if (indexPath.row == 4) {
        return 80.f;
    }
    return 0;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;//scrollview当前显示区域定点相对于fram顶点的偏移量
    CGRect bounds = scrollView.bounds;//原点
    CGSize size = scrollView.contentSize;//scrollview可以滚动的区域
    UIEdgeInsets inset = scrollView.contentInset;//scrollview的contentview的顶点相对于scrollview的位置
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    if (currentOffset >= maximumOffset) {
        YDLog(@"滑到底部");
        scrollView.contentOffset = CGPointMake(0, maximumOffset - bounds.size.height);
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.tableView.y != 0) {
        return;
    }
    //下滑隐藏头部背景图片
    if (offsetY < 0) {
        self.headerView.backImageV.hidden = YES;
    }else{
        self.headerView.backImageV.hidden = NO;
    }
    //下滑到个人动态
    if (offsetY < -kHeight(100)) {
        self.title = @"个人动态";
        self.bottomView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.y += SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.scrollBackView.hidden = NO;
            }];
        }];
    }
}

@end

//
//  YDUserDynamicViewController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/11.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDUserDynamicViewController+Delegate.h"
#import "WWAVPlayerView.h"

@implementation YDUserDynamicViewController (Delegate)

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
        NSUInteger index = [self.dynamicProxy.dynamics indexOfObject:moment];
        [self.dynamicProxy.dynamics removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)moment:(YDMoment *)moment commentCountChanged:(NSInteger )count{
    if (moment) {
        moment.commentnum = @(count);
        NSInteger row = [self.dynamicProxy.dynamics indexOfObject:moment];
        YDMomentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [cell.bottomView setLeftButtonCount:moment.taplikenum centerBtnCount:moment.commentnum likeState:moment.state];
    }
}
- (void)moment:(YDMoment *)moment likeCountChanged:(NSInteger )count isLike:(BOOL)isLike{
    if (moment) {
        moment.taplikenum = @(count);
        moment.state = isLike ? @2 : @0;
        NSInteger row = [self.dynamicProxy.dynamics indexOfObject:moment];
        YDMomentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [cell.bottomView setLeftButtonCount:moment.taplikenum centerBtnCount:moment.commentnum likeState:moment.state];
    }
}

#pragma mark - YDDynamicsTableViewDelegate
- (void)momentImagesViewClickImageMoment:(YDMoment *)moment atIndex:(NSInteger )index{
    [self pushDynamicVCWith:moment selectedRow:[self.dynamicProxy.dynamics indexOfObject:moment] selectedImageIndex:index needScrollToComment:NO];
}

- (void)dynamicsTableView:(YDDynamicsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YDMoment *moment = [self.dynamicProxy.dynamics objectAtIndex:indexPath.row];
    [self pushDynamicVCWith:moment selectedRow:[self.dynamicProxy.dynamics indexOfObject:moment] selectedImageIndex:0 needScrollToComment:NO];
}

//点击播放视频
- (void)momentImagesViewClickVideoCell:(YDMomentVideoCell *)cell imageView:(UIImageView *)imageView{
    [[WWAVPlayerView sharedPlayerView] showInView:imageView videoURL:YDURL(cell.moment.d_video) placeholderImage:imageView.image];
    self.tableView.playingCell = cell;
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
    [self pushDynamicVCWith:moment selectedRow:[self.dynamicProxy.dynamics indexOfObject:moment] selectedImageIndex:0 needScrollToComment:YES];
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

@end

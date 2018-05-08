//
//  YDRankListViewController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2017/1/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDRankListViewController+Delegate.h"

@implementation YDRankListViewController (Delegate)

#pragma mark - YDPopupControllerDelegate
- (void)popupControllerDidDismiss:(nonnull YDPopupController *)controller isTapBackgroud:(BOOL)isTapBackgroud{
    if (isTapBackgroud) {
        [self.filterView setCondition:self.filterView.condition];
    }
}

#pragma mark - YDAddMenuViewDelegate
- (void)addMenuView:(YDAddMenuView *)addMenuView didSelectedItem:(YDAddMenuItem *)item{
    if (item.type == YDAddMneuTypeFilter) {
        
        [self.popControoler presentPopupControllerAnimated:YES];
        
    }
    else if (item.type == YDAddMneuTypeShare){
        NSString *url = nil;
        if (YDHadLogin) {
            url = [NSString stringWithFormat:kRankListShareURL_hadLogin,kHtmlEnvironmentalKey,YDAccess_token,self.currentRankListIndex+1];
        }else{
            url = [NSString stringWithFormat:kRankListShareURL_notLogin,kHtmlEnvironmentalKey,self.currentRankListIndex+1];
        }
        
        NSString *title = @"";
        NSString *content = @"";
        YDRankingListModel *userData = self.currentRankingVC.viewModel.currentUserData;
        if (!YDHadLogin || userData == nil) {
            title = @"遇车会友，驭车有道，谁是极速之王？";
            content = @"遇道行车排行榜，谁是极速之王，快来与老司机一争高下。";
        }else{
            YDUser *user = [YDUserDefault defaultUser].user;
            switch (self.currentRankListIndex) {
                case 0://里程
                {
                    title = @"老司机的极速之王排行榜，不服来战！";
                    content = [NSString stringWithFormat:@"%@昨天开了%@公里，服不服？",user.ub_nickname,userData.oti_mileage];
                    break;}
                case 1://时速
                {
                    title = [NSString stringWithFormat:@"%@公里/H，差点就上天了！",userData.oti_speed];
                    content = [NSString stringWithFormat:@"%@昨天的时速%@公里/H，就问你服不服？",user.ub_nickname,userData.oti_speed];
                    break;}
                case 2://油耗
                {
                    title = [NSString stringWithFormat:@"100公里油耗%@L，这才是真正的老司机！",userData.oti_oilwear];
                    content = [NSString stringWithFormat:@"%@昨天油耗%@L，节能环保又经济。",user.ub_nickname,userData.oti_oilwear];
                    break;}
                case 3://滞留
                {
                    title = [NSString stringWithFormat:@"行进在龟速榜的%@：堵车%@分钟。",user.ub_nickname,userData.oti_stranded];
                    content = [NSString stringWithFormat:@"%@的“手推车”龟速行驶了%@分钟。",user.ub_nickname,userData.oti_stranded];
                    break;}
                case 4://积分
                {
                    title = [NSString stringWithFormat:@"积分大满贯：%@，定个小目标：先来一个亿！",userData.ud_credit];
                    content = [NSString stringWithFormat:@"%@的遇道积分：%@，排名第%@！",user.ub_nickname,userData.ud_credit,userData.ranking];
                    break;}
                case 5://喜欢
                {
                    title = [NSString stringWithFormat:@"粉丝%@人，我就是遇道的新晋网红",userData.enjoynum];
                    content = [NSString stringWithFormat:@"遇道新晋网红榜排名%@位：%@，超过%@人喜欢TA，一起来捧个场吧。",userData.ranking,user.ub_nickname,userData.enjoynum];
                    break;}
                default:
                    break;
            }
        }
        AWActionSheet *sheet = [AWActionSheet actionSheetWithTouchItemBlock:^(YDClickSharePlatformType index) {
            [YDShareManager shareToPlatform:index
                                      title:title
                                    content:content
                                        url:url
                                 thumbImage:YDImage(@"YuDaoLogo")
                                      image:YDImage(@"YuDaoLogo")
                               musicFileURL:nil
                                    extInfo:nil
                                   fileData:nil
                               emoticonData:nil
                                   latitude:0.0
                                  longitude:0.0 objectID:nil];
        }];
        [sheet show];
    }
}

@end

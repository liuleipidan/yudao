//
//  YDHPMessageController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHPMessageController+Delegate.h"
#import "YDWeatherController.h"
#import "YDIgnoreView.h"
#import "YDWeeklyReportController.h"
#import "YDActivityWebController.h"
#import "YDTrafficInfoManager.h"
#import "YDSettingHelper.h"
#import "YDServiceDetailsController.h"
#import "YDCardDetailsController.h"

#define kHPMessage_weather      @7000
#define kHPMessage_weeklyReport @2001
#define kHPMessage_activity     @9002
#define kHPMessage_coupon       @9003

@implementation YDHPMessageController (Delegate)

- (void)registerCells{
    [self.tableView registerClass:[YDHPMessageWeatherCell class] forCellReuseIdentifier:@"YDHPMessageWeatherCell"];
    [self.tableView registerClass:[YDHPMessageWeeklyReportCell class] forCellReuseIdentifier:@"YDHPMessageWeeklyReportCell"];
    [self.tableView registerClass:[YDHPMessageActivityCell class] forCellReuseIdentifier:@"YDHPMessageActivityCell"];
    [self.tableView registerClass:[YDHPMessageCouponCell class] forCellReuseIdentifier:@"YDHPMessageCouponCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}

#pragma mark - YDUserDefaultDelegate
- (void)defaultUserAlreadyLogged:(YDUser *)user{
    [[YDPushMessageManager sharePushMessageManager] post_requestHomePageMessagesByCurrentUserToken:YDAccess_token];
}

- (void)defaultUserExitingLogin{
    self.data = nil;
    [self.tableView reloadData];
    if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(HPMessageController:dataSourceDidChanged:)]) {
        [self.messageDelegate HPMessageController:self dataSourceDidChanged:0.0];
    }
}

#pragma mark - YDPushMessageManagerDelegate
- (void)receivedHomePageMessages:(NSArray<YDPushMessage *> *)messages{
    
    if (messages.count > 0) {
        [self.data removeAllObjects];
        __block NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:messages.count];
        [messages enumerateObjectsUsingBlock:^(YDPushMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //需要先检查是否显示
            if ([YDHPIgnoreStore checkTwentyFourHoursMessagesIngnoreBySubtype:obj.msgSubtype.integerValue]) {
                YDHPMessageModel *model = [YDHPMessageModel createHPMessageModelByPushMessage:obj];
                [tempArr addObject:model];
            }
        }];
        self.data = tempArr;
        [self.tableView reloadData];
        if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(HPMessageController:dataSourceDidChanged:)]) {
            CGFloat height = self.data.count * kHPMessageTableViewRowHeight;
            [self.messageDelegate HPMessageController:self dataSourceDidChanged:height];
        }
    }
    else if (!YDHadLogin || messages == nil || messages.count == 0){
        self.data = nil;
        if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(HPMessageController:dataSourceDidChanged:)]) {
            [self.messageDelegate HPMessageController:self dataSourceDidChanged:0.0];
        }
    }
}

#pragma mark - YDHPMessageCellDelegate
- (void)HPMessageCellMoreButtonClicked:(YDHPMessageModel *)model rect:(CGRect )rect{
    YDWeakSelf(self);
    [YDIgnoreView showAtFrame:rect type:YDIgnoreViewTypeDefault clickedBlock:^(NSUInteger index) {
        [weakself.data removeObject:model];
        [weakself.tableView reloadData];
        if (weakself.messageDelegate && [weakself.messageDelegate respondsToSelector:@selector(HPMessageController:dataSourceDidChanged:)]) {
            CGFloat height = weakself.data.count * kHPMessageTableViewRowHeight;
            [weakself.messageDelegate HPMessageController:weakself dataSourceDidChanged:height];
        }
        
        //更新数据库
        YDHPIgnoreModel *ignore = [YDHPIgnoreModel createIgnoreModelByModuleType:YDHomePageModuleTypeMessages subType:model.type];
        ignore.ignore_type = @(index);
        [YDSettingHelper addHPIgnoreByIgnoreModel:ignore success:nil failure:nil];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"EmptyCell";
    YDHPMessageBaseCell *cell;
    YDHPMessageModel *model = [self.data objectAtIndex:indexPath.row];
    if (model.type == YDServerMessageTypeWeather) {
        cellId = @"YDHPMessageWeatherCell";
    }
    else if (model.type == YDServerMessageTypeWeeklyReport){
        cellId = @"YDHPMessageWeeklyReportCell";
    }
    else if (model.type == YDServerMessageTypeMarketingActivity){
        cellId = @"YDHPMessageActivityCell";
    }
    else if (model.type == YDServerMessageTypeCouponSend){
        cellId = @"YDHPMessageCouponCell";
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ([cell isKindOfClass:[YDHPMessageBaseCell class]]) {
        [cell setModel:model];
        [cell setDelegate:self];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YDHPMessageModel *model = [self.data objectAtIndex:indexPath.row];
    if (model.type == YDServerMessageTypeWeather) {
        YDWeatherController *weaVC = [YDWeatherController new];
        [self.parentViewController.navigationController pushViewController:weaVC animated:YES];
    }
    else if (model.type == YDServerMessageTypeWeeklyReport){
        YDWeeklyReportController *wrVC = [[YDWeeklyReportController alloc] init];
        [self.parentViewController.navigationController pushViewController:wrVC animated:YES];
    }
    else if (model.type == YDServerMessageTypeMarketingActivity){
        if (model.aid) {
            YDActivity *activity = [[YDActivity alloc] init];
            activity.aid = model.aid;
            activity.title = model.text;
            activity.img_url = model.imageUrl;
            YDActivityWebController *webVC = [[YDActivityWebController alloc] init];
            webVC.activity = activity;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        else if (![model.activity_type isEqual:@1] && model.activity_url.length != 0){
            YDWKWebViewController *wkVC = [[YDWKWebViewController alloc] init];
            [wkVC setUrlString:model.activity_url];
            [self.navigationController pushViewController:wkVC animated:YES];
        }
    }
    else if (model.type == YDServerMessageTypeCouponSend){
        YDCardDetailsController *cardDetailsVC = [[YDCardDetailsController alloc] init];
        YDCard *card = [[YDCard alloc] init];
        card.couponId = model.coupon_id;
        card.name = model.coupon_name;
        [cardDetailsVC setCoupon:card];
        [self.navigationController pushViewController:cardDetailsVC animated:YES];
    }
}

@end

//
//  YDSettingHelper.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSettingHelper.h"
#import "YDHPIgnoreStore.h"


@implementation YDSettingHelper

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Public Methods
+ (void)addHPIgnoreByIgnoreModel:(YDHPIgnoreModel *)model
                         success:(void (^)(YDHPIgnoreModel * model))success
                         failure:(void (^)(void))failure{
    NSDictionary *para = @{@"access_token":YDAccess_token,
                           @"ptype":model.ptype,
                           @"ctype":model.subtype,
                           @"neglect":model.ignore_type};
    YDLog(@"添加忽略设置参数 = %@",para);
    [YDNetworking GET:kAddUserHPIgnoreURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        
        if ([code isEqual:@200]) {
            YDHPIgnoreModel * model = [YDHPIgnoreModel mj_objectWithKeyValues:data];
            model.time = [NSDate stringWithDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
            YDHPIgnoreStore *store = [YDHPIgnoreStore manager];
            if ([store addHPIgnoreModel:model]) {
                YDLog(@"插入本地设置表成功");
                [YDNotificationCenter postNotificationName:kHPModuleHadChangeNotificatoin object:model];
            }
            if (success) {
                success(model);
            }
        }
        else{
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

+ (void)deleteHPIgnoreBy:(YDHPIgnoreModel *)model
                 success:(void (^)(void))success
                 failure:(void (^)(void))failure{
    if (model == nil || model.rid == nil || [model.rid isEqual:@0]) {
        if (failure) {
            failure();
        }
        return;
    }
    NSDictionary *para = @{@"access_token":YDAccess_token,
                           @"hm_id":model.rid};
    [YDNetworking GET:kDeleteUserHPIgnoreURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        YDLog(@"delete setting code = %@",code);
        if ([code isEqual:@200]) {
            YDHPIgnoreStore *store = [YDHPIgnoreStore manager];
            if ([store deleteHPIgnore:model.rid userId:model.uid]) {
                YDLog(@"删除本地设置表成功");
            }
            [YDNotificationCenter postNotificationName:kHPModuleHadChangeNotificatoin object:model];
            if (success) {
                success();
            }
        }else{
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

#pragma mark - Getter
- (NSMutableArray *)mainSettingData{
    if (_mainSettingData == nil) {
        _mainSettingData = [NSMutableArray array];
        YDSettingItem *item1 = YDCreateSettingItem(@"消息通知");
        YDSettingItem *item2 = YDCreateSettingItem(@"功能设置");
        YDSettingGroup *group1 = YDCreateSettingGroup(nil, nil, (@[item1,item2]));
        
        YDSettingItem *item3 = YDCreateSettingItem(@"清除缓存");
        YDSettingGroup *group2 = YDCreateSettingGroup(nil, nil, (@[item3]));
        
        YDSettingItem *item4 = YDCreateSettingItem(@"意见反馈");
        YDSettingItem *item5 = YDCreateSettingItem(@"关于我们");
        YDSettingItem *item6 = YDCreateSettingItem(@"用户使用协议");
        YDSettingGroup *group3 = YDCreateSettingGroup(nil, nil, (@[item4,item5,item6]));
        
        YDSettingItem *item7 = YDCreateSettingItem(@"退出登录");
        item7.type = YDSettingItemTypeTitleButton;
        YDSettingGroup *group4 = YDCreateSettingGroup(nil, nil, (@[item7]));
        
        [self.mainSettingData addObjectsFromArray:@[group1,group2,group3,group4]];
    }
    return _mainSettingData;
}

- (NSMutableArray *)functionSettingData{
    if (_functionSettingData == nil) {
        _functionSettingData = [NSMutableArray array];
        
        YDSettingItem *item1 = YDCreateSettingItem(@"遇道成长任务");
        item1.type = YDSettingItemTypeSwitch;
        item1.ignoreModel = YDCheckHPIgnoreExist(YDUser_id, 2, 0, 2) ? : [YDHPIgnoreModel createIgnoreModelByModuleType:YDHomePageModuleTypeTask subType:0];
        item1.prompt = @"关闭后，首页将不再显示任务模块。";
        YDSettingGroup *group1 = YDCreateSettingGroup(nil, @"关闭后，首页将不再显示任务模块。", (@[item1]));
        YDSettingItem *item2 = YDCreateSettingItem(@"排行榜");
        item2.type = YDSettingItemTypeSwitch;
        item2.ignoreModel = YDCheckHPIgnoreExist(YDUser_id, 4, 0, 2) ? : [YDHPIgnoreModel createIgnoreModelByModuleType:YDHomePageModuleTypeRankList subType:0];
        item2.prompt = @"关闭后，首页将不再显示排行榜模块。";
        YDSettingGroup *group2 = YDCreateSettingGroup(nil, @"关闭后，首页将不再显示排行榜模块。", (@[item2]));
        
        YDSettingItem *item3 = YDCreateSettingItem(@"行车信息");
        item3.type = YDSettingItemTypeSwitch;
        item3.ignoreModel = YDCheckHPIgnoreExist(YDUser_id, 1, 0, 2) ? : [YDHPIgnoreModel createIgnoreModelByModuleType:YDHomePageModuleTypeCarInfo subType:0];
        item3.prompt = @"关闭后，将无法再首页查看您的行车情况。";
        YDSettingGroup *group3 = YDCreateSettingGroup(@"以下功能需结合\"遇道VE-BOX\"使用", @"关闭后，将无法再首页查看您的行车情况。", (@[item3]));
        
        YDSettingItem *item4 = YDCreateSettingItem(@"每周车辆使用报告");
        item4.type = YDSettingItemTypeSwitch;
        item4.ignoreModel = YDCheckHPIgnoreExist(YDUser_id, 3, 2001, 2) ? : [YDHPIgnoreModel createIgnoreModelByModuleType:YDHomePageModuleTypeMessages subType:YDServerMessageTypeWeeklyReport];
        item4.prompt = @"关闭后，将无法在首页查看每周车辆使用周报。";
        YDSettingGroup *group4 = YDCreateSettingGroup(nil, @"关闭后，将无法在首页查看每周车辆使用周报。", (@[item4]));
        [_functionSettingData addObjectsFromArray:@[group1,group2,group3,group4]];
    }
    return _functionSettingData;
}

- (NSMutableArray *)messageSettingData{
    if (_messageSettingData == nil) {
        _messageSettingData = [NSMutableArray array];
        YDSettingItem *item1 = YDCreateSettingItem(@"每日天气消息通知");
        item1.type = YDSettingItemTypeSwitch;
        item1.ignoreModel = YDCheckHPIgnoreExist(YDUser_id, 3, 7000, 2) ? : [YDHPIgnoreModel createIgnoreModelByModuleType:YDHomePageModuleTypeMessages subType:YDServerMessageTypeWeather];
        item1.prompt = @"关闭后，将不接收每日天气预报推送提示消息。";
        YDSettingGroup *group1 = YDCreateSettingGroup(nil, @"关闭后，将不接收每日天气预报推送提示消息。", (@[item1]));
        
        [_messageSettingData addObjectsFromArray:@[group1]];
    }
    return _messageSettingData;
}

@end

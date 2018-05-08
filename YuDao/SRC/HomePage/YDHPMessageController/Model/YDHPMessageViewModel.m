//
//  YDHPMessageViewModel.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHPMessageViewModel.h"

@interface YDHPMessageViewModel()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation YDHPMessageViewModel


- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

@end

@implementation YDHPMessageModel

+ (instancetype)createHPMessageModelByPushMessage:(YDPushMessage *)message{
    YDHPMessageModel *model = [[YDHPMessageModel alloc] init];
    
    model.type = message.msgSubtype.integerValue;
    model.time = [NSDate yd_timeInformationFromTimestamp:[NSString stringWithFormat:@"%@",message.time]];
    model.content = message.content;
    
    if (model.type == YDServerMessageTypeWeather) {
        model.title = @"天气预报";
        model.iconPath = @"homePage_message_weather";
    }
    else if (model.type == YDServerMessageTypeWeeklyReport){
        model.title = @"每周车况周报";
        model.iconPath = @"homePage_message_weeklyReport";
    }
    else if (model.type == YDServerMessageTypeCouponSend){
        model.title = @"我的卡券";
        model.iconPath = @"homePage_message_coupon";
    }
    else if (model.type == YDServerMessageTypeMarketingActivity){
        model.title = @"热门活动";
        model.iconPath = @"homePage_message_activity";
    }
    
    return model;
}

#pragma mark - Getter

- (NSNumber *)aid{
    return [self.contentDic objectForKey:@"aid"];
}

- (NSString *)text{
    return [self.contentDic objectForKey:@"text"];
}

- (NSNumber *)activity_type{
    return [self.contentDic objectForKey:@"type"];
}

- (NSString *)imageUrl{
    return [self.contentDic objectForKey:@"image"];
}

- (NSString *)activity_url{
    return [self.contentDic objectForKey:@"url"];
}

- (NSNumber *)coupon_id{
    return [self.contentDic objectForKey:@"coupon_id"];
}

- (NSString *)coupon_name{
    return [self.contentDic objectForKey:@"coupon_name"];
}

- (NSDictionary *)contentDic{
    if (_contentDic == nil) {
        if (self.content.length == 0) {
            _contentDic = @{};
        }
        else{
            _contentDic = [self.content mj_JSONObject];
        }
    }
    return _contentDic;
}

@end

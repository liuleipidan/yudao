//
//  YDHPMessageViewModel.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDHPMessageViewModel : NSObject



@end


@interface YDHPMessageModel : NSObject

@property (nonatomic, assign) YDServerMessageType type;

@property (nonatomic, copy  ) NSString *iconPath;

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, copy  ) NSString *time;

@property (nonatomic, copy  ) NSString *content;

/**
 content解析后的字典
 */
@property (nonatomic, strong) NSDictionary *contentDic;

@property (nonatomic, copy  ) NSString *text;

#pragma mark - 活动
@property (nonatomic, copy  ) NSNumber *aid;

@property (nonatomic, copy  ) NSString *imageUrl;

@property (nonatomic, strong) NSNumber *activity_type;

@property (nonatomic, copy  ) NSString *activity_url;

#pragma mark - 卡券
@property (nonatomic, strong) NSNumber *coupon_id;
@property (nonatomic, copy  ) NSString *coupon_name;

+ (instancetype)createHPMessageModelByPushMessage:(YDPushMessage *)message;

@end

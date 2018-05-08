//
//  YDSettingItem.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDHPIgnoreModel.h"

#define YDCreateSettingItem(title) [YDSettingItem createItemWithTitle:title]

typedef NS_ENUM(NSInteger, YDSettingItemType) {
    YDSettingItemTypeDefault = 0,
    YDSettingItemTypeTitleButton,
    YDSettingItemTypeSwitch,
    YDSettingItemTypeOther,
};

@interface YDSettingItem : NSObject

/**
 主标题
 */
@property (nonatomic, copy  ) NSString *title;

/**
 副标题
 */
@property (nonatomic, copy  ) NSString *subTitle;

/**
 关闭提示信息
 */
@property (nonatomic, copy  ) NSString *prompt;

/**
 右侧图片（本地）
 */
@property (nonatomic, copy  ) NSString *rightImagePath;

/**
 右侧图片（网络）
 */
@property (nonatomic, copy  ) NSString *rightImageURL;

/**
 是否显示箭头（default：YES）
 */
@property (nonatomic, assign) BOOL showDisclosureIndicator;

/**
 停用高亮（default：NO）
 */
@property (nonatomic, assign) BOOL disableHighlight;

/**
 switch开关的状态，默认YES
 */
@property (nonatomic, assign) BOOL switchStatus;

/**
 忽略模型，对应本地数据库和服务器数据
 */
@property (nonatomic, strong) YDHPIgnoreModel *ignoreModel;

/**
 cell类型，默认default
 */
@property (nonatomic, assign) YDSettingItemType type;

+ (YDSettingItem *)createItemWithTitle:(NSString *)title;

- (NSString *)cellClassName;

@end

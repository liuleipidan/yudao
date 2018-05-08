//
//  YDCarInfoItem.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/17.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YDCreateCarInfoItem(Title, SubTitle, Type) [YDCarInfoItem createItemTitle:Title subTitle:SubTitle type:Type]

typedef NS_ENUM(NSInteger, YDCarInfoItemType) {
    YDCarInfoItemTypePlateNumber = 0,
    YDCarInfoItemTypeInput,
    YDCarInfoItemTypeArrow,
};

@interface YDCarInfoItem : NSObject

@property (nonatomic, assign) YDCarInfoItemType type;

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, copy  ) NSString *subTitle;

@property (nonatomic, copy  ) NSString *placeholder;

@property (nonatomic, assign) NSUInteger limit;

//车牌头，只有YDCarInfoPlateNumberCell用到
@property (nonatomic, copy  ) NSString *prefix;

//是否显示箭头，默认YES
@property (nonatomic, assign, getter=isShowDisclosureIndicator) BOOL showDisclosureIndicator;

+ (YDCarInfoItem *)createItemTitle:(NSString *)title subTitle:(NSString *)subTitle type:(YDCarInfoItemType)type;

+ (NSArray *)createItemsByCarInfo:(YDCarDetailModel *)carInfo isAddCar:(BOOL)isAddCar;

@end

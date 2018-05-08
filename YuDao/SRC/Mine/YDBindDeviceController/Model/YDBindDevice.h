//
//  YDBindDevice.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

//item的类型
typedef NS_ENUM(NSInteger,YDBindDeviceCellType) {
    YDBindDeviceCellTypeNone = 0, //无
    YDBindDeviceCellTypeArrow,    //箭头
    YDBindDeviceCellTypeScanner,  //扫描
};

@interface YDBindDevice : NSObject

@property (nonatomic, assign) YDBindDeviceCellType type;

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, copy  ) NSString *subTitle;

@property (nonatomic, copy  ) NSString *placeholder;

@property (nonatomic, assign) NSUInteger textFieldLimit;

@property (nonatomic, copy  ) NSString *rightImagePath;

+ (NSArray *)bindDeviceItemByCar:(YDCarDetailModel *)car
                      deviceType:(YDBindDeviceType)deviceType;

+ (YDBindDevice *)createBindDevice:(YDBindDeviceCellType )type
                             title:(NSString *)title
                       placeholder:(NSString *)placeholder;

@end

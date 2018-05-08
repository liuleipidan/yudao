//
//  YDPlacePickerTool.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/26.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDDBPlaceStore.h"

@interface YDPlacePickerTool : NSObject

@property (nonatomic,copy) void (^doneButtonActionBlock )(NSNumber *proId,NSString *proName,NSNumber *cityId,NSString *cityName,NSNumber *areaId,NSString *areaName);

+ (YDPlacePickerTool *)sharedInstance;

- (void)requestPlaceData;

- (void)setSelectedProvinName:(NSString *)provinceName cityName:(NSString *)cityName areaName:(NSString *)areaName;

- (void)show;

- (void)dismiss;

@end

//
//  YDDatePickerTool.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDPopupController.h"
#import "YDActionSheetToolBar.h"

@interface YDDatePickerTool : NSObject

//初始化时间,默认为当前时间
@property (nonatomic, strong) NSDate *startDate;

//最大时间间隔，默认为0即当前时间
@property (nonatomic,assign) NSInteger maxInterval;

//最小时间间隔，默认为往前推一百年
@property (nonatomic,assign) NSInteger minInterval;

@property (nonatomic,copy) void (^doneButtonAction )(NSDate *date);


- (void)show;

- (void)dismiss;

@end

//
//  YDTitlePickerTool.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/25.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDPopupController.h"
#import "YDActionSheetToolBar.h"

typedef NS_ENUM(NSInteger, YDTitlePickerToolType) {
    YDTitlePickerToolTypeGender = 0,
    YDTitlePickerToolTypeEmotion,
};

@interface YDTitlePickerTool : NSObject

@property (nonatomic, assign) YDTitlePickerToolType type;

@property (nonatomic, copy  ) NSString *originalTitle;

@property (nonatomic,copy) void (^doneButtonActionBlock)(NSString *selectedTitle, NSInteger row);

- (void)show;

- (void)dismiss;

@end

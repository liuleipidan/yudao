//
//  YDActionSheetToolBar.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDActionSheetTitleBarButtonItem.h"

@interface YDActionSheetToolBar : UIToolbar

@property(nullable, nonatomic, strong) UIBarButtonItem *cancelButton;

@property (nonatomic, strong) YDActionSheetTitleBarButtonItem * _Nullable titleButton;

@property(nullable, nonatomic, strong) UIBarButtonItem *doneButton;

- (void)setCancelButtonTarget:(id _Nullable )target action:(SEL _Nullable )action;

- (void)setDoneButtonTarget:(id _Nullable )target action:(SEL _Nullable )action;

@end

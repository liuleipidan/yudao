//
//  UITextField+Extension.h
//  YuDao
//
//  Created by 汪杰 on 17/3/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)

//限制长度,到达长度后是否隐藏键盘
- (void)limtTextLength:(NSInteger )limit hideKeyboard:(BOOL )hideKeyboard;

@end

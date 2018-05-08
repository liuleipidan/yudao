//
//  YDLimitTextField.h
//  YuDao
//
//  Created by 汪杰 on 17/2/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDLimitTextField : UITextField

//限制长度值，默认是0，不限制
@property (nonatomic,assign) NSInteger limit;

/**
 到限制长度后隐藏键盘，默认是NO
 */
@property (nonatomic,assign) BOOL hideKeyboard;

/**
 当text改变时调用，默认为nil
 */
@property (nonatomic,copy) void (^textDidChangeBlock) (NSString *text);

- (instancetype)initWithLimit:(NSInteger )limit;

- (instancetype)initWithFrame:(CGRect)frame limit:(NSInteger )limt;


@end

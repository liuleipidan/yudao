//
//  YDHomePageModel.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 首页子模块类
 */
@interface YDHomePageModel : NSObject

//标题
@property (nonatomic, copy  ) NSString *title;

//控制器
@property (nonatomic, strong) UIViewController *vc;

//视图高
@property (nonatomic, assign) CGFloat viewHeight;

//是否显示
@property (nonatomic, assign, getter=isShow) BOOL show;

@end






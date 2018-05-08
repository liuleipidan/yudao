//
//  YDTestTitleView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDTestTitleView : UIView

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic,copy) void (^TTTapChangeCarBlock )(void);

@end

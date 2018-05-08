//
//  YDCarPaopaoView.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

///我的爱车泡泡view
@interface YDCarPaopaoView : UIView

@property (nonatomic, copy  ) NSString *distance;

@property (nonatomic,copy) void (^selectedGoBlock) (void);

@end

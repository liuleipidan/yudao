//
//  YDRescueBottomTool.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDRescueBottomTool;
@protocol YDRescueBottomToolDelegate <NSObject>

- (void)rescueBottomTool:(YDRescueBottomTool *)tool selectedBtn:(UIButton *)btn;

@end

@interface YDRescueBottomTool : UIView

@property (nonatomic,weak) id<YDRescueBottomToolDelegate> delegate;

@end

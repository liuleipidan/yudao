//
//  YDDynamicDetailsBottomView.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDDynamicDetailsBottomView;
@protocol YDDynamicDetailsBottomViewDelegate <NSObject>

- (void)dynamicDetailsBottomView:(YDDynamicDetailsBottomView *)view didSelectedBtn:(UIButton *)btn;

@end

@interface YDDynamicDetailsBottomView : UIView

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *centerBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic,weak) id<YDDynamicDetailsBottomViewDelegate> delegate;

@end

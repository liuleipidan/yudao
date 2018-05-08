//
//  YDPlaceholderView.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 占位图类型

 - YDPlaceholderViewTypeFailure: 加载失败
 - YDPlaceholderViewTypeNoData: 无此类数据
 */
typedef NS_ENUM(NSInteger,YDPlaceholderViewType) {
    YDPlaceholderViewTypeFailure = 0,
    YDPlaceholderViewTypeNoData,
};

@class YDPlaceholderView;
@protocol YDPlaceholderViewDelegate <NSObject>

- (void)placeholderView:(YDPlaceholderView *)view reloadButtonDidClicked:(UIButton *)sender;

@end

@interface YDPlaceholderView : UIView

@property (nonatomic,assign,readonly) YDPlaceholderViewType type;

@property (nonatomic, weak ,readonly) id<YDPlaceholderViewDelegate> delegate;

/**
 刷新按钮标题
 */
@property (nonatomic, copy  ) NSString *reloadButtonTitle;

/**
 暂无数据图片
 */
@property (nonatomic, strong) UIImage *noDataImage;

/**
 暂无数据标题
 */
@property (nonatomic, copy  ) NSString *noDataTitle;

/**
 x轴偏移值
 */
@property (nonatomic,assign) CGFloat xOffset;

/**
 y轴偏移值，默认向上偏移32，用以适配导航栏存在的情况
 */
@property (nonatomic,assign) CGFloat yOffset;

@property (nonatomic,copy) void (^reloadBtnActionBlock )(void);

- (instancetype)initWithFrame:(CGRect)frame
                         type:(YDPlaceholderViewType )type
         reloadBtnActionBlock:(void (^)(void))reloadBtnActionBlock;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(YDPlaceholderViewType )type
                     delegate:(id)delegate;


- (void)showInView:(UIView *)view;

@end

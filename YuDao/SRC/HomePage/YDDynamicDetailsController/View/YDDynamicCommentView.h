//
//  YDDynamicCommentView.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/10.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDDynamicCommentView;
@protocol YDDynamicCommentViewDelegate <NSObject>

@required
- (void)dynamicCommentView:(YDDynamicCommentView *)view didClickedSendWithText:(NSString *)text;

@optional
- (void)dynamicCommentViewWillShow:(YDDynamicCommentView *)view;

- (void)dynamicCommentViewWillHide:(YDDynamicCommentView *)view;

@end

@interface YDDynamicCommentView : UIView

@property (nonatomic, weak  ) id<YDDynamicCommentViewDelegate> delegate;

//占位符
@property (nonatomic, copy  ) NSString *placeholderText;

- (void)show;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end

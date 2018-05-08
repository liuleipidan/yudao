//
//  YDSystemMessageBaseCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/31.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDSystemMessage.h"

@protocol YDSystemMessageCellDelegate <NSObject>

@optional

//点击查看／重新提交
- (void)systemMessage:(YDSystemMessage *)message didClickedLookLabel:(UILabel *)label;

//点击背景视图
- (void)systemMessageDidClickedBackgroundView:(YDSystemMessage *)message;

//长按背景视图
- (void)systemMessageDidLongPressBackgroundView:(YDSystemMessage *)message rect:(CGRect)rect;

@end

@interface YDSystemMessageBaseCell : UITableViewCell
{
    UIView *_borderView;
    YDSystemMessage *_message;
}

@property (nonatomic, weak  ) id<YDSystemMessageCellDelegate> delegate;

@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) YDSystemMessage *message;

@end

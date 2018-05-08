//
//  YDTableViewSingleLineCell.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/30.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 TableViewCell的分割线类型

 - YDCellSingleLineStyleNone: 无
 - YDCellSingleLineStyleDefault: 间距10
 - YDCellSingleLineStyleFill: 充满
 */
typedef NS_ENUM(NSInteger, YDCellSingleLineStyle) {
    YDCellSingleLineStyleNone,
    YDCellSingleLineStyleDefault,
    YDCellSingleLineStyleFill,
};

@interface YDTableViewSingleLineCell : UITableViewCell

/**
 分割线高度，默认1
 */
@property (nonatomic,assign) CGFloat separatorLineHeight;

/**
 左边距，默认10
 */
@property (nonatomic,assign) CGFloat leftSeparatorSpace;

/**
 右边距，默认10
 */
@property (nonatomic,assign) CGFloat rightSeparatorSpace;

/**
 顶部分割线类型，默认-YDCellSingleLineStyleNone
 */
@property (nonatomic,assign) YDCellSingleLineStyle topLineStyle;

/**
 底部分割线类型
 */
@property (nonatomic,assign) YDCellSingleLineStyle bottomLineStyle;

/**
 分割线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

@end

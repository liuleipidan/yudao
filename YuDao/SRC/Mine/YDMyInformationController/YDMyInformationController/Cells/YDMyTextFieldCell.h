//
//  YDMyInfoInputCell.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/18.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTableViewSingleLineCell.h"
#import "YDLimitTextField.h"
#import "YDMyInfoItem.h"

typedef NS_ENUM(NSInteger, YDMyTextFieldCellType) {
    YDMyTextFieldCellTypeNickName = 0,
    YDMyTextFieldCellTypeRealName,
};

@class YDMyTextFieldCell;
@protocol YDMyTextFieldCellDelegate <NSObject>

- (void)myTextFieldCell:(YDMyTextFieldCell *)cell
         textDidChanged:(NSString *)text;

@end

@interface YDMyTextFieldCell : YDTableViewSingleLineCell

@property (nonatomic, weak  ) id<YDMyTextFieldCellDelegate> delegate;

@property (nonatomic, strong) YDMyInfoItem *item;

@end

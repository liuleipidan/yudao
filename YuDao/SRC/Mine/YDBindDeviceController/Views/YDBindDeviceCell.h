//
//  YDBindDeviceCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTableViewSingleLineCell.h"
#import "YDBindDevice.h"

@class YDBindDeviceCell;
@protocol YDBindDeviceCellDelegate <NSObject>

- (void)bindDeviceCell:(YDBindDeviceCell *)cell didTouchScannerButton:(UIButton *)btn;

- (void)bindDeviceCell:(YDBindDeviceCell *)cell textFieldTextDidChange:(NSString *)text;

@end

@interface YDBindDeviceCell : YDTableViewSingleLineCell

@property (nonatomic, weak  ) id<YDBindDeviceCellDelegate> delegate;

@property (nonatomic, strong) YDBindDevice *item;

@end

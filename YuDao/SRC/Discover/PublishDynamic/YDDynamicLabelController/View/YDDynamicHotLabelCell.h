//
//  YDDynamicHotLabelCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/3.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDDynamicHotLabelCell;
@protocol YDDynamicHotLabelCellDelegate <NSObject>

@required
- (void)dynamicHotLabelCell:(YDDynamicHotLabelCell *)cell didSelctedLabel:(NSString *)label;

@end

@interface YDDynamicHotLabelCell : UITableViewCell

@property (nonatomic, weak  ) id<YDDynamicHotLabelCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *labels;

@end

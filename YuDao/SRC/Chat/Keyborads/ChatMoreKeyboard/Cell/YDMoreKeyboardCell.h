//
//  YDMoreKeyboardCell.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDMoreKeyboardItem.h"

@interface YDMoreKeyboardCell : UICollectionViewCell

@property (nonatomic, strong) YDMoreKeyboardItem *item;

@property (nonatomic,copy) void (^clickBlock) (YDMoreKeyboardItem *item);

@end

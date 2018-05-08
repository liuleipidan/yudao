//
//  YDPublishDynamicImagesView.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDPublishDynamicModel.h"
#import "YDPublishDynamicCellDelegate.h"

@interface YDPublishDynamicImagesView : UIView<YDPublishDynamicCellDelegate>

@property (nonatomic, weak  ) id<YDPublishDynamicCellDelegate> delegate;

@property (nonatomic, strong) YDPublishDynamicModel *item;

@end

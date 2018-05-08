//
//  YDDDImagesCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/20.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDynamicDetailModel.h"

@class YDDDImagesCell;
@protocol YDDDImagesCellDelegate <NSObject>

- (void)dynamicImagesCell:(YDDDImagesCell *)cell selectedImageIndex:(NSUInteger )index;

@end

@interface YDDDImagesCell : UITableViewCell

@property (nonatomic, weak  ) id<YDDDImagesCellDelegate> delegate;

@property (nonatomic, strong) YDDynamicDetailModel *item;

@property (nonatomic, strong) UIView *imageViews;

@end

//
//  YDDDVideoCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/20.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDynamicDetailModel.h"

@class YDDDVideoCell;
@protocol YDDDVideoCellDelegate <NSObject>

- (void)dynamicVideoCellDidClickedVideo:(YDDDVideoCell *)cell;

@end

@interface YDDDVideoCell : UITableViewCell

@property (nonatomic, weak  ) id<YDDDVideoCellDelegate> delegate;

@property (nonatomic, strong) YDDynamicDetailModel *item;

//视频缩略图
@property (nonatomic, strong) UIImageView *thumbnailImageView;

//播放按钮
@property (nonatomic, strong) UIImageView *playIcon;

@end

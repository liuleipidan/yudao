//
//  YDPDImageCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDPublishDynamicCellDelegate.h"

@interface YDPDImageCell : UICollectionViewCell

@property (nonatomic, weak  ) id<YDPublishDynamicCellDelegate> delegate;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) NSInteger imageIndex;

//是否为视频，默认为NO
@property (nonatomic, assign) BOOL isVideo;

@end

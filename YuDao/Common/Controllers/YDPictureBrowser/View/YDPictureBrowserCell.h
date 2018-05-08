//
//  YDPictureBrowserCell.h
//  FollowMe
//
//  Created by liyang on 16/10/12.
//  Copyright © 2016年 FM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDBrowseZoomScrollView.h"
#import "YDPictureBrowseSouceModel.h"

@protocol YDPictureBrowserCellDelegate <NSObject>

- (void)imageViewClick:(NSInteger)cellIndex;

@end

@interface YDPictureBrowserCell : UICollectionViewCell

@property (nonatomic, weak)   id <YDPictureBrowserCellDelegate> delegate;
@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, strong) YDBrowseZoomScrollView *pictureImageScrollView;

- (void)showWithModel:(YDPictureBrowseSouceModel *)model;

@end

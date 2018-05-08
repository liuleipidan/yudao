//
//  YDEmojiBaseCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDEmoji.h"

@protocol YDEmojiCellProtocl <NSObject>

- (CGRect)displayBaseRect;

@end

@interface YDEmojiBaseCell : UICollectionViewCell<YDEmojiCellProtocl>

@property (nonatomic, strong) YDEmoji *item;

@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) UIImage *highlightImage;

@property (nonatomic, assign) BOOL showHighlightImage;

@end

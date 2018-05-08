//
//  YDMoreKeyboard.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBaseKeyboard.h"
#import "YDMoreKeyboardItem.h"

@class YDMoreKeyboard;
@protocol YDMoreKeyboardDelegate <NSObject>

@optional;
- (void)moreKeyboard:(YDMoreKeyboard *)keyboard didSelectedItem:(YDMoreKeyboardItem *)item;

@end

@interface YDMoreKeyboard : YDBaseKeyboard

@property (nonatomic,weak) id<YDMoreKeyboardDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *moreKeyboardData;

@property (nonatomic, strong) UICollectionView *collectionView;

+ (YDMoreKeyboard *)keyboard;

@end

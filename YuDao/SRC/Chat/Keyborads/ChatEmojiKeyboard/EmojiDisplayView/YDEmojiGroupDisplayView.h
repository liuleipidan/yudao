//
//  YDEmojiGroupDisplayView.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDEmojiGroupDisplayViewDelgate.h"
#import "YDEmojiGroupDisplayModel.h"

@interface YDEmojiGroupDisplayView : UIView

@property (nonatomic, weak  ) id<YDEmojiGroupDisplayViewDelgate> delegate;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSMutableArray *displayData;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger curPageIndex;



@end

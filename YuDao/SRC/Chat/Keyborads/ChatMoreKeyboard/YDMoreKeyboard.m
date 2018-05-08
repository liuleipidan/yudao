//
//  YDMoreKeyboard.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMoreKeyboard.h"
#import "YDMoreKeyboard+CollectionView.h"

static YDMoreKeyboard  *moreKB = nil;
@implementation YDMoreKeyboard

+ (YDMoreKeyboard *)keyboard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moreKB = [[YDMoreKeyboard alloc] init];
    });
    return moreKB;
}

- (id)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor colorGrayForChatBar]];
        [self addSubview:self.collectionView];
        [self y_addMasonry];
        
        [self registerCellClass];
    }
    return self;
}

- (CGFloat)keyboardHeight{
    return HEIGHT_CHAT_KEYBOARD/2.0f;
}

- (void)setMoreKeyboardData:(NSMutableArray *)moreKeyboardData{
    _moreKeyboardData = moreKeyboardData;
    [self.collectionView reloadData];
}

- (void)y_addMasonry{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorGrayLine].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, SCREEN_WIDTH, 0);
    CGContextStrokePath(context);
}

#pragma mark - Getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
    }
    return _collectionView;
}

@end

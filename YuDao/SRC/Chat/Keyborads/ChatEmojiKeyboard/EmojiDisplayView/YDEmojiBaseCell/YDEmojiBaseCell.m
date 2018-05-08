//
//  YDEmojiBaseCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDEmojiBaseCell.h"

@implementation YDEmojiBaseCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setItem:(YDEmoji *)item{
    if (item && ![_item.emojiID isEqualToString:item.emojiID]) {
        _item = item;
    }
}

#pragma mark - YDEmojiCellProtocl
- (CGRect)displayBaseRect{
    return self.frame;
}

#pragma mark - Setter
- (void)setShowHighlightImage:(BOOL)showHighlightImage{
    if (showHighlightImage) {
        [self.bgView setImage:self.highlightImage];
    }
    else{
        [self.bgView setImage:nil];
    }
}

#pragma mark - Getter
- (UIImageView *)bgView{
    if (_bgView == nil) {
        _bgView = [UIImageView new];
        _bgView.layer.cornerRadius = 5.0f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

@end

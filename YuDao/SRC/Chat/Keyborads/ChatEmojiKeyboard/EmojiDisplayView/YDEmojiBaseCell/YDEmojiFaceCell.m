//
//  YDEmojiFaceCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDEmojiFaceCell.h"

@interface YDEmojiFaceCell()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;


@end

@implementation YDEmojiFaceCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView yd_addSubviews:@[self.imageView,self.label]];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageView);
        }];
    }
    return self;
}

- (void)setItem:(YDEmoji *)item{
    [super setItem:item];
    
    [self.imageView setImage:[UIImage imageNamed:item.emojiPath]];
}

#pragma mark - Getters
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UILabel *)label{
    if (_label == nil) {
        _label = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_18] textAlignment:NSTextAlignmentCenter];
    }
    return _label;
}

@end

//
//  YDMineCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMineCell.h"

@interface YDMineCell()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *redCountLabel;

@end

@implementation YDMineCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self mc_initSubviews];
        [self mc_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setItem:(YDMineMenuItem *)item{
    _item = item;
    _imageView.image = YDImage(item.iconPath);
    _titleLabel.text = item.title;
    
    [self markAsUnreadCount:item.unredCount];
}

#pragma mark - Privated Methods
//标记未读
- (void)markAsUnreadCount:(NSInteger )count{
    NSString *text = @"";
    if (count > 99) {
        text = @"99+";
    }else{
        text = [NSString stringWithFormat:@"%ld",count];
    }
    CGFloat width = 20;
    if (text.length == 2) {
        width = 25;
    }
    else if (text.length == 3){
        width = 35;
    }
    
    _redCountLabel.hidden = count == 0;
    _redCountLabel.text = text;
    [_redCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    
}

- (void)mc_initSubviews{
    _imageView = [UIImageView new];
    
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14] textAlignment:NSTextAlignmentCenter];
    
    _redCountLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor redColor]];
    _redCountLabel.layer.cornerRadius = 10.0f;
    _redCountLabel.clipsToBounds = YES;
    
    [self.contentView yd_addSubviews:@[_imageView,_titleLabel,_redCountLabel]];
}

- (void)mc_addMasonry{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.mas_equalTo(28);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_imageView.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [_redCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView.mas_right).offset(5);
        make.top.equalTo(_imageView.mas_top);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(0);
    }];
}

@end

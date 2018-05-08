//
//  YDActivityCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDActivityCell.h"

@interface YDActivityCell()

@property (nonatomic, strong) UIImageView *bgImgV;

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *subImgV;

@property (nonatomic, strong) UILabel *subTitle;

@end

@implementation YDActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)setModel:(YDActivity *)model{
    _model = model;
    
    [_bgImgV yd_setImageFadeinWithString:model.img_url];
    
    _titleLabel.text = model.title;
    
    _subTitle.text = model.joinString;
    
    CGSize subTitleSize = [_subTitle sizeThatFits:CGSizeMake(MAXFLOAT, 17)];
    [_subTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(subTitleSize.width);
    }];
}

- (void)initSubviews{
    _bgImgV = [UIImageView new];
    _bgImgV.clipsToBounds = YES;
    _bgImgV.contentMode = UIViewContentModeScaleAspectFill;
    _bgImgV.layer.cornerRadius = 8.0;
    [self.contentView addSubview:_bgImgV];
    
    _alphaView = [UIView new];
    _alphaView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    
    _titleLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_16]];
    
    _subImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_avtivity_count"]];
    
    _subTitle = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentRight];
    
    [_bgImgV yd_addSubviews:@[_alphaView,_titleLabel,_subImgV,_subTitle]];
    
    [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    [_alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgImgV);
        make.height.mas_equalTo(34);
    }];
    _subTitle.numberOfLines = 0;
    [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImgV).offset(-10);
        make.height.mas_equalTo(17);
        make.centerY.equalTo(self.alphaView);
    }];
    
    [_subImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.subTitle.mas_left).offset(-3);
        make.centerY.equalTo(self.alphaView);
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(11);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.alphaView);
        make.left.equalTo(self.bgImgV).offset(10);
        make.height.mas_equalTo(22);
        make.right.equalTo(self.subImgV.mas_left).offset(-5);
    }];
    
}

@end

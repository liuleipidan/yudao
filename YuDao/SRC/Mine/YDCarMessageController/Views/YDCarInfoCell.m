//
//  YDCarInfoCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/17.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarInfoCell.h"

@interface YDCarInfoCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation YDCarInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self ci_initSubviews];
        [self ci_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setItem:(YDCarInfoItem *)item{
    _item = item;
    
    _titleLabel.text = item.title;
    _subTitleLabel.text = item.subTitle;
    
    _arrowImageView.hidden = !item.showDisclosureIndicator;
}

#pragma mark - Private Methods
- (void)ci_initSubviews{
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    
    _subTitleLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_16]];
    _subTitleLabel.backgroundColor = [UIColor whiteColor];
    
    _arrowImageView = [[UIImageView alloc] initWithImage:YDImage(@"tableViewCell_arrow_right")];
    
    [self.contentView yd_addSubviews:@[_titleLabel,_subTitleLabel,_arrowImageView]];
}

- (void)ci_addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(140);
        make.right.equalTo(self.contentView).offset(-42);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(47, 46));
        make.right.equalTo(self.contentView.mas_right);
    }];
}

@end

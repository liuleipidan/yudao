//
//  YDCarIllegalityCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/19.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarIllegalityCell.h"

@interface YDCarIllegalityCell()

@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) UILabel *monthLabel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *addressTitleLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *contentTitleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *horLineView;

@property (nonatomic, strong) UIView *verLineView;

@property (nonatomic, strong) UILabel *finesLabel;

@property (nonatomic, strong) UILabel *scoreLabel;

@end

@implementation YDCarIllegalityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self ci_initSubviews];
        [self ci_addMasonry];
    }
    return self;
}

- (void)setItem:(YDIllegalModel *)item{
    _item = item;
    
    _dayLabel.text = item.day;
    _monthLabel.text = item.month;
    
    _addressLabel.text = item.address;
    [_addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(item.addressHeight);
    }];
    _contentLabel.text = item.content;
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(item.contentHeight);
    }];
    
    NSString *finesStr = [NSString stringWithFormat:@"罚款   %@",YDNoNilNumber(item.price)];
    NSString *scoreStr = [NSString stringWithFormat:@"扣分   %@",YDNoNilNumber(item.score)];
    UIColor *finesColor = [UIColor redColor];
    UIColor *scoreColor = [UIColor redColor];
    if (item.price == nil || [item isEqual:@0]) {
        finesColor = [UIColor blackTextColor];
    }
    if (item.score == nil || [item.score isEqual:@0]) {
        scoreColor = [UIColor blackTextColor];
    }
    
    [self.finesLabel yd_setText:finesStr color1:[UIColor blackTextColor] color2:finesColor];
    [self.scoreLabel yd_setText:scoreStr color1:[UIColor blackTextColor] color2:scoreColor];
}


#pragma mark - Private Methods
- (void)ci_initSubviews{
    _dayLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:24]];
    
    _monthLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:14]];
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 8.0f;
    _bgView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    _bgView.layer.shadowColor = [UIColor shadowColor].CGColor;
    _bgView.layer.shadowOpacity = 1;
    
    _addressTitleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    _addressTitleLabel.text = @"地点：";
    
    _addressLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    _addressLabel.numberOfLines = 0;
    
    _contentTitleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    _contentTitleLabel.text = @"违章：";
    
    _contentLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    _contentLabel.numberOfLines = 0;
    
    _horLineView = [UIView new];
    _horLineView.backgroundColor = [UIColor tableViewSectionHeaderViewBackgoundColor];
    
    _verLineView = [UIView new];
    _verLineView.backgroundColor = [UIColor tableViewSectionHeaderViewBackgoundColor];
    
    _finesLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
    _finesLabel.text = @"罚款";
    
    _scoreLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
    _scoreLabel.text = @"扣分";
    
    [self.contentView yd_addSubviews:@[_dayLabel,_monthLabel,_bgView,_addressTitleLabel,_addressLabel,_contentTitleLabel,_contentLabel,_horLineView,_verLineView,_finesLabel,_scoreLabel]];
}

- (void)ci_addMasonry{
    UIView *contentView = self.contentView;
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(10);
        make.left.equalTo(contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dayLabel);
        make.top.equalTo(_dayLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(30, 25));
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(62);
        make.top.equalTo(contentView).offset(10);
        make.bottom.equalTo(contentView).offset(-10);
        make.right.equalTo(contentView).offset(-10);
    }];
    
    [_addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(20);
        make.left.equalTo(contentView).offset(72);
        make.height.mas_lessThanOrEqualTo(20);
        make.width.mas_lessThanOrEqualTo(50);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressTitleLabel.mas_top);
        make.left.equalTo(contentView).offset(114);
        make.right.equalTo(contentView).offset(-20);
    }];
    
    [_contentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressLabel.mas_bottom).offset(8);
        make.left.equalTo(_addressTitleLabel.mas_left);
        make.height.mas_lessThanOrEqualTo(20);
        make.width.mas_lessThanOrEqualTo(50);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentTitleLabel.mas_top);
        make.left.equalTo(_addressLabel.mas_left);
        make.right.equalTo(_addressLabel.mas_right);
    }];
    
    [_horLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressTitleLabel.mas_left);
        make.right.equalTo(_addressLabel.mas_right);
        make.bottom.equalTo(contentView).offset(-44);
        make.height.mas_equalTo(1);
    }];
    
    [_verLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView);
        make.top.equalTo(_horLineView.mas_bottom).offset(9);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(1);
    }];
    
    [_finesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView.mas_left).offset(5);
        make.right.equalTo(_verLineView.mas_left).offset(-5);
        make.centerY.equalTo(_verLineView);
        make.height.mas_equalTo(24);
    }];
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_verLineView.mas_right).offset(5);
        make.right.equalTo(_bgView.mas_right).offset(-5);
        make.centerY.equalTo(_verLineView);
        make.height.mas_equalTo(24);
    }];
}



@end

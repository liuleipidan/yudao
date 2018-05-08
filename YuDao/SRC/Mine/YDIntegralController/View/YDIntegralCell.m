//
//  YDIntegralCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDIntegralCell.h"

@interface YDIntegralCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation YDIntegralCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self ic_initSubviews];
        [self ic_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setItem:(YDIntegral *)item{
    _item = item;
    _titleLabel.text = item.c_content.length == 0 ? @"积分变动" : item.c_content;
    NSString *prefix = [item.c_modified isEqualToString:@"1"] ? @"+":@"-";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",prefix,item.c_credit]];
    [attributedString addAttributes:@{
                                      NSBaselineOffsetAttributeName: @(2)} range:NSMakeRange(0, 1)];
    [_subTitleLabel setAttributedText:attributedString];
    
    NSDate *date = [NSDate dateFromTimeStamp:item.c_time];
    _timeLabel.text = [date formatYMD];
}

#pragma mark - Private Methods
- (void)ic_initSubviews{
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    
    _subTitleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16]];
    
    _timeLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14]];
    
    [self.contentView yd_addSubviews:@[_titleLabel,_subTitleLabel,_timeLabel]];
}

- (void)ic_addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-80);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(60);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(150);
    }];
}

@end

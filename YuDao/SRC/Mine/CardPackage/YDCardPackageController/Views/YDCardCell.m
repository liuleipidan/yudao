//
//  YDCardCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCardCell.h"

@interface YDCardCell()

/**
 背景
 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

/**
 类型
 */
@property (nonatomic, strong) UILabel *typeLabel;

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 公司
 */
@property (nonatomic, strong) UILabel *companyLabel;

/**
 时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 状态
 */
@property (nonatomic, strong) UIImageView *stateImageView;

@end

@implementation YDCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self cc_initSubviews];
        [self cc_addMasonry];
        
    }
    
    return self;
}

#pragma mark - Public Methods
- (void)setCard:(YDCard *)card{
    _card = card;
    
    if (card.isExpired || ![card.status isEqual:@1]) {
        _backgroundImageView.image = YDImage(@"mine_coupon_background_invaild");
        _typeLabel.textColor = [UIColor lineColor1];
    }
    else{
        _backgroundImageView.image = YDImage(@"mine_coupon_background_normal");
        _typeLabel.textColor = [UIColor orangeTextColor];
    }
    
    _typeLabel.text = card.typeTitle;
    
    _titleLabel.text = card.name;
    
    _companyLabel.text = card.provider;
    
    if ([card.expires isEqual:@0]) {
        _timeLabel.text = @"无时间限制";
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"%@-%@",[NSDate formatYear_Month_Day:card.startTime],[NSDate formatYear_Month_Day:card.endTime]];
    }
    
    _stateImageView.image = YDImage(card.statusIconPath);
    
}

#pragma mark - Private Methods
- (void)cc_initSubviews{
    _backgroundImageView = [[UIImageView alloc] init];
    
    _typeLabel = [UILabel labelByTextColor:[UIColor orangeTextColor] font:[UIFont font_16] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
    _typeLabel.layer.cornerRadius = kWidth(30)/2.0;
    _typeLabel.clipsToBounds = YES;
    
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_18] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    
    _companyLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    
    _timeLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    
    _stateImageView = [[UIImageView alloc] init];
    
    [self.contentView yd_addSubviews:@[_backgroundImageView,_typeLabel,_titleLabel,_companyLabel,_timeLabel,_stateImageView]];
    
}

- (void)cc_addMasonry{
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kWidth(20));
        make.width.height.mas_equalTo(kWidth(30));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kWidth(75));
        make.top.equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(25);
        make.right.equalTo(_stateImageView.mas_left).offset(0);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(self.contentView).offset(-kHeight(17));
        make.height.mas_equalTo(17);
        make.right.equalTo(_titleLabel.mas_right);
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(_timeLabel.mas_top).offset(-kHeight(4));
        make.height.mas_equalTo(17);
        make.right.equalTo(_titleLabel.mas_right);
    }];
    
    [_stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backgroundImageView);
        make.right.equalTo(_backgroundImageView).offset(-19);
        make.size.mas_equalTo(CGSizeMake(kWidth(66), kHeight(50)));
    }];
}

@end

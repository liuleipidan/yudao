//
//  YDAdviseAnswerView.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDAdviseAnswerView.h"

@interface YDAdviseAnswerView()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end


@implementation YDAdviseAnswerView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor grayBackgoundColor];
        
        [self av_initSubviews];
        [self av_addMasonry];
    }
    return self;
}

- (void)setItem:(YDAdviseAnswer *)item{
    _item = item;
    _nameLabel.text = item.name;
    NSDate *date = [NSDate dateFromTimeStamp:item.time];
    _timeLabel.text = [date formatYMD];
    
    _contentLabel.text = item.content;
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(item.contentHeight);
    }];
}

#pragma mark - Private Methods
- (void)av_initSubviews{
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor orangeTextColor];
    
    _nameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    
    _timeLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12]];
    
    _contentLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    _contentLabel.numberOfLines = 0;
    
    [self yd_addSubviews:@[_lineView,_nameLabel,_timeLabel,_contentLabel]];
    
}
- (void)av_addMasonry{
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(3, 16));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(5);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(1);
        make.left.equalTo(self.nameLabel.mas_left);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(7);
        make.right.equalTo(self).offset(-12);
    }];
}

@end

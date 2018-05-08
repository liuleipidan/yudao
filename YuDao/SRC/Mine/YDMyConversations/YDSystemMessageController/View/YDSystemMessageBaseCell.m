//
//  YDSystemMessageBaseCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/31.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSystemMessageBaseCell.h"

@interface YDSystemMessageBaseCell()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation YDSystemMessageBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor grayBackgoundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.borderView];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(17.5);
            make.height.mas_equalTo(20);
            make.width.mas_lessThanOrEqualTo(150);
        }];
        
        [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-7.5);
        }];
    }
    return self;
}

- (void)setMessage:(YDSystemMessage *)message{
    if (_message && [_message.msgId isEqual:message.msgId]) {
        return;
    }
    
    _message = message;
    
    if (message.showTime) {
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"  %@  ",message.timeInfo];
        [_borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(52.5);
        }];
    }
    else{
        _timeLabel.hidden = YES;
        _timeLabel.text = @"";
        [_borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(7.5);
        }];
    }
}

#pragma mark - Event
//单击
- (void)sm_didClickedBackgroundView:(UIGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(systemMessageDidClickedBackgroundView:)]) {
        [_delegate systemMessageDidClickedBackgroundView:self.message];
    }
}
//长按
- (void)sm_didLongPressBackgroundView:(UIGestureRecognizer *)press{
    if (_delegate && [_delegate respondsToSelector:@selector(systemMessageDidLongPressBackgroundView:rect:)]) {
        CGRect rect = self.borderView.frame;
        rect.size.height -= 10;
        [_delegate systemMessageDidLongPressBackgroundView:self.message rect:rect];
    }
}

#pragma mark - Getters
- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter backgroundColor:YDColor(216, 216, 216, 1)];
        _timeLabel.layer.cornerRadius = 4.0f;
        _timeLabel.clipsToBounds = YES;
    }
    return _timeLabel;
}

- (UIView *)borderView{
    if (_borderView == nil) {
        _borderView = [UIView new];
        _borderView.backgroundColor = [UIColor whiteColor];
        _borderView.layer.borderColor = [UIColor shadowColor].CGColor;
        _borderView.layer.borderWidth = 1.0f;
        _borderView.layer.cornerRadius = 8.0f;
        _borderView.clipsToBounds = YES;
        [_borderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sm_didClickedBackgroundView:)]];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sm_didLongPressBackgroundView:)];
        longPress.minimumPressDuration = 0.5;
        [_borderView addGestureRecognizer:longPress];
    }
    return _borderView;
}

@end

//
//  YDHPMessageActivityCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHPMessageActivityCell.h"

@interface YDHPMessageActivityCell()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *lookBtn;

/**
 覆盖层
 */
@property (nonatomic, strong) UIView *overView;

@end

@implementation YDHPMessageActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLabel.textColor = [UIColor whiteColor];
        self.timeLabel.textColor = [UIColor whiteColor];
        
        [self.contentView insertSubview:self.overView aboveSubview:self.bgImageView];
        [self.detailContent yd_addSubviews:@[self.contentLabel,self.lookBtn]];
        [self y_report_addMasonry];
    }
    return self;
}

- (void)setModel:(YDHPMessageModel *)model{
    [super setModel:model];
    
    _contentLabel.text = model.text;
    [_bgImageView yd_setImageFadeinWithString:model.imageUrl];
    
}

- (void)y_report_addMasonry{
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_timeLabel.mas_bottom).offset(5);
        make.bottom.equalTo(_lookBtn.mas_top).offset(-5);
        make.right.equalTo(_moreBtn.mas_left).offset(-5);
    }];
    [_lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(self.detailContent).offset(-20);
        make.size.mas_equalTo(CGSizeMake(74, 28));
    }];
    
    [_overView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [YDUIKit labelTextColor:[UIColor whiteColor] fontSize:18];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)lookBtn{
    if (!_lookBtn) {
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookBtn.layer.cornerRadius = 14.0f;
        _lookBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _lookBtn.layer.borderWidth = 1.0f;
        [_lookBtn setTitle:@"点击查看" forState:0];
        [_lookBtn setTitleColor:[UIColor whiteColor] forState:0];
        _lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _lookBtn.enabled = NO;
    }
    return _lookBtn;
}

- (UIView *)overView{
    if (!_overView) {
        _overView = [[UIView alloc] init];
        _overView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _overView;
}

@end
//
//  YDTaskDetailsView.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/2.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTaskDetailsView.h"

@interface YDTaskDetailsView()

@property (nonatomic, strong) UIImageView *topImageV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *rewardLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *goBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation YDTaskDetailsView

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<YDTaskDetailsViewDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowColor = YDColorString(@"#000000").CGColor;
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 5;
        self.layer.cornerRadius = 8.f;
        self.clipsToBounds = YES;
        [self setupSubviews];
        
        _delegate = delegate;
    }
    return self;
}

- (void)setModel:(YDTaskModel *)model{
    _model = model;
    [_topImageV yd_setImageWithString:model.t_back_ground showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    _titleLabel.text = model.t_title;
    _timeLabel.text = @"时效:不限";
    _rewardLabel.text = [NSString stringWithFormat:@"奖励:%@积分",YDNoNilNumber(model.t_reward)];
    _contentLabel.text = model.t_content;
}

- (void)setupSubviews{
    [self addSubview:self.topImageV];
    [self bringSubviewToFront:_cancelBtn];
    [_topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(_topImageV.mas_width).multipliedBy(0.466);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(_topImageV.mas_bottom).offset(15);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel);
        make.left.equalTo(_timeLabel.mas_right).offset(20);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(15);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_lessThanOrEqualTo(60);
    }];
    
    [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentLabel);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

#pragma mark - Events
- (void)goButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskDetailsReviewClickGO:)]) {
        [self.delegate taskDetailsReviewClickGO:self.model];
    }
}
- (void)cancelButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskDetailsReviewClickCancel)]) {
        [self.delegate taskDetailsReviewClickCancel];
    }
}

- (UIImageView *)topImageV{
    if (!_topImageV) {
        _topImageV = [[UIImageView alloc] init];
        _topImageV.backgroundColor = [UIColor lightGrayColor];
        _titleLabel = [YDUIKit labelTextColor:YDColorString(@"#4A4A4A") fontSize:22 textAlignment:NSTextAlignmentLeft];
        _timeLabel = [YDUIKit labelTextColor:YDColorString(@"#4A4A4A") fontSize:12 textAlignment:NSTextAlignmentLeft];
        _rewardLabel = [YDUIKit labelTextColor:YDColorString(@"#4A4A4A") fontSize:12 textAlignment:NSTextAlignmentLeft];
        _contentLabel = [YDUIKit labelTextColor:YDColorString(@"#4A4A4A") fontSize:14 textAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:YDImage(@"homePage_task_cancel") forState:0];
        [_cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goBtn.backgroundColor = YDBaseColor;
        _goBtn.layer.cornerRadius = 8.0f;
        _goBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_goBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_goBtn setTitle:@"去完成" forState:0];
        [_goBtn addTarget:self action:@selector(goButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self yd_addSubviews:@[_titleLabel,_timeLabel,_rewardLabel,_contentLabel,_cancelBtn,_goBtn]];
    }
    return _topImageV;
}

@end

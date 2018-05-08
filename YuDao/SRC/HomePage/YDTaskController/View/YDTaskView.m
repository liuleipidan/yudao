//
//  YDTaskView.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/2.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTaskView.h"

@interface YDTaskView()

@property (nonatomic, strong) UIImageView *bgImageV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *rewardLabel;

@property (nonatomic, strong) UILabel *promptLabel;

/**
 加载失败会显示出来，点击可重新加载
 */
@property (nonatomic, strong) UIButton *reloadBtn;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation YDTaskView

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setModel:(YDTaskModel *)model{
    _model = model;
    if (model == nil) {
        _promptLabel.hidden = NO;
    }else{
        _promptLabel.hidden = YES;
    }
    [_bgImageV yd_setImageWithString:model.t_back_ground showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    _titleLabel.text = model.t_title;
    _timeLabel.text = @"时效:不限";
    _rewardLabel.text = [NSString stringWithFormat:@"奖励:%@积分",model.t_reward];
}

- (void)showLoadView{
    
    [self.indicatorView startAnimating];
}

- (void)hideLoadView{
    if (self.indicatorView.isAnimating) {
        [self.indicatorView stopAnimating];
    }
}

- (void)taskDataLoadFailure{
    self.reloadBtn.hidden = NO;
}

#pragma mark - Events
- (void)clickAllViewAction:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskViewBeClicked:)]) {
        [self.delegate taskViewBeClicked:self.model];
    }
}

- (void)clickReloadButtonAction:(UIButton *)btn{
    btn.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskViewClickReloadButton:)]) {
        [self.delegate taskViewClickReloadButton:btn];
    }
}

- (void)initSubviews{
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAllViewAction:)]];
    
    _bgImageV = [[UIImageView alloc] init];
    [self yd_addSubviews:@[_bgImageV,self.titleLabel,self.timeLabel,self.rewardLabel,self.reloadBtn,self.promptLabel,self.indicatorView]];
    [self bringSubviewToFront:_indicatorView];
    
    [_bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(self.bgImageV);
        make.height.mas_equalTo(30);
    }];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(11);
        make.top.equalTo(self).offset(14);
        make.right.equalTo(self).offset(-11);
        make.height.mas_equalTo(30);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
        make.width.lessThanOrEqualTo(self.mas_width);
    }];
    
    [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(_timeLabel.mas_bottom).offset(1);
        make.height.mas_equalTo(17);
        make.width.lessThanOrEqualTo(self.mas_width);
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

#pragma mark - Getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YDUIKit labelTextColor:[UIColor whiteColor] fontSize:22 textAlignment:NSTextAlignmentLeft];
        _titleLabel.font = [UIFont boldSystemFontOfSize:22];
        _titleLabel.layer.shadowRadius = 1.f;
        _titleLabel.layer.shadowColor = [UIColor colorWithString:@"#000000"].CGColor;
        _titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.layer.shadowOpacity = 0.6f;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [YDUIKit labelTextColor:[UIColor whiteColor] fontSize:12 textAlignment:NSTextAlignmentLeft];
        _timeLabel.text = @"不限";
    }
    return _timeLabel;
}

- (UILabel *)rewardLabel{
    if (!_rewardLabel) {
        _rewardLabel = [YDUIKit labelTextColor:[UIColor whiteColor] fontSize:12 textAlignment:NSTextAlignmentLeft];
    }
    return _rewardLabel;
}

- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor lightGrayColor];
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.text = @"暂无新任务";
        _promptLabel.font = [UIFont systemFontOfSize:20];
        _promptLabel.layer.cornerRadius = 8.0f;
        _promptLabel.layer.masksToBounds = YES;
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.hidden = YES;
    }
    return _promptLabel;
}

- (UIButton *)reloadBtn{
    if (!_reloadBtn) {
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadBtn setTitle:@"加载失败，点击重试" forState:0];
        [_reloadBtn setTitleColor:[UIColor lightGrayColor] forState:0];
        [_reloadBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _reloadBtn.hidden = YES;
        [_reloadBtn addTarget:self action:@selector(clickReloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadBtn;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

@end

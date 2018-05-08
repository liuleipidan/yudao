//
//  YDMomentTextView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMomentTextView.h"

@interface YDMomentTextView()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIView *loctionView;

@property (nonatomic, strong) UIImageView *locImageView;

@property (nonatomic, strong) UILabel *locLabel;

@end

@implementation YDMomentTextView

- (instancetype)init{
    if (self = [super init]) {
        [self mt_setupSubviews];
        [self mt_addMasonry];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setMomentFrame:(YDMomentFrame *)momentFrame{
    _momentFrame = momentFrame;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(momentFrame.textAndLocationHeight);
    }];
    
    [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(momentFrame.heightText);
    }];
    
    [_loctionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(momentFrame.locationHeight);
    }];
}

- (void)setText:(NSAttributedString *)text location:(NSString *)location{
    _textLabel.attributedText = text;
    _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _locLabel.text = location;
}

#pragma mark - Private Methods
- (void)mt_setupSubviews{
    self.backgroundColor = [UIColor whiteColor];
    
    _textLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont systemFontOfSize:14] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    _textLabel.numberOfLines = 2;
    
    _loctionView = [UIView new];
    _loctionView.backgroundColor = [UIColor whiteColor];
    
    _locImageView = [[UIImageView alloc] initWithImage:YDImage(@"dynamic_location_icon")];
    
    _locLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:12] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    
    [self yd_addSubviews:@[_textLabel,_loctionView]];
    [_loctionView yd_addSubviews:@[_locImageView,_locLabel]];
    
}

- (void)mt_addMasonry{
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    
    [_loctionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    
    [_locImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.loctionView);
        make.width.mas_equalTo(14);
    }];
    
    [_locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locImageView.mas_right).offset(5);
        make.top.bottom.right.equalTo(self.loctionView);
    }];
}


@end

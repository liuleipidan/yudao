//
//  YDHPMessageWeatherCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHPMessageWeatherCell.h"

@interface YDHPMessageWeatherCell()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *lookBtn;

@end

@implementation YDHPMessageWeatherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.moreBtn setImage:[UIImage imageNamed:@"homePage_message_more_gray"] forState:0];
        
        [self.detailContent yd_addSubviews:@[self.contentLabel,self.lookBtn]];
        [self y_weather_addMasonry];
    }
    return self;
}

- (void)setModel:(YDHPMessageModel *)model{
    [super setModel:model];
    
    [_contentLabel setText:model.text lineSpacing:5];
}

- (void)y_weather_addMasonry{
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_timeLabel.mas_bottom).offset(15);
        make.right.equalTo(self.moreBtn.mas_left).offset(5);
    }];
    
    [_lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.detailContent);
        make.height.mas_equalTo(36);
    }];
}

#pragma mark - Getter
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:18];
        _contentLabel.numberOfLines = 3;
    }
    return _contentLabel;
}

- (UIButton *)lookBtn{
    if (!_lookBtn) {
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookBtn setTitle:@"立即查看" forState:0];
        
        [_lookBtn setTitleColor:[UIColor grayTextColor] forState:0];
        _lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _lookBtn.backgroundColor = [UIColor grayBackgoundColor];
        _lookBtn.enabled = NO;
    }
    return _lookBtn;
}



@end

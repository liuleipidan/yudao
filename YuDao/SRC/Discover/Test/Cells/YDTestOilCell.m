//
//  YDTestOilCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestOilCell.h"

@interface YDTestOilCell()

@property (nonatomic, strong) YDSlider *slider;

@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UIImageView *prompBGView;

@end

@implementation YDTestOilCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.bgImageView setImage:YDImage(@"test_arvoil_bg")];
        
        self.titleLabel.text = @"平均油耗";
        
        [self.contentView yd_addSubviews:@[self.slider,self.prompBGView,self.promptLabel]];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(25);
            make.right.equalTo(self.contentView).offset(-25);
            make.bottom.equalTo(self.contentView).offset(-35);
            make.height.mas_equalTo(10);
        }];
        
        [self.prompBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.slider.mas_top).offset(-8);
            make.height.mas_equalTo(30);
        }];
        
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.prompBGView);
            make.top.equalTo(self.prompBGView.mas_top).offset(3);
            make.height.mas_equalTo(20);
        }];
        
        
    }
    return self;
}

- (void)setModel:(YDTestsModel *)model{
    [super setModel:model];
    
    CGFloat value = model.avg_fuel.floatValue / 15.0;
    [_slider setValue:value animated:YES];
    
    _promptLabel.text = [NSString stringWithFormat:@"%.1fL/100KM",model.avg_fuel.floatValue];
    CGFloat width = [_promptLabel.text yd_stringWidthBySize:CGSizeMake(CGFLOAT_MAX, 20) font:[UIFont font_14]] + 20;
    
    CGFloat leftOffset = value * (SCREEN_WIDTH-50) - width/2.0 - 2;
    leftOffset = leftOffset <= -25.f ? -25.f : leftOffset;
    [_prompBGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider.mas_left).offset(leftOffset);
        make.width.mas_equalTo(width);
    }];
}

#pragma mark - Getters
- (YDSlider *)slider{
    if (_slider == nil) {
        _slider = [YDSlider new];
        _slider.userInteractionEnabled = NO;
        _slider.minimumValue = 0.f;
        _slider.maximumValue = 1.f;
        
        [_slider setMinimumTrackImage:YDImage(@"test_oil_progress") forState:0];
        [_slider setMaximumTrackImage:YDImage(@"test_oil_progress") forState:0];
        [_slider setThumbImage:YDImage(@"test_oil_thumb") forState:0];
    }
    return _slider;
}

- (UILabel *)promptLabel{
    if (_promptLabel == nil) {
        _promptLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_14] textAlignment:NSTextAlignmentCenter];
    }
    return _promptLabel;
}

- (UIImageView *)prompBGView{
    if (_prompBGView == nil) {
        _prompBGView = [[UIImageView alloc] initWithImage:YDImage(@"test_oil_promptBG")];
    }
    return _prompBGView;
}

@end

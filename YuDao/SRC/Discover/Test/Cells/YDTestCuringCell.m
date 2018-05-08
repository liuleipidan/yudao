//
//  YDTestCuringCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestCuringCell.h"

@interface YDTestCuringCell()

@property (nonatomic, strong) YDSlider *slider;

@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation YDTestCuringCell
{
    NSString *_slider_miniTack_red;
    NSString *_slider_miniTack_green;
    NSString *_slider_thumb_red;
    NSString *_slider_thumb_green;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.bgImageView setImage:YDImage(@"test_curing_bg")];
        
        self.titleLabel.text = @"车辆养护";
        
        [self.contentView yd_addSubviews:@[self.slider,self.promptLabel]];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(25);
            make.right.equalTo(self.contentView).offset(-25);
            make.bottom.equalTo(self.contentView).offset(-35);
            make.height.mas_equalTo(10);
        }];
        
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.slider.mas_top).offset(-8);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(60);
        }];
    }
    return self;
}

- (void)setModel:(YDTestsModel *)model{
    [super setModel:model];
    
    CGFloat value = model.percent.floatValue / 100.0;
    [_slider setValue:value animated:YES];
    
    if (value < 50) {
        [_slider setMinimumTrackImage:YDImage(_slider_miniTack_green) forState:0];
        [_slider setThumbImage:YDImage(_slider_thumb_green) forState:0];
        _promptLabel.text = @"无需养护";
    }
    else{
        [_slider setMinimumTrackImage:YDImage(_slider_miniTack_red) forState:0];
        [_slider setThumbImage:YDImage(_slider_thumb_red) forState:0];
        _promptLabel.text = @"急需养护";
    }
    
    CGFloat leftOffset = value * (SCREEN_WIDTH-50) - 30;
    leftOffset = leftOffset <= -25.f ? -25.f : leftOffset;
    [_promptLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider.mas_left).offset(leftOffset);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - Getters
- (YDSlider *)slider{
    if (_slider == nil) {
        _slider = [YDSlider new];
        _slider.userInteractionEnabled = NO;
        _slider.minimumValue = 0.f;
        _slider.maximumValue = 1.f;
        
        _slider_miniTack_red = @"test_curing_miniTrack_red";
        _slider_miniTack_green = @"test_curing_miniTrack_green";
        _slider_thumb_red = @"test_curing_thumb_red";
        _slider_thumb_green = @"test_curing_thumb_green";
        
        [_slider setMinimumTrackImage:nil forState:0];
        [_slider setMaximumTrackImage:YDImage(@"test_curing_progress") forState:0];
    }
    return _slider;
}

- (UILabel *)promptLabel{
    if (_promptLabel == nil) {
        _promptLabel = [UILabel labelByTextColor:[UIColor blackColor] font:[UIFont font_14] textAlignment:NSTextAlignmentCenter];
    }
    return _promptLabel;
}

@end

//
//  YDCustomButton.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/19.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCustomButton.h"

@interface YDCustomButton()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *textLabel;

#pragma mark - 计算位置的基准线
//中心垂直
@property (nonatomic, strong) UIView *verLine;
//中心水平
@property (nonatomic, strong) UIView *horLine;

@end

@implementation YDCustomButton

- (id)initWithTitle:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath iconType:(YDCustomButtonIconType)iconType{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        _iconType = iconType;
        self.iconTextSpace = 5.0f;
        self.title = title;
        self.iconPath = iconPath;
        self.iconHLPath = iconHLPath;
        
        [self yd_addSubviews:@[self.verLine,self.horLine,self.iconImageView,self.textLabel]];
        
        [self cd_addBaseLineMasonry];
        
        [self cb_addMasonry];
    }
    return self;
}

#pragma mark - Settters
- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.textLabel setText:title];
    
    CGSize titleSize = [self.textLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 22)];
    
    [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleSize.width);
    }];
}

- (void)setIconPath:(NSString *)iconPath
{
    _iconPath = iconPath;
    [self.iconImageView setImage:[UIImage imageNamed:iconPath]];
}

- (void)setIconHLPath:(NSString *)iconHLPath
{
    _iconHLPath = iconHLPath;
    [self.iconImageView setHighlightedImage:[UIImage imageNamed:iconHLPath]];
}

- (void)setTextHLColor:(UIColor *)textHLColor{
    _textHLColor = textHLColor;
    [self.textLabel setHighlightedTextColor:textHLColor ? : [UIColor orangeTextColor]];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self.iconImageView setHighlighted:selected];
    [self.textLabel setHighlighted:selected];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.iconImageView.image.size;
    switch (_iconType) {
        case YDCustomButtonIconTypeLeft:
        {
            CGFloat width = size.width / size.height * self.height;
            [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
            }];
            break;}
            
        default:
            break;
    }
    [self layoutIfNeeded];
}

#pragma mark - Private Methods
- (void)cd_addBaseLineMasonry{
    [_verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(self);
        make.width.mas_equalTo(0);
    }];
    
    [_horLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];
}
- (void)cb_addMasonry{
    switch (_iconType) {
        case YDCustomButtonIconTypeTop:
        {
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.bottom.equalTo(_horLine).offset(-_iconTextSpace/2.0);
            }];
            [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self);
                make.top.equalTo(_horLine).offset(_iconTextSpace/2.0);
            }];
            break;}
        case YDCustomButtonIconTypeLeft:
        {
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(self);
                make.width.mas_equalTo(0);
            }];
            [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(self);
                make.left.equalTo(_iconImageView.mas_right).offset(_iconTextSpace);
            }];
            break;}
        case YDCustomButtonIconTypeBottom:
        {
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self);
                make.top.equalTo(_horLine).offset(_iconTextSpace/2.0);
            }];
            [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.bottom.equalTo(_horLine).offset(-_iconTextSpace/2.0);
            }];
            break;}
        case YDCustomButtonIconTypeRight:
        {
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(self);
                make.left.equalTo(_verLine).offset(_iconTextSpace/2.0);
            }];
            [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(self);
                make.right.equalTo(_verLine).offset(-_iconTextSpace/2.0);
            }];
            break;}
        default:
            break;
    }
    
}

#pragma mark - Getters
- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel setTextColor:[UIColor grayTextColor]];
        [_textLabel setHighlightedTextColor:[UIColor orangeTextColor]];
    }
    return _textLabel;
}

- (UIView *)verLine{
    if (_verLine == nil) {
        _verLine = [UIView new];
        _verLine.backgroundColor = [UIColor clearColor];
    }
    return _verLine;
}

- (UIView *)horLine{
    if (_horLine == nil) {
        _horLine = [UIView new];
        _horLine.backgroundColor = [UIColor clearColor];
    }
    return _horLine;
}

@end

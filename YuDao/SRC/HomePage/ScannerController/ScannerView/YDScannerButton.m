//
//  YDScannerButton.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDScannerButton.h"

#define kScannerButtonImageWidth 38.0f

@interface YDScannerButton()



@end

@implementation YDScannerButton

- (id)initWithType:(YDScannerType)type title:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath{
    
    if (self = [[YDScannerButton alloc] initWithTitle:title iconPath:iconPath iconHLPath:iconHLPath]) {
        self.type = type;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath{
    if (self = [super init]) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.textLabel];
        [self cb_addMasonry];
        self.type = YDScannerTypeAll;
        self.title = title;
        self.iconPath = iconPath;
        self.iconHLPath = iconHLPath;
        
    }
    return self;
}

#pragma mark - Settters
- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.textLabel setText:title];
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

#pragma mark - Private Methods -
- (void)cb_addMasonry
{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(kScannerButtonImageWidth);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
}

#pragma mark - Getter -
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setHighlightedTextColor:[UIColor orangeTextColor]];
    }
    return _textLabel;
}


@end

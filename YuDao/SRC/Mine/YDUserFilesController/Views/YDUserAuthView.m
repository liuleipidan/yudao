//
//  YDUserAuthView.m
//  YuDao
//
//  Created by 汪杰 on 16/12/30.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUserAuthView.h"

@implementation YDUserAuthView

- (id)init{
    if (self = [super init]) {
        [self sd_addSubviews:@[self.imageV,self.titleLabel,self.flagImageV]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self sd_addSubviews:@[self.imageV,self.titleLabel,self.flagImageV]];
        
        _imageV.frame = CGRectMake((frame.size.width-45)/2, 5, 45, 45);
        _titleLabel.frame = CGRectMake(0, CGRectGetMaxY(_imageV.frame)+5, frame.size.width, 21);
        _flagImageV.frame = CGRectMake(CGRectGetMaxX(_imageV.frame)-9, CGRectGetMaxY(_imageV.frame)-16, 16, 16);
    }
    return self;
}


- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:13 textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIImageView *)flagImageV{
    if (!_flagImageV) {
        _flagImageV = [[UIImageView alloc] init];
        _flagImageV.image = [UIImage imageNamed:@"discover_test_normal"];
    }
    return _flagImageV;
}

@end

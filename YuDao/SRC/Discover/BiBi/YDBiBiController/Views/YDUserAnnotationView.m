//
//  YDUserAnnotationView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDUserAnnotationView.h"

@interface YDUserAnnotationView()

//用户头像
@property (nonatomic, strong) UIImageView *avatarImgV;

@end

@implementation YDUserAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        //设置未选中下背景视图
        self.enabled = NO;
        self.image = [UIImage imageNamed:@"discover_user_normal"];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    _avatarImgV = [[UIImageView alloc] init];
    [self addSubview:_avatarImgV];
    [_avatarImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(3);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(_avatarImgV.mas_width);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _avatarImgV.layer.cornerRadius = _avatarImgV.width * 0.5;
    _avatarImgV.layer.masksToBounds = YES;
}

#pragma mark  - Public Methods
- (void)setAvatarUrl:(NSString *)avatarUrl{
    _avatarUrl = avatarUrl;
    [_avatarImgV sd_setImageWithURL:YDURL(_avatarUrl) placeholderImage:[UIImage imageNamed:kDefaultAvatarPath]];
}

- (void)customSelected{
    self.image = [UIImage imageNamed:@"discover_user_selected"];
}

@end

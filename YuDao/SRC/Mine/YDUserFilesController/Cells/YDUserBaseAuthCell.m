//
//  YDUserBaseAuthCell.m
//  YuDao
//
//  Created by 汪杰 on 16/12/30.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUserBaseAuthCell.h"
#import "YDUserAuthView.h"

@interface YDUserBaseAuthCell()


@end

@implementation YDUserBaseAuthCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self.contentView addSubview:self.titleLabel];
        {
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            topLine.backgroundColor = [UIColor colorWithString:@"#EBEBEB"];
            [self addSubview:topLine];
            UIView *bottomLine = [[UIView alloc] init];
            bottomLine.backgroundColor = [UIColor colorWithString:@"#EBEBEB"];
            [self addSubview:bottomLine];
            bottomLine.sd_layout
            .leftEqualToView(self.contentView)
            .rightEqualToView(self.contentView)
            .bottomEqualToView(self.contentView)
            .heightIs(10);
        }
        
        NSArray *images = @[@"userFiles_header",
                            @"userFiles_video",
                            @"userFiles_zfb",
                            @"userFiles_car",
                            @"userFiles_OBD"];
        NSArray *titles = @[@"头像认证",
                            @"视频认证",
                            @"支付宝认证",
                            @"车辆认证",
                            @"VE-BOX认证"];
        __block NSInteger row = 0;
        [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat x = idx * (SCREEN_WIDTH/3);
            if (idx > 2) {
                row = 1;
                x = (idx-3)* (SCREEN_WIDTH/3);
            }
            CGFloat y = row * 74 + 41;
            
            YDUserAuthView *authView = [[YDUserAuthView alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH/3, 74)];
            authView.imageV.image = [UIImage imageNamed:obj];
            authView.titleLabel.text = titles[idx];
            authView.tag = 1000+idx;
            [self.contentView addSubview:authView];
        }];
        
    }
    return self;
}

- (void)setAuthArray:(NSArray *)authArray{
    _authArray = authArray;
    [_authArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YDUserAuthView *authView = [self viewWithTag:1000+idx];
        NSString *imageStr = nil;
        if ([obj isEqual:@1]) {
            imageStr = @"userFiles_authed";
        }else{
            imageStr = @"userFiles_noAuth";
        }
        [authView.flagImageV setImage:[UIImage imageNamed:imageStr]];
    }];
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:15];
        _titleLabel.frame = CGRectMake(20, 20, 150, 21);
        _titleLabel.text = @"认证信息";
    }
    return _titleLabel;
}




@end

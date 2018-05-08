//
//  YDHomePageCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHomePageCell.h"

@implementation YDHomePageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setHostedView:(UIView *)hostedView{
    _hostedView = hostedView;
    if (hostedView.superview) {
        [hostedView removeFromSuperview];
    }
    [self.contentView addSubview:hostedView];
    [_hostedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    //[self layoutIfNeeded];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end

//
//  YDTestCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestCell.h"

@implementation YDTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSelectionStyle:0];
        self.backgroundColor = [UIColor whiteColor];
        
        _bgImageView = [UIImageView new];
        
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:22]];
        
        [self.contentView yd_addSubviews:@[_bgImageView,_titleLabel]];
        
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgImageView.mas_top).offset(15);
            make.left.equalTo(self.bgImageView.mas_left).offset(30);
            //make.height.mas_equalTo(30);
            make.width.mas_lessThanOrEqualTo(120);
        }];
        
    }
    return self;
}

- (void)setModel:(YDTestsModel *)model{
    
    _model = model;
}

@end

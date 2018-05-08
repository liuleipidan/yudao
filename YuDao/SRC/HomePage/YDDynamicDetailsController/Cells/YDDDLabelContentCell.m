//
//  YDDDLabelContentCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/20.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDDLabelContentCell.h"

@interface YDDDLabelContentCell()

@property (nonatomic, strong) UIImageView *leftImageV;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *triangleImageV;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation YDDDLabelContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setClipsToBounds:YES];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self lc_initSubviews];
        [self lc_addMasonry];
        
    }
    return self;
}

- (void)setItem:(YDDynamicDetailModel *)item{
    if (_item && [_item.d_id isEqual:item.d_id]) {
        return;
    }
    
    _item = item;
    
    _label.text = item.d_label;
    [_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(item.labelWidth);
    }];
    
    [_contentLabel setAttributedText:item.contentAttr];
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_lessThanOrEqualTo(item.contentHeight);
    }];
    
}

#pragma mark - Private Methods
- (void)lc_initSubviews{
    _leftImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamic_label_left"]];
    
    _label = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
    _label.backgroundColor = [UIColor orangeTextColor];
    
    _triangleImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamic_label_right"]];
    
    _contentLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    _contentLabel.numberOfLines = 0;
    
    [self.contentView yd_addSubviews:@[_contentLabel,_leftImageV,_label,_triangleImageV]];
    
}

- (void)lc_addMasonry{
    [_leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(5);
        make.size.mas_equalTo(CGSizeMake(3, 24));
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageV.mas_right);
        make.top.equalTo(_leftImageV.mas_top);
        make.bottom.equalTo(_leftImageV.mas_bottom);
        make.width.mas_equalTo(10);
    }];
    
    [_triangleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label.mas_right).offset(-1);
        make.top.equalTo(_leftImageV.mas_top);
        make.bottom.equalTo(_leftImageV.mas_bottom);
        make.width.mas_equalTo(14);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_top).offset(4);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

@end

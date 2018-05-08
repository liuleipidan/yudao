//
//  YDSelectCarCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSelectCarCell.h"

@interface YDSelectCarCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YDSelectCarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self sc_initSubviews];
        [self sc_addMasonry];
        
    }
    return self;
}

- (void)setItem:(YDCarDetailModel *)item{
    _item = item;
    
    _titleLabel.text = item.ug_series_name;
}

#pragma mark - Private Methods
- (void)sc_initSubviews{
    _promptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_promptButton setImage:@"cardriving_chooseBtn_normal" imageSelected:@"cardriving_chooseBtn_selected"];
    
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    
    [self.contentView yd_addSubviews:@[_promptButton,_titleLabel]];
}

- (void)sc_addMasonry{
    
    [_promptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(24);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.promptButton.mas_right).offset(20);
        make.height.mas_equalTo(22);
        make.right.equalTo(self.contentView).offset(-20);
    }];
}

@end

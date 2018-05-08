//
//  YDMyInfoAvatarCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/18.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMyInfoAvatarCell.h"

@interface YDMyInfoAvatarCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *avatarImageV;

@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation YDMyInfoAvatarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setAccessoryType:UITableViewCellAccessoryNone];
        
        [self mia_initSubviews];
        [self mia_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setItem:(YDMyInfoItem *)item{
    _item = item;
    
    _titleLabel.text = item.title;
    
    if (item.avatarImage) {
        [_avatarImageV setImage:item.avatarImage];
    }
    else if (item.avatarPath) {
        [_avatarImageV setImage:YDImage(item.avatarPath)];
    }
    else if (item.avatarURL){
        
        [_avatarImageV yd_setImageWithString:item.avatarURL placeholaderImageString:[[YDUserDefault defaultUser].user.ud_sex isEqual:@1] ? kDefaultAvatarPathMale : kDefaultAvatarPath];
    }
    else{
        [_avatarImageV setImage:nil];
    }
}

#pragma mark - Private Methods
- (void)mia_initSubviews{
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    
    _avatarImageV = [UIImageView new];
    _avatarImageV.layer.cornerRadius = 25;
    _avatarImageV.layer.masksToBounds = YES;
    
    _arrowImageView = [[UIImageView alloc] initWithImage:YDImage(@"tableViewCell_arrow_right")];
    
    [self.contentView yd_addSubviews:@[_titleLabel,_avatarImageV,_arrowImageView]];
}

- (void)mia_addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_avatarImageV mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-42);
        make.width.height.mas_equalTo(50);
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(47, 46));
        make.right.equalTo(self.contentView.mas_right);
    }];
    
}


@end

//
//  YDLikePersonCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/5/4.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDLikePersonCell.h"

@interface YDLikePersonCell ()

@property (nonatomic, strong) UIView *separatorView;

@end

@implementation YDLikePersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _separatorView = [UIView new];
        _separatorView.backgroundColor = [UIColor lineColor];
        [self.contentView addSubview:_separatorView];
        
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.left.equalTo(self.avatarImageView.mas_right);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setLikePersonItem:(YDLikePersonModel *)likePersonItem{
    _likePersonItem = likePersonItem;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:YDNoNilString(likePersonItem.ud_face)] placeholderImage:[UIImage imageNamed:kDefaultAvatarPath]];
    
    self.usernameLabel.text = likePersonItem.ub_nickname;
    
}

@end

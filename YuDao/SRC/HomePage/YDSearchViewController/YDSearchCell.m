//
//  YDSearchCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/3/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSearchCell.h"

@implementation YDSearchModel


@end

@implementation YDSearchCell

- (void)setSearchModel:(YDSearchModel *)searchModel{
    _searchModel = searchModel;
    
    [self.avatarImageView yd_setImageWithString:searchModel.ud_face placeholaderImageString:kDefaultAvatarPath];
    
    self.usernameLabel.text = searchModel.ub_nickname;
}

@end

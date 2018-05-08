//
//  YDRankListFilterButton.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/26.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDRankListFilterButton.h"


@implementation YDRankListFilterButton

//@synthesize textLabel = _textLabel;
//@synthesize iconImageView = _iconImageView;

- (id)initWithCondition:(YDRankingListFilterCondition)condition title:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath{
    if (self = [super initWithTitle:title iconPath:iconPath iconHLPath:iconHLPath]) {
        self.condition = condition;
        
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        CGSize imageSize = [UIImage imageNamed:iconPath].size;
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(imageSize);
            make.bottom.equalTo(self.textLabel.mas_top).offset(-10);
        }];
        
        self.textLabel.textColor = [UIColor grayTextColor];
        self.textLabel.highlightedTextColor = [UIColor baseColor];
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-8);
            make.height.mas_equalTo(17);
        }];
    }
    return self;
}

@end

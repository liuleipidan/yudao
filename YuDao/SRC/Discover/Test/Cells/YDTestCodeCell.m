//
//  YDTestCodeCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestCodeCell.h"

@interface YDTestCodeCell()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation YDTestCodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.bgImageView setImage:YDImage(@"test_faultcode_bg")];
        
        self.titleLabel.text = @"车辆故障码";
        
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.right.equalTo(self.contentView).offset(-25);
            make.height.mas_lessThanOrEqualTo(60);
        }];
    }
    return self;
}

- (void)setModel:(YDTestsModel *)model{
    [super setModel:model];
    
    self.contentLabel.text = model.faultString;
}

#pragma mark - Getters
- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
        _contentLabel.text = @"正常";
    }
    return _contentLabel;
}

@end

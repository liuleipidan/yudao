//
//  YDUserBaseInfoCell.m
//  YuDao
//
//  Created by 汪杰 on 16/12/30.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUserBaseInfoCell.h"

@implementation YDUserBaseInfoModel

+ (YDUserBaseInfoModel *)userInfoModelWith:(NSString *)title subTitle:(NSString *)subTitle{
    YDUserBaseInfoModel *model = [YDUserBaseInfoModel new];
    model.title = title;
    model.subTitle = subTitle;
    return model;
}

@end

@implementation YDUserBaseInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self y_layoutSubviews];
    }
    return self;
}

- (void)setModel:(YDUserBaseInfoModel *)model{
    _model = model;
    _titleLabel.text = model.title;
    _subTitleLabel.text = model.subTitle;
}

//MARK:布局
- (void)y_layoutSubviews{
    [self.contentView sd_addSubviews:@[self.titleLabel,self.subTitleLabel,self.bottomLine]];
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,20)
    .centerYEqualToView(self.contentView)
    .heightIs(21);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _subTitleLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,20)
    .leftSpaceToView(_titleLabel, 5)
    .heightIs(21);
    
    _bottomLine.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_subTitleLabel)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
}

#pragma mark - Getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YDUIKit labelTextColor:[UIColor grayTextColor] fontSize:15];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:15 textAlignment:NSTextAlignmentRight];
        
    }
    return _subTitleLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = YDSeperatorColor;
    }
    return _bottomLine;
}

@end

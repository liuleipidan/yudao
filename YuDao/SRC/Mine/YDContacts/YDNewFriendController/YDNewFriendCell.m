//
//  YDNewFriendCell.m
//  YuDao
//
//  Created by 汪杰 on 17/2/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDNewFriendCell.h"

@interface YDNewFriendCell()

@end

@implementation YDNewFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headerImageV = [UIImageView new];
        _nameLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:16];
        _contentLabel = [YDUIKit labelWithTextColor:[UIColor grayTextColor] text:@"请求添加你为好友" fontSize:14 textAlignment:0];
        _acceptBtn = [YDUIKit buttonWithTitle:@"接受" titleColor:[UIColor whiteColor] backgroundColor:[UIColor orangeTextColor] selector:@selector(acceptBtnAction:)  target:self];
        _acceptBtn.titleLabel.font = [UIFont font_12];
        _acceptBtn.layer.cornerRadius = 2.f;
        
        
        [self.contentView sd_addSubviews:@[_headerImageV,_nameLabel,_contentLabel,_acceptBtn]];
        
        [self y_layoutSubviews];
    }
    return self;
}

- (void)acceptBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(newFriendCell:didSelectedBtn:)]) {
        [self.delegate newFriendCell:self didSelectedBtn:sender];
    }
}

- (void)y_layoutSubviews{
    _headerImageV.frame = CGRectMake(12, 9, 36, 36);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageV.frame)+14, 7, 150, 21);
    _contentLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageV.frame)+14, CGRectGetMaxY(_headerImageV.frame)-18, 150, 20);
    
    [_acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(45, 30));
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:@"#B6C5DC"];
    [self.contentView addSubview:lineView];
    
    lineView.sd_layout
    .leftSpaceToView(self.contentView,11)
    .rightSpaceToView(self.contentView,11)
    .heightIs(1)
    .bottomEqualToView(self.contentView);
    
}

- (void)setMessage:(YDPushMessage *)message{
    _message = message;
    [_headerImageV yd_setImageWithString:message.avatar placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
    
    _nameLabel.text = message.name;
    
    if (message.frStatus == YDFriendRequestStatusAccept){
        [_acceptBtn setTitle:@"已添加" forState:0];
        [_acceptBtn setBackgroundColor:[UIColor clearColor]];
        [_acceptBtn setTitleColor:[UIColor grayColor] forState:0];
        _acceptBtn.enabled = NO;
    }
    
}

@end

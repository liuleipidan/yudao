//
//  YDEmojiControl.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/8.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDEmojiControl.h"

@interface YDEmojiControl()

@property (nonatomic, strong) UIButton *emojiIcon;

@end

@implementation YDEmojiControl

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self yd_addSubviews:@[self.emojiIcon,self.sendButton]];
        
        [self ec_addMasonry];
    }
    return self;
}

- (void)ec_sendButtonAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(emojiControlClickedSendButton:)]) {
        [_delegate emojiControlClickedSendButton:sender];
    }
}

- (void)ec_addMasonry{
    [self.emojiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.mas_equalTo(80);
    }];
}

#pragma mark - Getter
- (UIButton *)emojiIcon{
    if (_emojiIcon == nil) {
        _emojiIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiIcon.userInteractionEnabled = NO;
        [_emojiIcon setImage:[UIImage imageNamed:@"emoji_control_icon"] forState:0];
        _emojiIcon.backgroundColor = [UIColor grayBackgoundColor];
    }
    return _emojiIcon;
}

- (UIButton *)sendButton{
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:0];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:0];
        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_sendButton.titleLabel setFont:[UIFont pingFangSC_MediumFont:16]];
        _sendButton.backgroundColor = [UIColor baseColor];
        
        [_sendButton addTarget:self action:@selector(ec_sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end

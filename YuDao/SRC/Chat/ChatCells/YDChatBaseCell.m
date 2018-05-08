//
//  YDChatBaseCell.m
//  YuDao
//
//  Created by 汪杰 on 17/2/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatBaseCell.h"

@implementation YDChatBaseCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.avatarButton];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.messageBackgroundView];
        [self.contentView addSubview:self.indicatorView];
        [self.contentView addSubview:self.failBtn];
        [self y_addMasonry];
    }
    return self;
}

- (void)startSendAnimation{
    self.isSending = YES;
    if (!self.indicatorView.isAnimating) {
        [self.indicatorView startAnimating];
    }
}

- (void)stopSendAnimationWithSuccess:(BOOL )success{
    self.isSending = NO;
    if (self.indicatorView.isAnimating) {
        [self.indicatorView stopAnimating];
    }
}

- (UIImage *)resizebleImage:(YDMessageOwnerType) type{
    UIImage *image = nil;
    if (type == YDMessageOwnerTypeSelf) {
        image = [UIImage imageNamed:@"chat_message_self"];
    }else{
        image = [UIImage imageNamed:@"chat_message_other"];
    }
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
}

- (void)setMessage:(YDChatMessage *)message{
    if (message) {
        [self changeMessageSendStatus:message.sendState];
    }
    if (self.message && [self.message.msgId isEqualToString:message.msgId]) {
        return;
    }
    [self.timeLabel setText:[NSString stringWithFormat:@"%@    ", message.date.chatTimeInfo]];
    
    if (message.ownerType == YDMessageOwnerTypeSelf) {
        [self.usernameLabel setText:[YDUserDefault defaultUser].user.ub_nickname];
        [self.avatarButton yd_setImageWithString:[YDUserDefault defaultUser].user.ud_face placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
    }else{
        [self.usernameLabel setText:message.fName];
        [self.avatarButton yd_setImageWithString:message.fAvatarUrl placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
    }
    
    // 时间
    if (!_message || _message.showTime != message.showTime) {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(message.showTime ? TIMELABEL_HEIGHT : 0);
            make.top.mas_equalTo(self.contentView).mas_offset(message.showTime ? TIMELABEL_SPACE_Y : 0);
        }];
    }
    
    if (!message || _message.ownerType != message.ownerType) {
        // 头像
        [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(AVATAR_WIDTH);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(AVATAR_SPACE_Y);
            if(message.ownerType == YDMessageOwnerTypeSelf) {
                make.right.mas_equalTo(self.contentView).mas_offset(-AVATAR_SPACE_X);
            }
            else {
                make.left.mas_equalTo(self.contentView).mas_offset(AVATAR_SPACE_X);
            }
        }];
        
        // 用户名
        [self.usernameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarButton).mas_equalTo(-NAMELABEL_SPACE_Y);
            if (message.ownerType == YDMessageOwnerTypeSelf) {
                make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(- NAMELABEL_SPACE_X);
            }
            else {
                make.left.mas_equalTo(self.avatarButton.mas_right).mas_equalTo(NAMELABEL_SPACE_X);
            }
        }];
        
        // 背景
        [self.messageBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            message.ownerType == YDMessageOwnerTypeSelf ? make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-MSGBG_SPACE_X) : make.left.mas_equalTo(self.avatarButton.mas_right).mas_offset(MSGBG_SPACE_X);
            //make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(message.showName ? 0 : -MSGBG_SPACE_Y);
            make.top.equalTo(self.avatarButton);
        }];
    }
    
    [self.usernameLabel setHidden:!message.showName];
    [self.usernameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(message.showName ? NAMELABEL_HEIGHT : 0);
    }];
    
    _message = message;
}

- (void)updateMessage:(YDChatMessage *)message{
    [self setMessage:message];
}

- (void)changeMessageSendStatus:(YDMessageSendState )status{
    
    if (status == YDMessageSending && self.message.ownerType == YDMessageOwnerTypeSelf) {
        [self.indicatorView startAnimating];
    }else{
        [self.indicatorView stopAnimating];
    }
    self.failBtn.hidden = status == YDMessageSendFail ? NO : YES;
}

#pragma mark - Private Methods -
- (void)y_addMasonry
{
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(TIMELABEL_SPACE_Y);
        make.centerX.equalTo(self.contentView);
    }];
    
    // Default - self
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-AVATAR_SPACE_X);
        make.width.height.mas_equalTo(AVATAR_WIDTH);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(AVATAR_SPACE_Y);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarButton).mas_equalTo(-NAMELABEL_SPACE_Y);
        make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(- NAMELABEL_SPACE_X);
    }];
    
    [self.messageBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatarButton.mas_left).offset(-MSGBG_SPACE_X);
        make.top.equalTo(self.avatarButton);
    }];
    
}

#pragma mark - Event Response -
- (void)setLongpressStatus:(BOOL)selected{
    NSLog(@"子类未实现");
}

- (void)avatarButtonDown:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellDidClickAvatarForUser:)]) {
        [_delegate messageCellDidClickAvatarForUser:self.message.ownerType == YDMessageOwnerTypeSelf ? self.message.uid : self.message.fid];
    }
}
- (void)longPressMsgBGView{
    [self.messageBackgroundView setHighlighted:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellLongPress:rect:)]) {
        CGRect rect = self.messageBackgroundView.frame;
        rect.size.height -= 10;     //背景图片底部空白区域
        [_delegate messageCellLongPress:self.message rect:rect];
    }
    
}

- (void)doubleTabpMsgBGView
{
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellDoubleClick:)]) {
        [_delegate messageCellDoubleClick:self.message];
    }
}

#pragma mark - Getter -
- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [YDUIKit labelTextColor:[UIColor whiteColor] fontSize:12 textAlignment:NSTextAlignmentCenter];
        [_timeLabel setBackgroundColor:[UIColor colorWithString:@"#D8D8D8"]];
        [_timeLabel.layer setMasksToBounds:YES];
        [_timeLabel.layer setCornerRadius:5.0f];
    }
    return _timeLabel;
}

- (UIImageView *)avatarButton
{
    if (_avatarButton == nil) {
        _avatarButton = [[UIImageView alloc] init];
        _avatarButton.userInteractionEnabled = YES;
        [_avatarButton setClipsToBounds:YES];
        [_avatarButton.layer setCornerRadius:AVATAR_WIDTH/2.0];
        [_avatarButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarButtonDown:)]];
    }
    return _avatarButton;
}

- (UILabel *)usernameLabel
{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setTextColor:[UIColor grayColor]];
        [_usernameLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _usernameLabel;
}

- (UIImageView *)messageBackgroundView
{
    if (_messageBackgroundView == nil) {
        _messageBackgroundView = [[UIImageView alloc] init];
        [_messageBackgroundView setUserInteractionEnabled:YES];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMsgBGView)];
        [_messageBackgroundView addGestureRecognizer:longPressGR];
        
        UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTabpMsgBGView)];
        [doubleTapGR setNumberOfTapsRequired:2];
        [_messageBackgroundView addGestureRecognizer:doubleTapGR];
    }
    return _messageBackgroundView;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

- (UIButton *)failBtn{
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_failBtn setImage:@"chat_message_send_fail" imageHL:@"chat_message_send_fail"];
        _failBtn.hidden = YES;
    }
    return _failBtn;
}

@end

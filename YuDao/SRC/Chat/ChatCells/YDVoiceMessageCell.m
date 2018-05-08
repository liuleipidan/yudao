//
//  YDVoiceMessageCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDVoiceMessageCell.h"
#import "YDVoiceImageView.h"

@interface YDVoiceMessageCell ()

@property (nonatomic, strong) UILabel *voiceTimeLabel;

@property (nonatomic, strong) YDVoiceImageView *voiceImageView;

@end

@implementation YDVoiceMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.voiceTimeLabel];
        [self.messageBackgroundView addSubview:self.voiceImageView];
        [self.indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMsgBGView:)];
        [self.messageBackgroundView addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)setMessage:(YDVoiceChatMessage *)message
{
    YDMessageOwnerType lastOwnType = self.message ? self.message.ownerType : -1;
    [super setMessage:message];
    
    [self.voiceTimeLabel setText:[NSString stringWithFormat:@"%.0lf\"\n", message.seconds]];
    
    if (lastOwnType != message.ownerType) {
        UIImage *image = [self resizebleImage:message.ownerType];
        [self.messageBackgroundView setImage:image];
        [self.messageBackgroundView setHighlightedImage:image];
        if (message.ownerType == YDMessageOwnerTypeSelf) {
            [self.voiceImageView setIsFromMe:YES];
            
            [self.voiceTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.messageBackgroundView.mas_left).offset(-5);
                make.top.mas_equalTo(self.messageBackgroundView.mas_centerY).mas_offset(-5);
            }];
            [self.voiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-13);
                make.centerY.mas_equalTo(self.avatarButton);
            }];
            //添加发送进度加载
            [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.messageBackgroundView);
                make.right.equalTo(self.messageBackgroundView.mas_left).offset(-10);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            
            [self.failBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.messageBackgroundView);
                make.right.equalTo(self.messageBackgroundView.mas_left).offset(-5);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
        }
        else if (message.ownerType == YDMessageOwnerTypeFriend){
            [self.voiceImageView setIsFromMe:NO];
            
            [self.voiceTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.messageBackgroundView.mas_right).offset(5);
                make.top.mas_equalTo(self.messageBackgroundView.mas_centerY).mas_offset(-5);
            }];
            [self.voiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(13);
                make.centerY.mas_equalTo(self.avatarButton);
            }];
        }
    }
    
    [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(message.messageFrame.contentSize.width);
        make.bottom.equalTo(self.avatarButton.mas_bottom);
    }];
    
    if (message.msgStatus == YDVoiceMessageStatusRecording) {
        [self.voiceTimeLabel setHidden:YES];
        [self.voiceImageView setHidden:YES];
        [self p_startRecordingAnimation];
    }
    else {
        [self.voiceTimeLabel setHidden:NO];
        [self.voiceImageView setHidden:NO];
        [self p_stopRecordingAnimation];
        [self.messageBackgroundView setAlpha:1.0];
    }
    message.msgStatus == YDVoiceMessageStatusPlaying ? [self.voiceImageView startPlayingAnimation] : [self.voiceImageView stopPlayingAnimation];
}

- (void)updateMessage:(YDVoiceChatMessage *)message{
    [super setMessage:message];
    [self changeMessageSendStatus:message.sendState];
    [self.voiceTimeLabel setText:[NSString stringWithFormat:@"%.0lf\"\n", message.seconds]];
    if (message.msgStatus == YDVoiceMessageStatusRecording) {
        [self.voiceTimeLabel setHidden:YES];
        [self.voiceImageView setHidden:YES];
        [self p_startRecordingAnimation];
    }
    else {
        [self.voiceTimeLabel setHidden:NO];
        [self.voiceImageView setHidden:NO];
        [self p_stopRecordingAnimation];
    }
    message.msgStatus == YDVoiceMessageStatusPlaying ? [self.voiceImageView startPlayingAnimation] : [self.voiceImageView stopPlayingAnimation];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(message.messageFrame.contentSize);
        }];
        [self layoutIfNeeded];
    }];
}

#pragma mark - # Event Response
- (void)didTapMsgBGView:(UITapGestureRecognizer *)tap
{
    [self.voiceImageView startPlayingAnimation];
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellTapView:message:)]) {
        [self.delegate messageCellTapView:tap.view message:self.message];
    }
}

#pragma mark - # Private Methods
static bool isStartAnimation = NO;
static float bgAlpha = 1.0;
- (void)p_startRecordingAnimation
{
    isStartAnimation = YES;
    bgAlpha = 0.4;
    [self p_repeatAnimation];
}

- (void)p_repeatAnimation
{
    [UIView animateWithDuration:1.0 animations:^{
        [self.messageBackgroundView setAlpha:bgAlpha];
    } completion:^(BOOL finished) {
        if (finished) {
            bgAlpha = bgAlpha > 0.9 ? 0.4 : 1.0;
            if (isStartAnimation) {
                [self p_repeatAnimation];
            }
            else {
                [self.messageBackgroundView setAlpha:1.0];
            }
        }
    }];
}

- (void)p_stopRecordingAnimation
{
    isStartAnimation = NO;
}


#pragma mark - # Getter
- (UILabel *)voiceTimeLabel
{
    if (_voiceTimeLabel == nil) {
        _voiceTimeLabel = [[UILabel alloc] init];
        [_voiceTimeLabel setTextColor:[UIColor grayColor]];
        [_voiceTimeLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    return _voiceTimeLabel;
}

- (YDVoiceImageView *)voiceImageView
{
    if (_voiceImageView == nil) {
        _voiceImageView = [[YDVoiceImageView alloc] init];
    }
    return _voiceImageView;
}

@end

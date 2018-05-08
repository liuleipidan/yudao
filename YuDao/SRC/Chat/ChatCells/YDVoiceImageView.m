//
//  YDVoiceImageView.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDVoiceImageView.h"

@interface YDVoiceImageView ()

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, strong) UIImage *normalImage;

@end

@implementation YDVoiceImageView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setIsFromMe:YES];
    }
    return self;
}

- (void)setIsFromMe:(BOOL)isFromMe
{
    _isFromMe = isFromMe;
    if (isFromMe) {
        self.imagesArray = @[[UIImage imageNamed:@"message_voice_sender_playing_1"],
                             [UIImage imageNamed:@"message_voice_sender_playing_2"],
                             [UIImage imageNamed:@"message_voice_sender_playing_3"]];
        self.normalImage = [UIImage imageNamed:@"message_voice_sender_normal"];
    }
    else {
        self.imagesArray = @[[UIImage imageNamed:@"message_voice_receiver_playing_1"],
                             [UIImage imageNamed:@"message_voice_receiver_playing_2"],
                             [UIImage imageNamed:@"message_voice_receiver_playing_3"]];
        self.normalImage = [UIImage imageNamed:@"message_voice_receiver_normal"];
    }
    [self setImage:self.normalImage];
}

- (void)startPlayingAnimation
{
    self.animationImages = self.imagesArray;
    self.animationRepeatCount = 0;
    self.animationDuration = 1.0;
    [self startAnimating];
}

- (void)stopPlayingAnimation
{
    [self stopAnimating];
}

@end

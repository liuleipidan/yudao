//
//  YDVoiceImageView.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDVoiceImageView : UIImageView

@property (nonatomic, assign) BOOL isFromMe;

- (void)startPlayingAnimation;

- (void)stopPlayingAnimation;

@end

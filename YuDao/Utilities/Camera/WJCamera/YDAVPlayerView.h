//
//  YDAVPlayerView.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/12.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDAVPlayerView : UIView

@property(nonatomic,strong) CALayer     *playerLayer;
@property(nonatomic,strong) AVPlayer    *player;
@property(nonatomic,strong) NSURL       *playUrl;

+ (YDAVPlayerView *)showInView:(UIView *)view;

- (void)stopPlayer;

@end

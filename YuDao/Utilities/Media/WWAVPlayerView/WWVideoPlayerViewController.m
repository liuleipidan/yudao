//
//  WWVideoPlayerViewController.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "WWVideoPlayerViewController.h"
#import "WWAVPlayerView.h"

@interface WWVideoPlayerViewController ()<WWAVPlayerViewDelegate>

@property (nonatomic, strong) WWAVPlayerView *playerView;

@property (nonatomic, strong) NSURL *videoURL;

@end

@implementation WWVideoPlayerViewController

- (id)initWithVideoURL:(NSURL *)videoURL{
    if (self = [super init]) {
        _videoURL = videoURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.playerView showInView:self.view videoURL:self.videoURL placeholderImage:nil];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] yd_setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] yd_setStatusBarHidden:NO];
}

#pragma mark - WWAVPlayerViewDelegate
- (void)AVPlayerViewDidClickCloseBtn:(WWAVPlayerView *)view{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter
- (WWAVPlayerView *)playerView{
    if (_playerView == nil) {
        _playerView = [[WWAVPlayerView alloc] initWithFrame:self.view.bounds];
        [_playerView setDelegate:self];
        [_playerView.operationView setFullScreen:YES];
    }
    return _playerView;
}

@end

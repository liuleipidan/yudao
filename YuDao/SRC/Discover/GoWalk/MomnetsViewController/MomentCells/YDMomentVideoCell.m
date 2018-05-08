//
//  YDMomentVideoCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/13.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDMomentVideoCell.h"
#import "WWAVPlayerView.h"
#import "AppDelegate.h"

//宽高比
#define kVideoWidthHeightRate 0.563

@interface YDMomentVideoCell()



@end

@implementation YDMomentVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _thumbnailImageView = [UIImageView new];
        _thumbnailImageView.backgroundColor = [UIColor blackColor];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbnailImageView.userInteractionEnabled = YES;
        
        _playIcon = [[UIImageView alloc] initWithImage:YDImage(@"video_icon_play")];
        _playIcon.userInteractionEnabled = YES;
        [_playIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mv_videoIconAction:)]];
        
        [self.contentView addSubview:_thumbnailImageView];
        [_thumbnailImageView addSubview:_playIcon];
        
        [_thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom).offset(9);
            make.left.equalTo(self.contentView).offset(9);
            make.right.equalTo(self.contentView).offset(-9);
        make.height.mas_equalTo(_thumbnailImageView.mas_width).multipliedBy(kVideoWidthHeightRate);
        }];
        
        [_playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_thumbnailImageView);
            make.width.height.mas_equalTo(50);
        }];
    }
    return self;
}

- (void)setMoment:(YDMoment *)moment{
    [super setMoment:moment];
    
    if (moment.imagesURL.count > 0) {
        [self.thumbnailImageView sd_setImageWithURL:YDURL(moment.imagesURL.firstObject)];
    }
}

- (void)startPlayVideo{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.networkStatus == YDReachabilityStatusWiFi) {
        [[WWAVPlayerView sharedPlayerView] showInView:self.thumbnailImageView videoURL:YDURL(self.moment.d_video) placeholderImage:self.thumbnailImageView.image];
    }
}

- (void)stopPlayVideo{
    [[WWAVPlayerView sharedPlayerView] stopPlay];
    [[WWAVPlayerView sharedPlayerView] removeFromSuperview];
}

#pragma mark - Event
- (void)mv_videoIconAction:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(momentImagesViewClickVideoCell:imageView:)]) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.networkStatus != YDReachabilityStatusWiFi) {
            [UIAlertController YD_alertController:[UIViewController yd_getTheCurrentViewController] title:@"提示" subTitle:@"当前为非WIFI网络，将使用流量播放" items:@[@"确认"] style:UIAlertControllerStyleAlert clickBlock:^(NSInteger index) {
                if (index == 1) {
                    [self.delegate momentImagesViewClickVideoCell:self imageView:self.thumbnailImageView];
                }
            }];
        }
        else{
            [self.delegate momentImagesViewClickVideoCell:self imageView:self.thumbnailImageView];
        }
    }
}


#pragma mark - Getter
- (BOOL)hasPlayerView{
    __block BOOL has = NO;
    [self.thumbnailImageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:[WWAVPlayerView class]]) {
            has = YES;
        }
    }];
    return has;
}

@end

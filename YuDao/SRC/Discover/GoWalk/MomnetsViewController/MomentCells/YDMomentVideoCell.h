//
//  YDMomentVideoCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/13.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDMomentCell.h"

/**
 * 播放滑动不可及cell的类型
 */
typedef NS_OPTIONS(NSInteger, YDMomentVideoUnreachCellStyle) {
    YDMomentVideoUnreachCellStyleNone = 1 << 0,    // normal 播放滑动可及cell
    YDMomentVideoUnreachCellStyleUp   = 1 << 1,    // top 顶部不可及
    YDMomentVideoUnreachCellStyleDown = 1<< 2      // bottom 底部不可及
};

@interface YDMomentVideoCell : YDMomentCell

//视频缩略图
@property (nonatomic, strong) UIImageView *thumbnailImageView;

//播放按钮
@property (nonatomic, strong) UIImageView *playIcon;

//是否在播放
@property (nonatomic, assign) BOOL isPlaying;

//是否视频播放器
@property (nonatomic, assign, readonly) BOOL hasPlayerView;

/** cell类型 */
@property(nonatomic, assign)YDMomentVideoUnreachCellStyle cellStyle;

- (void)startPlayVideo;

- (void)stopPlayVideo;

@end

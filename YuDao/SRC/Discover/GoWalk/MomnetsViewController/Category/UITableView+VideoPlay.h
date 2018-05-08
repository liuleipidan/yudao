//
//  UITableView+VideoPlay.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/15.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * The scroll derection of tableview.
 * 滚动类型
 */
typedef NS_ENUM(NSUInteger, YDVideoPlayerScrollDerection) {
    YDVideoPlayerScrollDerectionNone = 0,
    YDVideoPlayerScrollDerectionUp = 1, // 向上滚动
    YDVideoPlayerScrollDerectionDown = 2 // 向下滚动
};

@class YDMomentVideoCell;
@interface UITableView (VideoPlay)


/**
 * The cell of playing video.
 * 正在播放视频的cell.
 */
@property(nonatomic, nullable) YDMomentVideoCell *playingCell;

/**
 * The number of cells cannot stop in screen center.
 * 滑动不可及cell个数.
 */
@property(nonatomic) NSUInteger maxNumCannotPlayVideoCells;

/**
 * The scroll derection of tableview now.
 * 当前滚动方向类型.
 */
@property(nonatomic) YDVideoPlayerScrollDerection currentDerection;

/**
 * The dictionary of record the number of cells that cannot stop in screen center.
 * 滑动不可及cell字典.
 */
@property(nonatomic, nonnull) NSDictionary *dictOfVisiableAndNotPlayCells;

/**
 * For calculate the scroll derection of tableview, we need record the offset-Y of tableview when begain drag.
 * 刚开始拖拽时scrollView的偏移量Y值, 用来判断滚动方向.
 */
@property(nonatomic, assign) CGFloat offsetY_last;

/*
 * tabBarHeight.
 */
@property(nonatomic) CGFloat tabBarHeight;


- (void)playVideoInVisiableCells;

- (void)handleScrollStop;

- (void)handleQuickScroll;

//处理滑动方向
- (void)handleScrollDerectionWithOffset:(CGFloat)offsetY;

- (void)stopPlay;

@end

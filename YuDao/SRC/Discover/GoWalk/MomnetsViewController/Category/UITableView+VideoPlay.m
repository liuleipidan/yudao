//
//  UITableView+VideoPlay.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/15.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "UITableView+VideoPlay.h"
#import "YDMomentVideoCell.h"
#import "WWAVPlayerView.h"

@implementation UITableView (VideoPlay)

- (void)playVideoInVisiableCells{
    NSArray *visiableCells = [self visibleCells];
    
    // Find first cell need play video in visiable cells.
    // 在可见cell中找到第一个有视频的cell
    YDMomentVideoCell *videoCell = nil;
    
    for (YDMomentVideoCell *cell in visiableCells) {
        if ([cell.moment.d_type isEqual:@2]) {
            videoCell = cell;
            break;
        }
    }
    
    // If found, play.
    // 如果找到了, 就开始播放视频
    if (videoCell) {
        self.playingCell = videoCell;
        
        // display status view.
        //[videoCell.videoImv jp_playVideoWithURL:[NSURL URLWithString:videoCell.videoPath]];
    }
}


#pragma mark - Video Play Events

- (void)handleScrollStop{
    YDMomentVideoCell *bestCell = [self findTheBestToPlayVideoCell];
    
    // If the found cell is the cell playing video, this situation cannot play video again.
    // 注意, 如果正在播放的 cell 和 finnalCell 是同一个 cell, 不应该在播放.
    if (self.playingCell.hash != bestCell.hash && bestCell.hash != 0) {
        
        [self.playingCell stopPlayVideo];
        
        [bestCell startPlayVideo];
        
        self.playingCell = bestCell;
    }
}

- (void)handleQuickScroll{
    
    if (self.playingCell == nil) return;
    
    // Stop play when the cell playing video is unvisiable.
    // 当前播放视频的cell移出视线，要移除播放器.
    
    if (![self playingCellIsVisiable]) {
        
        [self stopPlay];
    }
}

- (void)handleScrollDerectionWithOffset:(CGFloat)offsetY{
    self.currentDerection = (offsetY - self.offsetY_last > 0) ? YDVideoPlayerScrollDerectionUp : YDVideoPlayerScrollDerectionDown;
    self.offsetY_last = offsetY;
}

- (void)stopPlay{
    if (self.playingCell) {
        [self.playingCell stopPlayVideo];
        self.playingCell = nil;
    }
}


#pragma mark - Private
- (YDMomentVideoCell *)findTheBestToPlayVideoCell{
    
    // To find next cell need play video.
    // 找到下一个要播放的cell(最在屏幕中心的).
    
    YDMomentVideoCell *finnalCell = nil;
    NSArray *visiableCells = [self visibleCells];
    CGFloat gap = MAXFLOAT;
    
    CGRect windowRect = [self windowRect];
    CGFloat navAndStatusBarHeight = STATUSBAR_HEIGHT + NAVBAR_HEIGHT;
    
    for (YDMomentVideoCell *cell in visiableCells) {
        
        @autoreleasepool {
            
            if ([cell.moment.d_type isEqual:@2]) { // If need to play video, 如果这个cell有视频
                
                // Find the cell cannot stop in screen center first.
                // 优先查找滑动不可及cell.
                if (cell.cellStyle != YDMomentVideoUnreachCellStyleNone) {
                    
                    // Must the all area of the cell is visiable.
                    // 并且不可及cell要全部露出.
                    if (cell.cellStyle == YDMomentVideoUnreachCellStyleUp) {
                        CGPoint cellLeftUpPoint = cell.thumbnailImageView.frame.origin;
                        
                        // 不要在边界上.
                        cellLeftUpPoint.y += 2;
                        CGPoint coorPoint = [cell.thumbnailImageView.superview convertPoint:cellLeftUpPoint toView:nil];
                        BOOL isContain = CGRectContainsPoint(windowRect, coorPoint);
                        if (isContain){
                            finnalCell = cell;
                            break;
                        }
                    }
                    else if (cell.cellStyle == YDMomentVideoUnreachCellStyleDown){
                        CGPoint cellLeftUpPoint = cell.thumbnailImageView.frame.origin;
                        CGFloat cellDownY = cellLeftUpPoint.y + cell.thumbnailImageView.bounds.size.height;
                        CGPoint cellLeftDownPoint = CGPointMake(cellLeftUpPoint.x, cellDownY);
                        
                        // 不要在边界上.
                        cellLeftDownPoint.y -= 1;
                        CGPoint coorPoint = [cell.thumbnailImageView.superview convertPoint:cellLeftDownPoint toView:nil];
                        BOOL isContain = CGRectContainsPoint(windowRect, coorPoint);
                        if (isContain){
                            finnalCell = cell;
                            break;
                        }
                    }
                    
                }
                else{
                    CGPoint coorCentre = [cell.thumbnailImageView.superview convertPoint:cell.thumbnailImageView.center toView:nil];
                    CGFloat delta = fabs(coorCentre.y - navAndStatusBarHeight - windowRect.size.height*0.5);
                    if (delta < gap) {
                        gap = delta;
                        finnalCell = cell;
                    }
                }
            }
        }
    }
    
    return finnalCell;
}

- (BOOL)playingCellIsVisiable{
    CGRect windowRect = [self windowRect];
    
    if (self.currentDerection == YDVideoPlayerScrollDerectionUp) { // 向上滚动
        CGPoint cellLeftUpPoint = self.playingCell.thumbnailImageView.frame.origin;
        CGFloat cellDownY = cellLeftUpPoint.y + self.playingCell.thumbnailImageView.bounds.size.height;
        CGPoint cellLeftDownPoint = CGPointMake(cellLeftUpPoint.x, cellDownY);
        
        // 不要在边界上.
        cellLeftUpPoint.y -= 1;
        CGPoint coorPoint = [self.playingCell.thumbnailImageView.superview convertPoint:cellLeftDownPoint toView:nil];
        
        BOOL isContain = CGRectContainsPoint(windowRect, coorPoint);
        return isContain;
    }
    else if(self.currentDerection == YDVideoPlayerScrollDerectionDown){ // 向下滚动
        CGPoint cellLeftUpPoint = self.playingCell.thumbnailImageView.frame.origin;
        
        // 不要在边界上.
        cellLeftUpPoint.y += 1;
        CGPoint coorPoint = [self.playingCell.thumbnailImageView.superview convertPoint:cellLeftUpPoint toView:nil];
        
        BOOL isContain = CGRectContainsPoint(windowRect, coorPoint);
        return isContain;
    }
    return YES;
}

//可是窗口范围
- (CGRect)windowRect{
    CGRect windowRect = [UIScreen mainScreen].bounds;
    CGFloat navAndStatusBarHeight = STATUSBAR_HEIGHT + NAVBAR_HEIGHT;
    windowRect.origin.y = navAndStatusBarHeight;
    windowRect.size.height -= (navAndStatusBarHeight + self.tabBarHeight);
    
    return windowRect;
}

#pragma mark - Getter & Setter
- (void)setCurrentDerection:(YDVideoPlayerScrollDerection)currentDerection{
    objc_setAssociatedObject(self, @selector(currentDerection), @(currentDerection), OBJC_ASSOCIATION_ASSIGN);
}

- (YDVideoPlayerScrollDerection)currentDerection{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setOffsetY_last:(CGFloat)offsetY_last{
    objc_setAssociatedObject(self, @selector(offsetY_last), @(offsetY_last), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)offsetY_last{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setMaxNumCannotPlayVideoCells:(NSUInteger)maxNumCannotPlayVideoCells{
    
}

- (NSUInteger)maxNumCannotPlayVideoCells{
    NSUInteger num = [objc_getAssociatedObject(self, _cmd) integerValue];
    if (num==0) {
        CGFloat radius = [UIScreen mainScreen].bounds.size.height / HEIGHT_MOMENT_VIDEO_DEFAULT;
        NSUInteger maxNumOfVisiableCells = ceil(radius);
        if (maxNumOfVisiableCells >= 3) {
            num =  [[self.dictOfVisiableAndNotPlayCells valueForKey:[NSString stringWithFormat:@"%ld", (unsigned long)maxNumOfVisiableCells]] integerValue];
            objc_setAssociatedObject(self, @selector(maxNumCannotPlayVideoCells), @(num), OBJC_ASSOCIATION_ASSIGN);
        }
    }
    return num;
}

- (void)setPlayingCell:(YDMomentVideoCell *)playingCell{
    objc_setAssociatedObject(self, @selector(playingCell), playingCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YDMomentVideoCell *)playingCell{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDictOfVisiableAndNotPlayCells:(NSDictionary *)dictOfVisiableAndNotPlayCells{
    
}

/**
 * 由于我们是在tableView静止的时候播放停在屏幕中心的cell, 所以可能出现总有一些cell无法满足我们的播放条件.
 * 所以我们必须特别处理这种情况, 我们首先要做的就是检查什么样的情况下才会出现这种类型的cell.
 * 下面是我的测量结果(iPhone 6s, iPhone 6 plus).
 * 每屏可见cell个数           4  3  2
 * 滑动不可及的cell个数        1  1  0
 * 注意 : 你需要仔细思考一下我的测量结果, 举个例子, 如果屏幕上有4个cell, 那么这个时候, 我们能够在顶部发现一个滑动不可及cell, 同时, 我们在底部也会发现一个这样的cell.
 * 注意 : 只有每屏可见cell数在3以上时,才会出现滑动不可及cell.
 */
- (NSDictionary *)dictOfVisiableAndNotPlayCells{
    
    // The key is the number of visiable cells in screen, the value is the number of cells cannot stop in screen center.
    // 以每屏可见cell的最大个数为key, 对应的滑动不可及cell数为value
    
    NSDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = @{
                 @"4" : @"1",
                 @"3" : @"1",
                 @"2" : @"0"
                 };
        objc_setAssociatedObject(self, @selector(setDictOfVisiableAndNotPlayCells:), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

- (void)setTabBarHeight:(CGFloat)tabBarHeight {
    objc_setAssociatedObject(self, @selector(tabBarHeight), @(tabBarHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)tabBarHeight {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

@end

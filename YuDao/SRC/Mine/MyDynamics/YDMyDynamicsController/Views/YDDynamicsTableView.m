//
//  YDDynamicsTableView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/29.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDynamicsTableView.h"

@interface YDDynamicsTableView()<UITableViewDataSource,UITableViewDelegate,YDMomentCellDelegate>


@end

@implementation YDDynamicsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self dt_init];
    }
    return self;
}

- (void)dt_init{
    self.dataSource = self;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setTableFooterView:[UIView new]];
    [self yd_adaptToIOS11];
    
    [self registerClass:[YDMomentImagesCell class] forCellReuseIdentifier:@"YDMomentImagesCell"];
    [self registerClass:[YDMomentVideoCell class] forCellReuseIdentifier:@"YDMomentVideoCell"];
    [self registerClass:[YDTableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}

- (void)setData:(NSMutableArray<YDMoment *> *)data{
    _data = data;
    [self reloadData];
}

#pragma mark - YDMomentCellDelegate
- (void)momentImagesViewClickImageMoment:(YDMoment *)moment atIndex:(NSInteger )index{
    
    if (self.yd_delegate && [self.yd_delegate respondsToSelector:@selector(momentImagesViewClickImageMoment:atIndex:)]) {
        [self.yd_delegate momentImagesViewClickImageMoment:moment atIndex:index];
    }
}
- (void)momentBottomViewClickLeftButton:(UIButton *)btn moment:(YDMoment *)moment{
    
    if (self.yd_delegate && [self.yd_delegate respondsToSelector:@selector(momentBottomViewClickLeftButton:moment:)]) {
        [self.yd_delegate momentBottomViewClickLeftButton:btn moment:moment];
    }
}
- (void)momentBottomViewClickCenterButton:(UIButton *)btn moment:(YDMoment *)moment{
    
    if (self.yd_delegate && [self.yd_delegate respondsToSelector:@selector(momentBottomViewClickCenterButton:moment:)]) {
        [self.yd_delegate momentBottomViewClickCenterButton:btn moment:moment];
    }
}
- (void)momentBottomViewClickRightButton:(UIButton *)btn moment:(YDMoment *)moment{
    
    if (self.yd_delegate && [self.yd_delegate respondsToSelector:@selector(momentBottomViewClickRightButton:moment:)]) {
        [self.yd_delegate momentBottomViewClickRightButton:btn moment:moment];
    }
}

- (void)momentImagesViewClickVideoCell:(YDMomentVideoCell *)cell imageView:(UIImageView *)imageView{
    self.playingCell = cell;
    if (self.yd_delegate && [self.yd_delegate respondsToSelector:@selector(momentImagesViewClickVideoCell:imageView:)]) {
        [self.yd_delegate momentImagesViewClickVideoCell:cell imageView:imageView];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDMomentCell *cell;
    YDMoment *moment = [self.data objectAtIndex:indexPath.row];
    if ([moment.d_type isEqual:@1]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"YDMomentImagesCell"];
        [cell setMoment:moment];
        [cell setDelegate:self];
        return cell;
    }
    else if ([moment.d_type isEqual:@2]){
        YDMomentVideoCell *videoCell = (YDMomentVideoCell *)cell;
        videoCell = [tableView dequeueReusableCellWithIdentifier:@"YDMomentVideoCell"];
        [videoCell setMoment:moment];
        [videoCell setDelegate:self];
        return videoCell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDMoment *moment = [self.data objectAtIndex:indexPath.row];
    //若出现动态类型d_type ==nil或0时高度为0
    if (moment.d_type == nil || [moment.d_type isEqual:@0]) {
        return 0;
    }
    return moment.frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_yd_delegate && [_yd_delegate respondsToSelector:@selector(dynamicsTableView:didSelectRowAtIndexPath:)]) {
        [_yd_delegate dynamicsTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
#pragma mark - 开启或关闭视频的判断
    // 处理滚动方向
    [self handleScrollDerectionWithOffset:scrollView.contentOffset.y];
    
    // Handle cyclic utilization
    // 处理循环利用
    [self handleQuickScroll];
    
    if (_yd_delegate && [_yd_delegate respondsToSelector:@selector(dynamicsTableViewDidScroll:)]) {
        [_yd_delegate dynamicsTableViewDidScroll:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.offsetY_last = scrollView.contentOffset.y;
    if (_yd_delegate && [_yd_delegate respondsToSelector:@selector(dynamicsTableViewWillBeginDragging:)]) {
        [_yd_delegate dynamicsTableViewWillBeginDragging:self];
    }
}

//松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_yd_delegate && [_yd_delegate respondsToSelector:@selector(dynamicsTableViewDidEndDragging:willDecelerate:)]) {
        [_yd_delegate dynamicsTableViewDidEndDragging:self willDecelerate:decelerate];
    }
}

//松手时已经静止, 只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_yd_delegate && [_yd_delegate respondsToSelector:@selector(dynamicsTableViewDidEndDecelerating:)]) {
        [_yd_delegate dynamicsTableViewDidEndDecelerating:self];
    }
}




@end

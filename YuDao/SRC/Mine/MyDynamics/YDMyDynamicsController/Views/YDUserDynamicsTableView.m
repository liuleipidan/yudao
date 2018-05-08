//
//  YDUserDynamicsTableView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDUserDynamicsTableView.h"

#define kDefaultHeaderImageViewHeight SCREEN_WIDTH * 2.0 / 3.0

@interface YDUserDynamicsTableView()<UITableViewDataSource,UITableViewDelegate,YDMomentCellDelegate>

@property (nonatomic, strong) YDStretchableView *strechableView;

@property (nonatomic, strong) UIImageView *headerImageView;

@end

@implementation YDUserDynamicsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self yd_setup];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setData:(NSMutableArray *)data{
    _data = data;
    [self reloadData];
}

- (void)setHeaderImageStr:(NSString *)headerImageStr{
    _headerImageStr = headerImageStr;
    [_headerImageView sd_setImageWithURL:YDURL(headerImageStr)];
}

- (void)yd_setup{
    
    self.dataSource = self;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[YDMomentCell class] forCellReuseIdentifier:@"YDMomentCell"];
    [self setTableFooterView:[UIView new]];
    
    _strechableView = [[YDStretchableView alloc] init];
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    _headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kDefaultHeaderImageViewHeight);
    [_strechableView stretchHeaderForTableView:self contentView:_headerImageView];

    //关闭ContentInsetAdjust
    [self yd_adaptToIOS11];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDMomentCell"];
    YDMoment *moment = self.data[indexPath.row];
    [cell setMoment:moment];
    [cell setDelegate:self];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDMoment *moment = [self.data objectAtIndex:indexPath.row];
    return moment.frame.cellHeight;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_strechableView wj_scrollViewDidScroll:scrollView];
}

@end

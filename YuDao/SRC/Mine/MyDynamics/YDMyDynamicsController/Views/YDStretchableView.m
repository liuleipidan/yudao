//
//  YDStretchableView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDStretchableView.h"

@interface YDStretchableView()
{
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}


@end

@implementation YDStretchableView

@synthesize tableView = _tableView;
@synthesize contentView = _contentView;

- (void)stretchHeaderForTableView:(UITableView *)tableView contentView:(UIView *)contentView{
    _tableView = tableView;
    _contentView = contentView;
    
    initialFrame = _contentView.frame;
    defaultViewHeight = initialFrame.size.height;
    
    UIView *emptyHeaderView = [[UIView alloc] initWithFrame:initialFrame];
    _tableView.tableHeaderView = emptyHeaderView;
    [_tableView addSubview:_contentView];
}

- (void)wj_scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0) {
        CGFloat offsetY = -1 * (scrollView.contentOffset.y + scrollView.contentInset.top);
        initialFrame.origin.y = -offsetY * 1.0;
        initialFrame.origin.x = -offsetY / 2.0;
        initialFrame.size.height = defaultViewHeight + offsetY;
        initialFrame.size.width = _tableView.frame.size.width + offsetY;
        _contentView.frame = initialFrame;
    }else{
        CGRect f = _contentView.frame;
        f.size.width = _tableView.frame.size.width;
        _contentView.frame = f;
        _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 2 / 3);
    }
}

- (void)resizeView{
    initialFrame.size.width = _tableView.frame.size.width;
    _contentView.frame = initialFrame;
}

@end

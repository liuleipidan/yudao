//
//  YDRefreshTool.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDRefreshTool.h"

@implementation YDRefreshTool

+ (MJRefreshGifHeader *)yd_MJheaderTarget:(id)target action:(SEL)action{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    
    [YDRefreshTool setBaseProperty:header];
    return header;
}

+ (MJRefreshGifHeader *)yd_MJheaderRefreshingBlock:(MJRefreshComponentRefreshingBlock )block{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:block];
    
    [YDRefreshTool setBaseProperty:header];
    return header;
}

+ (MJRefreshBackGifFooter *)yd_MJfooterTarget:(id)target action:(SEL)action{
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:action];
    [YDRefreshTool setBaseProperty:footer];
    return footer;
}

+ (MJRefreshBackGifFooter *)yd_MJfooterRefreshingBlock:(MJRefreshComponentRefreshingBlock )block{
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:block];
    
    [YDRefreshTool setBaseProperty:footer];
    return footer;
}

#pragma mark - Private Methods
//基础属性
+ (void)setBaseProperty:(id)refreshView{
    if ([refreshView isKindOfClass:[MJRefreshGifHeader class]]) {
        MJRefreshGifHeader *header = refreshView;
        // 设置普通状态的动画图片 (idleImages 是图片)
        [header setImages:[YDRefreshTool idleImages] forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [header setImages:[YDRefreshTool pullingImages] forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [header setImages:[YDRefreshTool refreshingImages] duration:1.0 forState:MJRefreshStateRefreshing];
        [header.stateLabel setFont:[UIFont font_12]];
        [header.stateLabel setTextColor:[UIColor grayTextColor]];
        [header.lastUpdatedTimeLabel setFont:[UIFont font_12]];
        [header.lastUpdatedTimeLabel setTextColor:[UIColor grayTextColor]];
    }
    else if ([refreshView isKindOfClass:[MJRefreshBackGifFooter class]]){
        MJRefreshBackGifFooter *footer = refreshView;
        // 设置普通状态的动画图片 (idleImages 是图片)
        [footer setImages:[YDRefreshTool idleImages] forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [footer setImages:[YDRefreshTool pullingImages] forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [footer setImages:[YDRefreshTool refreshingImages] duration:1.0 forState:MJRefreshStateRefreshing];
        [footer.stateLabel setFont:[UIFont font_12]];
        [footer.stateLabel setTextColor:[UIColor grayTextColor]];
    }
}

//动画图片
+ (NSArray *)idleImages{
    static NSArray *idleImages;
    if (idleImages == nil) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < 11; i++) {
            NSString *str = [NSString stringWithFormat:@"refresh_icon_%d",i];
            UIImage *image = [UIImage imageNamed:str];
            if (image) {
                [tempArr addObject:image];
            }
        }
        idleImages = [NSArray arrayWithArray:tempArr];
    }
    return idleImages;
}

+ (NSArray *)pullingImages{
    static NSArray *pullingImages;
    if (pullingImages == nil) {
        pullingImages = @[[UIImage imageNamed:@"refresh_icon_10"]];
    }
    return pullingImages;
}

+ (NSArray *)refreshingImages{
    static NSArray *refreshingImages;
    if (refreshingImages == nil) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < 29; i++) {
            NSString *str = [NSString stringWithFormat:@"refresh_icon_%d",i];
            UIImage *image = [UIImage imageNamed:str];
            if (image) {
                [tempArr addObject:image];
            }
        }
        refreshingImages = [NSArray arrayWithArray:tempArr];
    }
    return refreshingImages;
}

@end

//
//  YDTableView.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/11.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTableView.h"

@implementation YDTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                   dataSource:(id<UITableViewDataSource>)dataSource
                     delegate:(id<UITableViewDelegate>)delegate{
    if (self = [super initWithFrame:frame style:style]) {
        
        [self setDataSource:dataSource];
        [self setDelegate:delegate];
        
        [self tv_init];
    }
    return self;
}

#pragma mark - Super Methods
- (instancetype)init{
    if (self = [super init]) {
        //默认调用initWithFrame:
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //默认调用initWithFrame:style:
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self tv_init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        //初始化
        [self tv_init];
    }
    return self;
}

- (void)tv_init{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTableFooterView:[UITableViewHeaderFooterView new]];
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //iOS11
    [self yd_setContentInsetAdjustmentBehavior:2];
    [self setEstimatedRowHeight:0.0f];
    [self setEstimatedSectionHeaderHeight:0.0f];
    [self setEstimatedSectionFooterHeight:0.0f];
    
}

@end

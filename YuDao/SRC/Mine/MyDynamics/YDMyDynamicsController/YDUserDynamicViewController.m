//
//  YDUserDynamicViewController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/11.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDUserDynamicViewController.h"
#import "YDUserDynamicViewController+Delegate.h"
#import "YDPlaceholderView.h"

@interface YDUserDynamicViewController ()

@end

@implementation YDUserDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"我的动态"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [YDLoadingHUD showLoadingInView:self.view];
    
    YDWeakSelf(self);
    [self.dynamicProxy requestDynamicsCompletion:^(YDRequestReturnDataType dataType) {
        [weakself.tableView setData:weakself.dynamicProxy.dynamics];
        
        [weakself dataReturnHandle:dataType];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关闭播放
    [self.tableView stopPlay];
}

#pragma mark - Events
- (void)ud_MJHeaderAction:(MJRefreshGifHeader *)header{
    YDWeakSelf(self);
    self.dynamicProxy.pageIndex = 1;
    [self.dynamicProxy requestDynamicsCompletion:^(YDRequestReturnDataType dataType) {
        [weakself.tableView setData:weakself.dynamicProxy.dynamics];
        [header endRefreshing];
    }];
}

- (void)ud_MJFooterAction:(MJRefreshAutoGifFooter *)footer{
    YDWeakSelf(self);
    self.dynamicProxy.pageIndex ++;
    [self.dynamicProxy requestDynamicsCompletion:^(YDRequestReturnDataType dataType) {
        if (dataType == YDRequestReturnDataTypeNomore) {
            [footer endRefreshingWithNoMoreData];
        }
        else{
            [footer endRefreshing];
        }
        [weakself.tableView setData:weakself.dynamicProxy.dynamics];
    }];
}

/**
 第一次数据返回处理
 */
- (void)dataReturnHandle:(YDRequestReturnDataType)type{
    YDPlaceholderView *placeholderView;
    YDWeakSelf(self);
    if (type == YDRequestReturnDataTypeFailure) {
        placeholderView = [[YDPlaceholderView alloc] initWithFrame:self.tableView.frame type:YDPlaceholderViewTypeFailure reloadBtnActionBlock:^{
            [weakself.dynamicProxy requestDynamicsCompletion:^(YDRequestReturnDataType dataType) {
                [weakself.tableView reloadData];
            }];
        }];
        [placeholderView showInView:self.tableView];
    }
    else if (type  == YDRequestReturnDataTypeNULL){
        placeholderView = [[YDPlaceholderView alloc] initWithFrame:self.tableView.frame type:YDPlaceholderViewTypeNoData reloadBtnActionBlock:nil];
        
        [placeholderView setNoDataTitle:@"暂无动态"];
        [placeholderView showInView:self.tableView];
    }
    else if (type == YDRequestReturnDataTypeTimeout){
        
        placeholderView = [[YDPlaceholderView alloc] initWithFrame:self.tableView.frame type:YDPlaceholderViewTypeFailure reloadBtnActionBlock:^{
            [weakself.dynamicProxy requestDynamicsCompletion:^(YDRequestReturnDataType dataType) {
                [weakself.tableView reloadData];
            }];
        }];
        [placeholderView showInView:self.tableView];
    }
    else if (type == YDRequestReturnDataTypeNomore){
        self.tableView.mj_header = [YDRefreshTool yd_MJheaderTarget:self action:@selector(ud_MJHeaderAction:)];
    }
    else{
        self.tableView.mj_header = [YDRefreshTool yd_MJheaderTarget:self action:@selector(ud_MJHeaderAction:)];
        self.tableView.mj_footer = [YDRefreshTool yd_MJfooterTarget:self action:@selector(ud_MJFooterAction:)];
    }
}

#pragma mark - Getters
- (YDDynamicsTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDDynamicsTableView alloc] init];
        _tableView.yd_delegate = self;
    }
    return _tableView;
}

- (YDUserDynamicProxy *)dynamicProxy{
    if (_dynamicProxy == nil) {
        _dynamicProxy = [[YDUserDynamicProxy alloc] init];
    }
    return _dynamicProxy;
}

@end

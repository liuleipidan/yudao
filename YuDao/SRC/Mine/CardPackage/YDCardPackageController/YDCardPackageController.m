//
//  YDCardPackageController.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCardPackageController.h"
#import "YDCardCell.h"
#import "YDCardDetailsController.h"
#import "YDPlaceholderView.h"

@interface YDCardPackageController ()

@property (nonatomic, strong) YDCardPackageProxy *proxy;

@end

@implementation YDCardPackageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init UI
    [self.navigationItem setTitle:@"我的卡包"];
    
    //setup tableView
    [self.tableView registerClass:[YDCardCell class] forCellReuseIdentifier:@"YDCardCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = SCREEN_WIDTH * 110.0 / 375.0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    self.tableView.tableFooterView = [UIView new];
    
    //init data proxy
    self.proxy = [[YDCardPackageProxy alloc] init];
    
    //request data
    [self cpc_headerAction];
}

/**
 处理数据有问题的现实界面
 */
- (void)dataReturnHandle:(YDRequestReturnDataType)type{
    
    YDPlaceholderView *placeholderView;
    if (type == YDRequestReturnDataTypeFailure) {
        YDWeakSelf(self);
        placeholderView = [[YDPlaceholderView alloc] initWithFrame:self.tableView.frame type:YDPlaceholderViewTypeFailure reloadBtnActionBlock:^{
            [weakself cpc_headerAction];
        }];
        [placeholderView showInView:self.tableView];
    }
    else if (type  == YDRequestReturnDataTypeNULL){
        placeholderView = [[YDPlaceholderView alloc] initWithFrame:self.tableView.frame type:YDPlaceholderViewTypeNoData reloadBtnActionBlock:nil];
        
        [placeholderView setNoDataTitle:@"暂无卡券"];
        [placeholderView showInView:self.tableView];
    }
    else if (type == YDRequestReturnDataTypeTimeout){
        [UIAlertController YD_OK_AlertController:self title:@"请求超时" clickBlock:nil];
        YDWeakSelf(self);
        placeholderView = [[YDPlaceholderView alloc] initWithFrame:self.tableView.frame type:YDPlaceholderViewTypeFailure reloadBtnActionBlock:^{
            [weakself cpc_headerAction];
        }];
        [placeholderView showInView:self.tableView];
    }
}
- (void)setMj_header{
    if (self.tableView.mj_header) {
        return;
    }
    self.tableView.mj_header = [YDRefreshTool yd_MJheaderTarget:self action:@selector(cpc_headerAction)];
}

- (void)setMj_footer{
    if (self.tableView.mj_footer) {
        return;
    }
    self.tableView.mj_footer = [YDRefreshTool yd_MJfooterTarget:self action:@selector(cpc_footerAction)];
}

- (void)cpc_headerAction{
    [YDLoadingHUD showLoadingInView:self.view];
    YDWeakSelf(self);
    [self.proxy requestCardPackageCompletion:^(YDRequestReturnDataType dataType) {
        if (dataType == YDRequestReturnDataTypeSuccess) {
            [weakself setMj_header];
            [weakself setMj_footer];
        }
        if ([weakself.tableView.mj_header isRefreshing]) {
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
        }
        if (weakself.proxy.data.count == 0) {
            [weakself dataReturnHandle:dataType];
        }
        [weakself.tableView reloadData];
    }];
}

- (void)cpc_footerAction{
    YDWeakSelf(self);
    [_proxy requestMoreCardseCompletion:^(YDRequestReturnDataType dataType) {
        if (dataType == YDRequestReturnDataTypeNomore) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
        }
        [weakself.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.proxy.data ? self.proxy.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDCardCell"];
    [cell setCard:[self.proxy.data objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YDCardDetailsController *cardDetailsVC = [YDCardDetailsController new];
    [cardDetailsVC setCoupon:[self.proxy.data objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:cardDetailsVC animated:YES];
}



@end

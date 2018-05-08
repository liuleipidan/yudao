//
//  YDMomentViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMomentViewController.h"
#import "YDMomentViewController+TableView.h"
#import "YDPlaceholderView.h"

@interface YDMomentViewController ()

@property (nonatomic, strong) YDProgressHUD *hud;

@end

@implementation YDMomentViewController
- (instancetype)initWithType:(YDGowalkViewControllerType )type{
    if(self = [super init]){
        _vcType = type;
        
        _momentProxy = [[YDMomentProxy alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self registerCellToTableView:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //初始化一次菊花视图
    _hud = [YDLoadingHUD showLoadingInView:self.view];
    [_hud setDisableAutoHide:YES];
    _hud.yOffset = -32;
    
    [self mc_headerAction];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //关闭播放
    [self.tableView stopPlay];
}

#pragma mark - Events
- (void)mc_headerAction{
    YDWeakSelf(self);
    [_momentProxy requestMomentsByControllerType:_vcType completion:^(YDRequestReturnDataType dataType) {
        if (_hud) {
            [_hud hide:YES];
            _hud = nil;
        }
        if (dataType == YDRequestReturnDataTypeSuccess) {
            [weakself setMj_header];
            [weakself setMj_footer];
        }
        
        if ([weakself.tableView.mj_header isRefreshing]) {
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
        }
        if (weakself.momentProxy.moments.count == 0) {
            [weakself dataReturnHandle:dataType];
        }
        [weakself.tableView reloadData];
    }];
}

- (void)mc_footerAction{
    YDWeakSelf(self);
    [_momentProxy requestMoreMomentsByControllerType:_vcType completion:^(YDRequestReturnDataType dataType) {
        if (dataType == YDRequestReturnDataTypeNomore) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [weakself.tableView.mj_footer endRefreshing];
        }
        [weakself.tableView reloadData];
    }];
}

#pragma mark - Private Methods

/**
 处理数据有问题的现实界面
 */
- (void)dataReturnHandle:(YDRequestReturnDataType)type{
    YDPlaceholderView *placeholderView;
    if (type == YDRequestReturnDataTypeFailure) {
        YDWeakSelf(self);
        placeholderView = [[YDPlaceholderView alloc] initWithFrame:self.tableView.frame type:YDPlaceholderViewTypeFailure reloadBtnActionBlock:^{
            [weakself mc_headerAction];
        }];
        [placeholderView showInView:self.tableView];
    }
    else if (type == YDRequestReturnDataTypeNULL){
        placeholderView = [[YDPlaceholderView alloc] initWithFrame:self.tableView.frame type:YDPlaceholderViewTypeNoData reloadBtnActionBlock:nil];
        [placeholderView showInView:self.tableView];
    }
    else if (type == YDRequestReturnDataTypeTimeout){
        [UIAlertController YD_OK_AlertController:self title:@"请求超时" clickBlock:nil];
    }
}
- (void)setMj_header{
    if (self.tableView.mj_header) {
        return;
    }
    self.tableView.mj_header = [YDRefreshTool yd_MJheaderTarget:self action:@selector(mc_headerAction)];
}

- (void)setMj_footer{
    if (self.tableView.mj_footer) {
        return;
    }
    self.tableView.mj_footer = [YDRefreshTool yd_MJfooterTarget:self action:@selector(mc_footerAction)];
}

#pragma mark - Getters
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setTableFooterView:[UIView new]];
        
        [_tableView yd_adaptToIOS11];
    }
    return _tableView;
}

@end

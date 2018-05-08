//
//  YDActivityViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDActivityViewController.h"
#import "YDActivityCell.h"
#import "YDActivityWebController.h"
#import "YDServiceDetailsController.h"

@interface YDActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YDActivityViewModel *viewModel;

@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@end

@implementation YDActivityViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"玩一把"];
    
    _viewModel = [YDActivityViewModel new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self setMj_header];
    
    [YDLoadingHUD showLoadingInView:self.view];
    
    [self requestActivityList];
    
}
//添加下拉刷新
- (void)setMj_header{
    if (self.tableView.mj_header) { return; }
    YDWeakSelf(self);
    MJRefreshGifHeader *header = [YDRefreshTool yd_MJheaderRefreshingBlock:^{
        weakself.viewModel.pageIndex = 1;
        [weakself requestActivityList];
    }];
    
    self.tableView.mj_header = header;
}
//请求活动数据
- (void)requestActivityList{
    YDWeakSelf(self);
    [_viewModel requestActivityListWithSuccess:^(NSArray<YDActivity *> *data, BOOL hasMore) {
        [weakself.tableView reloadData];
        
        if (weakself.tableView.mj_header) {
            [weakself.tableView.mj_header endRefreshing];
        }
        if (!weakself.tableView.mj_footer) {
            weakself.tableView.mj_footer = self.footer;
        }
        if (weakself.tableView.mj_footer) {
            hasMore ? [weakself.tableView.mj_footer endRefreshing] : [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        //若暂无活动，加入提示，点击后回到上一个界面
        if (weakself.viewModel.activityList.count == 0 && data.count == 0) {
            [UIAlertController YD_OK_AlertController:weakself title:@"暂无活动" clickBlock:^{
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        }
        
    } failure:^(NSNumber *code, NSString *status) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _viewModel.activityList ? _viewModel.activityList.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDActivityCell"];
    cell.model = [_viewModel.activityList objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDActivity *activity = [_viewModel.activityList objectAtIndex:indexPath.row];
    switch (activity.type.integerValue) {
        case 1://报名活动
        case 4://活动预热
        {
            YDActivityWebController *webVC = [[YDActivityWebController alloc] init];
            webVC.activity = activity;
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        case 2://积分商城
        {
            YDServiceDetailsController *serviceDetails = [[YDServiceDetailsController alloc] init];
            [serviceDetails setUrlString:activity.type_url];
            [self.navigationController pushViewController:serviceDetails animated:YES];
            break;}
        case 3://外部链接
        {
            YDWKWebViewController *wkVC = [[YDWKWebViewController alloc] init];
            [wkVC setUrlString:activity.type_url];
            [self.navigationController pushViewController:wkVC animated:YES];
            break;}
        default:
        {
            YDActivityWebController *webVC = [[YDActivityWebController alloc] init];
            webVC.activity = activity;
            [self.navigationController pushViewController:webVC animated:YES];
            break;}
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YDActivityCell class] forCellReuseIdentifier:@"YDActivityCell"];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        _tableView.rowHeight = (SCREEN_WIDTH-20) * 0.48;
    }
    return _tableView;
}

- (MJRefreshAutoNormalFooter *)footer{
    if (!_footer) {
        YDWeakSelf(self);
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakself.viewModel.pageIndex++;
            [weakself requestActivityList];
        }];
        [_footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"-- 没有更多了 --" forState:MJRefreshStateNoMoreData];
    }
    return _footer;
}

@end

//
//  YDSelectLocatoinController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSelectLocationController.h"

@interface YDSelectLocationController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YDSelectLocationViewModel *viewModel;

@end

@implementation YDSelectLocationController

- (id)initWitViewModel:(YDSelectLocationViewModel *)viewModel{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self slc_initUI];
    
}

- (void)slc_initUI{
    [self.navigationItem setTitle:@"位置"];
    _tableView = [[UITableView alloc] init];
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = 53;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self setMj_footer];
    [self.tableView.mj_footer beginRefreshing];
}

- (void)setMj_footer{
    if (self.tableView.mj_footer) { return; }
    YDWeakSelf(self);
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself.viewModel searchNearbyWithUserLocation:[YDUserLocation sharedLocation].userCoor completion:^(BOOL noData) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            [weakself.tableView reloadData];
        }];
    }];
    [footer setTitle:@"正在搜索附近的位置" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在搜索附近的位置" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"-- 没有更多了 --" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
}

#pragma mark  - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _viewModel.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *selectedCellID = @"selectedCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:selectedCellID];
    }
    YDPoiInfo *poi = [_viewModel.data objectAtIndex:indexPath.row];
    if ([poi.name isEqualToString:@"不显示位置"]) {
        cell.textLabel.textColor = YDColor(65, 105, 225, 1);
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    if ([poi.name isEqualToString:_viewModel.selectedPoi.name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text  = poi.address;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDPoiInfo *poi = [_viewModel.data objectAtIndex:indexPath.row];
    _viewModel.selectedPoi = poi;
    [YDUserLocation sharedLocation].selectedPoi = poi;
    [tableView reloadData];
    
    if (_SLDidSelectedLoationBlock) {
        _SLDidSelectedLoationBlock(poi);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end

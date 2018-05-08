//
//  YDIntegralController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDIntegralController.h"
#import "YDIntegralHeaderView.h"
#import "YDIntegralCell.h"

#define kIntegralDetailsURL [kOriginalURL stringByAppendingString:@"integraldet"]

@interface YDIntegralController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) YDTableView *tableView;

@property (nonatomic, strong) YDIntegralHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) MJRefreshFooter *footer;

@property (nonatomic, assign) NSUInteger pageIndex;

@property (nonatomic, assign) NSUInteger pageSize;

@end

@implementation YDIntegralController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ic_initUI];
    
    _pageIndex = 1;
    _pageSize = 10;
    
    //请求数据
    [self ic_requestIntegralDetails];
}


- (void)ic_requestIntegralDetails{
    if (_pageIndex == 1) {
        [YDLoadingHUD showLoadingInView:self.view];
    }
    
    NSDictionary *param = @{
                            @"access_token":YDAccess_token,
                            @"pageindex":@(_pageIndex),
                            @"pagesize":@(_pageSize)
                            };
    
    [YDNetworking GET:kIntegralDetailsURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            NSNumber *userfulScore = [data objectForKey:@"available"];
            NSNumber *allScore = [data objectForKey:@"sum"];
            NSMutableArray *tempArr = [NSMutableArray array];
            id list = [data objectForKey:@"list"];
            if ([list isKindOfClass:[NSArray class]]
                || [list isKindOfClass:[NSMutableArray class]]) {
                [tempArr addObjectsFromArray:list];
                [self.data addObjectsFromArray:[YDIntegral mj_objectArrayWithKeyValuesArray:tempArr]];
            }
            
            [self.headerView setAllScore:allScore.integerValue usefulScore:userfulScore.unsignedIntegerValue];
            [self.tableView reloadData];
            
            if (self.tableView.mj_footer) {
                if (tempArr.count < self.pageSize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            else if (tempArr.count == self.pageSize && self.tableView.mj_footer == nil) {
                self.tableView.mj_footer = self.footer;
            }
            
        }
        else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Private Methods
- (void)ic_initUI{
    [_navigationBar setStatus_navigationBackgroundColor:[UIColor whiteColor]];
    _navigationBar.title = @"我的积分";
    _navigationBar.titleColor = [UIColor blackTextColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:@"login_back" imageHL:@"login_back"];
    [leftButton addTarget:self action:@selector(ic_backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar setLeftBarItem:leftButton];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
    
    [self.tableView registerClass:[YDIntegralCell class] forCellReuseIdentifier:@"YDIntegralCell"];
}

- (void)ic_backButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ic_refreshFooterAction:(MJRefreshFooter *)footer{
    _pageIndex++;
    [self ic_requestIntegralDetails];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDIntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDIntegralCell"];
    
    [cell setItem:self.data[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - Getters
- (YDTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDTableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.rowHeight = 67.0f;
    }
    return _tableView;
}

- (YDIntegralHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[YDIntegralHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
    }
    return _headerView;
}

- (NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (MJRefreshFooter *)footer{
    if (_footer == nil) {
        _footer = [YDRefreshTool yd_MJfooterTarget:self action:@selector(ic_refreshFooterAction:)];
    }
    return _footer;
}

@end

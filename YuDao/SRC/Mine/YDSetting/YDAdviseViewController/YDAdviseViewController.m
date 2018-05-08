//
//  YDAdviseViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAdviseViewController.h"
#import "YDAdviseHeaderView.h"
#import "YDAdviseCell.h"

#define kUploadAdviceURL [kOriginalURL stringByAppendingString:@"addfeedback"]

#define kDownloadAdviceURL [kOriginalURL stringByAppendingString:@"lookfeedback"]

#define kAdviseLestLength 20
#define kAdviseMostLength 500

@interface YDAdviseViewController ()<UITableViewDataSource,UITableViewDelegate,YDAdviseHeaderViewDelegate>

@property (nonatomic, strong) YDTableView *tableView;

@property (nonatomic, strong) YDAdviseHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) NSUInteger pageIndex;

@property (nonatomic, assign) NSUInteger pageSize;

@property (nonatomic, strong) MJRefreshFooter *footer;

@end

@implementation YDAdviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"意见反馈"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _pageIndex = 1;
    _pageSize = 10;
    [self ad_requestAdviseHistory];
}

#pragma mark - Private Methods
- (void)ad_requestAdviseHistory{
    NSDictionary *param = @{
                            @"access_token":YDAccess_token,
                            @"pageindex":@(_pageIndex),
                            @"pagesize":@(_pageSize)
                            };
    [YDNetworking GET:kDownloadAdviceURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            NSArray *tempArr = [YDAdvise mj_objectArrayWithKeyValuesArray:data];
            [self.data addObjectsFromArray:tempArr];
            [self.tableView reloadData];
            
            if (self.tableView.mj_footer) {
                if (tempArr.count < _pageSize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            else if (tempArr.count == _pageSize && self.tableView.mj_footer == nil) {
                self.tableView.mj_footer = self.footer;
            }
        }
        else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Events
- (void)ad_commitButtonAction:(UIButton *)sender{
    [self.view endEditing:YES];
    if (self.headerView.text.length < 20) {
        [YDMBPTool showInfoImageWithMessage:@"请输入20个文字以上" hideBlock:^{

        }];
        return;
    }
    NSDictionary *paramter = @{@"access_token":YDAccess_token,
                               @"opinion":self.headerView.text};
    [YDLoadingHUD showLoadingInView:self.view];
    YDWeakSelf(self);
    [YDNetworking GET:kUploadAdviceURL parameters:paramter success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            [weakself.headerView setText:@""];
            [YDMBPTool showSuccessImageWithMessage:@"提交成功" hideBlock:^{
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [YDMBPTool showErrorImageWithMessage:YDNoNilString(status) hideBlock:nil];
        }
    } failure:^(NSError *error) {
            [YDMBPTool showErrorImageWithMessage:@"提交失败" hideBlock:nil];
    }];
    
}

- (void)ad_refreshFooterAction:(MJRefreshFooter *)footer{
    _pageIndex++;
    [self ad_requestAdviseHistory];
}

#pragma mark - YDAdviseHeaderViewDelegate
- (void)adviseHeaderView:(YDAdviseHeaderView *)headerView didClickedCommitButton:(UIButton *)button{
    [self ad_commitButtonAction:button];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDAdviseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDAdviseCell"];
    [cell setItem:self.data[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDAdvise *item = self.data[indexPath.row];
    return item.wholeHeight;
}

#pragma mark - Getter
- (YDTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDTableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor grayBackgoundColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headerView;
        
        [_tableView registerClass:[YDAdviseCell class] forCellReuseIdentifier:@"YDAdviseCell"];
    }
    return _tableView;
}

- (YDAdviseHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[YDAdviseHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20 + SCREEN_WIDTH * 0.48 + 30 + kHeight(44) + 40 + 22)];
        _headerView.delegate = self;
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
        _footer = [YDRefreshTool yd_MJfooterTarget:self action:@selector(ad_refreshFooterAction:)];
    }
    return _footer;
}

@end

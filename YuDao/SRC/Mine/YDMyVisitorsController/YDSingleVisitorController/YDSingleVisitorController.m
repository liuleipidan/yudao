//
//  YDSingleVisitorController.m
//  YuDao
//
//  Created by 汪杰 on 17/1/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSingleVisitorController.h"

@interface YDSingleVisitorController ()

@property (nonatomic, strong) NSArray<YDVisitorsModel *> *data;

@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@end

@implementation YDSingleVisitorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self svc_initUI];
    
    [self.footer beginRefreshing];
}

- (void)svc_initUI{
    
    [self.tableView registerClass:[YDSingleVisitorCell class] forCellReuseIdentifier:@"YDSingleVisitorCell"];
    
    self.tableView.separatorColor = [UIColor whiteColor];
    
    self.tableView.rowHeight = 70.f;
    
    self.tableView.mj_footer = self.footer;
}

//获取访客
- (void)downloadVisitors{
    YDWeakSelf(self);
    NSDictionary *parameters = @{@"access_token":YDAccess_token,
                                 @"limit":@20,
                                 @"type":@(_visitorType)};
    YDLog(@"parameters = %@",parameters);
    [YDNetworking GET:kVisitorsURL parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        
        if ([code isEqual:@200]) {
            NSArray *tempArr = [YDVisitorsModel mj_objectArrayWithKeyValuesArray:data];
            if (tempArr.count == 0) {
                [weakself.footer setTitle:@"-- 暂时没有 --" forState:MJRefreshStateNoMoreData];
            }
            else{
                [weakself.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
                weakself.data = [NSArray arrayWithArray:tempArr];
            }
            [weakself.footer endRefreshingWithNoMoreData];
            [weakself.tableView reloadData];
        }
        else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data? self.data.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDSingleVisitorCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"YDSingleVisitorCell"];
    cell.visitorType = _visitorType;
    cell.visitorModel = _data[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDVisitorsModel *model = _data[indexPath.row];
    //跳转到个人详情页面
    
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:model.vis_id];
    viewM.userName = model.ub_nickname;
    viewM.userHeaderUrl = model.ud_face;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];

    [self.parentViewController.navigationController pushViewController:userVC animated:YES];
}

- (MJRefreshAutoNormalFooter *)footer{
    if (!_footer) {
        YDWeakSelf(self);
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself downloadVisitors];
        }];
        [_footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"-- 暂时没有 --" forState:MJRefreshStateNoMoreData];
    }
    return _footer;
}

@end

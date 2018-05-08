//
//  YDLikePersonController.m
//  YuDao
//
//  Created by 汪杰 on 16/11/3.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDLikePersonController.h"
#import "YDLikePersonController+Delegate.h"

#define kMyLikedPeopleURL [kOriginalURL stringByAppendingString:@"like"]

@interface YDLikePersonController ()
{
    UIButton *_firstBtn;
    UIButton *_secondBtn;
    UIButton *_thirdBtn;
    NSMutableArray *_buttons;
}

@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@end

@implementation YDLikePersonController

- (id)init{
    if (self = [super init]) {
        _likedType = YDLikedPeopleTypeLikeMe;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self lpc_initUI];
    
    [self.footer beginRefreshing];
}

#pragma mark - Private Methods
- (void)downloadDataWithType:(YDLikedPeopleType )type{
    YDWeakSelf(self);
    NSDictionary *para = @{@"access_token":YDAccess_token,@"type":@(self.likedType)};
    [YDNetworking GET:kMyLikedPeopleURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        if (weakself.data == nil) {
            weakself.data = [NSMutableArray array];
        }
        
        [weakself.data addObjectsFromArray:[YDLikePersonModel mj_objectArrayWithKeyValuesArray:data]];
        
        if (weakself.data.count == 0) {
            [weakself.footer setTitle:@"-- 暂时没有 --" forState:MJRefreshStateNoMoreData];
        }else{
            [weakself.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        }
        [weakself.footer endRefreshingWithNoMoreData];
        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
        [weakself.footer setTitle:@"-- 暂时没有 --" forState:MJRefreshStateNoMoreData];
        [weakself.footer endRefreshingWithNoMoreData];
    }];
}

- (void)lpc_initUI{
    [self.navigationItem setTitle:@"喜欢的人"];
    
    [self registerCellClass];
    [self.tableView setTableFooterView:[UIView new]];
    self.tableView.rowHeight = 70.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.mj_footer = self.footer;
}

- (MJRefreshAutoNormalFooter *)footer{
    if (!_footer) {
        YDWeakSelf(self);
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself downloadDataWithType:weakself.likedType];
        }];
        [_footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"-- 暂时没有 --" forState:MJRefreshStateNoMoreData];
    }
    return _footer;
}

@end

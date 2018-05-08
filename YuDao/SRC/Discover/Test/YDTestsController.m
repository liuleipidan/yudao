//
//  YDTestsController.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestsController.h"
#import "YDTestsController+Delegate.h"
#import "YDTestSwitchCarView.h"
#import "YDBluetoothManager.h"


@interface YDTestsController ()

@property (nonatomic, strong) YDTestSwitchCarView *switchView;

@property (nonatomic, strong) UIView *topBGView;

@end

@implementation YDTestsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UI
    [self.navigationItem setTitleView:self.titleView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self registerCells];
    
    //Data
    if (self.car == nil) {
        [self setCar:[[YDCarHelper sharedHelper] defaultCar]];
    }
    if (self.car == nil) {
        [UIAlertController YD_OK_AlertController:self title:@"当前数据存在问题" clickBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    
}

- (void)dealloc{
    YDLog();
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController yd_hiddenBottomImageView:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController yd_hiddenBottomImageView:NO];
}

#pragma mark - Public Methods
- (void)setCar:(YDCarDetailModel *)car{
    _car = car;
    
    [self.topView setCarInfo:self.car];
    [self.tableView reloadData];
    [self.titleView setTitle:self.car.ug_series_name];
    
    if (car) {
        [self requestCarTestData];
    }
    
    if (car.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR ||
        car.boundDeviceType == YDCarBoundDeviceTypeVE_AIR) {
        [[YDBluetoothManager manager] setCurrentCar:car];
    }
}

//请求车辆数据
- (void)requestCarTestData{
    if (!self.tableView.mj_header.isRefreshing) {
        [YDLoadingHUD showLoadingInView:self.view];
    }
    
    NSDictionary *parameters  = @{@"access_token":YDAccess_token,
                                  @"ug_id"  :YDNoNilNumber(self.car.ug_id)};
    
    [YDNetworking GET:kTestDataURL parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200] && data) {
            self.car.testModel = [YDTestsModel mj_objectWithKeyValues:data];
            if (self.tableView.tableHeaderView == nil) {
                [self.tableView setTableHeaderView:self.topView];
            }
            if (self.tableView.mj_header == nil) {
                self.tableView.mj_header = [YDRefreshTool yd_MJheaderTarget:self action:@selector(tc_tableRefreshHeader:)];
            }
            
            [self.topView startAnimationByPercent:self.car.testModel.ug_health.integerValue isOpen:[self.car.testModel.isopen isEqual:@1]];
        }
        else{
            [YDMBPTool showInfoImageWithMessage:@"请求失败" hideBlock:^{
                
            }];
        }
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [YDMBPTool showInfoImageWithMessage:@"请求失败" hideBlock:^{
            
        }];
    }];
}

#pragma mark - Events
- (void)tc_tableRefreshHeader:(MJRefreshHeader *)header{
    [self requestCarTestData];
}


#pragma mark - Getters
- (YDTestTitleView *)titleView{
    if (_titleView == nil) {
        _titleView = [[YDTestTitleView alloc] initWithFrame:CGRectZero];
        YDWeakSelf(self);
        [_titleView setTTTapChangeCarBlock:^{
            if (weakself.switchView.isShow) {
                [weakself.switchView dismiss];
            }
            else{
                weakself.switchView.selectedCar = weakself.switchView.selectedCar ? : weakself.car;
                [weakself.switchView showInView:weakself.navigationController.view data:[YDCarHelper sharedHelper].carArray];
            }
        }];
    }
    return _titleView;
}

- (YDTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDTableView alloc] initWithFrame:CGRectZero];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        
//        UIView *topBgView = [UIView new];
//        topBgView.backgroundColor = [UIColor redColor];
//        [_tableView insertSubview:topBgView atIndex:0];
//        [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.tableView);
//            make.centerX.equalTo(self.tableView);
//            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.height.mas_equalTo(370);
//        }];
//        _topBGView = topBgView;
    }
    return _tableView;
}

- (YDTestTopView *)topView{
    if (_topView == nil) {
        _topView = [[YDTestTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 340)];
    }
    return _topView;
}

- (YDTestSwitchCarView *)switchView{
    if (_switchView == nil) {
        _switchView = [[YDTestSwitchCarView alloc] initWithFrame:CGRectZero];
        YDWeakSelf(self);
        [_switchView setSCDidSelectedCarBlack:^(YDCarDetailModel *selectedCar) {
            [weakself setCar:selectedCar];
        }];
    }
    return _switchView;
}

@end

//
//  YDDiscoverController.m
//  YuDao
//
//  Created by 汪杰 on 17/3/2.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDiscoverController.h"
#import "YDRankListViewController.h"
#import "YDAllDynamicController.h"
#import "YDTestsController.h"
#import "YDSlipFaceController.h"
#import "YDBiBiController.h"
#import "YDActivityViewController.h"
#import "YDMomentViewController.h"
#import "YDContactHeaderView.h"
#import "YDGameViewController.h"
#import "YDCustomNavigationAnimation.h"

@interface YDDiscoverController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) YDDiscoverViewModel *viewM;

@property (nonatomic, strong) YDAllDynamicController *dynamicsVC;

@property (nonatomic,strong) YDRankListViewController *rankListVC;

//记录排行榜数据的时间,暂存1小时
@property (nonatomic, strong) NSDate *rankListDate;

@end

@implementation YDDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"发现"];
    
    _viewM = [[YDDiscoverViewModel alloc] init];
    
    [self.view addSubview:self.tableView];
    
    [[YDUserDefault defaultUser] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    YDWeakSelf(self);
    [_viewM reloadDataSource:^{
        [weakself.tableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)dealloc{
    [[YDUserDefault defaultUser] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - YDUserDefaultDelegate
- (void)defaultUserAlreadyLogged:(YDUser *)user{
    [self reloadShowData];
}
- (void)defaultUserExitingLogin{
    [self reloadShowData];
}

#pragma mark - Private Methods
/**
 登录或注销需要置空“排行榜”和“逛一逛”，同时检测是否需要显示“测一测”
 */
- (void)reloadShowData{
    self.dynamicsVC = nil;
    self.rankListVC = nil;
    YDWeakSelf(self);
    [_viewM reloadDataSource:^{
        [weakself.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewM.data ? self.viewM.data.count : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArray = [self.viewM.data objectAtIndex:section];
    return sectionArray ? sectionArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"discoverCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSMutableArray *section = [self.viewM.data objectAtIndex:indexPath.section];
    NSDictionary *dic =  [section objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[dic valueForKey:@"image"]];
    cell.textLabel.text = [dic valueForKey:@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *section = [self.viewM.data objectAtIndex:indexPath.section];
    NSDictionary *dic =  [section objectAtIndex:indexPath.row];
    NSString *title = [dic valueForKey:@"title"];
    if ([title isEqualToString:@"排行榜"]) {
        if (self.rankListDate == nil) {
            self.rankListDate = [NSDate date];
        }
        else if ([NSDate differFirstDate:[NSDate date] secondDate:self.rankListDate differType:YDDifferDateTypeMinute] >= 60){
            self.rankListDate = [NSDate date];
            self.rankListVC = nil;
        }
        [self.navigationController pushViewController:self.rankListVC animated:YES];
    }
    else if ([title isEqualToString:@"逛一逛"]){
        [YDAllDynamicController sharedAlldynamicVC].fromFlag = 0;
        [self.navigationController pushViewController:self.dynamicsVC animated:YES];
    }
    else if ([title isEqualToString:@"测一测"]){
        YDTestsController *testVC = [YDTestsController new];
        
        [self.navigationController pushViewController:testVC animated:YES];
    }
    else if ([title isEqualToString:@"刷脸"]){
        if (YDHadLogin) {
            [self.navigationController pushViewController:[YDSlipFaceController new] animated:YES];
        }else{
            [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }];
        }
    }
    else if ([title isEqualToString:@"哔哔"]){
        [self.navigationController pushViewController:[YDBiBiController new] animated:YES];
    }
    else if ([title isEqualToString:@"玩一把"]){
        [self.navigationController pushViewController:[YDActivityViewController new] animated:YES];
    }
    else if ([title isEqualToString:@"游戏"]){
        if (YDHadLogin) {
            [self.navigationController pushViewController:[YDGameViewController new] animated:YES];
        }
        else{
            [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YDContactHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YDContactHeaderView"];
    [view setBgColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0){
    
    if (operation == UINavigationControllerOperationPop){
        return [YDCustomNavigationAnimation new];
    }
    else if (operation == UINavigationControllerOperationPush){
        return [YDCustomNavigationAnimation new];
    }
    
    return nil;
}

#pragma mark - Gerter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = 44.f;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor grayBackgoundColor];
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[YDContactHeaderView class] forHeaderFooterViewReuseIdentifier:@"YDContactHeaderView"];
        
        //关闭ContentInsetAdjust
        [_tableView yd_adaptToIOS11];
    }
    return _tableView;
}

- (YDAllDynamicController *)dynamicsVC{
    if (!_dynamicsVC) {
        _dynamicsVC = [[YDAllDynamicController alloc] init];
    }
    return _dynamicsVC;
}

-(YDRankListViewController *)rankListVC{
    if (!_rankListVC) {
        _rankListVC = [[YDRankListViewController alloc] init];
    }
    return _rankListVC;
}

@end

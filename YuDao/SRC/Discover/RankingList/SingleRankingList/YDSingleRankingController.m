//
//  YDSingleRankingController.m
//  YuDao
//
//  Created by 汪杰 on 2017/1/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSingleRankingController.h"
#import "YDUserFilesController.h"
#import "YDSingleRLBottomView.h"
#import "YDPlaceholderView.h"


#define kRankingBottomViewHeight 70.0f

@interface YDSingleRankingController ()<UITableViewDataSource,UITableViewDelegate,YDSingleRankingListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

//底部浮动栏，用户展示当前数据
@property (nonatomic, strong) YDSingleRLBottomView *bottomView;

/**
 加载失败标示
 */
@property (nonatomic,assign) BOOL loadFailure;

@end

@implementation YDSingleRankingController
- (id)initWitViewModel:(YDSingleRankingViewModel *)viewModel{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kRankingBottomViewHeight);
    }];
    
    //当前排行榜为里程时直接加载数据
    if (_viewModel.dataType == YDRankingListDataTypeMileage) {
        [self requestRankingListWithCondition:YDRankingListFilterConditionNo];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

///请求排行榜数据
- (void)requestRankingListWithCondition:(YDRankingListFilterCondition)condition{
    
    //条件没变直接return
    if (_viewModel.condition == condition && !_loadFailure) {
        NSLog(@"条件没变直接return");
        return;
    }
    
    //若有占位图，移除占位图
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[YDPlaceholderView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    _loadFailure = NO;
    
    YDProgressHUD *hud = [YDLoadingHUD showLoadingInView:self.view];
    [hud setDisableAutoHide:YES];
    YDWeakSelf(self);
    [_viewModel requestRankingListByFilterCondition:condition completion:^(YDRequestReturnDataType dataType) {
        [hud hide];
        if (weakself.viewModel.isTopTen || weakself.viewModel.currentUserData == nil) {
            weakself.tableView.tableFooterView.height = 5;
            [weakself.bottomView setItem:nil];
            [weakself.bottomView dismissWithAnimation:YES];
        }
        else{
            weakself.tableView.tableFooterView.height = kRankingBottomViewHeight + 5;
            [weakself.bottomView setItem:weakself.viewModel.currentUserData];
            [weakself.bottomView showWithAnimation:YES];
        }
        [weakself.tableView reloadData];
        [weakself dataReturnHandle:dataType];
    }];
}

#pragma mark - Private Methods

/**
 处理数据有问题的现实界面
 */
- (void)dataReturnHandle:(YDRequestReturnDataType)type{
    
    YDPlaceholderView *placeholderView;
    if (type == YDRequestReturnDataTypeFailure) {
        _loadFailure = YES;
        YDWeakSelf(self);
        placeholderView = [[YDPlaceholderView alloc] initWithFrame:self.tableView.frame type:YDPlaceholderViewTypeFailure reloadBtnActionBlock:^{
            [weakself requestRankingListWithCondition:weakself.viewModel.condition];
        }];
        [placeholderView showInView:self.view];
    }
    else if (type == YDRequestReturnDataTypeNULL){
        placeholderView = [[YDPlaceholderView alloc] initWithFrame:self.tableView.frame type:YDPlaceholderViewTypeNoData reloadBtnActionBlock:nil];
        [placeholderView setNoDataTitle:@"暂无此类排行榜"];
        [placeholderView showInView:self.view];
    }
    else if (type == YDRequestReturnDataTypeTimeout){
        [UIAlertController YD_OK_AlertController:self title:@"请求超时" clickBlock:nil];
    }
}

#pragma mark - YDSingleRankingListCellDelegate
- (void)singleRankingListCell:(YDSingleRankingListCell *)cell didClickedLikeButton:(YDSingleRLLikeButton *)likeButton{
    
    if (!YDHadLogin) {
        [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
            [[YDRootViewController sharedRootViewController] presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        }];
        return;
    }
    [likeButton setSelected:!likeButton.selected];
    NSInteger value = likeButton.title.integerValue;
    value = likeButton.selected ? ++value : --value;
    NSLog(@"value = %ld",value);
    [likeButton setTitle:[NSString stringWithFormat:@"%ld",value]];
    
    NSDictionary *parameter = @{@"d_id":cell.item.ub_id,
                                @"access_token":YDAccess_token,
                                @"tl_type":@(cell.item.type+1)};
    [YDNetworking POST:kAddLikedynamicURL parameters:parameter success:^(NSNumber *code, NSString *status, id data) {
        YDLog(@"rankingList_tapLike_code = %@",code);
    } failure:^(NSError *error) {
        YDLog(@"rankingList_tapLike_error = %@",error.localizedDescription);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _viewModel.data ? _viewModel.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDSingleRankingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDSingleRankingListCell"];
    
    YDRankingListModel *item = _viewModel.data[indexPath.row];
    [cell setItem:item];
    [cell setDelegate:self];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YDRankingListModel *item = _viewModel.data[indexPath.row];
    UIViewController *parentViewController = [UIViewController yd_getTheCurrentViewController];
    
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:item.ub_id];
    viewM.userName = item.ub_nickname;
    viewM.userHeaderUrl = item.ud_face;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];

    [parentViewController.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - Getters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.rowHeight = 70.0f;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[YDSingleRankingListCell class] forCellReuseIdentifier:@"YDSingleRankingListCell"];
    }
    return _tableView;
}
- (YDSingleRLBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[YDSingleRLBottomView alloc] init];
        _bottomView.alpha = 0;
    }
    return _bottomView;
}

@end

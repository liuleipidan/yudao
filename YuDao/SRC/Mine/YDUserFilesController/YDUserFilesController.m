//
//  YDUserFilesController.m
//  YuDao
//
//  Created by 汪杰 on 16/12/29.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUserFilesController.h"
#import "YDUserFilesController+Delegate.h"

@interface YDUserFilesController ()

@property (nonatomic, strong) UIButton *backButton;

@end

@implementation YDUserFilesController

- (instancetype)initWithViewModel:(YDUserFilesViewModel *)model{
    if(self = [super init]){
        _viewModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ufc_initUI];
    
    //请求用户档案
    YDWeakSelf(self);
    [YDLoadingHUD showLoadingInView:self.view];
    
    [_viewModel requestUserInformation:^{
        weakself.userInfo = weakself.viewModel.userInfo;
        [weakself handleUserInformation:weakself.userInfo];
    } failure:^{
        
    }];
    
    [self requestDynamics];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)dealloc{
    YDLog();
}

- (void)ufc_leftBtnAction:(id )sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ufc_initUI{
    
    [self.navigationItem setTitle:@"个人资料"];
    
    [self.view yd_addSubviews:@[
                                self.dynamicTable,
                                self.tableView,
                                self.scrollBackView,
                                self.bottomView,
                                self.backButton
                                ]];
    
    //注册Cells
    [self registerCellClass];
    
    //顶部偏移适配
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

#pragma mark - Private Methods
- (void)requestDynamics{
    if (!self.dynamicTable.mj_footer.isRefreshing) {
        [YDLoadingHUD showLoadingInView:self.dynamicTable];
    }
    YDWeakSelf(self);
    [_viewModel requestUserDynamics:^(BOOL hasMore) {
        [weakself.dynamicTable setData:weakself.viewModel.dynamics];
        
        hasMore ? [weakself.dynamicTable.mj_footer endRefreshing] : [weakself.dynamicTable.mj_footer endRefreshingWithNoMoreData];
        
    } failure:^{
        [weakself.dynamicTable.mj_footer endRefreshing];
    }];
}
//刷新用户信息
- (void)handleUserInformation:(YDUserInfoModel *)userInfo{
    //[self.dynamicTable setHeaderImageStr:userInfo.ud_background];
    
    //刷新底部视图
    [self.bottomView showInView:self.view userInfo:userInfo];
    
    [self.headerView updateDataWith:userInfo.ud_face name:userInfo.ub_nickname start:userInfo.ud_constellation gender:userInfo.ud_sex.integerValue level:[NSString stringWithFormat:@"V%@",userInfo.ub_auth_grade] likeNum:userInfo.ud_likeunm score:userInfo.ud_credit backgroudImageUrl:userInfo.ud_background];
    YDUserBaseInfoModel *model1 = [self.userInfoArray objectAtIndex:0];
    YDUserBaseInfoModel *model2 = [self.userInfoArray objectAtIndex:1];
    YDUserBaseInfoModel *model3 = [self.userInfoArray objectAtIndex:2];
    
    model1.subTitle = [NSString stringWithFormat:@"%@",userInfo.ub_id];
    model2.subTitle = userInfo.vehicle?userInfo.vehicle:@"暂无";
    model3.subTitle = [NSString stringWithFormat:@"%@ %@ %@",userInfo.ud_often_province_name,userInfo.ud_often_city_name,userInfo.ud_often_area_name];
    
    //认证状态
    NSArray *auths = @[YDNoNilNumber(userInfo.ud_faceauth),
                       YDNoNilNumber(userInfo.ud_videoauth),
                       YDNoNilNumber(userInfo.ud_aliauth),
                       YDNoNilNumber(userInfo.ug_vehicle_auth),
                       YDNoNilNumber(userInfo.mybound)];
    [self.userInfoArray replaceObjectAtIndex:3 withObject:auths];
    if (userInfo.ud_tag_name) {
        NSArray *interests = [userInfo.ud_tag_name componentsSeparatedByString:@","];
        if (userInfo.ud_ftag) {
            NSArray *f_tags = [userInfo.ud_ftag componentsSeparatedByString:@","];
            _f_tags = f_tags;
        }
        [self.userInfoArray replaceObjectAtIndex:4 withObject:interests];
    }
    [self.tableView reloadData];
}

#pragma mark - Events
//点击回到个人资料
- (void)tapScrollBackView:(UIGestureRecognizer *)tap{
    tap.view.hidden = YES;
    self.title = @"个人资料";
    [self.dynamicTable setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.y = 0;
    } completion:^(BOOL finished) {
        self.headerView.backImageV.hidden = NO;
        self.bottomView.hidden = NO;
    }];
}
//向上滑回到个人资料
- (void)swipeScrollBackView:(UISwipeGestureRecognizer *)swipe{
    swipe.view.hidden = YES;
    self.title = @"个人资料";
    [self.dynamicTable setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.y = 0;
    } completion:^(BOOL finished) {
        self.headerView.backImageV.hidden = NO;
        self.bottomView.hidden = NO;
    }];
}

#pragma mark - Getters
- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:@"mine_goBack" imageHL:@"mine_goBack"];
        _backButton.frame = CGRectMake(10, 20, 40, 44);
        [_backButton addTarget:self action:@selector(ufc_leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headerView;
        BOOL isSelf = [[YDUserDefault defaultUser].user.ub_id isEqual:self.viewModel.uid];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, isSelf ? 0 : kHeight(50))];
        footerView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = footerView;
        
        //关闭ContentInsetAdjust
        [_tableView yd_setContentInsetAdjustmentBehavior:2];
    }
    return _tableView;
}

- (NSMutableArray *)userInfoArray{
    if (!_userInfoArray) {
        _userInfoArray = [NSMutableArray arrayWithCapacity:5];
        YDUserBaseInfoModel *model1 = [YDUserBaseInfoModel userInfoModelWith:@"ID" subTitle:@""];
        YDUserBaseInfoModel *model2 = [YDUserBaseInfoModel userInfoModelWith:@"爱车" subTitle:@""];
        YDUserBaseInfoModel *model3 = [YDUserBaseInfoModel userInfoModelWith:@"常出没地点" subTitle:@""];
        [_userInfoArray addObjectsFromArray:@[model1,model2,model3]];
        [_userInfoArray addObject:[NSMutableArray arrayWithCapacity:5]];
        [_userInfoArray addObject:[NSMutableArray arrayWithCapacity:5]];
    }
    return _userInfoArray;
}

- (YDDynamicsTableView *)dynamicTable{
    if (!_dynamicTable) {
        _dynamicTable = [[YDDynamicsTableView alloc] initWithFrame:self.view.bounds];
        _dynamicTable.yd_delegate = self;
        MJRefreshBackGifFooter *footer = [YDRefreshTool yd_MJfooterTarget:self action:@selector(requestDynamics)];
        [footer setTitle:@"--- 没有更多了 ---" forState:MJRefreshStateNoMoreData];
        _dynamicTable.mj_footer = footer;
    }
    return _dynamicTable;
}

- (YDUFHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YDUFHeaderView alloc] init];
        float h1 = 2.0f/3.0f * SCREEN_WIDTH;
        float h2 = kWidth(47);
        float h3 = 15+1+49+10;
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, h1+h2+h3);
        _headerView.subDelegate = self;
        _headerView.nameLabel.text = YDNoNilString(_viewModel.userName);
        [_headerView.headerImageV yd_setImageWithString:_viewModel.userHeaderUrl placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
    }
    return _headerView;
}

- (YDUserFilesBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[YDUserFilesBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kHeight(50), SCREEN_WIDTH, kHeight(50))];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (UIView *)scrollBackView{
    if (!_scrollBackView) {
        _scrollBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kHeight(50), SCREEN_WIDTH, kHeight(50))];
        _scrollBackView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _scrollBackView.hidden = YES;
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userFiles_topBack"]];
        imageV.frame = CGRectMake((SCREEN_WIDTH-20)/2, 20, 20, 10);
        [_scrollBackView addSubview:imageV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollBackView:)];
        [_scrollBackView addGestureRecognizer:tap];
        UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeScrollBackView:)];
        swipeGR.numberOfTouchesRequired =1;
        //设置轻扫动作的方向
        swipeGR.direction = UISwipeGestureRecognizerDirectionUp;
        [_scrollBackView addGestureRecognizer:swipeGR];
    }
    return _scrollBackView;
}

- (YDPictureBrowseInteractiveAnimatedTransition *)animatedTransition{
    if (_animatedTransition == nil) {
        _animatedTransition = [YDPictureBrowseInteractiveAnimatedTransition new];
    }
    return _animatedTransition;
}

@end

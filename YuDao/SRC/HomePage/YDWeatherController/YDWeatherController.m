//
//  YDWeatherController.m
//  YuDao
//
//  Created by 汪杰 on 16/12/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDWeatherController.h"
#import "YDWeatherHeaderView.h"

@interface YDWeatherController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) YDTableView *tableView;

@property (nonatomic, strong) YDWeatherHeaderView *headerView;

@end

@implementation YDWeatherController
{
    NSArray     *_icons;
    NSArray     *_titles;
    NSArray     *_subTitles;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UI
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationBar.title = [YDUserLocation sharedLocation].userCity;
    self.navigationBar.titleColor = [UIColor whiteColor];
    [self.navigationBar setStatus_navigationBackgroundColor:[UIColor clearColor]];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:@"navigation_back_image" imageHL:@"navigation_back_image"];
    [leftButton addTarget:self action:@selector(wc_backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar setLeftBarItem:leftButton];
    
    [self.tableView setTableHeaderView:self.headerView];
    [self.view insertSubview:self.tableView belowSubview:self.navigationBar];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //请求数据
    [self wc_downloadWeatherData];
}


- (void)setModel:(YDWeatherModel *)model{
    if (model == nil) {
        return;
    }
    _model = model;
    _icons = @[
               @"weather_car",
               @"weather_clother",
               @"weather_exercise",
               @"weather_travel"];
    _titles = @[@"洗车指数",
                @"穿衣指数",
                @"运动指数",
                @"旅游指数"];
    
    _subTitles = @[
                   YDNoNilString(model.washCarDesc),
                   YDNoNilString(model.clothesDesc),
                   YDNoNilString(model.sportsDesc),
                   YDNoNilString(model.travelDesc)];
    [self.headerView setModel:model];
    
    [self.tableView reloadData];
}

#pragma mark - Private Methods
//返回
- (void)wc_backButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//下载车辆数据
- (void)wc_downloadWeatherData{
    
    [YDLoadingHUD showLoadingInView:self.view];
    
    YDWeakSelf(self);
    [YDWeatherModel requestWeatherData:^(YDWeatherModel *weather) {
        [weakself setModel:weather];
    } failure:^{
        [YDMBPTool showInfoImageWithMessage:@"天气请求失败" hideBlock:^{
           [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model ? 4 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDWeatherCell"];
    cell.iconV.image = [UIImage imageNamed:_icons[indexPath.row]];
    cell.titleLabel.text = _titles[indexPath.row];
    cell.subTitleLabel.text = _subTitles[indexPath.row];
    
    return cell;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //限制顶部滑动
    CGPoint offset = scrollView.contentOffset;
    if (offset.y <= 0) {
        [scrollView setContentOffset:CGPointMake(offset.x, 0)];
    }
}

#pragma mark - Getters
- (YDWeatherHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[YDWeatherHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 334)];
    }
    return _headerView;
}

-  (YDTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain dataSource:self delegate:self];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 75;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[YDWeatherCell class] forCellReuseIdentifier:@"YDWeatherCell"];
    }
    return _tableView;
}

@end

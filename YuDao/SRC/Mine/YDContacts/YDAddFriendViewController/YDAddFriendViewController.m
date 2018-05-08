//
//  YDAddFriendViewController.m
//  YuDao
//
//  Created by 汪杰 on 16/10/17.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDAddFriendViewController.h"
#import "YDSearchController.h"
#import "YDQRCodeController.h"
#import "YDPhoneContactsController.h"
#import "YDScannerViewController.h"
#import "YDAFSearchResultController.h"
#import "YDWebController.h"
#import "YDUserFilesController.h"

@interface YDAddFriendViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) YDSearchController *searchController;

@property (nonatomic, strong) UIView           *tableHeaderView;

@property (nonatomic, strong) YDAFSearchResultController *searchResultVC;

@end

@implementation YDAddFriendViewController
{
    NSArray *_images;
    NSArray *_titles;
    NSArray *_subTitles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    
    _images = @[@"mine_contacts_scan",@"mine_contacts_iphone"];
    _titles = @[@"扫一扫",@"手机联系人"];
    _subTitles = @[@"扫描二维码名片",@"添加手机通讯录中的朋友"];
    
    //适配UISearchController的动画效果
    self.definesPresentationContext = YES;
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    
    [self.tableView setTableHeaderView:self.tableHeaderView];
    self.tableView.rowHeight = 63.f;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - Events
//点击我的二维码
- (void)tapMyCodeViewAction:(UITapGestureRecognizer *)tap{
    [self.navigationController pushViewController:[YDQRCodeController new] animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _images.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *YDAddFCell = @"YDAddFCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YDAddFCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:YDAddFCell];
        cell.textLabel.textColor = YDBaseColor;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        cell.detailTextLabel.textColor = [UIColor grayTextColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.detailTextLabel.text = _subTitles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_images[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        YDScannerViewController *scanVC = [YDScannerViewController new];
        [scanVC setScannerType:YDScannerTypeQRUser];
        [scanVC setDisableMoreButton:YES];
        [self.navigationController pushViewController:scanVC animated:YES];
        
        //关闭自动处理
        scanVC.disableAutoHandle = YES;
        YDWeakSelf(self);
        YDWeakSelf(scanVC);
        [scanVC setScannerCompletionBlock:^(NSString *text) {
            [YDScannerViewController handleScannerString:text isUserBlock:^(NSNumber *userId) {
                YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:userId];
                YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
                [weakself.navigationController pushViewController:userVC animated:YES];
            } isDeviceBlock:^(NSString *imei, NSString *authCode, NSString *typeCode) {
                [weakscanVC handlecanningResult_Device];
            } isHttpBlock:^(NSString *url) {
                [weakscanVC handlecanningResult_Http];
            } isUnknownBlock:^(NSString *text) {
                [YDMBPTool showInfoImageWithMessage:@"未知扫描结果" hideBlock:nil];
            }];
        }];
    }
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[YDPhoneContactsController new] animated:YES];
    }
}

#pragma mark - Events
- (YDSearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[YDSearchController alloc] initWithSearchResultsController:self.searchResultVC];
        [_searchController setSearchResultsUpdater:self.searchResultVC];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}

- (YDAFSearchResultController *)searchResultVC{
    if (!_searchResultVC) {
        _searchResultVC = [[YDAFSearchResultController alloc] init];
    }
    return _searchResultVC;
}

- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];;
        [_tableHeaderView addSubview:self.searchController.searchBar];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchController.searchBar.frame), SCREEN_WIDTH, 60)];
        backgroundView.backgroundColor = [UIColor grayBackgoundColor];
        [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyCodeViewAction:)]];
        [_tableHeaderView addSubview:backgroundView];
        
        NSString *text = [NSString stringWithFormat:@"我的遇道号: %@",[YDUserDefault defaultUser].user.ub_nickname];
        
        UILabel *label = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
        label.text = text;
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_contacts_code"]];
        [backgroundView sd_addSubviews:@[label,imageV]];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backgroundView).offset(10);
            make.centerX.equalTo(backgroundView);
            make.height.mas_equalTo(21);
            make.width.mas_lessThanOrEqualTo(200);
        }];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label);
            make.left.equalTo(label.mas_right);
            make.size.mas_equalTo(CGSizeMake(39, 39));
        }];
        [_tableHeaderView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(backgroundView.frame))];
    }
    return _tableHeaderView;
}

@end

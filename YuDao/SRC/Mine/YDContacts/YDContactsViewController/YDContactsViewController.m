//
//  YDContactsViewController.m
//  YuDao
//
//  Created by 汪杰 on 16/11/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDContactsViewController.h"
#import "YDSearchController.h"
#import "YDContactsViewController+Delegate.h"

#import "YDAddFriendViewController.h"


#define kFriendsURL [kOriginalURL stringByAppendingString:@"friendlist"]

@interface YDContactsViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) YDSearchController *searchController;

@end

@implementation YDContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"通讯录"];
    [self registerCellClass];
    [self cvc_initUI];
    
    self.data = [YDFriendHelper sharedFriendHelper].data;
    self.headers = [YDFriendHelper sharedFriendHelper].sectionHeaders;
    self.friendsCount = [YDFriendHelper sharedFriendHelper].friendsData.count;
    
    //初始化好友数据，优先读取数据库数据
    YDWeakSelf(self);
    [[YDFriendHelper sharedFriendHelper] downloadFriendsData:^(NSArray *data, NSArray *headers, NSInteger count) {
        weakself.data = [data mutableCopy];
        weakself.headers = [headers mutableCopy];
        weakself.friendsCount = count;
        [weakself.tableView reloadData];
    }];
    
    //添加推送消息代理
    [[YDPushMessageManager sharePushMessageManager] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAcceptOrDeletedNotification:) name:kUpdateContactsNotification object:nil];
    
    [self addObserver:self forKeyPath:@"friendsCount" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
}

- (void)dealloc{
    [[YDPushMessageManager sharePushMessageManager] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    [YDNotificationCenter removeObserver:self name:kUpdateContactsNotification object:nil];
    [self removeObserver:self forKeyPath:@"friendsCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"friendsCount"]) {
        NSString *footerString = @"";
        if (self.friendsCount <= 0) {
            footerString = @"暂无联系人";
        }else{
            footerString = [NSString stringWithFormat:@"%ld位联系人",self.friendsCount];
        }
        [self.footerLabel setText:footerString];
    }
}

//点击接受好友或被他人删除触发
- (void)receiveAcceptOrDeletedNotification:(NSNotification *)noti{
    YDWeakSelf(self);
    [[YDFriendHelper sharedFriendHelper] yd_resetFriendData:^(NSArray *data, NSArray *headers, NSInteger count) {
        weakself.data = [data mutableCopy];
        weakself.headers = [headers mutableCopy];
        weakself.friendsCount = count;
        [weakself.tableView reloadData];
    }];
}


#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender
{
    [self.navigationController pushViewController:[YDAddFriendViewController new] animated:YES];
}
//点击右边添加好友
- (void)contactsRightBarItemAction:(UIBarButtonItem *)item{
    [self.navigationController pushViewController:[YDAddFriendViewController new] animated:YES];
}

#pragma mark - Private Methods -
- (void)cvc_initUI{
    UIBarButtonItem *rightBarItem = [UIBarButtonItem itemWithImage:@"mine_contacts_addfriend" target:self action:@selector(contactsRightBarItemAction:)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    self.tableView.separatorColor = [UIColor whiteColor];
    //self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    //[self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    //[self.tableView setSectionIndexColor:[UIColor colorBlackForNavBar]];
    self.tableView.rowHeight = 70.0f;
    
    //关闭ContentInsetAdjust
    [self.tableView yd_setContentInsetAdjustmentBehavior:2];
    
    UIView *tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.searchController.searchBar.height)];
        [view addSubview:self.searchController.searchBar];
        view;
    });
    [self.tableView setTableHeaderView:tableHeaderView];
    [self.tableView setTableFooterView:self.footerLabel];
    
    //适配UISearchController的动画效果
    self.definesPresentationContext = YES;
    self.edgesForExtendedLayout =  UIRectEdgeNone;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //限制第一个字符为通配符
    if (searchBar.text.length == 0 && [text isEqualToString:@"%"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Getter -
- (YDSearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[YDSearchController alloc] initWithSearchResultsController:self.friendSearchVC];
        [_searchController setSearchResultsUpdater:self.friendSearchVC];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}

- (YDFriendSearchController *)friendSearchVC{
    if (!_friendSearchVC) {
        _friendSearchVC = [[YDFriendSearchController alloc] init];
    }
    return _friendSearchVC;
}

- (UILabel *)footerLabel{
    if (_footerLabel == nil) {
        _footerLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50.0f)];
        [_footerLabel setTextAlignment:NSTextAlignmentCenter];
        [_footerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_footerLabel setTextColor:[UIColor grayColor]];
    }
    return _footerLabel;
}


@end

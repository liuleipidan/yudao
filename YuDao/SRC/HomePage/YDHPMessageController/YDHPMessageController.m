//
//  YDHPMessageController.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHPMessageController.h"
#import "YDHPMessageController+Delegate.h"

@interface YDHPMessageController ()

@property (nonatomic, strong) NSDate *date;

@end

@implementation YDHPMessageController
- (instancetype)init{
    if (self = [super init]) {
        _viewModel = [[YDHPMessageViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hpm_initUI];
    
    [[YDUserDefault defaultUser] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[YDPushMessageManager sharePushMessageManager] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[YDPushMessageManager sharePushMessageManager] post_requestHomePageMessagesByCurrentUserToken:YDAccess_token];
    self.date = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSInteger second = [NSDate differFirstDate:[NSDate date] secondDate:self.date differType:YDDifferDateTypeSecond];
    if (second >= 60) {
        self.date = [NSDate date];
        [[YDPushMessageManager sharePushMessageManager] post_requestHomePageMessagesByCurrentUserToken:YDAccess_token];
    }
}

- (void)dealloc{
    [[YDUserDefault defaultUser] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[YDPushMessageManager sharePushMessageManager] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)hpm_initUI{
    self.tableView.rowHeight = kHPMessageTableViewRowHeight;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self registerCells];
}



@end

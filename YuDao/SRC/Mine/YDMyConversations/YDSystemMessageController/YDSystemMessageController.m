//
//  YDSystemMessageController.m
//  YuDao
//
//  Created by 汪杰 on 17/2/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSystemMessageController.h"
#import "YDChatCellMenuView.h"
#import "YDSystemMessageController+Delegate.h"

@interface YDSystemMessageController ()<YDSystemMessageCellDelegate>



@end

@implementation YDSystemMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"系统通知"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(sm_rightButtonItemAction:)];
    
    self.data = [NSMutableArray array];
    
    self.tableView.backgroundColor = [UIColor grayBackgoundColor];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //关闭ContentInsetAdjust
    [self.tableView yd_adaptToIOS11];
    
    [self sm_registerCells];
    
    //添加系统消息代理
    [[YDSystemMessageHelper sharedInstance] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //从数据库取数据
    self.count = 10;
    [self setRefreshFooter];
    [self smc_takeOutSystemMessagesWithCount:self.count];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[YDSystemMessageHelper sharedInstance] updateSystemMessageToRead];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[YDChatCellMenuView sharedMenuView] dismiss];
}

- (void)dealloc{
    NSLog(@"dealloc self.class = %@",self.class);
    [[YDSystemMessageHelper sharedInstance] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - YDSystemMessageDelegate
- (void)receivedNewSystemMessages{
    NSLog(@"%s",__func__);
    self.count = 10;
    [self smc_takeOutSystemMessagesWithCount:self.count];
    [[YDSystemMessageHelper sharedInstance] updateSystemMessageToRead];
}

- (void)smc_takeOutSystemMessagesWithCount:(NSUInteger )count{
    YDWeakSelf(self);
    [[YDSystemMessageHelper sharedInstance] messagesByCount:count complete:^(NSArray *data, BOOL hasMore) {
        if (data.count == 0) {
            [weakself.footer setTitle:@"暂无系统消息" forState:MJRefreshStateNoMoreData];
            [weakself.footer endRefreshingWithNoMoreData];
        }
        else{
            weakself.data = [NSMutableArray arrayWithArray:data];
            [weakself.tableView reloadData];
            if (hasMore) {
                [weakself.footer endRefreshing];
            }
            else{
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
}

- (void)setRefreshFooter{
    YDWeakSelf(self);
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.count += 10;
        [weakself smc_takeOutSystemMessagesWithCount:weakself.count];
    }];
    [footer.stateLabel setFont:[UIFont font_12]];
    [footer.stateLabel setTextColor:[UIColor colorWithString:@"#FF9B9B9B"]];
    [footer setTitle:@"-- 没有更多了 --" forState:MJRefreshStateNoMoreData];
    self.footer = footer;
    self.tableView.mj_footer = footer;
}

- (void)sm_rightButtonItemAction:(UIBarButtonItem *)item{
    YDWeakSelf(self);
    [LPActionSheet showActionSheetWithTitle:@"系统消息清空后不可恢复" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == -1) {
            YDProgressHUD *hud = [YDLoadingHUD showLoadingInView:self.view];
            if ([[YDSystemMessageHelper sharedInstance] deleteAllSystemMessages]) {
                [hud hide];
                [weakself.footer setTitle:@"暂无系统消息" forState:MJRefreshStateNoMoreData];
                [weakself.footer endRefreshingWithNoMoreData];
                weakself.data = nil;
                [weakself.tableView reloadData];
            }
            else{
                [hud hide];
                [YDMBPTool showErrorImageWithMessage:@"清空失败" hideBlock:^{
                    
                }];
            }
        }
    }];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([YDChatCellMenuView sharedMenuView].isShow) {
        [[YDChatCellMenuView sharedMenuView] dismiss];
    }
}

@end

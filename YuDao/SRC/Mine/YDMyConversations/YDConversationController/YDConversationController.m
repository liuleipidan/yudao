//
//  YDConversationController.m
//  YuDao
//
//  Created by 汪杰 on 17/2/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDConversationController.h"
#import "YDConversationController+Delegate.h"
#import "YDChatHelper+ConversationRecord.h"

@interface YDConversationController ()

@end

@implementation YDConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"我的消息"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 70.0f;
    
    [self registerConversationCell];
    
    //关闭ContentInsetAdjust
    [self.tableView yd_adaptToIOS11];
    
    //添加系统消息代理
    [[YDSystemMessageHelper sharedInstance] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [[YDChatHelper sharedInstance] addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateConversationData];
    
}

- (void)dealloc{
    [[YDChatHelper sharedInstance] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark 刷新消息列表
- (void)updateConversationData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        YDConversation *model = self.data.firstObject;
        [self updateLastSystemMessageAtFirstModel:model];
        //刷新聊天列表
        YDWeakSelf(self);
        [[YDChatHelper sharedInstance] getAllConversaionRecord:^(NSArray<YDConversation *> *data) {
            if (weakself.data.count > 1) {
                [weakself.data removeObjectsInRange:NSMakeRange(1, self.data.count-1)];
            }
            [weakself.data addObjectsFromArray:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakself.tableView reloadData];
            });
        }];
    });
    
}

//刷新最后一条系统消息
- (void)updateLastSystemMessageAtFirstModel:(YDConversation *)model{
    
    YDSystemMessage *message = [[YDSystemMessageHelper sharedInstance] newestSystemtMessage];
    
    if (message.text && message.text.length > 0) {
        model.content = message.text;
        model.date = [NSDate dateFromTimeStamp:message.time];
    }
    else{
        model.content = @"暂无系统消息";
        model.date = [NSDate date];
    }
    
    //未读系统消息数
    model.unreadCount = [YDSystemMessageHelper sharedInstance].unreadSysCount;
    
    [self.tableView reloadData];
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
        
        YDConversation *model = [[YDConversation alloc] init];
        model.fname = @"系统通知";
        model.avatarPath = @"mine_systemMessage_image";
        
        [_data addObject:model];
    }
    return _data;
}

@end

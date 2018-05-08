//
//  YDMineHelper.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMineHelper.h"
#import "YDChatHelper+ConversationRecord.h"
#import "YDRootViewController+Delegate.h"

@interface YDMineHelper()<YDPushMessageManagerDelegate,YDSystemMessageDelegate,YDChatHelperDelegate>

/**
 我的动态Item
 */
@property (nonatomic, strong) YDMineMenuItem *myDynamicItem;

/**
 我的消息Item
 */
@property (nonatomic, strong) YDMineMenuItem *msgItem;

/**
 通讯录Item
 */
@property (nonatomic, strong) YDMineMenuItem *contactItem;

@end

static YDMineHelper *mineHelper = nil;

@implementation YDMineHelper

+ (YDMineHelper *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mineHelper = [[YDMineHelper alloc] init];
    });
    return mineHelper;
}

- (id)init{
    if (self = [super init]) {
        self.mineMenuData = [NSMutableArray array];
        [self mh_initMineMenuData];
        [self recountUnreadMessages];
        
        //添加推送消息代理
        [[YDPushMessageManager sharePushMessageManager] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //添加系统消息代理
        [[YDSystemMessageHelper sharedInstance] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        [[YDChatHelper sharedInstance] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)recountUnreadMessages{
    
    NSUInteger frCount = [YDPushMessageManager sharePushMessageManager].frCount;
    NSUInteger sysCount = [YDSystemMessageHelper sharedInstance].unreadSysCount;;
    NSUInteger chatCount = [[YDChatHelper sharedInstance] allUnreadMessageByUid:[YDUserDefault defaultUser].user.ub_id];
    
    _myDynamicItem.unredCount = self.dyMsgUnreadCount;
    _msgItem.unredCount = sysCount + chatCount;
    _contactItem.unredCount = frCount;

    //统计完所有未读消息数量后开启回调
    if (self.unreadCountChanged) { self.unreadCountChanged(); }
}

- (void)requestRecentVistors:(void (^)(void))completion{
    YDWeakSelf(self);
    NSDictionary *parameters = @{@"access_token":YDAccess_token,
                                 @"limit":@5,
                                 @"type":@0};
    [YDNetworking GET:kVisitorsURL parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        if (data) {
            NSArray *dataArray = [NSArray arrayWithArray:data];
            weakself.visitors = [YDVisitorsModel mj_objectArrayWithKeyValuesArray:dataArray];
            if (completion) {
                completion();
            }
        }else{
            YDLog(@"暂无访客！");
        }
    } failure:^(NSError *error) {
        YDLog(@"下载访客失败 error = %@",error);
    }];
}

- (void)requestDynamicMessagesCount{
    
    NSDictionary *param = @{
                            @"access_token":YDAccess_token
                            };
    [YDNetworking GET:kDynamicMessagesCountURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        NSNumber *count = [data valueForKey:@"count"];
        [self setDyMsgUnreadCount:count.unsignedIntegerValue];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 动态消息
- (void)setDyMsgUnreadCount:(NSUInteger)dyMsgUnreadCount{
    _dyMsgUnreadCount = dyMsgUnreadCount;
    
    [self recountUnreadMessages];
    
    [[YDRootViewController sharedRootViewController] recountBadges];
}

#pragma mark - YDPushMessageManagerDelegate - 系统消息
//收到新的好友请求
- (void)receivedNewFriendRequest{
    [self recountUnreadMessages];
}
//未读好友请求数量改变
- (void)unreadFirendRequestCountDidChange{
    
    [self recountUnreadMessages];
}

#pragma mark - YDSystemMessageDelegate
//收到新的新的系统消息
- (void)receivedNewSystemMessages{
    [self recountUnreadMessages];
}
//系统消息都已读
- (void)systemMessagesAreRead{
    [self recountUnreadMessages];
}

#pragma mark - YDChatHelperDelegate - 聊天消息
- (void)unreadChatMessageCountHadChanged{
    [self recountUnreadMessages];
}

- (void)mh_initMineMenuData{
    YDMineMenuItem *item1 = YDCreateMineMenuItem(@"mine_homePage_personalInfo", @"个人资料");
    YDMineMenuItem *item2 = YDCreateMineMenuItem(@"mine_homePage_dynamics", @"我的动态");
    YDMineMenuItem *item3 = YDCreateMineMenuItem(@"mine_homePage_message", @"我的消息");
    YDMineMenuItem *item4 = YDCreateMineMenuItem(@"mine_homePage_visitors", @"最近访客");
    YDMineMenuItem *item5 = YDCreateMineMenuItem(@"mine_homePage_orders", @"我的订单");
    YDMineMenuItem *item6 = YDCreateMineMenuItem(@"mine_homePage_coupon", @"我的卡包");
    YDMineMenuItem *item7 = YDCreateMineMenuItem(@"mine_homePage_garage", @"我的车库");
    YDMineMenuItem *item8 = YDCreateMineMenuItem(@"mine_homePage_contacts", @"通讯录");
    YDMineMenuItem *item9 = YDCreateMineMenuItem(@"mine_homePage_setting", @"系统设置");
    _myDynamicItem = item2;
    _msgItem = item3;
    _contactItem = item8;
    self.mineMenuData = [NSMutableArray arrayWithArray:@[item1,item2,item3,item4,item5,item6,item7,item8,item9]];
}


- (NSMutableArray *)mineMenuData{
    if (!_mineMenuData) {
        _mineMenuData = [NSMutableArray array];
    }
    return _mineMenuData;
}

@end


//
//  YDDBManager.m
//  YuDao
//
//  Created by 汪杰 on 16/10/25.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDBManager.h"

static YDDBManager *manager;

@implementation YDDBManager

+ (YDDBManager *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[YDDBManager alloc] init];
    });
    return manager;
}

- (id)initWithUserID:(NSString *)userID
{
    if (self = [super init]) {
        NSString *commonQueuePath = [NSFileManager pathDBCommon];
        YDLog(@"commonQueuePath = %@",commonQueuePath);
        self.commonQueue = [FMDatabaseQueue databaseQueueWithPath:commonQueuePath];
        
        NSString *messageQueuePath = [NSFileManager pathDBMessage];
        YDLog(@"messageQueuePath = %@",messageQueuePath);
        self.messageQueue = [FMDatabaseQueue databaseQueueWithPath:messageQueuePath];
        
        NSString *sysCommonQueuePath = [NSFileManager pathSystemCommon];
        YDLog(@"sysCommonQueuePath = %@",sysCommonQueuePath);
        self.sysCommonQueue = [FMDatabaseQueue databaseQueueWithPath:sysCommonQueuePath];
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        NSString *commonQueuePath = [NSFileManager pathDBCommon];
        YDLog(@"commonQueuePath = %@",commonQueuePath);
        self.commonQueue = [FMDatabaseQueue databaseQueueWithPath:commonQueuePath];
        
        NSString *messageQueuePath = [NSFileManager pathDBMessage];
        YDLog(@"messageQueuePath = %@",messageQueuePath);
        self.messageQueue = [FMDatabaseQueue databaseQueueWithPath:messageQueuePath];
        
        NSString *sysCommonQueuePath = [NSFileManager pathSystemCommon];
        YDLog(@"sysCommonQueuePath = %@",sysCommonQueuePath);
        self.sysCommonQueue = [FMDatabaseQueue databaseQueueWithPath:sysCommonQueuePath];
    }
    return self;
}

@end

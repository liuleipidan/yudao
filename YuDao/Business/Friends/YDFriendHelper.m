//
//  YDFriendHelper.m
//  YuDao
//
//  Created by 汪杰 on 16/11/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDFriendHelper.h"
#import "YDDBFriendStore.h"
#import "NSObject+Category.h"

#define kFriendsURL [kOriginalURL stringByAppendingString:@"friendlist"]

static YDFriendHelper *friendHelper = nil;
static dispatch_once_t fh_once;

@interface YDFriendHelper()

@property (nonatomic, strong) YDDBFriendStore *friendStore;

@end

@implementation YDFriendHelper

+ (YDFriendHelper *)sharedFriendHelper
{
    
    dispatch_once(&fh_once, ^{
        friendHelper = [[YDFriendHelper alloc] init];
    });
    return friendHelper;
}

- (id)init{
    if (self = [super init]) {
        self.data = [NSMutableArray arrayWithObjects:self.defaultGroup, nil];
        self.sectionHeaders = [NSMutableArray arrayWithObjects:UITableViewIndexSearch, nil];
        [self yd_resetFriendData:nil];
    }
    return self;
}

+ (void)attemptDealloc{
    if (friendHelper.friendsData) {
        [friendHelper.friendsData removeAllObjects];
        friendHelper.friendsData = nil;
    }
    if (friendHelper.data) {
        [friendHelper.data removeAllObjects];
        friendHelper.data = nil;
    }
    if (friendHelper.sectionHeaders) {
        [friendHelper.sectionHeaders removeAllObjects];
        friendHelper.sectionHeaders = nil;
    }
    fh_once = 0;
    friendHelper = nil;
}

- (void)downloadFriendsData:(void (^)(NSArray *data, NSArray *headers, NSInteger count))completeBlock{
    YDWeakSelf(self);
    NSDictionary *para = @{@"access_token":YDAccess_token};
    [YDNetworking GET:kFriendsURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200] && data) {
            NSMutableArray *friends = [YDFriendModel mj_objectArrayWithKeyValuesArray:data];
            [weakself addFriends:friends];
            [weakself yd_resetFriendData:completeBlock];
        }
    } failure:^(NSError *error) {
        YDLog(@"下载好友error = %@",error);
    }];
}

- (void)addFriends:(NSMutableArray *)data{
    if (data == nil || data.count == 0) {
        return;
    }
    for (YDFriendModel *model in data) {
        [self.friendStore addFriend:model];
    }
}

- (void)yd_resetFriendData:(void (^)(NSArray *data, NSArray *headers, NSInteger count))completeBlock{
    self.friendsData = [self.friendStore friendsDataByUid:[YDUserDefault defaultUser].user.ub_id];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *serializeArray = [self.friendsData sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            int i;
            NSString *strA = ((YDFriendModel *)obj1).pinyin;
            NSString *strB = ((YDFriendModel *)obj2).pinyin;
            for (i = 0; i < strA.length && i < strB.length; i ++) {
                char a = toupper([strA characterAtIndex:i]);
                char b = toupper([strB characterAtIndex:i]);
                if (a > b) {
                    return (NSComparisonResult)NSOrderedDescending;
                }else if (a < b){
                    return (NSComparisonResult)NSOrderedAscending;
                }
            }
            if (strA.length > strB.length) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            else if (strA.length < strB.length){
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *data = [NSMutableArray arrayWithObjects:self.defaultGroup, nil];
        NSMutableArray *sectionHeaders = [NSMutableArray arrayWithObjects:UITableViewIndexSearch, nil];
        char lastC = '1';
        YDUserGroup *curGroup;
        YDUserGroup *otherGroup = [[YDUserGroup alloc] init];
        [otherGroup setGroupName:@"#"];
        for (YDFriendModel *user in serializeArray) {
            if (user.pinyin == nil || user.pinyin.length == 0) {
                [otherGroup addObject:user];
                continue;
            }
            
            char c = toupper([user.pinyin characterAtIndex:0]);
            if (!isalpha(c)) {
                [otherGroup addObject:user];
            }
            else if (c != lastC){
                if (curGroup && curGroup.count > 0) {
                    [data addObject:curGroup];
                    [sectionHeaders addObject:curGroup.groupName];
                }
                lastC = c;
                curGroup = [[YDUserGroup alloc] init];
                [curGroup setGroupName:[NSString stringWithFormat:@"%c",c]];
                [curGroup addObject:user];
            }
            else{
                [curGroup addObject:user];
            }
        }
        
        if (curGroup && curGroup.count > 0) {
            [data addObject:curGroup];
            [sectionHeaders addObject:curGroup.groupName];
        }
        if (otherGroup.count > 0) {
            [data addObject:otherGroup];
            [sectionHeaders addObject:otherGroup.groupName];
        }
        [self.data removeAllObjects];
        [self.data addObjectsFromArray:data];
        [self.sectionHeaders removeAllObjects];
        [self.sectionHeaders addObjectsFromArray:sectionHeaders];
        YDLog(@"好友已经排序好!!!");
        if (completeBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(self.data,self.sectionHeaders,self.friendsData.count);
            });
        }
    });
}

#pragma mark - Public Methods -
- (YDFriendModel *)getFriendInfoByFid:(NSNumber *)fid
{
    if (fid == nil) {
        return nil;
    }
    return [self.friendStore friendByUid:[YDUserDefault defaultUser].user.ub_id friendId:fid];
}

- (BOOL )friendIsInExistenceByUid:(NSNumber *)uid{
    return [self.friendStore friendIsInExistenceByUid:uid];
}

/**
 *  查询好友,通过名字或者id
 */
- (void )searchFriendByName:(NSString *)name orId:(NSNumber *)fid completion:(void (^)(NSArray *data))completion{
    [self.friendStore searchFriendByName:name orId:fid completion:completion];
}

- (BOOL )addFriendByModel:(YDFriendModel *)model{
    BOOL ok = [self.friendStore addFriend:model];
    if (ok) {
        [self yd_resetFriendData:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateContactsNotification object:nil];
    }
    return ok;
}

- (BOOL )deleteFriendByFid:(NSNumber *)fid{
    BOOL ok = [self.friendStore deleteFriendByFid:fid forUid:[YDUserDefault defaultUser].user.ub_id];
    if (ok) {
        [self yd_resetFriendData:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateContactsNotification object:nil];
    }
    return ok;
}

- (BOOL )deleteAllFriends{
    BOOL ok = [self.friendStore deleteAllFriends];
    if (ok) {
        [self yd_resetFriendData:nil];
        YDLog(@"删除所有好友成功");
    }else{
        YDLog(@"删除所有好友失败");
    }
    return ok;
}

//统计所有好友
- (NSInteger )countAllFriends{
    return [self.friendStore countAllFriends];
}


#pragma mark - Getter -
- (YDDBFriendStore *)friendStore{
    if (!_friendStore) {
        _friendStore = [YDDBFriendStore new];
    }
    return _friendStore;
}

- (YDUserGroup *)defaultGroup{
    if (!_defaultGroup) {
        YDFriendModel *user = [[YDFriendModel alloc] init];
        user.friendid = @(-1);
        user.avatarPath = @"mine_contacts_newfriend";
        user.friendName = @"新的朋友";
        
        _defaultGroup = [[YDUserGroup alloc] initWithGroupName:nil users:[NSMutableArray arrayWithObjects:user, nil]];
    }
    return _defaultGroup;
}

@end

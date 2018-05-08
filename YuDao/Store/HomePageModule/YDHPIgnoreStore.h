//
//  YDHPIgnoreStore.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "YDHPIgnoreModel.h"

#define YDCheckHPIgnoreExist(Uid, Ptype, Subtype, Ignore_type) [[YDHPIgnoreStore manager] checkIgnoreListIsExistByUserId:Uid ptype:Ptype subtype:Subtype ignore_type:Ignore_type]

#define YDCheckHPIgnoreModel(Uid, Ptype, Subtype) [[YDHPIgnoreStore manager] checkIgnoreModelByUserId:Uid ptype:Ptype subtype:Subtype]

#define YDDeleteHPIgnoreModel(Rid, Uid) [[YDHPIgnoreStore manager] deleteHPIgnore:Rid userId:Uid]

@interface YDHPIgnoreStore : YDDBBaseStore

+ (YDHPIgnoreStore *)manager;


/**
 插入首页忽略设置数组，会先删除当前登录用户的忽略设置，存储最新的，保证与服务器同步

 @param arr 设置数组
 @param uid 用户id
 */
- (void)addHPIgnoreArray:(NSArray<YDHPIgnoreModel *> *)arr userId:(NSNumber *)uid;

- (BOOL)addHPIgnoreModel:(YDHPIgnoreModel *)model;

- (BOOL)deleteHPIgnore:(NSNumber *)rid userId:(NSNumber *)uid;

- (BOOL)deleteAllHPIgnoreByUserId:(NSNumber *)uid;

- (NSArray *)ignoreListByUserId:(NSNumber *)uid;

/**
 检查是否要隐藏此模块

 @param uid 用户id
 @param ptype 父级类型
 @param subtype 子级类型，行车信息、任务、排行榜默认为0
 @param ignore_type 忽略类型，0->无,1->24小时,2->永久
 */
- (YDHPIgnoreModel *)checkIgnoreListIsExistByUserId:(NSNumber *)uid
                                              ptype:(NSInteger )ptype
                                            subtype:(NSInteger )subtype
                                        ignore_type:(NSInteger )ignore_type;

/**
 获取是否要隐藏此模块
 
 @param uid 用户id
 @param ptype 父级类型
 @param subtype 子级类型，行车信息、任务、排行榜默认为0
 */
- (YDHPIgnoreModel *)checkIgnoreModelByUserId:(NSNumber *)uid
                                     ptype:(NSInteger )ptype
                                   subtype:(NSInteger )subtype;

/**
 检查24小时是否显示的消息

 @param subtype 消息类型==系统消息的子类型
 @return YES->可以显示，NO->不可以
 */
+ (BOOL)checkTwentyFourHoursMessagesIngnoreBySubtype:(NSInteger)subtype;

@end

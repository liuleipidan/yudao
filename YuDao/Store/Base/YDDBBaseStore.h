//
//  YDDBBaseStore.h
//  YuDao
//
//  Created by 汪杰 on 16/10/25.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDDBManager.h"

@interface YDDBBaseStore : NSObject

/// 数据库操作队列(从YDDBManager中获取，默认使用commonQueue)
@property (nonatomic, weak) FMDatabaseQueue *dbQueue;

/**
 表是否存在
 */
- (BOOL)tableExists:(NSString *)tableName;

/**
 *  表创建
 */
- (BOOL)createTable:(NSString*)tableName withSQL:(NSString*)sqlString;

/**
 *  表删除
 */
- (BOOL)deleteTable:(NSString *)tableName;

/*
 *  执行带数组参数的sql语句 (增，删，改)
 */
-(BOOL)excuteSQL:(NSString*)sqlString withArrParameter:(NSArray*)arrParameter;

/*
 *  执行带字典参数的sql语句 (增，删，改)
 */
-(BOOL)excuteSQL:(NSString*)sqlString withDicParameter:(NSDictionary*)dicParameter;

/*
 *  执行格式化的sql语句 (增，删，改)
 */
- (BOOL)excuteSQL:(NSString *)sqlString,...;

/**
 *  执行查询指令
 */
- (void)excuteQuerySQL:(NSString*)sqlStr resultBlock:(void(^)(FMResultSet * rsSet))resultBlock;

/**
 *  统计
 */
- (NSUInteger )excuteCountSql:(NSString *)sqlStr;


/**
 增加表字段

 @param tableName 表名
 @param columName 字段名
 @param cloumType 类型字符串（INTEGER,TEXT）
 @param dfValue   默认值
 */
- (void)addColumWithTableName:(NSString *)tableName
                    columName:(NSString *)columName
                    columType:(NSString *)cloumType
                 defaultValue:(NSString *)dfValue;

@end

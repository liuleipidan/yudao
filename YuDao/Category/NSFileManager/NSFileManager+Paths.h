//
//  NSFileManager+Paths.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Paths)

/**
 程序主目录，包括（可见）：Documents、Library、tmp
 */
+ (NSString *)homePath;

/**
 文档目录，需要iTunes同步备份的数据存储位置
 */
+ (NSString *)documentsPath;
+ (NSURL *)documentsURL;

/**
 库目录，iTunes不会备份此目录
 */
+ (NSString *)libraryPath;
+ (NSURL *)libraryURL;

/**
 配置目录，存储配置文件
 */
+ (NSString *)libraryPreferencePath;

/**
 缓存目录，iTunes不会备份此目录
 */
+ (NSString *)cachesPath;
+ (NSURL *)cachesURL;

/**
 临时缓冲目录，App退出，系统可能会删除这里的内容
 */
+ (NSString *)tmpPath;

/**
 Adds a special filesystem flag to a file to avoid iCloud backup it.
 
 @param path Path to a file to set an attribute.
 */
+ (BOOL)addSkipBackupAttributeToFile:(NSString *)path;

/**
 Get available disk space.
 
 @return An amount of available disk space in Megabytes.
 */
+ (double)availableDiskSpace;

@end

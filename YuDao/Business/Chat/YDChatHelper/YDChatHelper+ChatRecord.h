//
//  YDChatHelper+ChatRecord.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatHelper.h"

@interface YDChatHelper (ChatRecord)

/**
 *  查询聊天记录
 */
- (void)chatMessageByUserId:(NSNumber *)userId
                        fid:(NSNumber *)fid
                   fromDate:(NSDate *)date
                      count:(NSUInteger )count
                 completion:(void (^)(NSArray *data, BOOL hasMore))completion;

/**
 *  查询聊天文件
 */
- (void)chatImagesForFid:(NSString *)fid
              completed:(void (^)(NSArray *))completed;

@end

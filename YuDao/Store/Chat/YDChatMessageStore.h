//
//  YDChatMessageStore.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "YDChatMessage.h"

@interface YDChatMessageStore : YDDBBaseStore
/**
 *  插入消息到数据库
 */
- (BOOL)addChatMessage:(YDChatMessage *)message;

/**
 *  删除一个用户与其好友的消息
 */
- (BOOL)deleteChatMessagesByUid:(NSNumber *)uid fid:(NSNumber *)fid;

/**
 *  删除一条消息
 */
- (BOOL)deleteOneMessageByMsgId:(NSString *)msgId
                            uid:(NSNumber *)uid
                            fid:(NSNumber *)fid;

/**
 获取一条消息
 */
- (YDChatMessage *)getOneMessageByMsgId:(NSString *)msgId
                                    uid:(NSNumber *)uid
                                    fid:(NSString *)fid;
/**
 获取对应好友最后一条消息
 */
- (YDChatMessage *)getLastMessageByUid:(NSNumber *)uid
                                   fid:(NSNumber *)fid;

/**
 *  获取与某个好友的聊天记录
 */
- (void)chatMessageByUserId:(NSNumber *)userId
                        fid:(NSNumber *)fid
                   fromDate:(NSDate *)date
                      count:(NSUInteger )count
                 completion:(void (^)(NSArray *data, BOOL hasMore))completion;

/**
 *  获取与某个好友的聊天图片
 */
- (NSArray *)chatImagesAndVideosByUserId:(NSNumber *)userId fid:(NSString *)fid;

/**
 *  刷新消息的发送状态
 */
- (BOOL)updateMessageSendStatus:(YDMessageSendState )status
                      messageId:(NSString *)msgId
                         userId:(NSNumber *)userId;
/**
 *  刷新消息的读取状态
 */
- (BOOL)updateMessageReadStatus:(YDMessageReadState )status
                      messageId:(NSString *)msgId
                         userId:(NSNumber *)userId;

@end

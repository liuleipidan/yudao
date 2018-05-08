//
//  YDChatHelper+ConversationRecord.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatHelper+ConversationRecord.h"

@implementation YDChatHelper (ConversationRecord)

/**
 *  所有未读消息数
 */
- (NSInteger)allUnreadMessageByUid:(NSNumber *)uid{
    return [self.convStrore allUnreadMessageByUid:[YDUserDefault defaultUser].user.ub_id];
}

//所有聊天记录
- (void)getAllConversaionRecord:(void (^)(NSArray<YDConversation *> *))complete{
    NSArray<YDConversation *> *data = [self.convStrore conversationsByUid:[YDUserDefault defaultUser].user.ub_id];
    [data enumerateObjectsUsingBlock:^(YDConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YDFriendModel *friend = [[YDFriendHelper sharedFriendHelper] getFriendInfoByFid:obj.fid];
        if (friend) {
            obj.fname.length == 0 ? obj.fname = friend.friendName : obj.fname;
            obj.fimageUrl.length == 0 ? obj.fimageUrl = friend.friendImage : obj.fimageUrl;
        }
    }];
    complete(data);
}

- (void)addConversationByMessage:(YDChatMessage *)message{
    YDConversation *conversation = [[YDConversation alloc] init];
    conversation.uid = message.uid;
    conversation.fid = message.fid;
    conversation.content = [message conversationContent];
    conversation.convType = YDConversationTypePersonal;
    conversation.date = message.date;
    conversation.fname = message.fName;
    conversation.fimageUrl = message.fAvatarUrl;
    if (message.ownerType == YDMessageOwnerTypeSelf) {
        conversation.unreadCount = 0;
    }else{
        conversation.unreadCount = message.readState == YDMessageUnRead ? 1 : 0;
    }
    if ([self.convStrore addConversationByModel:conversation]) {
        YDLog(@"插入消息列表成功");
        [self.delegate conversationHadChanged];
    }else{
        YDLog(@"插入消息列表失败");
    }
}

/**
 *  新的会话
 */
- (BOOL)addConversationByModel:(YDConversation *)conversation{
    BOOL ok = [self.convStrore addConversationByModel:conversation];
    if (ok) {
        YDLog(@"插入消息列表成功");
    }else{
        YDLog(@"插入消息列表失败");
    }
    return ok;
}

/**
 *  更新会话状态（已读）
 */
- (BOOL)updateConversationByUid:(NSNumber *)uid fid:(NSNumber *)fid{
    BOOL ok = [self.convStrore updateConversationByUid:uid fid:fid];
    if (ok) {
        [self.delegate unreadChatMessageCountHadChanged];
        YDLog(@"未读消息数量删除成功");
    }else{
        YDLog(@"未读消息数量删除失败");
    }
    return ok;
}

/**
 *  删除一条消息
 */
- (BOOL)deleteConversationByUid:(NSNumber *)uid fid:(NSNumber *)fid{
    BOOL ok = [self.convStrore deleteConversationByUid:uid fid:fid];
    if (!ok) {
        YDLog(@"chat_删除一条消息失败");
    }
    [self.delegate unreadChatMessageCountHadChanged];
    return ok;
}

- (void)deleteAllConversations:(NSNumber *)uid{
    BOOL ok = [self.convStrore deleteConversationsByUid:uid];
    if (ok) {
        YDLog(@"删除用户所有消息成功");
    }else{
        YDLog(@"删除用户所有消息失败");
    }
}

@end

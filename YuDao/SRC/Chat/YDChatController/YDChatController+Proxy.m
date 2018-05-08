//
//  YDChatController+Proxy.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatController+Proxy.h"
#import "YDChatController+MessageDisplayView.h"
#import "YDChatHelper+ConversationRecord.h"

@implementation YDChatController (Proxy)

- (void)sendImageMessage:(UIImage *)image{
    NSData *imageData =UIImageJPEGRepresentation(image, 0.5);
    NSString *imageName = [NSString stringWithFormat:@"%lf.jpg", [NSDate date].timeIntervalSince1970];
    NSString *imagePath = [NSFileManager pathUserChatImage:imageName];
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
    
    YDImageChatMessage *message = [[YDImageChatMessage alloc] init];
    message.uid = YDUser_id;
    message.fid = self.partner.chat_userId;
    message.imagePath = imageName;
    message.imageSize = image.size;
    message.ownerType = YDMessageOwnerTypeSelf;
    message.sendState = YDMessageSending;
    message.date = [NSDate date];
    [self addToShowMessage:message];
    //预先存储
    [[YDChatHelper sharedInstance] addMessage:message];
    [YDNetworking uploadMessageData:image dataName:@"img" url:kUploadMessageDataURL success:^(NSDictionary *data,NSString *dataUrl) {
        message.imageURL = YDNoNilString(dataUrl);
        [[YDChatHelper sharedInstance] sendMessage:message];
    } failure:^{
        [[YDChatHelper sharedInstance] updateMessageSendStatus:YDMessageSendFail messageId:message.msgId userId:YDUser_id];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageDisplayView updateMessageSendStatus:message.msgId sendStatus:YDMessageSendFail];
        });
    }];
}

- (void)sendVideoMessage:(NSURL *)videoUrl thumbnailImage:(UIImage *)thumbnailImage{
    NSData *imageData =UIImageJPEGRepresentation(thumbnailImage, 0.5);
    NSString *imageName = [NSString stringWithFormat:@"%lf.jpg", [NSDate date].timeIntervalSince1970];
    NSString *imagePath = [NSFileManager pathUserChatImage:imageName];
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
    
    YDVideoChatMessage *message = [[YDVideoChatMessage alloc] init];
    message.uid = YDUser_id;
    message.fid = self.partner.chat_userId;
    //本地三个值
    message.videoPath = videoUrl.absoluteString;
    message.thumbnailImagePath = imageName;
    message.thumbnailImageSize = thumbnailImage.size;
    message.ownerType = YDMessageOwnerTypeSelf;
    message.sendState = YDMessageSending;
    message.date = [NSDate date];
    [self addToShowMessage:message];
    //预先存储
    [[YDChatHelper sharedInstance] addMessage:message];
    
    //转成mp4
    [YDVideoUtil ConvertMovToMp4:videoUrl completion:^(AVAssetExportSessionStatus status, NSString *exportPath) {
        [YDNetworking uploadVideoData:exportPath thumbnailImage:thumbnailImage dataName:@"video" url:kUploadVideoDataURL success:^(NSString *videoUrl, NSString *thumbnailImageUrl) {
            message.videoURL = YDNoNilString(videoUrl);
            message.thumbnailImageURL = YDNoNilString(thumbnailImageUrl);
            [[YDChatHelper sharedInstance] sendMessage:message];
        } failure:^{
            [[YDChatHelper sharedInstance] updateMessageSendStatus:YDMessageSendFail messageId:message.msgId userId:YDUser_id];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.messageDisplayView updateMessageSendStatus:message.msgId sendStatus:YDMessageSendFail];
            });
        }];
    } ];
    
    
}

- (void)sendVoiceMessage:(YDVoiceChatMessage *)message{
    [self.messageDisplayView updateMessage:message];
    //预先存储
    [[YDChatHelper sharedInstance] addMessage:message];
    [YDNetworking uploadVoiceFile:message.amrPath dataName:@"amr" url:kUploadMessageDataURL success:^(NSString *dataUrl) {
        NSLog(@"dataUrl = %@",dataUrl);
        message.url = YDNoNilString(dataUrl);
        [[YDChatHelper sharedInstance] sendMessage:message];
        if ([[NSFileManager defaultManager] fileExistsAtPath:message.amrPath]) {
            BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:message.amrPath error:nil];
            NSLog(@"remove =%d",remove);
        }
        
    } failure:^{
        [[YDChatHelper sharedInstance] updateMessageSendStatus:YDMessageSendFail messageId:message.msgId userId:YDUser_id];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageDisplayView updateMessageSendStatus:message.msgId sendStatus:YDMessageSendFail];
        });
        if ([[NSFileManager defaultManager] fileExistsAtPath:message.amrPath]) {
            BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:message.amrPath error:nil];
            NSLog(@"remove =%d",remove);
        }
    }];
}

- (void)sendMessage:(YDChatMessage *)message{
    message.ownerType = YDMessageOwnerTypeSelf;
    message.uid = YDUser_id;
    message.fid = self.partner.chat_userId;
    message.date = [NSDate date];
    
    if (message.messageType == YDMessageTypeVoice) {
        [self.messageDisplayView updateMessage:message];
    }else{
        [self addToShowMessage:message];
    }
    
    //发送消息
    [[YDChatHelper sharedInstance] sendMessage:message];
}

- (void)receivedMessage:(YDChatMessage *)message{
    [self addToShowMessage:message];
    //修改消息的读取状态
    if ([[YDChatHelper sharedInstance] updateMessageReadStatus:YDMessageReaded messageId:message.msgId userId:YDUser_id]) {
        //更新消息列表的未读数量
        [[YDChatHelper sharedInstance] updateConversationByUid:YDUser_id fid:message.fid];
    }
}

#pragma mark - YDChatHelperDelegate
/**
 发送消息成功
 */
- (void)chatMessageSendSuccess:(NSString *)msgId{
    YDLog(@"消息发送成功，此处修改UI:msgId = %@",msgId);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.messageDisplayView updateMessageSendStatus:msgId sendStatus:YDMessageSendSuccess];
    });
}
/**
 发送消息失败
 */
- (void)chatMessageSendFail:(NSString *)msgId{
    YDLog(@"消息发送失败，此处修改UI:msgId = %@",msgId);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.messageDisplayView updateMessageSendStatus:msgId sendStatus:YDMessageSendFail];
    });
}

/**
 接受到消息
 1.将消息添加到tableView
 2.修改消息为已读状态
 */
- (void)receiveChatMessage:(YDChatMessage *)message{
    //如果消息的来源id与当前界面的partner的id不一样直接返回
    if (![message.fid isEqual:self.partner.chat_userId]) {
        return;
    }
    UIViewController *chatVC = [self.navigationController findViewController:@"YDChatController"];
    if (chatVC) {
        //非聊天界面消息没有头像和名字
        if (message.fAvatarUrl == nil || message.fAvatarUrl.length == 0) {
            message.fAvatarUrl = self.partner.chat_avatarURL;
        }
        if (message.fName == nil || message.fName.length == 0) {
            message.fName = self.partner.chat_username;
        }
        
        [self receivedMessage:message];
    }
}

@end

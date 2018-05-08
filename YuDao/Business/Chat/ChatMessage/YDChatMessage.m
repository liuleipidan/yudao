//
//  YDChatMessage.m
//  YuDao
//
//  Created by 汪杰 on 17/1/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatMessage.h"

@implementation YDChatMessage

- (instancetype)init{
    if (self = [super init]) {
        self.msgId = [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970] * 1000000)];
        
    }
    return self;
}

+ (YDChatMessage *)createChatMessageByType:(YDMessageType )type{
    // YDTextChatMeesage YDImageChatMessage YDVoiceChatMessage
    NSString *className = nil;
    if (type == YDMessageTypeText) {
        className = @"YDTextChatMeesage";//文字
    }
    else if (type == YDMessageTypeImage){
        className = @"YDImageChatMessage";//图片
    }
    else if (type == YDMessageTypeVoice){
        className = @"YDVoiceChatMessage";//语言
    }
    else if (type == YDMessageTypeVideo){
        className = @"YDVideoChatMessage";//视频
    }
    if (className) {
        return [[NSClassFromString(className) alloc] init];
    }
    return nil;
}

- (void)resetMessageFrame{
    _messageFrame = nil;
}

#pragma mark - Protocol
- (NSString *)conversationContent{
    return @"子类未定义";
}

- (NSString *)messageCopy{
    return @"子类未定义";
}

#pragma mark - # Getter
- (NSMutableDictionary *)content
{
    if (_content == nil) {
        _content = [[NSMutableDictionary alloc] init];
    }
    return _content;
}

@end

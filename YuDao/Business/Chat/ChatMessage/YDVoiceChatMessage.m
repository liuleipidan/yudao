//
//  YDVoiceChatMessage.m
//  YuDao
//
//  Created by 汪杰 on 17/1/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDVoiceChatMessage.h"

@implementation YDVoiceChatMessage
@synthesize recFileName = _recFileName;
@synthesize path = _path;
@synthesize url = _url;
@synthesize seconds = _seconds;

- (id)init
{
    if (self = [super init]) {
        [self setMessageType:YDMessageTypeVoice];
    }
    return self;
}

- (NSString *)recFileName
{
    if (_recFileName == nil) {
        _recFileName = [self.content objectForKey:@"path"];
    }
    return _recFileName;
}
- (void)setRecFileName:(NSString *)recFileName
{
    _recFileName = recFileName;
    [self.content setObject:recFileName forKey:@"path"];
}

- (NSString *)path
{
    if (_path == nil) {
        _path = [NSFileManager pathUserChatVoice:self.recFileName];
    }
    return _path;
}

- (NSString *)url
{
    if (_url == nil) {
        _url = [self.content objectForKey:@"url"];
    }
    return _url;
}
- (void)setUrl:(NSString *)url
{
    _url = url;
    [self.content setObject:url forKey:@"url"];
}

- (CGFloat)seconds
{
    return [[self.content objectForKey:@"seconds"] doubleValue];
}
- (void)setSeconds:(CGFloat)seconds
{
    [self.content setObject:[NSNumber numberWithDouble:seconds] forKey:@"seconds"];
}

- (YDMessageFrame *)messageFrame{
    if (!_messageFrame) {
        _messageFrame = [[YDMessageFrame alloc] init];
        CGFloat width = 60 + (self.seconds > 20 ? 1.0 : self.seconds / 20.0)  * (MAX_MESSAGE_WIDTH - 60);
        CGFloat height = 54;
        _messageFrame.contentSize = CGSizeMake(width, height);
        _messageFrame.height = _messageFrame.contentSize.height + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0) + 3;
    }
    return _messageFrame;
}

- (NSString *)conversationContent
{
    return @"[语音]";
}

- (NSString *)messageCopy
{
    return [self.content mj_JSONString];
}

@end

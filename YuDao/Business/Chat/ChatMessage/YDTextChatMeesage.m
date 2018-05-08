//
//  YDTextChatMeesage.m
//  YuDao
//
//  Created by 汪杰 on 17/1/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTextChatMeesage.h"

static UILabel *textLabel = nil;

@implementation YDTextChatMeesage
- (id)init
{
    if (self = [super init]) {
        [self setMessageType:YDMessageTypeText];
        
        if (textLabel == nil) {
            textLabel = [[UILabel alloc] init];
            [textLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:15]];
            [textLabel setNumberOfLines:0];
        }
    }
    return self;
}

- (NSString *)text{
    if (_text == nil) {
        _text = [self.content objectForKey:@"text"];
    }
    return _text;
}

- (void)setText:(NSString *)text{
    _text = text;
    [self.content setObject:text forKey:@"text"];
}

- (NSAttributedString *)attrText
{
    if (_attrText == nil) {
        _attrText = [self.text toMessageString];
    }
    return _attrText;
}

- (YDMessageFrame *)messageFrame{
    if (!_messageFrame) {
        _messageFrame = [[YDMessageFrame alloc] init];
        
        _messageFrame.height = 12 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0);
        [textLabel setAttributedText:self.attrText];
        
        _messageFrame.contentSize = [textLabel sizeThatFits:CGSizeMake(MAX_MESSAGE_WIDTH, MAXFLOAT)];
        
        _messageFrame.height +=  _messageFrame.contentSize.height + MSG_SPACE_TOP + MSG_SPACE_BTM;
        if (_messageFrame.height < 40) {
            _messageFrame.height = 40;
        }
        
        //_messageFrame.height += _messageFrame.contentSize.height > 20 ? _messageFrame.contentSize.height + MSG_SPACE_TOP + MSG_SPACE_BTM : 20 + MSG_SPACE_TOP + MSG_SPACE_BTM;
    }
    return _messageFrame;
}

- (NSString *)conversationContent{
    return self.text;
}

- (NSString *)messageCopy
{
    return self.text;
}

@end

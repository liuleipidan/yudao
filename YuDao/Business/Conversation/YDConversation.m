//
//  YDConversation.m
//  YuDao
//
//  Created by 汪杰 on 16/11/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDConversation.h"

@implementation YDConversation

- (void)setConvType:(YDConversationType)convType
{
    _convType = convType;
    switch (convType) {
        case YDConversationTypePersonal:
        case YDConversationTypeGroup:
            _clueType = YDClueTypePointWithNumber;
            break;
        case YDConversationTypePublic:
        case YDConversationTypeServerGroup:
            _clueType = YDClueTypePoint;
            break;
        default:
            break;
    }
}

- (NSString *)timeInfo{
    if (_timeInfo == nil) {
        _timeInfo = [NSDate timeInfoWithDate:self.date];
    }
    return _timeInfo;
}

- (BOOL)isRead
{
    return self.unreadCount == 0;
}

- (NSAttributedString *)attrContent
{
    if (_attrContent == nil) {
        _attrContent = [self.content toMessageString];
    }
    return _attrContent;
}

@end

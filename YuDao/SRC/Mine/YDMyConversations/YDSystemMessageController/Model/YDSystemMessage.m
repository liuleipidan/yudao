//
//  YDSystemMessage.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/31.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSystemMessage.h"

@interface YDSystemMessage()

@property (nonatomic, strong) NSDictionary *contentDic;

@end

@implementation YDSystemMessage

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"msgId":@"m_id",
             @"msgType":@"m_type",
             @"msgSubtype":@"m_subtype",
             @"time":@"time",
             @"content":@"content",
             };
}

- (id)init{
    if (self = [super init]) {
        _showTime = YES;
        _type = YDSystemMessageTypeUnknown;
    }
    return self;
}


- (YDSystemMessageType)type{
    if (_type == YDSystemMessageTypeUnknown) {
        _type = [self resetSystemMessageTypeByMsgSubtype:self.msgSubtype contentDic:self.contentDic];
    }
    return _type;
}

#pragma mark - 重置显示类型
- (YDSystemMessageType)resetSystemMessageTypeByMsgSubtype:(NSNumber *)subtype contentDic:(NSDictionary *)contentDic{
    NSInteger type = subtype.integerValue;
    switch (type) {
        case 2002:
        case 4001:
        case 9004:
        case 9005:
            return YDSystemMessageTypeTextJump;
            
        case 5001:
        case 5002:
        case 5003:
        case 5004:
            return self.isSkip ? YDSystemMessageTypeTextJump : YDSystemMessageTypeNormal;
            
        case 1010:
            return YDSystemMessageTypeUser;
        
        case 3001:
        case 3002:
        case 8001:
        case 9010:
        case 9001:
            return YDSystemMessageTypeNormal;
            break;
        default:
            break;
    }
    
    return YDSystemMessageTypeNormal;
}

#pragma mark - Getter
- (NSDictionary *)contentDic{
    if (_contentDic == nil) {
        _contentDic = [self.content mj_JSONObject];
    }
    return _contentDic;
}

#pragma mark - UI
- (CGFloat)textHeight{
    if (_textHeight == 0) {
        if (self.text.length == 0) {
            _textHeight = 20.0f;
        }
        else{
            CGFloat height = [self.text yd_stringHeightBySize:CGSizeMake(SCREEN_WIDTH-50, CGFLOAT_MAX) font:[UIFont font_14]];
            _textHeight = height > 20.0f ? height : 20.0f;
        }
    }
    return _textHeight;
}

- (NSString *)timeInfo{
    if (_timeInfo == nil) {
        _timeInfo = [NSDate timeInfoWithDate:self.time];
    }
    return _timeInfo;
}

- (NSString *)jumpText{
    if (_jumpText == nil) {
        NSInteger msgSubtype = self.msgSubtype.integerValue;
        if (self.type == YDSystemMessageTypeTextJump) {
            _jumpText = @"点击查看>>";
            switch (msgSubtype) {
                case 5001:
                case 5002:
                case 5003:
                case 5004:
                    _jumpText = @"重新提交>>";
                    break;
                default:
                    break;
            }
        }
        else{
            _jumpText = @"";
        }
    }
    return _jumpText;
}

- (CGFloat)wholeHeight{
    if (_wholeHeight == 0) {
        //上下最少间距7.5
        _wholeHeight += 15;
        CGFloat height = 0;
        if (self.type == YDSystemMessageTypeUser) {
            height = 70.0f;
        }
        else if (self.type == YDSystemMessageTypeNormal){
            height = 10 + 22 + 5 + self.textHeight + 10;
        }
        else if (self.type == YDSystemMessageTypeTextJump){
            height = 10 + 22 + 5 + self.textHeight + 10 + 20 + 10;
        }
        else{
            height = 0;
        }
        _wholeHeight += height;
        
        //显示时间的高度
        _wholeHeight += self.showTime ? (17.5 + 20 + 7.5) : 0;
    }
    return _wholeHeight;
}

#pragma mark - Extensions
- (NSString *)text{
    return [self.contentDic objectForKey:@"text"];
}

- (NSString *)title{
    NSString *title = [self.contentDic objectForKey:@"title"];
    return title.length > 0 ? title : @"系统通知";
}

- (NSNumber *)userId{
    return [self.contentDic objectForKey:@"userid"];
}

- (NSString *)nickname{
    return [self.contentDic objectForKey:@"nickname"];
}

- (NSString *)avatarURL{
    return [self.contentDic objectForKey:@"face"];
}

- (NSNumber *)ug_id{
    return [self.contentDic objectForKey:@"ug_id"];
}

- (BOOL)isSkip{
    NSNumber *skip = [self.contentDic objectForKey:@"isSkip"];
    if (skip && [skip isEqual:@1]) {
        return YES;
    }
    return NO;
}

@end

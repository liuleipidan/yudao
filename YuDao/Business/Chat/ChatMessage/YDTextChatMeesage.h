//
//  YDTextChatMeesage.h
//  YuDao
//
//  Created by 汪杰 on 17/1/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatMessage.h"

@interface YDTextChatMeesage : YDChatMessage
{
    NSString *_text;
}
@property (nonatomic, copy  ) NSString *text;

#pragma mark - UI
@property (nonatomic, strong) NSAttributedString *attrText;

@end

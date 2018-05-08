//
//  YDConversationController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 17/2/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDConversationController.h"

@interface YDConversationController (Delegate)<YDSystemMessageDelegate,YDChatHelperDelegate>

- (void)registerConversationCell;

@end

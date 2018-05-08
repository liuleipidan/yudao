//
//  YDHPMessageController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHPMessageController.h"

@interface YDHPMessageController (Delegate)<YDHPMessageCellDelegate,YDPushMessageManagerDelegate,YDUserDefaultDelegate>

- (void)registerCells;

@end

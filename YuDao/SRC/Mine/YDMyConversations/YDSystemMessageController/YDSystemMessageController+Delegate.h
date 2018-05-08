//
//  YDSystemMessageController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSystemMessageController.h"
#import "YDUserSysMessageCell.h"
#import "YDNormalSysMessageCell.h"
#import "YDTextJumpSysMessageCell.h"

@interface YDSystemMessageController (Delegate)<UITableViewDelegate,UITableViewDataSource,YDSystemMessageCellDelegate>

- (void)sm_registerCells;

@end

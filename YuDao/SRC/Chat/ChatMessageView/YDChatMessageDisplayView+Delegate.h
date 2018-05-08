//
//  YDChatMessageDisplayView+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 17/3/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatMessageDisplayView.h"
#import "YDTextMessageCell.h"
#import "YDImageMessageCell.h"
#import "YDVoiceMessageCell.h"
#import "YDVideoMessageCell.h"

@interface YDChatMessageDisplayView (Delegate)<UITableViewDelegate, UITableViewDataSource,YDMessageCellDelegate>

- (void)registerCellClassForTableView:(UITableView *)tableView;

@end

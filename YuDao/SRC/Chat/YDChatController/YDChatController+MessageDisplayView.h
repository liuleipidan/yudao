//
//  YDChatController+MessageDisplayView.h
//  YuDao
//
//  Created by 汪杰 on 17/3/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatController.h"
#import "XLPhotoBrowser.h"

@interface YDChatController (MessageDisplayView)<YDChatMessageViewDelegate,XLPhotoBrowserDatasource,XLPhotoBrowserDelegate>

- (void)addToShowMessage:(YDChatMessage *)message;

- (void)resetChatViewConroller;

@end

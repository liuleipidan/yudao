//
//  YDChatBaseController+MessageDisplayView.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatBaseController+MessageDisplayView.h"
#import "YDChatBaseController+ChatBar.h"

@implementation YDChatBaseController (MessageDisplayView)

#pragma mark - YDChatMessageViewDelegate
#pragma mark - 聊天界面点击事件，用于收键盘
- (void)chatMessageDisplayViewDidTouched:(YDChatMessageDisplayView *)chatTVC{
    [self dismissKeyboard];
}
#pragma mark - 下拉刷新，获取某个时间段的聊天记录
- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
            getRecordsFromDate:(NSDate *)date
                         count:(NSUInteger)count
                     completed:(void (^)(NSDate *, NSArray *, BOOL))completed{

}

@end

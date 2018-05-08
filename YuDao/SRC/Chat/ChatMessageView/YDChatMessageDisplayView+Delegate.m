//
//  YDChatMessageDisplayView+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 17/3/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatMessageDisplayView+Delegate.h"

@implementation YDChatMessageDisplayView (Delegate)

#pragma mark - # Public Methods
- (void)registerCellClassForTableView:(UITableView *)tableView
{
    [tableView registerClass:[YDTextMessageCell class] forCellReuseIdentifier:@"YDTextMessageCell"];
    [tableView registerClass:[YDImageMessageCell class] forCellReuseIdentifier:@"YDImageMessageCell"];
    [tableView registerClass:[YDVoiceMessageCell class] forCellReuseIdentifier:@"YDVoiceMessageCell"];
    [tableView registerClass:[YDVideoMessageCell class] forCellReuseIdentifier:@"YDVideoMessageCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}

#pragma mark - # Delegate
//MARK: UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDChatMessage *message = self.data[indexPath.row];
    if (message.messageType == YDMessageTypeText) {
        YDTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDTextMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    else if (message.messageType == YDMessageTypeImage){
        YDImageMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDImageMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    else if (message.messageType == YDMessageTypeVoice){
        YDVoiceMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDVoiceMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    else if (message.messageType == YDMessageTypeVideo){
        YDVideoMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDVideoMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row >= self.data.count) {
        return 0.0f;
    }
    YDChatMessage *message = self.data[indexPath.row];
    return message.messageFrame.height;
}
//MARK: UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayViewDidTouched:)]) {
        [self.delegate chatMessageDisplayViewDidTouched:self];
    }
}

#pragma mark - YDMessageCellDelegate
//点击头像
- (void)messageCellDidClickAvatarForUser:(NSNumber *)userId{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:didClickUserAvatar:)]) {
        [self.delegate chatMessageDisplayView:self didClickUserAvatar:userId];
    }
}
//单击
- (void)messageCellTapView:(UIView *)view message:(YDChatMessage *)message{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:tapedView:didClickMessage:)]) {
        [self.delegate chatMessageDisplayView:self tapedView:view didClickMessage:message];
    }
}


//双击
- (void)messageCellDoubleClick:(YDChatMessage *)message{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:didDoubleClickMessage:)]) {
        [self.delegate chatMessageDisplayView:self didDoubleClickMessage:message];
    }
}
//长按
- (void)messageCellLongPress:(YDChatMessage *)message rect:(CGRect)rect{
    __block NSInteger row = -1;
    [self.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YDChatMessage *dataMessage = obj;
        if ([dataMessage.msgId isEqualToString:message.msgId]) {
            row = idx;
            *stop = YES;
        }
    }];
    if (row == -1) {    return;}
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if (self.disableLongPressMenu) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if ([YDChatCellMenuView sharedMenuView].isShow) {
        return;
    }
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    rect.origin.y += cellRect.origin.y - self.tableView.contentOffset.y;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:showCellMenuViewrect:message:)]) {
        [self.delegate chatMessageDisplayView:self showCellMenuViewrect:rect message:message];
    }
}


@end

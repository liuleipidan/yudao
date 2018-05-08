//
//  YDSystemMessageController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSystemMessageController+Delegate.h"
#import "YDCarIllegalityController.h"
#import "YDCarAuthenticateController.h"
#import "YDUserFilesController.h"

@implementation YDSystemMessageController (Delegate)

- (void)sm_registerCells{
    
    [self.tableView registerClass:[YDUserSysMessageCell class] forCellReuseIdentifier:@"YDUserSysMessageCell"];
    [self.tableView registerClass:[YDNormalSysMessageCell class] forCellReuseIdentifier:@"YDNormalSysMessageCell"];
    [self.tableView registerClass:[YDTextJumpSysMessageCell class] forCellReuseIdentifier:@"YDTextJumpSysMessageCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
    
}

#pragma mark - YDSystemMessageCellDelegate
//点击查看／重新提交
- (void)systemMessage:(YDSystemMessage *)message didClickedLookLabel:(UILabel *)label{
    [self sm_pushToControllerByMessage:message];
}

//点击背景视图
- (void)systemMessageDidClickedBackgroundView:(YDSystemMessage *)message{
    if (message.type == YDSystemMessageTypeUser) {
        [self sm_pushToControllerByMessage:message];
    }
}
//长按背景视图
- (void)systemMessageDidLongPressBackgroundView:(YDSystemMessage *)message rect:(CGRect)rect{
    NSInteger row = [self.data indexOfObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if ([YDChatCellMenuView sharedMenuView].isShow) {
        return;
    }
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    rect.origin.y += cellRect.origin.y - self.tableView.contentOffset.y;
    YDWeakSelf(self);
    [[YDChatCellMenuView sharedMenuView] showInView:self.view isFirstResponder:YES messageType:YDMessageTypeText rect:rect actionBlcok:^(YDChatMenuItemType itemType) {
        if (itemType == YDChatMenuItemTypeDelete) {
            [LPActionSheet showActionSheetWithTitle:@"是否删除该消息" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
                if (index == -1) {
                    [weakself sm_deleteMessage:message indexPath:indexPath];
                }
            }];
        }
        else if (itemType == YDChatMenuItemTypeCopy){
            [[UIPasteboard generalPasteboard] setString:YDNoNilString(message.text)];
        }
    }];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDSystemMessage *message = self.data[indexPath.row];
    if (message.type == YDSystemMessageTypeUser) {
        YDUserSysMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUserSysMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    else if (message.type == YDSystemMessageTypeNormal) {
        YDNormalSysMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDNormalSysMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    else if (message.type == YDSystemMessageTypeTextJump) {
        YDTextJumpSysMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDTextJumpSysMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDSystemMessage *message = self.data[indexPath.row];
    return message.wholeHeight;
}

#pragma mark Private Methods
- (void)sm_deleteMessage:(YDSystemMessage *)message indexPath:(NSIndexPath *)indexPath{
    [[YDSystemMessageHelper sharedInstance] deleteSystemMessageByMsgid:message.msgId];
    [self.data removeObject:message];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)sm_pushToControllerByMessage:(YDSystemMessage *)message{
    NSString *vcClassString = nil;
    NSInteger subtype = message.msgSubtype.integerValue;
    switch (subtype) {
        case YDServerMessageTypeIllegal: {
            YDCarIllegalityController *carIllegal = [YDCarIllegalityController new];
            [carIllegal setUg_id:message.ug_id];
            [self.navigationController pushViewController:carIllegal animated:YES];
            break;
        }
        case YDServerMessageTypeAdviseFeedback:  vcClassString = @"YDAdviseViewController";  break;
        case YDServerMessageTypeDailyPush:
        case YDServerMessageTypeIntegralChanged:  vcClassString = @"YDIntegralController";  break;
            
        case YDServerMessageTypeAvatarVerify:  {
            if (!message.isSkip) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            break;
        }
        case YDServerMessageTypeBackgroundVerify:  {
            if (!message.isSkip) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            break;
        }
        case YDServerMessageTypeIdentityAuth:  {
            vcClassString = @"YDPersonalAuthController";
            break;
        }
        case YDServerMessageTypeCarAuth:  {
            YDCarAuthenticateController *vc = [YDCarAuthenticateController new];
            YDCarDetailModel *car = [[YDCarHelper sharedHelper] getOneCarWithCarid:message.ug_id];
            if (car) {
                [vc setCarInfo:car];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
            
        case YDServerMessageTypeLikedCurrentUser:  {
            YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:message.userId];
            viewM.userName = message.nickname;
            viewM.userHeaderUrl = message.avatarURL;
            YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
            
            [self.navigationController pushViewController:userVC animated:YES];
            break;
        }
        
        default:
            break;
    }
    
    if (vcClassString) {
        [self yd_pushViewControllerWithString:vcClassString];
    }
}

@end

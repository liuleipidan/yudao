//
//  YDConversationController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 17/2/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDConversationController+Delegate.h"
#import "YDConversationCell.h"
#import "YDSystemMessageController.h"
#import "YDChatHelper+ConversationRecord.h"

@implementation YDConversationController (Delegate)

- (void)registerConversationCell{
    
    [self.tableView registerClass:[YDConversationCell class] forCellReuseIdentifier:@"YDConversationCell"];
}

#pragma mark - YDSystemMessageDelegate
- (void)receivedNewSystemMessages{
    YDConversation *model = self.data.firstObject;
    [self updateLastSystemMessageAtFirstModel:model];
}

- (void)systemMessagesAreRead{
    YDConversation *model = self.data.firstObject;
    [self updateLastSystemMessageAtFirstModel:model];
}

#pragma mark - YDChatHelperDelegate - 聊天消息改变
- (void)conversationHadChanged{
    [self updateConversationData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDConversationCell"];
    cell.model = [self.data objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDConversation *model = [self.data objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        if ([model.content isEqualToString:@"暂无系统消息"]) {
            [YDMBPTool showText:@"暂无系统消息"];
        }
        else{
            [self.navigationController pushViewController:[YDSystemMessageController new] animated:YES];
        }
    }
    else{
        YDChatController *chatVC = [YDChatController shareChatVC];
        YDChatPartner *partner = YDCreateChatPartner(model.fid, model.fname, model.fimageUrl, 0);
        [chatVC setPartner:partner];
        [self.navigationController pushViewController:chatVC animated:YES];
        
        //去掉红点
        [(YDConversationCell *)[tableView cellForRowAtIndexPath:indexPath] markAsRead];
    }
}

//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [LPActionSheet showActionSheetWithTitle:@"删除后，将清空该聊天的消息记录" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
            if (index == -1) {
                YDConversation *conv = [self.data objectAtIndex:indexPath.row];
                NSLog(@"conv.uid = %@",conv.uid);
                    //删除此条消息
                if ([[YDChatHelper sharedInstance] deleteConversationByUid:conv.uid fid:conv.fid]) {
                    //删除此消息对应用户的聊天记录
                    [[YDChatHelper sharedInstance] deleteChatMessagesByUid:conv.uid fid:conv.fid];
                    [self.data removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }];
    }
}

//修改删除按钮为中文
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//是否运行编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}

@end

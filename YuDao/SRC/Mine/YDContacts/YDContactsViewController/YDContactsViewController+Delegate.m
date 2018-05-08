//
//  YDContactsViewController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 16/11/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDContactsViewController+Delegate.h"
#import "YDUserFilesController.h"
#import "YDPhoneContactsController.h"
#import "YDNewFriendController.h"
#import "YDContactHeaderView.h"
#import "YDChatHelper+ConversationRecord.h"

@implementation YDContactsViewController (Delegate)
#pragma mark - Public Methods -
- (void)registerCellClass
{
    [self.tableView registerClass:[YDFriendCell class] forCellReuseIdentifier:@"YDFriendCell"];
    
    [self.tableView registerClass:[YDContactHeaderView class] forHeaderFooterViewReuseIdentifier:@"YDContactHeaderView"];
}

#pragma mark - YDPushMessageManagerDelegate
//收到新的好友请求
- (void)receivedNewFriendRequest{
    [self.tableView reloadData];
}
//未读好友请求数量改变
- (void)unreadFirendRequestCountDidChange{
    [self.tableView reloadData];
}

#pragma mark - YDFriendCellDelegate
- (void)friendCell:(YDFriendCell *)cell didClickAvatarImageView:(UIImageView *)avatarImageView{
    if (![cell.item.friendid isEqual:@0]) {
        YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:cell.item.friendid];
        viewM.userName = cell.item.friendName;
        viewM.userHeaderUrl = cell.item.friendImage;
        YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YDUserGroup *group = [self.data objectAtIndex:section];
    return group.count;
}
////右侧索引标题数据源
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return self.headers;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDFriendCell"];
    YDUserGroup *group = [self.data objectAtIndex:indexPath.section];
    YDFriendModel *friend = [group objectAtIndex:indexPath.row];
    [cell setItem:friend];
    [cell setDelegate:self];
    if (indexPath.section == 0) {
        NSInteger count = [[YDPushMessageManager sharePushMessageManager] countFriendRequestMessageByUserid:[YDUserDefault defaultUser].user.ub_id];
        [cell markRemindLabelCount:count];
    }
    else{
        [cell markRemindLabelCount:0];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(index == 0) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, tableView.width, tableView.height) animated:NO];
        return -1;
    }
    return index;
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    YDUserGroup *group = [self.data objectAtIndex:section];
    YDContactHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YDContactHeaderView"];
    [view setTitle:group.groupName];
    return view;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0f;
    }
    return 22.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDUserGroup *group = [self.data objectAtIndex:indexPath.section];
    YDFriendModel *friend = [group objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        if ([friend.friendid isEqual:@(-1)]) {
            [self.navigationController pushViewController:[YDNewFriendController new] animated:YES];
        }
    }else{
        YDChatController *chatVC = [YDChatController shareChatVC];
        YDChatPartner *partner = YDCreateChatPartner(friend.friendid, friend.friendName, friend.friendImage, 0);
        [chatVC setPartner:partner];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

//实现左滑删除方法
//第一个参数：表格视图对象
//第二个参数：编辑表格的方式
//第三个参数：操作cell对应的位置
-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    //如果是删除
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        YDUserGroup *group = [self.data objectAtIndex:indexPath.section];
        YDFriendModel *model = [group objectAtIndex:indexPath.row];
        NSString *title = [NSString stringWithFormat:@"将联系人\"%@\"删除，同时删除相应的聊天记录",model.friendName];
        [LPActionSheet showActionSheetWithTitle:title cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除联系人" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
            if (index == -1) {
                //1.发送给服务器
                YDWeakSelf(self);
                NSDictionary *param = @{
                                        @"access_token":YDAccess_token,
                                        @"f_ub_id":model.friendid
                                        };
                [YDNetworking POST:[kOriginalURL stringByAppendingString:@"delfriend"] parameters:param success:^(NSNumber *code, NSString *status, id data) {
                    NSLog(@"code = %@",code);
                    NSLog(@"data = %@",data);
                    if ([code isEqual:@200]) {
                        //2.删除数据库里对应好友
                        if ([[YDFriendHelper sharedFriendHelper] deleteFriendByFid:model.friendid]) {
                            YDLog(@"删除数据库好友成功");
                        }else{
                            YDLog(@"删除数据库好友失败");
                        }
                        
                        //3.删除好友消息记录
                        if ([[YDChatHelper sharedInstance] deleteChatMessagesByUid:YDUser_id fid:model.friendid]) {
                            YDLog(@"删除好友聊天记录成功");
                        }
                        
                        //4.删除好友消息列表
                        if ([[YDChatHelper sharedInstance] deleteConversationByUid:YDUser_id fid:model.friendid]) {
                            YDLog(@"删除好友消息列表成功");
                        }
                        
                        //修改底部好友数量
                        self.friendsCount = self.friendsCount - 1;
                        
                        //5.数据源删除
                        [group removeObject:model];
                        
                        //6.UI上删除
                        if (group.count == 0) {
                            [weakself.headers removeObjectAtIndex:indexPath.section];
                            [weakself.data removeObjectAtIndex:indexPath.section];
                            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                        }
                        else{
                            [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
                        }
                    }
                    else{
                        [YDMBPTool showInfoImageWithMessage:@"删除好友失败" hideBlock:nil];
                    }
                } failure:^(NSError *error) {
                    [YDMBPTool showInfoImageWithMessage:@"删除好友失败" hideBlock:nil];
                }];
            }
        }];
    }
}

//修改删除按钮为中文的删除
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath{
    return @"删除";
}

//是否允许编辑行，默认是YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.friendSearchVC setFriendsData:self.data];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}


@end

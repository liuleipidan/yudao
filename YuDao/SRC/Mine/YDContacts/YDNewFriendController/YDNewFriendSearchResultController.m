//
//  YDNewFriendSearchResultController.m
//  YuDao
//
//  Created by 汪杰 on 2017/5/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDNewFriendSearchResultController.h"
#import "YDNewFriendCell.h"
#import "YDUserFilesController.h"
#import "NSString+PinYin.h"

#define     HEIGHT_FRIEND_CELL      54.0f

@interface YDNewFriendSearchResultController ()<YDNewFriendCellDelegate>

@property (nonatomic, strong) NSArray *data;

@end

@implementation YDNewFriendSearchResultController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.data = [[NSMutableArray alloc] init];
    [self.tableView registerClass:[YDNewFriendCell class] forCellReuseIdentifier:@"YDNewFriendCell"];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

#pragma mark - YDNewFriendCellDelegate
- (void)newFriendCell:(YDNewFriendCell *)cell didSelectedBtn:(UIButton *)btn{
    YDLog(@"btn.titleLabel.text = %@",btn.titleLabel.text);
    YDPushMessage *message = cell.message;
    YDWeakSelf(self);
    if ([btn.titleLabel.text isEqualToString:@"接受"]) {
        [YDLoadingHUD showLoading];
        [YDNetworking postUrl:[kOriginalURL stringByAppendingString:@"addfriends"] parameters:@{@"access_token":YDAccess_token,@"f_ub_id":message.senderid,@"type":@1} success:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *status_code = [[responseObject mj_JSONObject] valueForKey:@"status_code"];
            if ([status_code isEqual:@200]) {
                //修改好友请求的状态
                [YDMBPTool showSuccessImageWithMessage:@"添加成功" hideBlock:nil];
                
                YDFriendModel *model = [YDFriendModel new];
                model.friendid = message.senderid;
                model.currentUserid = message.userid;
                model.friendImage = message.avatar;
                model.friendName = message.name;
                model.friendGrade = @5;
                NSString *pinyin = [message.name pinyinInitial];
                if (pinyin.length == 1) {
                    model.firstchar = pinyin;
                }else{
                    model.firstchar = [pinyin substringFromIndex:0];
                }
                
                if ([[YDFriendHelper sharedFriendHelper] addFriendByModel:model]) {
                    YDLog(@"接受好友请求，并插入数据库");
                    message.frStatus = YDFriendRequestStatusAccept;
                    [[YDPushMessageManager sharePushMessageManager] updateFriendRequestMessageToAccptedByUserid:[YDUserDefault defaultUser].user.ub_id senderid:message.senderid];
                    [YDNotificationCenter postNotificationName:@"YDNeedUpdateFriendRequest" object:nil];
                }
                [weakself.tableView reloadData];
            }else{
                [YDMBPTool showText:[[responseObject mj_JSONObject] valueForKey:@"status"] ];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            YDLog(@"接受好友请求:error = %@",error);
            [YDMBPTool showText:@"添加失败"];
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"联系人";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDNewFriendCell"];
    
    YDPushMessage *message = [self.data objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.message = message;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDPushMessage *message = [self.data objectAtIndex:indexPath.row];
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:message.senderid];
    viewM.userName = message.name;
    viewM.userHeaderUrl = message.avatar;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    [self.presentingViewController.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - Delegate -
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_FRIEND_CELL;
}

//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = [searchController.searchBar.text lowercaseString];
    YDWeakSelf(self);
    [[YDPushMessageManager sharePushMessageManager] searchFriendRequestMessageByUserid:[YDUserDefault defaultUser].user.ub_id senderName:searchText complete:^(NSArray *data) {
        weakself.data = [NSArray arrayWithArray:data];
        [weakself.tableView reloadData];
    }];
}

@end

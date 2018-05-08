//
//  YDFriendSearchController.m
//  YuDao
//
//  Created by 汪杰 on 16/11/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDFriendSearchController.h"
#import "YDFriendCell.h"
#import "YDFriendModel.h"

@interface YDFriendSearchController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation YDFriendSearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.data = [[NSMutableArray alloc] init];;
    [self.tableView registerClass:[YDFriendCell class] forCellReuseIdentifier:@"YDFriendCell"];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
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
    YDFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDFriendCell"];
    
    YDFriendModel *model = [self.data objectAtIndex:indexPath.row];
    [cell setItem:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDFriendModel *model = [self.data objectAtIndex:indexPath.row];
    if ([[YDFriendHelper sharedFriendHelper] friendIsInExistenceByUid:model.friendid]) {
        YDChatController *chatVC = [YDChatController shareChatVC];
        YDChatPartner *partner = YDCreateChatPartner(model.friendid, model.friendName, model.friendImage, 0);
        [chatVC setPartner:partner];
//        self.presentingViewController.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.presentingViewController.navigationController pushViewController:chatVC animated:YES];
    }
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
    [[YDFriendHelper sharedFriendHelper] searchFriendByName:searchText orId:nil completion:^(NSArray *data) {
        weakself.data = [NSMutableArray arrayWithArray:data];
        [weakself.tableView reloadData];
    }];
}



@end

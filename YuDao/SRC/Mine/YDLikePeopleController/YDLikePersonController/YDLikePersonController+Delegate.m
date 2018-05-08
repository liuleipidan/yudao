//
//  YDLikePersonController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 16/11/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDLikePersonController+Delegate.h"
#import "YDLikePersonCell.h"
#import "YDUserFilesController.h"

@implementation YDLikePersonController (Delegate)

- (void)registerCellClass{
    [self.tableView registerClass:[YDLikePersonCell class] forCellReuseIdentifier:@"YDLikePersonCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data? self.data.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDLikePersonCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"YDLikePersonCell"];
    YDLikePersonModel *item = self.data[indexPath.row];
    [cell setLikePersonItem:item];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    YDLikePersonModel *model = self.data[indexPath.row];
    NSNumber *ubid = self.likedType == 1 ? model.ub_id: model.e_ub_id;
    //跳转到个人详情页面
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:ubid];
    viewM.userName = model.ub_nickname;
    viewM.userHeaderUrl = model.ud_face;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    [self.parentViewController.navigationController pushViewController:userVC animated:YES];
    
}

@end

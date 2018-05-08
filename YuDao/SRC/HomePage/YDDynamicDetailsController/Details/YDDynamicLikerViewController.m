//
//  YDDynamicLikerViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/4/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDynamicLikerViewController.h"
#import "YDDynamicDetailModel.h"
#import "YDDynamicLikerCell.h"
#import "YDUserFilesController.h"

@interface YDDynamicLikerViewController ()

@end

@implementation YDDynamicLikerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"点赞的人"];
    [self.tableView registerClass:[YDDynamicLikerCell class] forCellReuseIdentifier:@"YDDynamicLikerCell"];
    self.tableView.separatorColor = YDSeperatorColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.rowHeight = 53.f;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YDDynamicLikerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDDynamicLikerCell"];
    
    YDTapLikeModel *liker = [self.data objectAtIndex:indexPath.row];
    
    cell.model = liker;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YDTapLikeModel *liker = [self.data objectAtIndex:indexPath.row];
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:liker.ub_id];
    viewM.userName = liker.ub_nickname;
    viewM.userHeaderUrl = liker.ud_face;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    [self.navigationController pushViewController:userVC animated:YES];
}

@end

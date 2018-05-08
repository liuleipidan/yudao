//
//  YDPhoneContactsSearchResultController.m
//  YuDao
//
//  Created by 汪杰 on 17/3/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPhoneContactsSearchResultController.h"
#import "YDPhoneContactsCell.h"
#import "YDAddressBookManager.h"
#import "YDPhoneContactsController.h"
#import "YDUserFilesController.h"

@interface YDPhoneContactsSearchResultController ()<YDPhoneContactsCellDelegate>

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) YDAddressBookManager *adb;

@end

@implementation YDPhoneContactsSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 53.0f;
    [self.tableView registerClass:[YDPhoneContactsCell class] forCellReuseIdentifier:@"YDPhoneContactsCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"手机联系人";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDPhoneContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDPhoneContactsCell"];
    cell.model = self.data[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDContactsModel *model = self.data[indexPath.row];
    if (model.ub_id && model.ub_id.integerValue > 0) {
        //跳转到个人详情页面
        YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:model.ub_id];
        viewM.userName = model.nickName;
        viewM.userHeaderUrl = model.avatarURL;
        YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
        self.presentingViewController.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.presentingViewController.navigationController pushViewController:userVC animated:YES];
    }
}

#pragma mark - YDPhoneContactsCellDelegate
- (void)phoneContactsCell:(YDPhoneContactsCell *)cell touchedButton:(UIButton *)btn model:(YDContactsModel *)model{
    if ([btn.titleLabel.text isEqualToString:@"邀请加入"]) {
        [YDMBPTool showText:@"跳转中..."];
        if (!_adb) {
            _adb = [[YDAddressBookManager alloc] init];
        }
        [_adb showMessageViewInViewController:self phones:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",model.phoneNumber], nil] title:model.name body:@"【遇道好友邀请】每天都会遇到新鲜事，每天都会遇到好玩的人，邀请你一起来加入《遇道》，和我一起发现新的惊喜吧！！http://t.cn/RSpzJfc"];
    }else{
        [YDMBPTool showNoBackgroundViewInView:btn];
        [YDAddressBookManager addFriend:model finish:^(BOOL success, NSString *status) {
            if (success) {
                model.status = YDContactStatusWait;
                btn.backgroundColor = [UIColor clearColor];
                btn.layer.borderColor = [UIColor clearColor].CGColor;
                [btn setTitle:@"等待验证" forState:0];
                [btn setTitleColor:[UIColor lightGrayColor] forState:0];
                [YDMBPTool showText:status];
            }else{
                [YDMBPTool showText:@"发送失败"];
            }
        }];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.presentingViewController.view endEditing:YES];
    YDPhoneContactsController *fVC = (YDPhoneContactsController *)self.presentingViewController;
    [fVC.searchController.searchBar resignFirstResponder];
}

//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = [searchController.searchBar.text lowercaseString];
    NSString *format = [NSString stringWithFormat:@"name LIKE[cd] '*%@*'",searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    self.data = [self.dataSource filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

@end

//
//  YDPhoneContactsController.m
//  YuDao
//
//  Created by 汪杰 on 16/11/22.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDPhoneContactsController.h"
#import "YDContactsModel.h"
#import "YDPhoneContactsCell.h"
#import "YDPhoneContactsSearchResultController.h"
#import "YDContactHeaderView.h"
#import "YDAddressBookManager.h"
#import "YDUserFilesController.h"

#define kCheckContactsNotification @"kCheckContactsNotification"

@interface YDPhoneContactsController ()<UISearchBarDelegate,YDPhoneContactsCellDelegate>

@property (nonatomic, strong) YDPhoneContactsSearchResultController *resultController;

@property (nonatomic, strong) YDAddressBookManager *adbManager;

@end

@implementation YDPhoneContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机联系人";
    self.tableView.rowHeight = 53.0f;
    
    [self.tableView registerClass:[YDPhoneContactsCell class] forCellReuseIdentifier:@"YDPhoneContactsCell"];
    [self.tableView registerClass:[YDContactHeaderView class] forHeaderFooterViewReuseIdentifier:@"YDContactHeaderView"];
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.searchController.searchBar.height)];
        [view addSubview:self.searchController.searchBar];
        view;
    });;
    
    //适配UISearchController的动画效果
    self.definesPresentationContext = YES;
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    _adbManager = [[YDAddressBookManager alloc] init];
    
    YDProgressHUD *hud = [YDLoadingHUD showLoading];
    YDWeakSelf(self);
    [_adbManager getContactsFinish:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (granted) {
                [weakself.tableView reloadData];
                [weakself.adbManager uploadContactsString:^{
                    [weakself.tableView reloadData];
                }];
            }
            else{
                [hud hide];
                [UIAlertController YD_OK_AlertController:weakself title:@"请在iPhone的\"设置-隐私\"选项中允许遇道访问你的通讯录" clickBlock:^{
                    
                }];
            }
            weakself.resultController.dataSource = weakself.adbManager.dataSource;
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)dealloc{
    NSLog(@"dealloc");
}

#pragma mark - YDPhoneContactsCellDelegate
//点击添加好友或邀请加入
- (void)phoneContactsCell:(YDPhoneContactsCell *)cell touchedButton:(UIButton *)btn model:(YDContactsModel *)model{
    if ([btn.titleLabel.text isEqualToString:@"邀请加入"]) {
        [YDMBPTool showText:@"跳转中..."];
        [_adbManager showMessageViewInViewController:self phones:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",model.phoneNumber], nil] title:model.name body:@"【遇道好友邀请】每天都会遇到新鲜事，每天都会遇到好玩的人，邀请你一起来加入《遇道》，和我一起发现新的惊喜吧！！http://t.cn/RSpzJfc"];
    }
    else if ([btn.titleLabel.text isEqualToString:@"加为好友"]){
        [YDMBPTool showNoBackgroundViewInView:btn];
        [YDAddressBookManager addFriend:model finish:^(BOOL success, NSString *status) {
            if (success) {
                [btn setTitle:@"已发送" forState:0];
                [YDMBPTool showText:status];
                
                //将好友申请加入数据库
                [YDDBSendFriendRequestStore insertSenderFriendRequestSenderID:YDUser_id receiverID:model.ub_id];
            }else{
                [YDMBPTool showText:@"发送失败"];
            }
        }];
    }
}

#pragma mark - Private Methods

#pragma mark - UITableViewDataSource
//组标题数据源
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _adbManager.indexArr;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_adbManager.indexArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_adbManager.letterArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDPhoneContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDPhoneContactsCell"];
    YDContactsModel *model = [[_adbManager.letterArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
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
    YDContactHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YDContactHeaderView"];
    [view setTitle:[_adbManager.indexArr objectAtIndex:section]];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDContactsModel *model = [[_adbManager.letterArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    if (model.ub_id && model.ub_id.integerValue > 0) {
        //跳转到个人详情页面
        YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:model.ub_id];
        viewM.userName = model.nickName;
        viewM.userHeaderUrl = model.avatarURL;
        YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
        
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //限制第一个字符为通配符
    if (searchBar.text.length == 0 && [text isEqualToString:@"%"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Getter -
- (YDSearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[YDSearchController alloc] initWithSearchResultsController:self.resultController];
        [_searchController setSearchResultsUpdater:self.resultController];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}

- (YDPhoneContactsSearchResultController *)resultController{
    if (!_resultController) {
        _resultController = [[YDPhoneContactsSearchResultController alloc] init];
    }
    return _resultController;
}


@end

//
//  YDNewFriendController.m
//  YuDao
//
//  Created by 汪杰 on 17/1/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDNewFriendController.h"
#import "YDSearchController.h"
#import "YDAddFriendViewController.h"
#import "YDPhoneContactsController.h"
#import "YDNewFriendCell.h"
#import "YDUserFilesController.h"
#import "NSString+PinYin.h"
#import "YDNewFriendSearchResultController.h"

@interface YDNewFriendController ()<UISearchBarDelegate,YDNewFriendCellDelegate,YDPushMessageManagerDelegate>

@property (nonatomic, strong) UIView *tableheaderView;

@property (nonatomic, strong) YDSearchController *searchController;

@property (nonatomic, strong) YDNewFriendSearchResultController *resultController;

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation YDNewFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新的朋友";
    
    self.tableView.rowHeight = 53.f;
    [self.tableView registerClass:[YDNewFriendCell class] forCellReuseIdentifier:@"YDNewFriendCell"];
    [self.tableView setTableHeaderView:self.tableheaderView];
    [self.tableView setTableFooterView:[UIView new]];
    self.tableView.separatorColor = [UIColor whiteColor];
    
    //适配UISearchController的动画效果
    self.definesPresentationContext = YES;
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    
    UIBarButtonItem *rightBarItem = [UIBarButtonItem itemWithImage:@"mine_contacts_addfriend" target:self action:@selector(newFriendRightBarItemAction:)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    [self updateFriendsRequestData];
    
    [[YDPushMessageManager sharePushMessageManager] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [YDNotificationCenter addObserver:self selector:@selector(updateFriendsRequestData) name:@"YDNeedUpdateFriendRequest" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[YDPushMessageManager sharePushMessageManager] updateFriendRequestMessageToReadByUserid:[YDUserDefault defaultUser].user.ub_id];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)dealloc{
    [[YDPushMessageManager sharePushMessageManager] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)updateFriendsRequestData{
    YDWeakSelf(self);
    [[YDPushMessageManager sharePushMessageManager] getFriendRequestMessageByUserid:[YDUserDefault defaultUser].user.ub_id count:100 complete:^(NSArray *data, BOOL hasMore) {
        weakself.data = [NSMutableArray arrayWithArray:data];
        [weakself.tableView reloadData];
    }];
    
}

//点击右边添加好友
- (void)newFriendRightBarItemAction:(UIBarButtonItem *)item{
    [self.navigationController pushViewController:[YDAddFriendViewController new] animated:YES];
}

//点击手机联系人
- (void)tapPhoneContacts:(UITapGestureRecognizer *)tap{
    [self.navigationController pushViewController:[YDPhoneContactsController new] animated:YES];
}

#pragma mark - YDPushMessageManagerDelegate
- (void)receivedNewFriendRequest{
    NSLog(@"%s",__func__);
    [self updateFriendsRequestData];
    [[YDPushMessageManager sharePushMessageManager] updateFriendRequestMessageToReadByUserid:[YDUserDefault defaultUser].user.ub_id];
}

#pragma mark - YDNewFriendCellDelegate
- (void)newFriendCell:(YDNewFriendCell *)cell didSelectedBtn:(UIButton *)btn{
    YDPushMessage *message = cell.message;
    YDWeakSelf(self);
    if ([btn.titleLabel.text isEqualToString:@"接受"]) {
        [YDLoadingHUD showLoading];
        [YDNetworking POST:[kOriginalURL stringByAppendingString:@"addfriends"] parameters:@{@"access_token":YDAccess_token,@"f_ub_id":message.senderid,@"type":@1} success:^(NSNumber *code, NSString *status, id data) {
            NSLog(@"code = %@,status = %@,data = %@",code,status,data);
            if ([code isEqual:@200]) {
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
                }
            }
            else if ([code isEqual:@3015]){//已经是好友
                [YDMBPTool showText:@"已添加"];
                [[YDPushMessageManager sharePushMessageManager] updateFriendRequestMessageToAccptedByUserid:[YDUserDefault defaultUser].user.ub_id senderid:message.senderid];
            }
            else{
                [YDMBPTool showText:status];
            }
            [weakself updateFriendsRequestData];
        } failure:^(NSError *error) {
            NSLog(@"接受好友请求：error = %@",error);
            [YDMBPTool showText:@"添加失败"];
        }];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDNewFriendCell"];
    cell.delegate = self;
    cell.message = [self.data objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //跳转到个人详情页面
    YDPushMessage *message = self.data[indexPath.row];
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:message.senderid];
    viewM.userName = message.name;
    viewM.userHeaderUrl = message.avatar;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    [self.navigationController pushViewController:userVC animated:YES];
}
//实现左滑删除方法
//第一个参数：表格视图对象
//第二个参数：编辑表格的方式
//第三个参数：操作cell对应的位置
-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    //如果是删除
    if(editingStyle==UITableViewCellEditingStyleDelete){
        YDPushMessage *message = [self.data objectAtIndex:indexPath.row];
        [self.data removeObject:message];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [[YDPushMessageManager sharePushMessageManager] deleteFriendRequestByMsgid:message.msgid];
    }
}
//修改删除按钮为中文的删除
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath{
    return@"删除";
}

//是否允许编辑行，默认是YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UIView *)tableheaderView{
    if (!_tableheaderView) {
        _tableheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
        [_tableheaderView addSubview:self.searchController.searchBar];
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(50, 59, SCREEN_WIDTH-100, 100)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoneContacts:)];
        [tapView addGestureRecognizer:tap];
        [_tableheaderView addGestureRecognizer:tap];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_contacts_iphone"]];
        imageV.userInteractionEnabled = YES;
        imageV.frame = CGRectMake((SCREEN_WIDTH-26)/2, 60, 26, 34);
        [_tableheaderView addSubview:imageV];
        
        UILabel *label = [YDUIKit labelWithTextColor:[UIColor grayTextColor] text:@"添加手机联系人" fontSize:14 textAlignment:NSTextAlignmentCenter];
        label.frame = CGRectMake((SCREEN_WIDTH-100)/2, CGRectGetMaxY(imageV.frame)+10, 100, 21);
        label.userInteractionEnabled = YES;
        [_tableheaderView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 138, SCREEN_WIDTH, 20)];
        lineView.backgroundColor = [UIColor colorWithString:@"#EBEBEB"];
        
        [_tableheaderView addSubview:lineView];
    }
    return _tableheaderView;
}

- (YDSearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[YDSearchController alloc] initWithSearchResultsController:self.resultController];
        [_searchController setSearchResultsUpdater:self.resultController];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}

- (YDNewFriendSearchResultController *)resultController{
    if (!_resultController) {
        _resultController = [[YDNewFriendSearchResultController alloc] init];
    }
    return _resultController;
}


@end

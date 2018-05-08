//
//  YDDynamicMessagesController.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/30.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDynamicMessagesController.h"
#import "YDDynamicMessageCell.h"
#import "YDDynamicDetailsController.h"

@interface YDDynamicMessagesController ()

@property (nonatomic, strong) NSArray<YDDynamicMessage *> *messages;

@end

@implementation YDDynamicMessagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init UI
    [self.navigationItem setTitle:@"动态消息"];
    
    //init tableView
    [self.tableView registerClass:[YDDynamicMessageCell class] forCellReuseIdentifier:@"YDDynamicMessageCell"];
    [self.tableView setTableFooterView:[UIView new]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 70.f;
    
    //请求数据
    [self dm_requestDynamicMessages];
    
    //清空动态消息数量
    [[YDMineHelper sharedInstance] setDyMsgUnreadCount:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)dm_requestDynamicMessages{
    [YDLoadingHUD showLoadingInView:self.view];
    NSDictionary *param = @{
                            @"access_token":YDAccess_token
                            };
    [YDNetworking GET:kDynamicMessagesURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        if (data) {
            self.messages = [YDDynamicMessage mj_objectArrayWithKeyValuesArray:data];
            [self.tableView reloadData];
        }
        else{
            
        }
    } failure:^(NSError *error) {
        //超时
        if (error.code == -1001) {
            
        }
        else{//失败
        
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages ? self.messages.count : 0;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     YDDynamicMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDDynamicMessageCell"];
     if (indexPath.row < self.messages.count) {
         YDDynamicMessage *msg = [self.messages objectAtIndex:indexPath.row];
         
         [cell setMessage:msg];
     }
     return cell;
 }


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.messages.count) {
        YDUser *user = [YDUserDefault defaultUser].user;
        YDDynamicMessage *msg = [self.messages objectAtIndex:indexPath.row];
        YDDynamicDetailViewModel *dyViewModel = [[YDDynamicDetailViewModel alloc] initWithDyId:msg.d_id userId:user.ub_id userIcon:user.ud_face nickname:user.ub_nickname label:msg.d_label time:@""];
        [dyViewModel setScrollToLike:YES];
        YDDynamicDetailsController *detailVC = [[YDDynamicDetailsController alloc] initWithViewModel:dyViewModel];
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

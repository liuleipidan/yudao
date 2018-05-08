//
//  YDRankingListController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 16/12/13.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDTaskController+Delegate.h"
#import "YDPhoneContactsController.h"
#import "YDMineViewController.h"
#import "YDPopViewTool.h"
#import "YDAllDynamicController.h"
#import "YDSlipFaceController.h"

@implementation YDTaskController (Delegate)

#pragma mark - YDSystemMessageDelegate
- (void)systemMessagesHadFinishTask{
    [self requestUserTask];
}

#pragma mark - YDTaskViewDelegate
- (void)taskViewBeClicked:(YDTaskModel *)model{
    if (!model) {
        return;
    }
    CGFloat width = SCREEN_WIDTH-40;
    YDTaskDetailsView *taskView = [[YDTaskDetailsView alloc] initWithFrame:CGRectMake(0, 0, width, width * 0.466 + 226) delegate:self];
    [taskView setModel:model];
    [YDPopViewTool showWithContentView:taskView];
}

- (void)taskViewClickReloadButton:(UIButton *)sender{
    [self requestUserTask];
}

#pragma mark - YDTaskDetailsViewDelegate
- (void)taskDetailsReviewClickCancel{
    [YDPopViewTool dismissView];
}
- (void)taskDetailsReviewClickGO:(YDTaskModel *)model{
    [YDPopViewTool dismissView];
    [self performSelector:@selector(presentOrPopViewControllerBy:) withObject:model.t_id afterDelay:0.2f];
}

#pragma mark Private Method - 点击弹出视图，根据任务id跳转到相应界面
- (void)presentOrPopViewControllerBy:(NSNumber *)index{
    switch (index.integerValue) {
        case 1://跳入登录界面
        { 
            if (!YDHadLogin) {
               [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
            break;}
        case 2://上传并认证头像
        {
            if (YDHadLogin) {
                [[YDRootViewController sharedRootViewController] setSelectedIndex:3];
            }else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
            break;}
        case 3://完善个人资料
        {
            if (YDHadLogin) {
                [[YDRootViewController sharedRootViewController] setSelectedIndex:3];
                YDNavigationController *nav = [[YDRootViewController sharedRootViewController].childViewControllers objectAtIndex:3];
                [nav pushViewController:[NSClassFromString(@"YDMyInformationController") new] animated:YES];
            }else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
            break;}
        case 4://和她/他们打招呼--逛一逛
        {
            if (YDHadLogin) {
                [[YDRootViewController sharedRootViewController] setSelectedIndex:1];
                YDNavigationController *nav = [[YDRootViewController sharedRootViewController].childViewControllers objectAtIndex:1];
                [nav pushViewController:[[YDAllDynamicController alloc] init] animated:YES];
            }else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
            break;}
        case 5://比心->刷脸
        {
            if (YDHadLogin) {
                [[YDRootViewController sharedRootViewController] setSelectedIndex:1];
                YDNavigationController *nav = [[YDRootViewController sharedRootViewController].childViewControllers objectAtIndex:1];
                [nav pushViewController:[[YDSlipFaceController alloc] init] animated:YES];
            }else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
            break;}
        case 6://添加兴趣标签->兴趣
        {
            if (YDHadLogin) {
                [self.parentViewController.navigationController pushViewController:[NSClassFromString(@"YDInterestsController") new] animated:YES];
            }else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
            break;}
        case 7://结交5个好友->逛一逛
        {
            if (YDHadLogin) {
                [[YDRootViewController sharedRootViewController] setSelectedIndex:1];
                YDNavigationController *nav = [[YDRootViewController sharedRootViewController].childViewControllers objectAtIndex:1];
                [nav pushViewController:[[YDAllDynamicController alloc] init] animated:YES];
            }else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
            break;}
        case 8://发布一条新动态
        {
            if (YDHadLogin) {
                [self.parentViewController.navigationController presentViewController:[YDNavigationController createNaviByRootController:[NSClassFromString(@"YDPublishDynamicController") new]] animated:YES completion:nil];
            }
            else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
            break;}
        case 9://添加并认证你的爱车
        {
            if (YDHadLogin) {
                if (YDHadLogin) {
                    [[YDRootViewController sharedRootViewController] setSelectedIndex:3];
                    YDNavigationController *nav = [[YDRootViewController sharedRootViewController].childViewControllers objectAtIndex:3];
                    [nav pushViewController:[NSClassFromString(@"YDGarageViewController") new] animated:YES];
                }else{
                    [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
                }
            }else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
            break;}
        case 10://绑定VE-BOX
        {
            if (YDHadLogin) {
                [self.parentViewController.navigationController pushViewController:[NSClassFromString(@"YDBindDeviceIntroductionController") new] animated:YES];
            }else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
            break;}
        default:
            break;
    }
}

@end

//
//  YDMainSettingViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMainSettingViewController.h"
#import "YDSettingHelper.h"
#import "YDAboutUsViewController.h"
#import "YDUseProtocolViewController.h"
#import "YDFunctionSettingViewController.h"
#import "YDNewMessageSettingViewController.h"
#import "YDAdviseViewController.h"

#define kLogoutURL [kOriginalURL stringByAppendingString:@"logout"]

@interface YDMainSettingViewController ()

@property (nonatomic, strong) YDSettingHelper *helper;

@end

@implementation YDMainSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置"];
    
    self.helper = [[YDSettingHelper alloc] init];
    self.data = self.helper.mainSettingData;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YDSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"消息通知"]) {
        [self.navigationController pushViewController:[YDNewMessageSettingViewController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"功能设置"]){
        [self.navigationController pushViewController:[YDFunctionSettingViewController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"清除缓存"]){
        float cacheSize = [[SDWebImageManager sharedManager].imageCache getSize]/1000.f/1000.f;
        [UIAlertController YD_alertController:self title:@"遇道" subTitle:[NSString stringWithFormat:@"已占用%.2lfM缓存",cacheSize] items:@[@"立即清除"] style:UIAlertControllerStyleAlert clickBlock:^(NSInteger index) {
            if (index == 1) {
                [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
                    NSLog(@"清除缓存完成");
                }];
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
            }
        }];
    }
    else if ([item.title isEqualToString:@"意见反馈"]){
        [self.navigationController pushViewController:[YDAdviseViewController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"关于我们"]){
        [self.navigationController pushViewController:[YDAboutUsViewController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"用户使用协议"]){
        YDUseProtocolViewController *useProtocolVC = [[YDUseProtocolViewController alloc] init];
        [self.navigationController pushViewController:useProtocolVC animated:YES];
    }
    else if ([item.title isEqualToString:@"退出登录"]){
        [LPActionSheet showActionSheetWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。" cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
            if (index == -1) {
                [YDLoadingHUD showLoading];
                [YDNetworking postUrl:kLogoutURL parameters:@{@"access_token":YDAccess_token} success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    NSDictionary *originalDic = [responseObject mj_JSONObject];
                    YDLog(@"logout response = %@",originalDic);
                    NSLog(@"status_code = %@",[originalDic valueForKey:@"status_code"]);
                    [self presentViewController:[YDLoginViewController new] animated:YES completion:^{
                        [[YDUserDefault defaultUser] removeUser];
                    }];
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"error = %@",error);
                    [YDMBPTool showErrorImageWithMessage:@"退出失败" hideBlock:^{
                        
                    }];
                }];
            }
        }];
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


@end

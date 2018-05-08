//
//  YDNewMessageSettingViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDNewMessageSettingViewController.h"
#import "YDSettingHelper.h"

@interface YDNewMessageSettingViewController ()

@property (nonatomic, strong) YDSettingHelper *helper;

//存储初始化的设置
@property (nonatomic, strong) NSMutableArray<YDHPIgnoreModel *> *startModels;

//存储被改变的设置
@property (nonatomic, strong) NSMutableArray *endIndexs;

@end

@implementation YDNewMessageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"消息通知"];
    
    self.helper = [[YDSettingHelper alloc] init];
    self.data = self.helper.messageSettingData;
    
    _startModels = [NSMutableArray array];
    _endIndexs = [NSMutableArray array];
    for (YDSettingGroup *group in self.data) {
        for (YDSettingItem *item in group.items) {
            [_startModels addObject:item.ignoreModel];
            [_endIndexs addObject:item.ignoreModel.ignore_type];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //统一同步设置数据
    [_startModels enumerateObjectsUsingBlock:^(YDHPIgnoreModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *ignore_type = [self.endIndexs objectAtIndex:idx];
        if (![obj.ignore_type isEqual:ignore_type]) {
            if ([obj.ignore_type isEqual:@0]) {
                [YDSettingHelper deleteHPIgnoreBy:obj success:nil failure:nil];
            }
            else if ([obj.ignore_type isEqual:@2]){
                [YDSettingHelper addHPIgnoreByIgnoreModel:obj success:nil failure:nil];
            }
        }
    }];
}

#pragma mark - YDSettingSwitchCellDelegate
- (void)settingSwitchCell:(YDSettingSwitchCell *)cell item:(YDSettingItem *)item switchBtn:(UISwitch *)switchBtn{
    if (switchBtn.isOn) {
        item.ignoreModel.ignore_type = @0;
    }
    else{
        [LPActionSheet showActionSheetWithTitle:item.prompt cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认关闭" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
            if (index == -1) {
                item.ignoreModel.ignore_type = @2;
            }
            else{
                [switchBtn setOn:YES animated:YES];
            }
        }];
    }
//    if (switchBtn.isOn) {
//        [YDSettingHelper deleteHPIgnoreBy:item.ignoreModel success:^{
//            YDHPIgnoreStore *store = [YDHPIgnoreStore manager];
//            if ([store deleteHPIgnore:item.ignoreModel.rid userId:item.ignoreModel.uid]) {
//                NSLog(@"删除本地设置表成功");
//            }
//        } failure:^{
//            NSLog(@"打开失败");
//            cell.openDelegate = NO;
//            [switchBtn setOn:NO animated:YES];
//            cell.openDelegate = YES;
//            [YDMBPTool showInfoImageWithMessage:@"打开失败" hideBlock:^{
//                
//            }];
//        }];
//    }
//    else{
//        [LPActionSheet showActionSheetWithTitle:item.prompt cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认关闭" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
//            if (index == -1) {
//                //更新数据库
//                item.ignoreModel.ignore_type = @2;
//                [YDSettingHelper addHPIgnoreByIgnoreModel:item.ignoreModel success:^(YDHPIgnoreModel *model) {
//                    
//                } failure:^{
//                    cell.openDelegate = NO;
//                    [switchBtn setOn:YES animated:YES];
//                    cell.openDelegate = YES;
//                    [YDMBPTool showInfoImageWithMessage:@"关闭失败" hideBlock:^{
//                        
//                    }];
//                }];
//            }else{
//                cell.openDelegate = NO;
//                [switchBtn setOn:YES animated:YES];
//                cell.openDelegate = YES;
//            }
//        }];
//    }
}

@end

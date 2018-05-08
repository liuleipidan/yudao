//
//  YDMineViewController+CollectionView.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMineViewController+CollectionView.h"
#import "YDMyInformationController.h"
#import "YDDynamicMessagesController.h"
#import "YDConversationController.h"
#import "YDGarageViewController.h"
#import "YDContactsViewController.h"
#import "YDQRCodeController.h"
#import "YDMyOrdersViewController.h"
#import "YDCardPackageController.h"
#import "YDMainSettingViewController.h"
#import "YDVisitorsController.h"
#import "YDUserDynamicViewController.h"

@implementation YDMineViewController (CollectionView)

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mineHelper.mineMenuData.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YDMineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDMineCell" forIndexPath:indexPath];
    YDMineMenuItem *item = [self.mineHelper.mineMenuData objectAtIndex:indexPath.row];
    [cell setItem:item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YDMineMenuItem *item = [self.mineHelper.mineMenuData objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"个人资料"]) {
        [self.navigationController pushViewController:[YDMyInformationController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"我的动态"]){
        if (item.unredCount > 0) {
            [self.navigationController pushViewController:[YDDynamicMessagesController new] animated:YES];
        }else{
            [self.navigationController pushViewController:[YDUserDynamicViewController new] animated:YES];
        }
    }
    else if ([item.title isEqualToString:@"我的消息"]){
        [self.navigationController pushViewController:[YDConversationController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"我的车库"]){
        [self.navigationController pushViewController:[YDGarageViewController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"通讯录"]){
        [self.navigationController pushViewController:[YDContactsViewController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"我的二维码"]){
        [self.navigationController pushViewController:[YDQRCodeController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"我的订单"]){
        [self.navigationController pushViewController:[YDMyOrdersViewController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"我的卡包"]){
        [self.navigationController pushViewController:[YDCardPackageController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"系统设置"]){
        [self.navigationController pushViewController:[YDMainSettingViewController new] animated:YES];
    }
    else if ([item.title isEqualToString:@"最近访客"]){
        [self.navigationController pushViewController:[YDVisitorsController new] animated:YES];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kWidth(100), kHeight(80));
}
//整组缩进
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kHeight(15), 8, 0, 8);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//section头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 0);
}
//section尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

@end

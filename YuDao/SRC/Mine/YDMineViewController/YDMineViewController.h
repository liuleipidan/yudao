//
//  YDMineViewController.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDMineCell.h"
#import "YDMineHeaderBlurView.h"
#import "YDMineHelper.h"
#import "YDAvatarBrowser.h"
#import "YDImagePickerTool.h"

@interface YDMineViewController : YDViewController

@property (nonatomic, strong) YDMineHelper *mineHelper;

@property (nonatomic, strong) YDMineHeaderBlurView *headerView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) YDAvatarBrowser *avatarBrowser;

@property (nonatomic, strong) YDImagePickerTool *imagePickerTool;

@end

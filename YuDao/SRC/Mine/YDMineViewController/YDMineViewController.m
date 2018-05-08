//
//  YDMineViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMineViewController.h"
#import "YDMineViewController+CollectionView.h"
#import "YDMineViewController+Delegate.h"

@interface YDMineViewController ()



@end

@implementation YDMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(295));
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(-23);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-self.tabBarController.tabBar.height+8);
    }];
    
    YDWeakSelf(self);
    //未读消息数量改变回调
    [self.mineHelper setUnreadCountChanged:^{
        [weakself.collectionView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [_headerView setUserInfo:[YDUserDefault defaultUser].user];
    
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark Getters
- (YDMineHelper *)mineHelper{
    if (!_mineHelper) {
        _mineHelper = [YDMineHelper sharedInstance];
    }
    return _mineHelper;
}

- (YDMineHeaderBlurView *)headerView{
    if (_headerView == nil) {
        _headerView = [[YDMineHeaderBlurView alloc] initWithFrame:CGRectZero];
        [_headerView setDelegate:self];
    }
    return _headerView;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.layer.cornerRadius = 8.0f;
        _collectionView.layer.shadowOffset = CGSizeMake(0, 0);
        _collectionView.layer.shadowColor = [UIColor shadowColor].CGColor;
        _collectionView.layer.shadowOpacity = 1;
        //_collectionView.layer.shadowRadius = 8.0f;
        _collectionView.clipsToBounds = NO;
        
        [_collectionView registerClass:[YDMineCell class] forCellWithReuseIdentifier:@"YDMineCell"];
    }
    return _collectionView;
}

- (YDAvatarBrowser *)avatarBrowser{
    if (_avatarBrowser == nil) {
        _avatarBrowser = [[YDAvatarBrowser alloc] init];
        _avatarBrowser.delegate = self;
    }
    return _avatarBrowser;
}

- (YDImagePickerTool *)imagePickerTool{
    if (_imagePickerTool == nil) {
        _imagePickerTool = [[YDImagePickerTool alloc] initWithPresentingViewController:[YDRootViewController sharedRootViewController]];
    }
    return _imagePickerTool;
}

@end

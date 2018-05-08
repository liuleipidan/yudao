//
//  YDUserFilesController.h
//  YuDao
//
//  Created by 汪杰 on 16/12/29.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDUFHeaderView.h"
#import "YDDynamicsTableView.h"

#import "YDUserBaseInfoCell.h"
#import "YDUserBaseAuthCell.h"
#import "YDUserBaseInterestCell.h"
#import "YDUserFilesBottomView.h"

#import "YDUserInfoModel.h"
#import "YDUserFilesViewModel.h"

#import "YDSingleImageBrowserController.h"
#import "YDSLBInteractiveTransition.h"
#import "YDPictureBrowse.h"

@interface YDUserFilesController : UIViewController
{
    YDUserFilesViewModel *_viewModel;
}
@property (nonatomic, strong) YDUserFilesViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YDDynamicsTableView *dynamicTable;

@property (nonatomic, strong) YDUFHeaderView *headerView;

@property (nonatomic, strong) UIView       *scrollBackView;

@property (nonatomic, strong) YDUserFilesBottomView *bottomView;

//当前用户信息
@property (nonatomic, strong) YDUserInfoModel *userInfo;

@property (nonatomic, strong) NSMutableArray *userInfoArray;

@property (nonatomic, strong) NSArray *f_tags;;

@property (nonatomic, strong) YDPictureBrowseInteractiveAnimatedTransition *animatedTransition;

- (instancetype)initWithViewModel:(YDUserFilesViewModel *)model;

@end

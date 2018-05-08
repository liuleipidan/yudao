//
//  YDMyInformationController.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/18.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDMyInfoHelper.h"
#import "YDMyInfoCell.h"
#import "YDMyTextFieldCell.h"
#import "YDMyInfoAvatarCell.h"

#import "YDImagePickerTool.h"
#import "YDDatePickerTool.h"
#import "YDTitlePickerTool.h"

#import "YDInterestsController.h"

@interface YDMyInformationController : YDViewController

@property (nonatomic, strong) YDMyInfoHelper *myInfo;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *authButton;

@property (nonatomic, strong) YDImagePickerTool *imagePickerTool;

@property (nonatomic, strong) YDDatePickerTool *datePickerTool;

@property (nonatomic, strong) YDTitlePickerTool *titlePickerTool;

@property (nonatomic, strong) YDInterestsController *interestsVC;

- (void)reloadTempUserInformation;

- (void)checkTempUserInformation:(YDUser *)user
                          avatar:(UIImage *)image
             tableViewNeedReload:(BOOL )reload;

@end

//
//  YDMyInformationController.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/18.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMyInformationController.h"
#import "YDMyInformationController+Delegate.h"
#import "YDPersonalAuthController.h"

@interface YDMyInformationController ()

@end

@implementation YDMyInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UI
    [self.navigationItem setTitle:@"个人资料"];
    UIBarButtonItem *comletionItem =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(mic_completionBarButtonItemAction:)];
    comletionItem.enabled = NO;
    [self.navigationItem setRightBarButtonItem:comletionItem];
    
    //TableView
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.authButton];
    [self mic_registerCells];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.size.mas_equalTo(CGSizeMake(kWidth(309),kHeight(44)));
        CGFloat bottomOffset = SCREEN_HEIGHT - (STATUSBAR_HEIGHT + NAVBAR_HEIGHT) - 27;
        make.bottom.equalTo(self.tableView).offset(IS_IPHONE5 ? bottomOffset + 10 : bottomOffset);
    }];
    
    //Data
    _myInfo = [[YDMyInfoHelper alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.authButton setTitle:[YDUserDefault defaultUser].user.authString forState:0];
}


- (void)reloadTempUserInformation{
    [self.myInfo reloadUserInfo:self.myInfo.tempUserInfo avatar:nil];
    [self.tableView reloadData];
}

- (void)checkTempUserInformation:(YDUser *)user
                          avatar:(UIImage *)image
             tableViewNeedReload:(BOOL )reload{
    
    YDUser *originalUser = [YDUserDefault defaultUser].user;
    BOOL isEqual = [self.myInfo.tempUserInfo compareUserCanChangeInformation:originalUser];
    if (isEqual && image == nil) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    else{
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    
    [self.myInfo reloadUserInfo:self.myInfo.tempUserInfo avatar:image];
    if (reload) {
        [self.tableView reloadData];
    }
}

#pragma mark - Events
- (void)mic_completionBarButtonItemAction:(UIBarButtonItem *)item{
    
    [YDLoadingHUD showLoading];
    YDMyInfoItem *avatarItem = [self.myInfo.data objectAtIndex:0];
    if (avatarItem.avatarImage) {
        [YDNetworking uploadImage:avatarItem.avatarImage url:kUploadUserHeaderImageURL success:^(NSString *imageUrl) {
            self.myInfo.tempUserInfo.ud_face = imageUrl;
            YDUser *user = [YDUserDefault defaultUser].user;
            user.ud_face = YDNoNilString(imageUrl);
            [YDUserDefault defaultUser].user = user;
            //如除头像以外有其他信息修改，一起同步到服务器
            if (![self.myInfo.tempUserInfo compareUserCanChangeInformation:[YDUserDefault defaultUser].user]) {
                [[YDUserDefault defaultUser] uploadUser:self.myInfo.tempUserInfo success:^{
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^{
                    [YDMBPTool showText:@"修改失败"];
                }];
            }
            else{
                self.navigationItem.rightBarButtonItem.enabled = NO;
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^{
            [YDMBPTool showText:@"修改失败"];
        }];
    }
    else{
        [[YDUserDefault defaultUser] uploadUser:self.myInfo.tempUserInfo success:^{
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^{
            [YDMBPTool showText:@"修改失败"];
        }];
    }
}

- (void)mic_authButtonAction:(UIButton *)sender{
    [self.navigationController pushViewController:[YDPersonalAuthController new] animated:YES];
}

#pragma mark - Getters
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.separatorColor = [UIColor whiteColor];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setTableFooterView:[UIView new]];
    }
    return _tableView;
}

- (UIButton *)authButton{
    if (_authButton == nil) {
        _authButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _authButton.backgroundColor = [UIColor baseColor];
        _authButton.layer.cornerRadius = 8.0f;
        [_authButton setTitleColor:[UIColor whiteColor] forState:0];
        [_authButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_authButton.titleLabel setFont:[UIFont font_16]];
        [_authButton addTarget:self action:@selector(mic_authButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authButton;
}

- (YDImagePickerTool *)imagePickerTool{
    if (_imagePickerTool == nil) {
        _imagePickerTool = [[YDImagePickerTool alloc] initWithPresentingViewController:self];
    }
    return _imagePickerTool;
}

- (YDDatePickerTool *)datePickerTool{
    if (_datePickerTool == nil) {
        _datePickerTool = [[YDDatePickerTool alloc] init];
    }
    return _datePickerTool;
}

- (YDTitlePickerTool *)titlePickerTool{
    if (_titlePickerTool == nil) {
        _titlePickerTool = [[YDTitlePickerTool alloc] init];
    }
    return _titlePickerTool;
}

- (YDInterestsController *)interestsVC{
    if (!_interestsVC) {
        _interestsVC = [[YDInterestsController alloc] init];
        _interestsVC.delegate = self;
    }
    return _interestsVC;
}

@end

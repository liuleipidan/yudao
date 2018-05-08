//
//  YDRegisterController.m
//  YuDao
//
//  Created by 汪杰 on 16/11/17.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDRegisterController.h"
#import "YDRootViewController.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "YDLoginInputView.h"
#import "YDThirdLoginView.h"
#import <ShareSDK/ShareSDK.h>
#import "YDHypeTextView.h"
#import "YDBindThirdPlatformController.h"
#import "YDUseProtocolViewController.h"

#define kRegisterURL [kOriginalURL stringByAppendingString:@"registerrun"]

@interface YDRegisterController ()<UITextFieldDelegate,YDLoginInputViewDelegate,YDThirdLoginViewDelegate>

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) YDLoginInputView *accountView;
@property (nonatomic, strong) YDLoginInputView *passwordView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) YDThirdLoginView *tlView;

@property (nonatomic, strong) YDHypeTextView *protocolView;

@property (nonatomic, strong) YDUseProtocolViewController *useProtocolVC;

@end

@implementation YDRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rgc_initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.view endEditing:YES];
}

- (void)rgc_initUI{
    [self.navigationItem setTitle:@"注册"];
    
    [self.view sd_addSubviews:@[self.titleImageView,self.accountView,self.passwordView,self.registerButton,self.cancelButton,self.tlView]];
    
    UITapGestureRecognizer *tapV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView)];
    [self.view addGestureRecognizer:tapV];
    
    [self initHypeTextView];
    [self y_layoutSubviews];
    
}
//初始化超链接视图
- (void)initHypeTextView{
    _protocolView = [[YDHypeTextView alloc] init];
    YDWeakSelf(self);
    [_protocolView setTapHypeTextBlock:^{
        if (!weakself.useProtocolVC) {
            weakself.useProtocolVC = [[YDUseProtocolViewController alloc] init];
        }
        
        YDNavigationController *navi = [[YDNavigationController alloc] initWithRootViewController:weakself.useProtocolVC];
        weakself.useProtocolVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back_image"] style:UIBarButtonItemStylePlain target:weakself action:@selector(clickProtocolBackItem)];
        [weakself presentViewController:navi animated:YES completion:nil];
        
    }];
    [_protocolView setCheckStatusChangeBlock:^(BOOL selected){
        weakself.registerButton.enabled = selected;
        weakself.registerButton.backgroundColor = selected ? YDBaseColor : [UIColor lightGrayColor];
    }];
    
    [self.view addSubview:_protocolView];
}
//点击协议的返回按钮
- (void)clickProtocolBackItem{
    [_useProtocolVC dismissViewControllerAnimated:YES completion:nil];
    _useProtocolVC = nil;
}

//MARK:Event
- (void)tapBackView{
    [self.view endEditing:YES];
}

- (void)setAccount:(NSString *)account{
    _account = account;
    self.accountView.textF.text = account;
    self.passwordView.phoneNumber = account;//用于获取验证码
}

#pragma mark - YDLoginInputViewDelegate
- (void)loginInputView:(YDLoginInputView *)inView didSelectedVariableBtnWithBackCode:(NSNumber *)code{
    NSLog(@"code = %@",code);
    if ([code isEqual:@4005]) {
        
    }
}

#pragma mark - YDThirdLoginViewDelegate - 第三方登录
- (void)thirdLoginView:(YDThirdLoginView *)view didSelectedPlatform:(YDThirdLoginPlatformType )platform{
    SSDKPlatformType type;
    switch (platform) {
        case YDThirdLoginPlatformTypeWechat: type = SSDKPlatformTypeWechat; break;
        case YDThirdLoginPlatformTypeQQ: type = SSDKPlatformTypeQQ; break;
        case YDThirdLoginPlatformTypeWebo: type = SSDKPlatformTypeSinaWeibo; break;
        default: type = SSDKPlatformTypeUnknown; break;
    }
    if (type != SSDKPlatformTypeUnknown) {
        [YDLoadingHUD showLoading];
        [YDShareManager thirdPlatformLoginBy:type success:^(SSDKUser *user, id data) {
            
            if (data) {
                //保存用户信息
                [[YDUserDefault defaultUser] saveUserInfo:data];
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }else{
                YDBindThirdPlatformController *btpVC = [YDBindThirdPlatformController new];
                btpVC.presentingVC = @2;
                btpVC.platformType = @(platform);
                btpVC.tpUid = user.uid;
                btpVC.tpIcon = user.icon;
                btpVC.tpNickName = user.nickname;
                btpVC.tpSex = user.gender==SSDKGenderFemale?@2:@1;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:btpVC];
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
            }
        } failure:^{
           
        }];
    }
}

- (void)cancelButtonAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//MARK:注册按钮
- (void)registerBtnAction:(UIButton *)sender{
    
    if (self.accountView.textF.text.length < 11) {
        [YDMBPTool showInfoImageWithMessage:@"手机号输入错误" hideBlock:nil];
        return;
    }
    if (self.passwordView.textF.text.length != 4) {
        [YDMBPTool showInfoImageWithMessage:@"验证码输入错误" hideBlock:nil];
        return;
    }
    
    [YDLoadingHUD showLoading];
    [self.view endEditing:YES];
    NSMutableDictionary *registerPra = [NSMutableDictionary dictionaryWithDictionary:@{@"ub_cellphone":self.accountView.textF.text,@"code":self.passwordView.textF.text}];
    
    NSString *jPushID = nil;
    jPushID = [YDStandardUserDefaults valueForKey:kRegistrationID] ? [YDStandardUserDefaults valueForKey:kRegistrationID] :[JPUSHService registrationID];
    if (jPushID) {
        [registerPra setValue:jPushID forKey:@"registration_id"];
        [registerPra setValue:@2 forKey:@"source"];
    }
    [YDNetworking POST:kRegisterURL parameters:registerPra success:^(NSNumber *code, NSString *status, id data) {
        YDLog(@"data = %@",data);
        if ([code isEqual:@200]) {//注册成功
            //保存用户信息
            [[YDUserDefault defaultUser] saveUserInfo:data];
            
            [YDNotificationCenter postNotificationName:kService_UserLoginNotification object:nil];
            //绑定用户与极光推送的id
            //绑定用户与极光推送的id
            NSString *jPushID = nil;
            jPushID = [YDStandardUserDefaults valueForKey:kRegistrationID] ? [YDStandardUserDefaults valueForKey:kRegistrationID] :[JPUSHService registrationID];
            if (jPushID) {
                NSDictionary *bindJPDic = @{ @"access_token":YDAccess_token,
                                             @"source":@2,
                                             @"registration_id":YDNoNilString(jPushID)};
                [YDNetworking uploadJpushRegisterID:bindJPDic];
            }
            
            [YDMBPTool showSuccessImageWithMessage:@"注册成功" hideBlock:^{
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }else{
            [YDMBPTool showErrorImageWithMessage:status hideBlock:nil];
        }
    } failure:^(NSError *error) {
        [YDMBPTool showErrorImageWithMessage:@"注册失败" hideBlock:nil];
    }];
}

//MARK:Layout
- (void)y_layoutSubviews{
    
    [_tlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_registerButton);
        make.height.mas_equalTo(77);
        make.top.equalTo(_registerButton.mas_bottom).offset(IS_IPHONE5?50:kHeight(91));
    }];
    
    [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH);
        make.bottom.equalTo(self.view).offset(-kHeight(30));
    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length > 0) {
        string = [textField.text stringByAppendingString:string];
    }else{
        string = [textField.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
    }
    
    if ([string length] == 4) {
        textField.text = string;
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Gettes
- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_title"]];
        _titleImageView.frame = CGRectMake((SCREEN_WIDTH-kWidth(80))/2, 80, kWidth(80), kWidth(80));
    }
    return _titleImageView;
}
- (YDLoginInputView *)accountView{
    if (!_accountView) {
        _accountView = [[YDLoginInputView alloc] initWithType:YDLoginInputViewTypeRegister subType:YDLoginInputViewSubTypePhone];
        _accountView.frame = CGRectMake((SCREEN_WIDTH - kWidth(295))/2, CGRectGetMaxY(self.titleImageView.frame)+48, kWidth(295), 40);
        _accountView.dataDic = @{@"label":@"帐号",@"image":@"login_account"};
    }
    return _accountView;
}
- (YDLoginInputView *)passwordView{
    if (!_passwordView) {
        _passwordView = [[YDLoginInputView alloc] initWithType:YDLoginInputViewTypeRegister subType:YDLoginInputViewSubTypePassword];
        _passwordView.frame = CGRectMake((SCREEN_WIDTH - kWidth(295))/2, CGRectGetMaxY(self.accountView.frame)+25, kWidth(295), 40);
        _passwordView.dataDic = @{@"label":@"密码",@"image":@"login_password"};
        _passwordView.delegate = self;
    }
    return _passwordView;
}

- (UIButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [UIButton new];
        _registerButton.frame = CGRectMake((SCREEN_WIDTH-kWidth(295))/2, CGRectGetMaxY(self.passwordView.frame)+kHeight(53), kWidth(295), kHeight(46));
        [_registerButton setBackgroundColor:YDBaseColor];
        [_registerButton setTitle:@"注 册" forState:0];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:0];
        [_registerButton.titleLabel setFont:kFont(20)];
        _registerButton.layer.cornerRadius = 8.f;
        _registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [_registerButton addTarget:self action:@selector(registerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:@"login_back" imageHL:@"login_back"];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_cancelButton setTitleColor:YDBaseColor forState:0];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.frame = CGRectMake(10, 40, 30, 30);
    }
    return _cancelButton;
}

- (YDThirdLoginView *)tlView{
    if (!_tlView) {
        _tlView = [[YDThirdLoginView alloc] init];
        _tlView.delegate = self;
        
    }
    return _tlView;
}

@end

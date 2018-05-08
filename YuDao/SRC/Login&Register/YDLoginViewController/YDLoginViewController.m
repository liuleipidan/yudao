//
//  YDLoginViewController.m
//  YuDao
//
//  Created by 汪杰 on 16/10/11.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDLoginViewController.h"
#import "YDLoginInputView.h"
#import "YDRegisterController.h"
#import "JPUSHService.h"
#import "YDThirdLoginView.h"
#import "YDBindThirdPlatformController.h"
@interface YDLoginViewController ()<UITextFieldDelegate,YDLoginInputViewDelegate,YDThirdLoginViewDelegate>

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) YDLoginInputView *accountView;
@property (nonatomic, strong) YDLoginInputView *passwordView;

@property (nonatomic, strong) UILabel *companyLabel;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UILabel *registerLabel;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) YDThirdLoginView *tlView;

@end

@implementation YDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lvc_initUI];
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

- (void)lvc_initUI{
    [self.navigationItem setTitle:@"登录"];
    
    [self.view sd_addSubviews:@[self.titleImageView,self.accountView,self.passwordView,self.loginButton,self.registerLabel,self.tlView,self.cancelButton,self.companyLabel]];
    
    UITapGestureRecognizer *tapV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView)];
    [self.view addGestureRecognizer:tapV];
    
    [self y_layoutSubviews];
}

//MARK:Event
- (void)tapBackView{
    [self.view endEditing:YES];
}
- (void)registerBtnAction:(UIButton *)sender{
    [self presentViewController:[YDRegisterController new]  animated:YES completion:^{
        
    }];
}
//取消按钮
- (void)cancelButtonAction:(UIButton *)sender{
    [[YDUserDefault defaultUser].delegate defaultUserCancelLogin];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setAccount:(NSString *)account{
    _account = account;
    self.accountView.textF.text = account;
}

#pragma mark - YDLoginInputViewDelegate
- (void)loginInputView:(YDLoginInputView *)inView didSelectedVariableBtnWithBackCode:(NSNumber *)code{
    NSLog(@"code = %@",code);
    if ([code isEqual:@4003]) {
        YDRegisterController *registerVC = [YDRegisterController new];
        registerVC.account = self.accountView.textF.text;
        [self presentViewController:registerVC  animated:YES completion:^{
            
        }];
    }
}

//MARK:登录
- (void)loginBtnAction:(UIButton *)sender{

    if (self.accountView.textF.text.length < 11) {
        [YDMBPTool showInfoImageWithMessage:@"手机号输入错误" hideBlock:nil];
        return;
    }
    if (self.passwordView.textF.text.length != 4) {
        [YDMBPTool showInfoImageWithMessage:@"验证码输入错误" hideBlock:nil];
        return;
    }
    
    [YDLoadingHUD showLoadingInView:self.view];
    [self.view endEditing:YES];
    //上传用户registerID（极光推送对应id）
    NSString *jPushID = [YDStandardUserDefaults valueForKey:kRegistrationID] ? [YDStandardUserDefaults valueForKey:kRegistrationID] :[JPUSHService registrationID];
    NSDictionary *para = @{@"ub_cellphone":self.accountView.textF.text,
                           @"code":self.passwordView.textF.text,
                           @"source":@2,
                           @"registration_id":YDNoNilString(jPushID)};
    [YDNetworking POST:kLoginURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {//登录成功
            //保存用户信息
            [[YDUserDefault defaultUser] saveUserInfo:data];
            
            [YDNotificationCenter postNotificationName:kService_UserLoginNotification object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [YDMBPTool showInfoImageWithMessage:status hideBlock:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}


//MARK:Layout
- (void)y_layoutSubviews{
    [_registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_loginButton);
        make.size.mas_equalTo(CGSizeMake(150, 18));
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(21);
    }];
    [_tlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_loginButton);
        make.height.mas_equalTo(77);
    }];
    [_registerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom).offset(6);
    }];
    [_companyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-kHeight(30));
    }];
    [_tlView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom).offset(IS_IPHONE5?50:kHeight(91));
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
        [YDShareManager thirdPlatformLoginBy:type success:^(SSDKUser *user, id data) {
            
            if (data) {
                //保存用户信息
                [[YDUserDefault defaultUser] saveUserInfo:data];

                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                YDBindThirdPlatformController *btpVC = [YDBindThirdPlatformController new];
                btpVC.presentingVC = @1;
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

#pragma mark - Getters
- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_title"]];
        _titleImageView.frame = CGRectMake((SCREEN_WIDTH-kWidth(80))/2, 80, kWidth(80), kWidth(80));
    }
    return _titleImageView;
}
- (YDLoginInputView *)accountView{
    if (!_accountView) {
        _accountView = [[YDLoginInputView alloc] initWithType:YDLoginInputViewTypeLogin subType:YDLoginInputViewSubTypePhone];
        _accountView.frame = CGRectMake((SCREEN_WIDTH - kWidth(295))/2, CGRectGetMaxY(self.titleImageView.frame)+48, kWidth(295), 40);
        _accountView.dataDic = @{@"label":@"帐号",@"image":@"login_account"};
    }
    return _accountView;
}
- (YDLoginInputView *)passwordView{
    if (!_passwordView) {
        _passwordView = [[YDLoginInputView alloc] initWithType:YDLoginInputViewTypeLogin subType:YDLoginInputViewSubTypePassword];
        _passwordView.frame = CGRectMake((SCREEN_WIDTH - kWidth(295))/2, CGRectGetMaxY(self.accountView.frame)+25, kWidth(295), 40);
        _passwordView.dataDic = @{@"label":@"密码",@"image":@"login_password"};
        _passwordView.delegate = self;
    }
    return _passwordView;
}

- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton new];
        _loginButton.frame = CGRectMake((SCREEN_WIDTH-kWidth(295))/2, CGRectGetMaxY(self.passwordView.frame)+kHeight(53), kWidth(295), kHeight(46));
        [_loginButton setBackgroundColor:YDBaseColor];
        [_loginButton setTitle:@"登 录" forState:0];
        [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:0];
        [_loginButton.titleLabel setFont:kFont(20)];
        _loginButton.layer.cornerRadius = 8.f;
        
        [_loginButton addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UILabel *)registerLabel{
    if (!_registerLabel) {
        _registerLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:kFontSize(13) textAlignment:NSTextAlignmentRight];
        
        [_registerLabel setText:@"快速注册"];
        _registerLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerBtnAction:)];
        [_registerLabel addGestureRecognizer:tap];
    }
    return _registerLabel;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_cancelButton setImage:@"login_cancel" imageHL:@"login_cancel"];
        [_cancelButton setTitleColor:YDBaseColor forState:0];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.frame = CGRectMake(10, 40, 30, 30);
    }
    return _cancelButton;
}

- (UILabel *)companyLabel{
    if (!_companyLabel) {
        _companyLabel = [YDUIKit labelWithTextColor:YDBaseColor text:@"驭联智能科技发展（上海）有限公司" fontSize:kFontSize(13) textAlignment:NSTextAlignmentCenter];
    }
    return _companyLabel;
}

- (YDThirdLoginView *)tlView{
    if (!_tlView) {
        _tlView = [[YDThirdLoginView alloc] init];
        _tlView.delegate = self;
    }
    return _tlView;
}


@end

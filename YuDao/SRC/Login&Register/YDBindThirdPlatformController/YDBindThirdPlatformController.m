//
//  YDBindThirdPlatformController.m
//  YuDao
//
//  Created by 汪杰 on 2017/5/23.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBindThirdPlatformController.h"
#import "YDLoginInputView.h"
#import "JPUSHService.h"
#import "YDUseProtocolViewController.h"
#import "YDHypeTextView.h"

@interface YDBindThirdPlatformController ()<YDLoginInputViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) YDLoginInputView *accountView;
@property (nonatomic, strong) YDLoginInputView *passwordView;

@property (nonatomic, strong) YDHypeTextView *protocolView;
@property (nonatomic, strong) YDUseProtocolViewController *useProtocolVC;

@property (nonatomic, strong) UIButton *bindBtn;

@end

@implementation YDBindThirdPlatformController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机号绑定";
    
    [self.view sd_addSubviews:@[self.titleLabel,self.accountView,self.passwordView,self.bindBtn]];
    [self initHypeTextView];
    
    [self.navigationController.navigationBar setTintColor:[UIColor baseColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem itemWithImage:@"login_cancel" target:self action:@selector(btpLeftItemAction:)]];
    
    UITapGestureRecognizer *tapV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView)];
    [self.view addGestureRecognizer:tapV];
}

- (void)tapBackView{
    [self.view endEditing:YES];
}

//MARK:绑定
- (void)btpLeftItemAction:(UIBarButtonItem *)item{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - YDLoginInputViewDelegate
- (void)loginInputView:(YDLoginInputView *)inView didSelectedVariableBtnWithBackCode:(NSNumber *)code{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
#pragma clang diagnostic pop
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
#pragma clang diagnostic pop
    
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
        weakself.bindBtn.enabled = selected;
        weakself.bindBtn.backgroundColor = selected ? YDBaseColor : [UIColor lightGrayColor];
    }];
    
    [self.view addSubview:_protocolView];
    [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-29);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH);
    }];
}
//点击协议的返回按钮
- (void)clickProtocolBackItem{
    [_useProtocolVC dismissViewControllerAnimated:YES completion:nil];
    _useProtocolVC = nil;
}

//点击绑定
- (void)bindBtnAction:(UIButton *)sender{
    if (self.accountView.textF.text.length < 11) {
        [YDMBPTool showInfoImageWithMessage:@"手机号输入错误" hideBlock:nil];
        return;
    }
    if (self.passwordView.textF.text.length != 4) {
        [YDMBPTool showInfoImageWithMessage:@"验证码输入错误" hideBlock:nil];
        return;
    }
    [self.view endEditing:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.tpUid forKey:@"esmark"];
    [param setValue:self.accountView.textF.text forKey:@"ub_cellphone"];
    [param setValue:self.passwordView.textF.text forKey:@"code"];
    [param setValue:self.platformType forKey:@"esource"];
    if (self.tpNickName) {
        [param setValue:self.tpNickName forKey:@"esname"];
    }
    if (self.tpSex) {
        [param setValue:self.tpSex forKey:@"esex"];
    }
    if (self.tpIcon) {
        [param setValue:self.tpIcon forKey:@"eface"];
    }
    [param setValue:@2 forKey:@"source"];
    NSString *jPushID = [YDStandardUserDefaults valueForKey:kRegistrationID] ? [YDStandardUserDefaults valueForKey:kRegistrationID] :[JPUSHService registrationID];;
    [param setValue:YDNoNilString(jPushID) forKey:@"registration_id"];
    YDLog(@"绑定手机号parameters = %@",param);
    [YDLoadingHUD showLoadingInView:self.view];
    [YDNetworking POST:kBindThirdPlatformURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        
        if ([code isEqual:@200] && data) {
            //保存用户信息
            [[YDUserDefault defaultUser] saveUserInfo:data];
            [self uploadThirdPlatformAvatar:self.tpIcon];
            [YDNotificationCenter postNotificationName:kService_UserLoginNotification object:nil];
            [YDMBPTool showSuccessImageWithMessage:@"绑定成功" hideBlock:^{
                if ([self.presentingVC isEqual:@2]) {
                    [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }else{
            [YDMBPTool showErrorImageWithMessage:status hideBlock:^{
                
            }];
        }
    } failure:^(NSError *error) {
        [YDMBPTool showErrorImageWithMessage:@"绑定失败" hideBlock:^{
            
        }];
    }];
    
}

/**
 上传第三方平台头像

 @param avatarURL 第三方平台头像路径
 */
- (void)uploadThirdPlatformAvatar:(NSString *)avatarURL{
    if (avatarURL.length > 0) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:YDURL(avatarURL) options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                [YDNetworking uploadImage:image url:kUploadUserHeaderImageURL success:^(NSString *imageUrl) {
                    [YDLoadingHUD hide];
                    YDUser *user = [YDUserDefault defaultUser].user;
                    user.ud_face = YDNoNilString(imageUrl);
                    [YDUserDefault defaultUser].user = user;
                } failure:^{
                    
                }];
            }
        }];
    }
}


#pragma mark - YDLoginInputViewDelegate
- (void)loginInputView:(YDLoginInputView *)inView getPassword:(UIButton *)btn{
    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YDUIKit labelWithTextColor:[UIColor whiteColor] text:@"为了您的账户安全，请绑定手机号~" fontSize:12 textAlignment:NSTextAlignmentCenter];
        _titleLabel.backgroundColor  = YDBaseColor;
        _titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 26);
    }
    return _titleLabel;
}

- (YDLoginInputView *)accountView{
    if (!_accountView) {
        _accountView = [[YDLoginInputView alloc] initWithType:YDLoginInputViewTypeLogin subType:YDLoginInputViewSubTypePhone];
        _accountView.frame = CGRectMake((SCREEN_WIDTH - kWidth(295))/2, CGRectGetMaxY(self.titleLabel.frame)+58, kWidth(295), 40);
        _accountView.dataDic = @{@"label":@"帐号",@"image":@"login_account"};
    }
    return _accountView;
}
- (YDLoginInputView *)passwordView{
    if (!_passwordView) {
        _passwordView = [[YDLoginInputView alloc] initWithType:YDLoginInputViewTypeBindThirdPlatform subType:YDLoginInputViewSubTypePassword];
        _passwordView.frame = CGRectMake((SCREEN_WIDTH - kWidth(295))/2, CGRectGetMaxY(self.accountView.frame)+25, kWidth(295), 40);
        _passwordView.dataDic = @{@"label":@"密码",@"image":@"login_password"};
        _passwordView.delegate = self;
    }
    return _passwordView;
}

- (UIButton *)bindBtn{
    if (!_bindBtn) {
        _bindBtn = [UIButton new];
        _bindBtn.frame = CGRectMake((SCREEN_WIDTH-kWidth(295))/2, CGRectGetMaxY(self.passwordView.frame)+kHeight(49), kWidth(295), kHeight(46));
        [_bindBtn setBackgroundColor:YDBaseColor];
        [_bindBtn setTitle:@"绑 定" forState:0];
        [_bindBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_bindBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_bindBtn.titleLabel setFont:kFont(20)];
        _bindBtn.layer.cornerRadius = 8.f;
        
        [_bindBtn addTarget:self action:@selector(bindBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindBtn;
}

@end

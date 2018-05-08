//
//  YDUnbindOBDController.m
//  YuDao
//
//  Created by 汪杰 on 17/2/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDUnbindOBDController.h"
#import "YDGarageViewController.h"

//解绑OBD
#define kUnbindOBDURL [kOriginalURL stringByAppendingString:@"delebound"]

@interface YDUnbindOBDController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *subTitles;

@end

@implementation YDUnbindOBDController
{
    UIButton    *_getCodeBtn;
    NSTimer     *_timer;
    NSInteger   _time;
    UITextField  *_textField;
    NSString    *_phoneNumber;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"解除绑定";
    self.tableView.rowHeight = 55;
    self.tableView.delaysContentTouches = NO;
    self.tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel *label = [YDUIKit labelWithTextColor:[UIColor blackColor] numberOfLines:2 text:@"解除绑定后，您讲无法通过遇道获取车况信息，出行服务等功能！请谨慎操作。" fontSize:14];
        label.frame = CGRectMake(20, 10, SCREEN_WIDTH-40, 50);
        [view addSubview:label];
        view;
    });
    
    UIButton *unbindBtn = [YDUIKit buttonWithTitle:@"解除绑定" titleColor:[UIColor whiteColor] backgroundColor:YDBaseColor selector:@selector(unbindButtonAction:)  target:self];
    unbindBtn.frame = CGRectMake(20, SCREEN_HEIGHT-150, SCREEN_WIDTH-40, 50);
    unbindBtn.layer.cornerRadius = 8.0f;
    
    [self.tableView addSubview:unbindBtn];
    
    _titles = @[@"您的设备号",@"绑定的手机号",@"验证码"];
    
    _phoneNumber = [YDUserDefault defaultUser].user.ub_cellphone;
    _subTitles = @[_obd_imei,_phoneNumber,@""];
}

//MARK:计数器
- (void)lgTimerAction:(id)sender{
    _time -= 1;
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒",(long)_time] forState:0];
    if (_time == 0) {
        _getCodeBtn.enabled = YES;
        [_getCodeBtn setTitle:@"获取动态密码" forState:0];
        [_timer invalidate];
        _timer = nil;
    }
}
//MARK:获取验证码
- (void)getCodeBtnAction:(UIButton *)button{
    [_getCodeBtn setTitle:@"获取中..." forState:0];
    _getCodeBtn.enabled = NO;
    NSDictionary *parameters = @{@"ub_cellphone":[_subTitles objectAtIndex:1],
                              @"type":@1};
    [YDNetworking getUrl:kSmsURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *originalDic = [responseObject mj_JSONObject];
        NSNumber *status_code = [originalDic objectForKey:@"status_code"];
        if ([status_code isEqual:@200]) {
            _time = 59;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(lgTimerAction:) userInfo:nil repeats:YES];
            [YDMBPTool showText:@"验证码正火速赶往中..."];
        }else{
            _getCodeBtn.enabled = YES;
            [_getCodeBtn setTitle:@"获取动态密码" forState:0];
            [YDMBPTool showText:@"获取失败，请检查网络或手机号"];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        YDLog(@"获取验证码失败 error ＝ %@",error);
        [YDMBPTool showText:@"获取失败，请检查网络或手机号"];
        [_getCodeBtn setTitle:@"获取动态密码" forState:0];
        _getCodeBtn.enabled = YES;
    }];
    
}

//MARK:解除绑定
- (void)unbindButtonAction:(UIButton *)button{
    if (_textField.text.length < 4) {
        [YDMBPTool showText:@"验证码错误"];
        return;
    }
    [YDLoadingHUD showLoading];
    YDWeakSelf(self);
    NSDictionary *parameters = @{@"phone":_phoneNumber,
                               @"vcode":_textField.text,
                               @"obdimei":_obd_imei};
    [YDNetworking postUrl:kUnbindOBDURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *originalDic = [responseObject mj_JSONObject];
        YDLog(@"originalDic = %@",originalDic);
        NSNumber *status_code = [originalDic objectForKey:@"status_code"];
        
        if ([status_code isEqual:@200]) {
            [[YDCarHelper sharedHelper] updateCarOBDStatus:0 uid:[YDUserDefault defaultUser].user.ub_id ug_id:weakself.ug_id];
            [YDMBPTool showSuccessImageWithMessage:@"解绑成功" hideBlock:^{
                for (UIViewController *vc in weakself.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[YDGarageViewController class]]) {
                        [weakself.navigationController popToViewController:vc animated:YES];
                    }
                }
            }];
            
        }else{
            [YDMBPTool showText:[originalDic objectForKey:@"status"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        YDLog(@"解绑VE-BOX error = %@",error);
        [YDMBPTool showText:@"解绑失败"];
    }];
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUnbindOBDCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YDUnbindOBDCell"];
        cell.textLabel.textColor = [UIColor grayTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = YDBaseColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.detailTextLabel.text = _subTitles[indexPath.row];
    
    if (indexPath.row == 2) {
        _getCodeBtn = [YDUIKit buttonWithTitle:@"获取验证码" titleColor:YDBaseColor backgroundColor:[UIColor whiteColor] selector:@selector(getCodeBtnAction:)  target:self];
        _getCodeBtn.layer.borderColor = YDBaseColor.CGColor;
        _getCodeBtn.layer.borderWidth = 1.0f;
        
        _getCodeBtn.titleLabel.font = [UIFont font_12];
        _getCodeBtn.frame = CGRectMake(SCREEN_WIDTH-100, 10, 80, 35);
        _getCodeBtn.layer.cornerRadius = 8.0f;
        
        [cell.contentView addSubview:_getCodeBtn];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(_getCodeBtn.x-120, 10, 100, 35)];
        _textField.placeholder = @"请输入验证码";
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:_textField];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger length = 4;
    if (string.length > 0) {
        string = [textField.text stringByAppendingString:string];
    }else{
        string = [textField.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
    }
    
    if ([string length] == length) {
        textField.text = string;
        [textField resignFirstResponder];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end

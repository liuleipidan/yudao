//
//  YDLoginInputView.h
//  YuDao
//
//  Created by 汪杰 on 16/11/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPhoneNumberNotification @"kPhoneNumberNotification"

/**
 当前输入视图所在控制器的用途
 */
typedef NS_ENUM(NSInteger, YDLoginInputViewType) {
    YDLoginInputViewTypeLogin = 1,//登录
    YDLoginInputViewTypeRegister, //注册
    YDLoginInputViewTypeBindThirdPlatform,//绑定第三方帐号
};
/**
 当前输入视图用于输入内容类型
 */
typedef NS_ENUM(NSInteger, YDLoginInputViewSubType) {
    YDLoginInputViewSubTypePhone = 1,//手机号
    YDLoginInputViewSubTypePassword,//验证码
};

@class YDLoginInputView;
@protocol YDLoginInputViewDelegate <NSObject>

@optional
- (void)loginInputView:(YDLoginInputView *)inView getPassword:(UIButton *)btn;

@required
- (void)loginInputView:(YDLoginInputView *)inView didSelectedVariableBtnWithBackCode:(NSNumber *)code;

@end

@interface YDLoginInputView : UIView<UITextFieldDelegate>

- (instancetype)initWithType:(YDLoginInputViewType )type subType:(YDLoginInputViewSubType )subType;

@property (nonatomic, weak  ) id<YDLoginInputViewDelegate> delegate;

@property (nonatomic, assign) YDLoginInputViewType type;

@property (nonatomic, assign) YDLoginInputViewSubType subType;

@property (nonatomic, strong) UILabel       *label;

@property (nonatomic, strong) UIButton      *icon;

@property (nonatomic, strong) UITextField    *textF;

@property (nonatomic, copy  ) NSString      *phoneNumber;

@property (nonatomic, strong) UIButton      *variableBtn;

@property (nonatomic, strong) NSDictionary   *dataDic;

@end

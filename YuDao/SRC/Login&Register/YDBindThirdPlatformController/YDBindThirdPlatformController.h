//
//  YDBindThirdPlatformController.h
//  YuDao
//
//  Created by 汪杰 on 2017/5/23.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"

@interface YDBindThirdPlatformController : YDViewController


/**
 由哪个界面所弹出，1 ->登录，2->注册
 */
@property (nonatomic, strong) NSNumber *presentingVC;

/**
 第三方平台类型，1->微信，2->QQ，3->微博
 */
@property (nonatomic, strong) NSNumber *platformType;

/**
 第三方标示
 */
@property (nonatomic, copy  ) NSString *tpUid;

/**
 用户头像网址
 */
@property (nonatomic, copy  ) NSString *tpIcon;

/**
 用户昵称
 */
@property (nonatomic, copy  ) NSString *tpNickName;

/**
 用户性别，1->男，2->女
 */
@property (nonatomic, strong) NSNumber *tpSex;

@end

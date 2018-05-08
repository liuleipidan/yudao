//
//  YDProgressHUD.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/12.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface YDProgressHUD : MBProgressHUD

//标识符
@property (nonatomic, copy  ) NSString *identifier;

//是否关闭自动隐藏，默认为NO，如果YES需要手动管理
@property (nonatomic, assign) BOOL disableAutoHide;

- (void)hide;

@end

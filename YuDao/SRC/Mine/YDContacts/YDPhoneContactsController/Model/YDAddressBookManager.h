//
//  YDAddressBookManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/26.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "YDContactsModel.h"



typedef void(^finishBlock)(BOOL granted);

@interface YDAddressBookManager : NSObject<MFMessageComposeViewControllerDelegate>

/**
 是否允许访问通讯录
 */
@property (nonatomic, assign) BOOL granted;

/**
 所有联系人
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 所有联系人的手机号，用逗号连接的字符串
 */
@property (nonatomic, copy  ) NSString *contactsStr;

/**
 索引数组
 */
@property (nonatomic, strong) NSArray *indexArr;

/**
 排序好的数组
 */
@property (nonatomic, strong) NSArray *letterArr;

/**
 获取所有联系人

 @param finish 获取完成
 */
- (void)getContactsFinish:(finishBlock )finish;

/**
 上传所有联系人手机号到服务器

 @param finish 完成后刷新tableview
 */
- (void)uploadContactsString:(void (^)())finish;

/**
 发送短信

 @param preVC present的viewcontoller
 @param phones 手机号数组
 @param title 标题
 @param body 内容
 */
- (void)showMessageViewInViewController:(UIViewController *)preVC
                                phones:(NSArray<NSString *> *)phones
                                 title:(NSString *)title
                                  body:(NSString *)body;

/**
 添加好友

 @param model 联系人
 @param finish 添加完成
 */
+ (void)addFriend:(YDContactsModel *)model
           finish:(void (^)(BOOL success, NSString *status))finish;

@end

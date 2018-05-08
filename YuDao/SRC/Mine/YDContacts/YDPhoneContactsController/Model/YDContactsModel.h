//
//  ContactsModel.h
//  YuDao
//
//  Created by 汪杰 on 16/9/28.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, YDContactStatus) {
    YDContactStatusNotJoin = 0, //未加入遇道
    YDContactStatusFriend,      //已经好友
    YDContactStatusStranger,    //可添加
    YDContactStatusWait,        //等待确认
};

@interface YDContactsModel : NSObject

//**************  通讯录信息  **************
@property (nonatomic, copy) NSString *name;//手机联系人名字
@property (nonatomic, copy) NSString *pinYin;//用于排序分组
@property (nonatomic, copy) NSString *phoneNumber;//手机号
@property (nonatomic, copy) NSString *avatarPath;//本地联系人头像路径

//**************  遇道平台信息  **************
@property (nonatomic, strong)  NSNumber *ub_id; //用户id

@property (nonatomic, copy  ) NSString *nickName;//用户昵称

@property (nonatomic, copy  ) NSString *avatarURL;//用户头像网站

@property (nonatomic, assign) YDContactStatus status;//联系人的当前状态

//聊天使用的标识符
@property (nonatomic, strong) XMPPJID *jid;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr;


@end

//
//  YDFriendModel.h
//  YuDao
//
//  Created by 汪杰 on 16/11/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDUserGroup.h"

@interface YDFriendModel : NSObject

/*f_ub_id,ud_face,ub_nickname,ub_auth_grade,f_firstchar,ub_id
 */
/**
 *  好友用户id
 */
@property (nonatomic, strong) NSNumber *friendid;
/**
 *  好友头像URL
 */
@property (nonatomic, copy  ) NSString *friendImage;

/**
 本地图片
 */
@property (nonatomic, copy  ) NSString *avatarPath;

/**
 *  好友呢称
 */
@property (nonatomic, copy  ) NSString *friendName;
/**
 *  好友等级
 */
@property (nonatomic, strong) NSNumber *friendGrade;
/**
 *  好友昵称首字母
 */
@property (nonatomic, copy  ) NSString *firstchar;

/**
 *  当前用户id
 */
@property (nonatomic, strong) NSNumber *currentUserid;

/**
 *  聊天标识符
 */
@property (nonatomic, strong) XMPPJID *jid;


#pragma mark - 列表用
/**
 *  拼音
 *
 *  来源：备注 > 昵称 > 用户名
 */
@property (nonatomic, strong) NSString *pinyin;

@property (nonatomic, strong) NSString *pinyinInitial;


@end

//
//  YDHPIgonreModel.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDEnumerate.h"

@interface YDHPIgnoreModel : NSObject

/**
 此条记录id,为服务器此表的主键
 */
@property (nonatomic, strong) NSNumber *rid;

/**
 用户id
 */
@property (nonatomic, strong) NSNumber *uid;

/**
 父级类型(1->行车信息,2->任务,3->消息,4->排行榜)
 消息包括（
        2001->周报,
        7000->天气,
        9003->卡券,
        9002->营销活动,
        9010->服务推送
 ）
 */
@property (nonatomic, strong) NSNumber *ptype;

/**
 子级类型(默认为0，其他参考上面父类型介绍)
 */
@property (nonatomic, strong) NSNumber *subtype;

/**
 忽略类型,0->无,1->24小时,2->永久
 */
@property (nonatomic, strong) NSNumber *ignore_type;

//时间,yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy  ) NSString *time;

+ (YDHPIgnoreModel *)createIgnoreModelByModuleType:(YDHomePageModuleType)moduleType
                                           subType:(YDServerMessageType)subType;

@end

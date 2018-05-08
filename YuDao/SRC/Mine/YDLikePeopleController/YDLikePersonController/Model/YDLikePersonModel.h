//
//  YDLikePersonModel.h
//  YuDao
//
//  Created by 汪杰 on 16/11/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDLikePersonModel : NSObject

@property (nonatomic, strong) NSNumber *e_id;
//用户id
@property (nonatomic, strong) NSNumber *ub_id;
//互相喜欢用户的id
@property (nonatomic, strong) NSNumber *e_ub_id;
//等级
@property (nonatomic, strong) NSNumber *ub_auth_grade;
//头像
@property (nonatomic, strong) NSString *ud_face;
//昵称
@property (nonatomic, strong) NSString *ub_nickname;


@end

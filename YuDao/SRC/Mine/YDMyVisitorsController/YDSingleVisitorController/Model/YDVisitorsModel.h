//
//  YDVisitorsModel.h
//  YuDao
//
//  Created by 汪杰 on 17/1/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDVisitorsModel : NSObject

//访客ID
@property (nonatomic, strong) NSNumber *vis_id;

//访问时间
@property (nonatomic, copy  ) NSString *lasttime;

//访问时间(新)
@property (nonatomic, strong) NSNumber *lasttimeInt;

//访客头像路径
@property (nonatomic, copy  ) NSString *ud_face;

//等级
@property (nonatomic, strong) NSNumber *ub_auth_grade;

//呢称
@property (nonatomic, copy  ) NSString *ub_nickname;

#pragma mark - UI
@property (nonatomic, copy  ) NSString *timeInfo;

@end

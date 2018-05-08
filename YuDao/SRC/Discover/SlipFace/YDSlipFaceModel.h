//
//  YDSlipFaceModel.h
//  YuDao
//
//  Created by 汪杰 on 17/1/17.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDSlipFaceModel : NSObject

@property (nonatomic, strong) NSNumber *ub_id;
@property (nonatomic, copy  ) NSString *ub_nickname;
@property (nonatomic, strong) NSNumber *ub_auth_grade;
@property (nonatomic, copy  ) NSString *ud_face;
@property (nonatomic, copy  ) NSString *ud_location;//位置(经纬度)
@property (nonatomic, strong) NSNumber *ud_age;
@property (nonatomic, strong) NSNumber *ud_sex;//(1 -> 男, 2 -> 女)

@property (nonatomic, strong) NSNumber *enjoymy;//(是否喜欢我， 0 -> 否， 1 -> 是)

@property (nonatomic, strong) NSNumber *ud_userauth;//认证状态()

@property (nonatomic, strong) NSNumber *distance;//距离/米

@property (nonatomic, copy  ) NSString *ud_constellation;//星座

@property (nonatomic, copy  ) NSString *ud_tag;     //兴趣id

@property (nonatomic, copy  ) NSString *ud_tag_name;//兴趣标签

@property (nonatomic, strong) NSMutableArray *interestArray;//兴趣数组

@end

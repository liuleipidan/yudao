//
//  YDSearchCell.h
//  YuDao
//
//  Created by 汪杰 on 2017/3/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDFriendCell.h"

@interface YDSearchModel : NSObject

@property (nonatomic,copy) NSString *ub_nickname;
@property (nonatomic,copy) NSString *ud_face;

@property (nonatomic,strong) NSNumber *ud_sex;
@property (nonatomic,strong) NSNumber *ub_auth_grade;
@property (nonatomic,strong) NSNumber *ub_id;


@end

@interface YDSearchCell : YDFriendCell

@property (nonatomic,strong) YDSearchModel *searchModel;

@end

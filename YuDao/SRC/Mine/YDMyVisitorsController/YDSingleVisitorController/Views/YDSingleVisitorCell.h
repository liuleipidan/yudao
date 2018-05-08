//
//  YDSingleVisitorCell.h
//  YuDao
//
//  Created by 汪杰 on 17/1/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDLikePersonCell.h"
#import "YDVisitorsModel.h"

//喜欢的人类型
typedef NS_ENUM(NSInteger, YDVisitorType) {
    YDVisitorTypeForMe = 0,    //访问我的
    YDVisitorTypeForOthers,    //我访问的
};

@interface YDSingleVisitorCell : YDLikePersonCell

@property (nonatomic, strong) UILabel         *timeLabel;

@property (nonatomic, assign) YDVisitorType   visitorType;

@property (nonatomic, strong) YDVisitorsModel *visitorModel;

@end

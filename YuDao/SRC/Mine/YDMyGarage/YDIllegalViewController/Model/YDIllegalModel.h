//
//  YDIllegalModel.h
//  YuDao
//
//  Created by 汪杰 on 17/3/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDIllegalModel : NSObject

//违章时间
@property (nonatomic, copy  ) NSNumber *time;

//违章地点
@property (nonatomic, copy  ) NSString *address;

//违章罚款
@property (nonatomic, strong) NSNumber *price;

//违章扣分
@property (nonatomic, strong) NSNumber *score;

//违章代码
@property (nonatomic, strong) NSNumber *legalnum;

//违章行为
@property (nonatomic, copy  ) NSString *content;

#pragma mark --- UI ---

@property (nonatomic, copy  ) NSString *day;

@property (nonatomic, copy  ) NSString *month;

//地点高度
@property (nonatomic, assign) CGFloat addressHeight;

//显示的时间
@property (nonatomic, copy  ) NSString *showTime;

//违章行为高度
@property (nonatomic, assign) CGFloat contentHeight;

//单元格高度
@property (nonatomic, assign) CGFloat cellHeight;

@end

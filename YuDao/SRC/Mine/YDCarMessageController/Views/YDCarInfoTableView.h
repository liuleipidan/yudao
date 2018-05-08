//
//  YDCarInfoTableView.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTableView.h"
#import "YDCarInfoItem.h"

@interface YDCarInfoTableView : YDTableView

//车牌头
@property (nonatomic, copy, readonly) NSString *plate_number_header;

//车牌号
@property (nonatomic, copy, readonly) NSString *plate_number;

//车架号
@property (nonatomic, copy, readonly) NSString *frame_number;

//发动机号
@property (nonatomic, copy, readonly) NSString *engine_number;

//年检时间
@property (nonatomic, strong) NSDate *inspect_time;

//保养时间
@property (nonatomic, strong) NSDate *maintain_time;

@property (nonatomic, assign, readonly) BOOL isDefault;

- (void)setData:(NSArray<YDCarInfoItem *> *)data title:(NSString *)title isDefault:(BOOL)isDefault;

@end

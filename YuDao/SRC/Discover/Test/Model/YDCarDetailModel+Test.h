//
//  YDCarDetailModel+Test.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarDetailModel.h"
#import "YDTestsModel.h"

@interface YDCarDetailModel (Test)

@property (nonatomic, strong) YDTestsModel *testModel;

@property (nonatomic, assign, readonly) BOOL isBound_BOX;

@property (nonatomic, assign, readonly) BOOL isBound_AIR;

#pragma mark - UI
@property (nonatomic, strong, readonly) NSDictionary *cellHeightDic;

@end

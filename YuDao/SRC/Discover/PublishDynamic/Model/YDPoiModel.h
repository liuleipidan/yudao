//
//  YDPoiModel.h
//  YuDao
//
//  Created by 汪杰 on 16/11/28.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDPoiModel : NSObject

@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, copy  ) NSString *address;
@property (nonatomic, copy  ) NSString *city;
@property (nonatomic, copy  ) NSString *phone;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lon;

@property (nonatomic, assign) CGFloat distance;

@end

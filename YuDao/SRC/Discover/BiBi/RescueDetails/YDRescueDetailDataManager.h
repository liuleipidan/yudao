//
//  YDRescueDetailDataManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDRescueDetailDataManager : NSObject

@property (nonatomic, copy  ) NSString *name;

@property (nonatomic, copy  ) NSString *avatarURL;

@property (nonatomic, copy  ) NSString *details;

@property (nonatomic, copy  ) NSString *address;

@property (nonatomic, copy  ) NSString *distance;

@property (nonatomic, assign) BOOL isWalk;

@property (nonatomic, assign) CLLocationCoordinate2D coor;


@end

//
//  YDCarAuthenticateController.h
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"

@interface YDCarAuthenticateController : YDViewController

/**
 已经上传新图片
 */
@property (nonatomic,copy) void (^didUploadNewImagesBlock)(void);

@property (nonatomic, strong) YDCarDetailModel *carInfo;

@end

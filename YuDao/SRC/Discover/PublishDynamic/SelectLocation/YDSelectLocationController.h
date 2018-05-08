//
//  YDSelectLocatoinController.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDSelectLocationViewModel.h"

@interface YDSelectLocationController : YDViewController

@property (nonatomic,copy) void (^SLDidSelectedLoationBlock)(YDPoiInfo *poi);

- (id)initWitViewModel:(YDSelectLocationViewModel *)viewModel;

@end

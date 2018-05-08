//
//  YDSLBPercentDrivenInteractive.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDPictureBrowseInteractiveAnimatedTransition.h"


//图片浏览器中图片之间的水平间距
#define kBrowseSpace 50.0f

@class YDPictureBrowseSouceModel;

@interface YDPictureBrowseViewController : UIViewController

@property (nonatomic, strong) YDPictureBrowseInteractiveAnimatedTransition *animatedTransition;

@property (nonatomic, strong) NSArray<YDPictureBrowseSouceModel *> *dataSouceArray;


@end

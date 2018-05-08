//
//  YDSLBInteractivePushAnimator.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDSLBInteractivePushAnimator : NSObject<UIViewControllerAnimatedTransitioning>


@property (nonatomic, strong) UIImageView *transitionImgV;

@property (nonatomic, assign) CGRect transitionBeforeImgFrame;

@property (nonatomic, assign) CGRect transitionAfterImgFrame;


@end

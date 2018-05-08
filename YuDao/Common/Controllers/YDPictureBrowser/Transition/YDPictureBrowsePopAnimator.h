//
//  YDPictureBrowsePopAnimator.h
//  YDCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YDPictureBrowseTransitionParameter;

@interface YDPictureBrowsePopAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) YDPictureBrowseTransitionParameter *transitionParameter;

@end

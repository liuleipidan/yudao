//
//  YDMomentMultilImagesView.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDMomentViewDelegate.h"

@interface YDMomentMultilImagesView : UIView

@property (nonatomic, weak  ) id<YDMomentImagesViewDelegate> delegate;

@property (nonatomic, strong) NSArray *images;

@end

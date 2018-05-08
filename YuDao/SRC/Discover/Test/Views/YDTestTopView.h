//
//  YDTestTopView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/22.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDTestTopView : UIView

@property (nonatomic,weak) YDCarDetailModel *carInfo;

- (void)startAnimationByPercent:(NSInteger)percent isOpen:(BOOL)isOpen;

@end

//
//  YDSinagleRLLikeButton.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDSingleRLLikeButton : UIButton

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, copy  ) NSString *iconPath;

@property (nonatomic, copy  ) NSString *iconHLPath;

- (id)initWithTitle:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath;

@end

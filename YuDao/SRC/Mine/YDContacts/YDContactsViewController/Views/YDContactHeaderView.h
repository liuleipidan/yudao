//
//  YDContactHeaderView.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/28.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDContactHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, strong) UIColor *titleColor;

//默认是0，titleLabel.x = 10
@property (nonatomic, assign) CGFloat offset_X;

@property (nonatomic, strong) UIColor *bgColor;

@end

//
//  YDLCSelectView.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

///我的爱车选择view，可选择《我》《车》《刷新》
@interface YDLCSelectView : UIView

@property (nonatomic,copy) void (^selectedBlock) (NSInteger index);

@end

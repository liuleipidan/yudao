//
//  YDClipImageView.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDClipImageView : UIView

/**
 设置中心截取框的大小
 */
@property (nonatomic,assign) CGSize clipSize;

/**
 截图框的背景图片
 */
@property (nonatomic, strong) UIImage *clipImage;

/**
 提示文字
 */
@property (nonatomic, copy  ) NSString *tipTitle;

@end

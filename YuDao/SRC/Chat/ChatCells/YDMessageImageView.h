//
//  YDMessageImageView.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDMessageImageView : UIImageView

@property (nonatomic, strong) UIImage *backgroundImage;

/**
 本地图片路径
 */
@property (nonatomic, strong) NSString *imagePath;

/**
 网络图片
 */
@property (nonatomic, strong) NSString *imageUrl;



@end

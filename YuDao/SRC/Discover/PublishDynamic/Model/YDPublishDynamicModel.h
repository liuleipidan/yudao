//
//  YDPublishDynamicModel.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPDImagesRowHeight 90.0f

@interface YDPublishDynamicModel : NSObject

//文本
@property (nonatomic, copy  ) NSString *text;

//地址
@property (nonatomic, copy  ) NSString *address;

//经度
@property (nonatomic, copy  ) NSString *lng;

//纬度
@property (nonatomic, copy  ) NSString *lat;

//标签
@property (nonatomic, copy  ) NSString *label;

//图片
@property (nonatomic, strong) NSMutableArray *images;

//系统相册
@property (nonatomic, strong) NSMutableArray *assets;

#pragma mark - 视频
@property (nonatomic, strong) NSURL *videoLocalURL;

@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, copy  ) NSString *videoNetworkURL;

@property (nonatomic, assign, readonly) BOOL isVideo;

#pragma mark - UI
@property (nonatomic, assign, readonly) CGFloat imagesHeight;

@property (nonatomic, assign) CGFloat imagesRowSpace;

@property (nonatomic, assign) CGFloat imagesColSpace;

@property (nonatomic, assign, readonly) CGFloat imagesWidth;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end

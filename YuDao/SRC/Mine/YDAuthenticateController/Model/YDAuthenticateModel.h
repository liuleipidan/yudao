//
//  YDAuthenticateModel.h
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 认证图片的类型

 - YDAuthenticateImageTypePositive: 正面
 - YDAuthenticateImageTypeNegative: 反面
 */
typedef NS_ENUM(NSInteger,YDAuthenticateImageType) {
    YDAuthenticateImageTypePositive = 0,
    YDAuthenticateImageTypeNegative,
};

@interface YDAuthenticateModel : NSObject

@property (nonatomic,assign) YDAuthenticateImageType imageType;

@property (nonatomic, copy  ) NSString *title;

//裁剪后的图片
@property (nonatomic, strong) UIImage *image;

//图片网址(图片可能为空)
@property (nonatomic, copy  ) NSString *imageUrl;

//认证状态(0 -> 未提交, 1 -> 审核中, 2 -> 审核失败请重新上传, 3 -> 审核成功)
@property (nonatomic, assign) NSInteger       authStatus;

+ (YDAuthenticateModel *)modelWithImageType:(YDAuthenticateImageType )imageType
                                      title:(NSString *)title
                                      image:(UIImage *)image
                                   imageUrl:(NSString *)imageUrl
                                 authStatus:(NSInteger )status;

@end

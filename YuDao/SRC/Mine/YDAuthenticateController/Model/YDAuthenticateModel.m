//
//  YDAuthenticateModel.m
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAuthenticateModel.h"

@implementation YDAuthenticateModel

+ (YDAuthenticateModel *)modelWithImageType:(YDAuthenticateImageType )imageType
                                      title:(NSString *)title
                                      image:(UIImage *)image
                                   imageUrl:(NSString *)imageUrl
                                 authStatus:(NSInteger )status{
    YDAuthenticateModel *model = [YDAuthenticateModel new];
    model.imageType = imageType;
    model.title = title;
    model.image = image;
    model.imageUrl = imageUrl;
    model.authStatus = status;
    
    return model;
}

@end

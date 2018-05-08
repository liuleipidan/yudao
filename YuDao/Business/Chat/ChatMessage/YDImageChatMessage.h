//
//  YDImageChatMessage.h
//  YuDao
//
//  Created by 汪杰 on 17/1/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatMessage.h"

@interface YDImageChatMessage : YDChatMessage

@property (nonatomic, strong) NSString *imagePath;        // 本地图片Path
@property (nonatomic, strong) NSString *imageURL;         // 网络图片URL
@property (nonatomic, assign) CGSize imageSize;


@end

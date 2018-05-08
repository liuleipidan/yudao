//
//  YDVideoChatMessage.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/5.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDChatMessage.h"

@interface YDVideoChatMessage : YDChatMessage

//视频本地路径
@property (nonatomic, copy  ) NSString *videoPath;

//网络视频路径
@property (nonatomic, copy  ) NSString *videoURL;

//缩略图本地路径
@property (nonatomic, copy  ) NSString *thumbnailImagePath;

//缩略图网络路径
@property (nonatomic, copy  ) NSString *thumbnailImageURL;

//缩略图大小
@property (nonatomic, assign) CGSize thumbnailImageSize;

@end


//
//  YDVideo+Util.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/5.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface YDVideoUtil : NSObject

//视频格式转换
+ (void)ConvertMovToMp4:(NSURL *)movURL
             completion:(void (^)(AVAssetExportSessionStatus status, NSString *exportPath))completion;

//保存视频到相册
+ (void)saveVideoWithURL:(NSURL *)videoURL completion:(void (^)(NSError *error))completion;

//计算时间字符串，例如 00:11
+ (NSString *)getVideoTimeString:(NSInteger)second;

//计算缓冲时间
+ (CGFloat)getVideoBufferTime:(AVPlayerItem *)item;


@end

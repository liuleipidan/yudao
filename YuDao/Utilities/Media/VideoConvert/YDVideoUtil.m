//
//  YDVideo+Util.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/5.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDVideoUtil.h"
@import Photos;
#import <AssetsLibrary/AssetsLibrary.h>

@implementation YDVideoUtil

+ (void)ConvertMovToMp4:(NSURL *)movURL
             completion:(void (^)(AVAssetExportSessionStatus status, NSString *exportPath))completion{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality] ||
        [compatiblePresets containsObject:AVAssetExportPresetMediumQuality] ||
        [compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPreset960x540];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        //输出路径
        NSString *fileName = [NSString stringWithFormat:@"%.0lf.mp4", [NSDate date].timeIntervalSince1970 * 1000];
        NSString *exportPath = [NSFileManager pathUserChatVideo:fileName];
        exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([exportSession status],exportPath);
            });
        }];
    }
}

+ (void)saveVideoWithURL:(NSURL *)videoURL completion:(void (^)(NSError *error))completion{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_8_0) {
        if (videoURL == nil) {
            if (completion) {
                completion([NSError new]);
            }
            return;
        }
        NSError *error;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoURL];
            if (completion) {
                completion(error);
            }
        } error:&error];
    }
    else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] yd_setStatusBarStyle:0];
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:videoURL completionBlock:^(NSURL *assetURL, NSError *error) {
            if (completion) {
                completion(error);
            }
        }];
#pragma clang diagnostic pop
    }
}

//计算时间字符串，例如 00:11
+ (NSString *)getVideoTimeString:(NSInteger)second{
    NSString *time = nil;
    if (second < 60) {
        time = [NSString stringWithFormat:@"00:%02ld",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"%02ld:%02ld",second/60,second%60];
        }
        else {
            time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",second/3600,(second-second/3600*3600)/60,second%60];
        }
    }
    return time;
}

//计算缓冲时间
+ (CGFloat)getVideoBufferTime:(AVPlayerItem *)item{
    NSArray *loadedTimeRanges = [item loadedTimeRanges];
    CMTimeRange range = [loadedTimeRanges.firstObject CMTimeRangeValue];
    CGFloat start = CMTimeGetSeconds(range.start);
    CGFloat duration = CMTimeGetSeconds(range.duration);
    return start + duration;
}

@end

//
//  YDAudioRecorder.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDAudioRecorder : NSObject

+ (YDAudioRecorder *)sharedRecorder;

+ (void)attemptDealloc;

- (void)startRecordingWithVolumeChangedBlock:(void (^)(CGFloat volume))volumeChanged
                               completeBlock:(void (^)(NSString *path, CGFloat time))complete
                                 cancelBlock:(void (^)(void))cancel;
- (void)stopRecording;

- (void)cancelRecording;

@end

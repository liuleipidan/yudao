//
//  YDVoiceChatMessage.h
//  YuDao
//
//  Created by 汪杰 on 17/1/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatMessage.h"

typedef NS_ENUM(NSInteger, YDVoiceMessageStatus) {
    YDVoiceMessageStatusNormal,
    YDVoiceMessageStatusRecording,
    YDVoiceMessageStatusPlaying,
};

@interface YDVoiceChatMessage : YDChatMessage

@property (nonatomic, strong) NSString *recFileName;

@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) CGFloat seconds;

/**
 临时路径，用于暂存amr格式录音
 */
@property (nonatomic, copy  ) NSString *amrPath;

@property (nonatomic, assign) YDVoiceMessageStatus msgStatus;


@end

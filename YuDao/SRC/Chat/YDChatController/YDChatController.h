//
//  YDChatController.h
//  YuDao
//
//  Created by 汪杰 on 17/2/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDChatBar.h"
#import "YDChatMessageDisplayView.h"
#import "YDRecorderIndicatorView.h"
#import "YDAudioPlayer.h"
#import "YDAudioRecorder.h"
#import "YDChatPartner.h"
#import "YDChatCellMenuView.h"
#import "YDVideoUtil.h"
#import "WJCameraViewController.h"

#define kUploadMessageDataURL [kOriginalURL stringByAppendingString:@"amr"]

#define kUploadVideoDataURL   [kOriginalURL stringByAppendingString:@"video"]

@interface YDChatController : YDViewController
{
    //当前chat bar的状态
    YDChatBarStatus _curStatus;
    //上一个chat bar的状态
    YDChatBarStatus _lastStatus;
}

/**
 聊天对象
 */
@property (nonatomic,strong) YDChatPartner *partner;

/**
 操作栏
 */
@property (nonatomic, strong) YDChatBar *chatBar;

/**
 点击图片获取当前好友聊天记录所有的图片网址
 */
@property (nonatomic, strong) NSMutableArray *imageUrls;

/**
 消息展示视图
 */
@property (nonatomic,strong) YDChatMessageDisplayView *messageDisplayView;

/**
 语言指示器
 */
@property (nonatomic, strong) YDRecorderIndicatorView *recorderIndicatorView;

/**
 正在播放语音的消息
 */
@property (nonatomic, strong) YDVoiceChatMessage *isPlayingMessage;

@property (nonatomic, assign) YDChatBarStatus curStatus;

@property (nonatomic, assign) YDChatBarStatus lastStatus;

@property (nonatomic, strong) WJCameraViewController *cameraVC;

+ (YDChatController *)shareChatVC;

@end

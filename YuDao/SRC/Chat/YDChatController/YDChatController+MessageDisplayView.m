//
//  YDChatController+MessageDisplayView.m
//  YuDao
//
//  Created by 汪杰 on 17/3/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatController+MessageDisplayView.h"
#import "YDChatController+ChatBar.h"
#import "YDTextDisplayView.h"
#import "YDChatHelper+ChatRecord.h"
#import "YDUserFilesController.h"
#import "WWAVPlayerView.h"

#pragma mark - 消息是否需要显示时间

//最大显示消息数量
#define     MAX_SHOWTIME_MSG_COUNT      10

//消息间隔最长时间(秒)
#define     MAX_SHOWTIME_MSG_SECOND     60

@implementation YDChatController (MessageDisplayView)

#pragma mark - # Public Methods
- (void)addToShowMessage:(YDChatMessage *)message{
    message.showTime = [self y_needShowTime:message.date];
    [self.messageDisplayView addMessage:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messageDisplayView scrollToBottomWithAnimation:YES];
    });
}
- (void)resetChatViewConroller{
    
    [self.messageDisplayView resetMessageView];
    lastDateInterval = 0;
    msgAccumulate = 0;
}

#pragma mark - # Delegate
//MARK: YDChatMessageViewDelegate
// chatView 点击事件
- (void)chatMessageDisplayViewDidTouched:(YDChatMessageDisplayView *)chatTVC
{
    [self dismissKeyboard];
}
// chatView 获取历史记录
- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC getRecordsFromDate:(NSDate *)date count:(NSUInteger)count completed:(void (^)(NSDate *, NSArray *, BOOL))completed{
    YDWeakSelf(self);
    [[YDChatHelper sharedInstance] chatMessageByUserId:YDUser_id fid:self.partner.chat_userId fromDate:date count:count completion:^(NSArray *data, BOOL hasMore) {
        if (data.count > 0) {
            int count = 0;
            NSTimeInterval tm = 0;
            for (YDChatMessage *message in data) {
                //是否需要显示时间
                if (++count > MAX_SHOWTIME_MSG_COUNT || tm == 0 || message.date.timeIntervalSince1970 - tm > MAX_SHOWTIME_MSG_SECOND) {
                    tm = message.date.timeIntervalSince1970;
                    count = 0;
                    message.showTime = YES;
                }
                
                //聊天对方的头像和名字
                if (message.ownerType == YDMessageOwnerTypeFriend) {
                    message.fAvatarUrl = weakself.partner.chat_avatarURL;
                    message.fName = weakself.partner.chat_username;
                }
                
            }
        }
        completed(date,data,hasMore);
    }];
}

- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
          showCellMenuViewrect:(CGRect)rect
                       message:(YDChatMessage *)message{
    YDChatCellMenuView *menuView = [YDChatCellMenuView sharedMenuView];
    if ([IQKeyboardManager sharedManager].keyboardShowing) {
        self.chatBar.textView.overrideNext = menuView;
    }else{
        [menuView becomeFirstResponder];
    }
    
    YDWeakSelf(self);
    [menuView showInView:self.messageDisplayView isFirstResponder:NO  messageType:message.messageType rect:rect actionBlcok:^(YDChatMenuItemType itemType) {
        weakself.chatBar.textView.overrideNext = nil;
        if (itemType == YDChatMenuItemTypeDelete) {
            [weakself.view endEditing:YES];
            [LPActionSheet showActionSheetWithTitle:@"是否删除该消息" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
                if (index == -1) {
                    if ([[YDChatHelper sharedInstance] deleteOneMessageByMsgId:message.msgId uid:message.uid fid:message.fid]) {
                        [weakself.messageDisplayView deleteMessage:message];
                    }else{
                        [UIAlertController YD_OK_AlertController:weakself title:@"删除失败" clickBlock:^{
                            
                        }];
                    }
                }
            }];
        }
        else if (itemType == YDChatMenuItemTypeCopy){
            NSString *str = [message messageCopy];
            [[UIPasteboard generalPasteboard] setString:str];
        }
        
    }];
}
//
///**
// *  消息长按删除
// *
// *  @return 删除是否成功
// */
//- (BOOL)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
//                 deleteMessage:(YDChatMessage *)message
//                          rect:(CGRect)rect{
//    __block BOOL isDeleted = NO;
//    YDWeakSelf(self);
//    [[YDChatCellMenuView sharedMenuView] showInView:self.messageDisplayView isFirstResponder:NO  messageType:message.messageType rect:rect actionBlcok:^(YDChatMenuItemType itemType) {
//        if (itemType == YDChatMenuItemTypeDelete) {
//            [LPActionSheet showActionSheetWithTitle:@"是否删除该消息" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
//                if (index == -1) {
//                    isDeleted = [[YDChatHelper sharedInstance] deleteOneMessageByMsgId:message.msgId uid:message.uid fid:message.fid];
//                    NSLog(@"isDeleted = %d",isDeleted);
//                }
//            }];
//        }
//        else if (itemType == YDChatMenuItemTypeCopy){
//            NSString *str = [message messageCopy];
//            [[UIPasteboard generalPasteboard] setString:str];
//        }
//        weakself.chatBar.textView.overrideNext = nil;
//    }];
//    return isDeleted;
//}

/**
 *  用户头像点击事件
 */
- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
            didClickUserAvatar:(NSNumber *)userId{
    if ([self respondsToSelector:@selector(clickUserAvatar:)]) {
        [self clickUserAvatar:userId];
    }
}

/**
 *  Message点击事件
 */
- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
                     tapedView:(UIView *)tapedView
               didClickMessage:(YDChatMessage *)message{
    [[YDAudioRecorder sharedRecorder] stopRecording];
    if (message.messageType == YDMessageTypeImage) {
        [self.view endEditing:YES];
        YDWeakSelf(self);
        [[YDChatHelper sharedInstance] chatImagesForFid:[NSString stringWithFormat:@"%@",self.partner.chat_userId] completed:^(NSArray *data) {
            NSInteger index = -1;
            for (int i = 0; i < data.count; i++) {
                YDChatMessage *chatMessage = data[i];
                if ([message.msgId isEqualToString:chatMessage.msgId]) {
                    index = i;
                }
            }
            if (index >= 0) {
                [weakself clickImageMessages:data AtIndex:index];
            }
        }];
    }
    else if (message.messageType == YDMessageTypeVoice){
        [self.view endEditing:YES];
        if ([(YDVoiceChatMessage *)message msgStatus] == YDVoiceMessageStatusNormal) {
            // 播放语音消息
            [(YDVoiceChatMessage *)message setMsgStatus:YDVoiceMessageStatusPlaying];
            [[YDAudioPlayer sharedAudioPlayer] playAudioAtPath:[(YDVoiceChatMessage *)message path] complete:^(BOOL finished) {
                [(YDVoiceChatMessage *)message setMsgStatus:YDVoiceMessageStatusNormal];
                [self.messageDisplayView updateMessage:message];
            }];
        }else{
            [[YDAudioPlayer sharedAudioPlayer] stopPlayingAudio];
            [(YDVoiceChatMessage *)message setMsgStatus:YDVoiceMessageStatusNormal];
            [self.messageDisplayView updateMessage:message];
        }
    }
    else if (message.messageType == YDMessageTypeVideo){
        [self.view endEditing:YES];
        YDVideoChatMessage *videoMessage = (YDVideoChatMessage *)message;
        if (videoMessage.ownerType == YDMessageOwnerTypeSelf && videoMessage.videoPath.length != 0) {
            CGRect rect = [tapedView.superview convertRect:tapedView.frame toView:nil];
            [[WWAVPlayerView sharedPlayerView] fullScreenPlay:YDURL(videoMessage.videoURL) placeholderImage:nil rect:rect];
        }
        else{
            CGRect rect = [tapedView.superview convertRect:tapedView.frame toView:nil];
            [[WWAVPlayerView sharedPlayerView] fullScreenPlay:YDURL(videoMessage.videoURL) placeholderImage:nil rect:rect];
        }
    }
}

/**
 *  Message双击事件
 */
- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
         didDoubleClickMessage:(YDChatMessage *)message{
    
    if (message.messageType == YDMessageTypeText) {
        YDTextDisplayView *textDisplayView = [[YDTextDisplayView alloc] init];
        [textDisplayView showInView:self.navigationController.view attrText:[(YDTextChatMeesage *)message attrText] animation:YES];
    }
}

#pragma mark - XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    if (index < self.imageUrls.count) {
        return self.imageUrls[index];
    }
    return nil;
}

#pragma mark - XLPhotoBrowserDelegate
- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex{
    if (actionSheetindex == 0) {//保存图片
        [browser saveCurrentShowImage];
    }
}

#pragma mark ================= Private Methods =================
//点击头像
- (void)clickUserAvatar:(NSNumber *)userId{
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:userId];
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    if ([userId isEqual:YDUser_id]) {
        viewM.userName = [YDUserDefault defaultUser].user.ub_nickname;
        viewM.userHeaderUrl = [YDUserDefault defaultUser].user.ud_face;
    }else{
        viewM.userName = self.partner.chat_username;
        viewM.userHeaderUrl = self.partner.chat_avatarURL;
    }
    [self.navigationController pushViewController:userVC animated:YES];
}

//点击图片
- (void)clickImageMessages:(NSArray *)data AtIndex:(NSInteger )index{
    if (self.imageUrls == nil) {
        self.imageUrls = [NSMutableArray array];
    }
    [self.imageUrls removeAllObjects];
    for (YDImageChatMessage *message in data) {
        [self.imageUrls addObject:YDURL(YDNoNilString(message.imageURL))];
    }
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:self.imageUrls.count datasource:self];
    [browser setCurrentImageIndex:index];
    [browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" deleteButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleNone;
}

#pragma mark - 计算是否需要显示时间
static NSTimeInterval lastDateInterval = 0;
static NSInteger msgAccumulate = 0;
- (BOOL)y_needShowTime:(NSDate *)date
{
    if (++msgAccumulate > MAX_SHOWTIME_MSG_COUNT || lastDateInterval == 0 || date.timeIntervalSince1970 - lastDateInterval > MAX_SHOWTIME_MSG_SECOND) {
        lastDateInterval = date.timeIntervalSince1970;
        msgAccumulate = 0;
        return YES;
    }
    return NO;
}

@end

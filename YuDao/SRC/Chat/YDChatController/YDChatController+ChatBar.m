//
//  YDChatController+ChatBar.m
//  YuDao
//
//  Created by 汪杰 on 17/2/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatController+ChatBar.h"
#import "YDChatController+MessageDisplayView.h"
#import "YDChatController+Proxy.h"
#import "VoiceConverter.h"
#import "NSString+RegularExpressionConfig.h"

@implementation YDChatController (ChatBar)
@dynamic moreKeyboard;
@dynamic emojiKeyboard;

- (void)addKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - # Public Methods
- (void)loadKeyboard{
    [self.moreKeyboard setKeyboardDelegate:self];
    [self.moreKeyboard setDelegate:self];
    [self.emojiKeyboard setKeyboardDelegate:self];
    [self.emojiKeyboard setDelegate:self];
}

- (void)dismissKeyboard{
    if (_curStatus == YDChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:YES];
        _curStatus = YDChatBarStatusInit;
    }
    else if (_curStatus == YDChatBarStatusEmoji){
        [self.emojiKeyboard dismissWithAnimation:YES];
        _curStatus = YDChatBarStatusInit;
    }
    [self.chatBar resignFirstResponder];
}

#pragma mark - System Keyboard Notification Action
- (void)keyboardWillShow:(NSNotification *)notification
{
    [[YDChatCellMenuView sharedMenuView] testDismiss];
    if (_curStatus != YDChatBarStatusKeyboard) {
        return;
    }
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification{
    if (_curStatus != YDChatBarStatusKeyboard) {
        return;
    }
    if (_lastStatus == YDChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    }
    else if (_lastStatus == YDChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:NO];
    }
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    if (_curStatus != YDChatBarStatusKeyboard && _lastStatus != YDChatBarStatusKeyboard) {
        return;
    }
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_lastStatus == YDChatBarStatusMore || _lastStatus == YDChatBarStatusEmoji) {
        if (keyboardFrame.size.height <= HEIGHT_CHAT_KEYBOARD) {
            return;
        }
    }
    else if (_curStatus == YDChatBarStatusMore || _curStatus == YDChatBarStatusEmoji){
        return;
    }
    
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-keyboardFrame.size.height);
    }];
    [self.view layoutIfNeeded];
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (_curStatus != YDChatBarStatusKeyboard && _lastStatus != YDChatBarStatusKeyboard) {
        return;
    }
    if (_curStatus == YDChatBarStatusEmoji || _curStatus == YDChatBarStatusMore) {
        return;
    }
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}

#pragma mark - YDKeyboardDelegate
- (void)chatKeyboardWillShow:(id)keyboard animated:(BOOL)animated{
    
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}
- (void)chatKeyboardDidShow:(id)keyboard animated:(BOOL)animated{
    if (_curStatus == YDChatBarStatusMore && _lastStatus == YDChatBarStatusEmoji) {
        //隐藏表情键盘
        [self.emojiKeyboard dismissWithAnimation:NO];
    }
    else if (_curStatus == YDChatBarStatusEmoji && _lastStatus == YDChatBarStatusMore){
        [self.moreKeyboard dismissWithAnimation:NO];
    }
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

- (void)chatKeyboardWillDismiss:(id)keyboard animated:(BOOL)animated{
    
}

- (void)chatKeyboardDidDismiss:(id)keyboard animated:(BOOL)animated{
    
}

- (void)chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height{
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).mas_offset(-height);
    }];
    [self.view layoutIfNeeded];
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

#pragma mark - YDMoreKeyboardDelegate
- (void)moreKeyboard:(YDMoreKeyboard *)keyboard didSelectedItem:(YDMoreKeyboardItem *)item{
    
    YDWeakSelf(self);
    if (item.type == YDMoreKeyboardItemTypeCamera) {
        self.cameraVC = [[WJCameraViewController alloc] init];
        [self.cameraVC setTakeImageBlock:^(UIImage *image){
            UIImage *messageImage = [UIImage fixOrientation:image];
            [weakself sendImageMessage:messageImage];
        }];
        [self.cameraVC setTakeVideoBlock:^(NSURL *videoUrl, UIImage *thumbnailImage) {
            UIImage *messageImage = [UIImage fixOrientation:thumbnailImage];
            //[weakself sendImageMessage:messageImage];
            [weakself sendVideoMessage:videoUrl thumbnailImage:messageImage];
        }];
        [self presentViewController:self.cameraVC animated:YES completion:nil];
    }
    else if (item.type == YDMoreKeyboardItemTypeImage){
        if ([YDPrivilegeManager allowAccessToAlbums]) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
            imagePickerVc.allowTakePicture = NO;
            YDWeakSelf(self);
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
                if (photos.count > 0) {
                    [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       [weakself sendImageMessage:obj];
                    }];
                }
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }
        else{
            [UIAlertController YD_OK_AlertController:self title:@"请在iPhone的\"设置-隐私-相机\"选项中，允许遇道访问你的手机相册" clickBlock:^{
                
            }];
        }
    }
}



#pragma mark - YDChatBarDelegate
//MARK: - chatBar状态切换
- (void)chatBar:(YDChatBar *)chatBar changeStatusFrom:(YDChatBarStatus)fromStatus to:(YDChatBarStatus)toStatus{
    if (_curStatus == toStatus) {
        return;
    }
    _lastStatus = fromStatus;
    _curStatus = toStatus;
    
    if (toStatus == YDChatBarStatusInit) {
        if (fromStatus == YDChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }
        else if (fromStatus == YDChatBarStatusEmoji){
            //隐藏表情键盘
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    }
    else if (toStatus == YDChatBarStatusVoice){
        if (fromStatus == YDChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }
        else if (fromStatus == YDChatBarStatusEmoji){
            //隐藏表情键盘
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    }
    else if (toStatus == YDChatBarStatusEmoji){
        [self.emojiKeyboard showInView:self.view withAnimation:YES];
    }
    else if (toStatus == YDChatBarStatusMore){
        [self.emojiKeyboard dismissWithAnimation:YES];
        [self.moreKeyboard showInView:self.view withAnimation:YES];
    }
}
//MARK: - 文字输入框高度改变
- (void)chatBar:(YDChatBar *)chatBar didChangeTextViewHeight:(CGFloat)height
{
    [self.messageDisplayView scrollToBottomWithAnimation:NO];
}
//MARK: 发送文本消息
- (void)chatBar:(YDChatBar *)chatBar sendText:(NSString *)text
{
    if ([text re_validateEmptyString]) {
        [UIAlertController YD_OK_AlertController:self title:@"不能发送空白消息" clickBlock:^{
            
        }];
        return;
    }
    YDTextChatMeesage *message = [[YDTextChatMeesage alloc] init];
    message.text = [text yd_stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    message.sendState = YDMessageSending;
    [self sendMessage:message];
}

#pragma mark - 录音相关
//开始录音
- (void)chatBarStartRecording:(YDChatBar *)chatBar{
    //停止语音
    [[YDAudioPlayer sharedAudioPlayer] stopPlayingAudio];
    NSLog(@"self.recorderIndicatorView = %@",self.recorderIndicatorView);
    [self.recorderIndicatorView setStatus:YDRecorderStatusRecording];
    [self.messageDisplayView addSubview:self.recorderIndicatorView];
    [self.recorderIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    __block NSInteger time_count = 0;
    YDVoiceChatMessage *message = [[YDVoiceChatMessage alloc] init];
    message.ownerType = YDMessageOwnerTypeSelf;
    message.uid = YDUser_id;
    message.fid = self.partner.chat_userId;
    message.msgStatus = YDVoiceMessageStatusRecording;
    message.readState = YDMessageReaded;
    message.date = [NSDate date];
    [[YDAudioRecorder sharedRecorder] startRecordingWithVolumeChangedBlock:^(CGFloat volume) {
        NSLog(@"volume = %f,time_count = %ld",volume,time_count);
        time_count ++;
        if (time_count == 2) {
            [self addToShowMessage:message];
        }
        [self.recorderIndicatorView setVolume:volume];
    } completeBlock:^(NSString *filePath, CGFloat time) {
        NSLog(@"time = %f",time);
        if (time < 1.0) {
            [self.recorderIndicatorView setStatus:YDRecorderStatusTooShort];
            return;
        }
        [self.recorderIndicatorView removeFromSuperview];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSLog(@"保存中--filePath");
            NSString *fileName = [NSString stringWithFormat:@"%.0lf.wav", [NSDate date].timeIntervalSince1970 * 1000];
            NSString *path = [NSFileManager pathUserChatVoice:fileName];
            NSError *error;
            [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:path error:&error];
            if (error) {
                YDLog(@"录音文件出错: %@", error);
                return;
            }
            message.recFileName = fileName;
            message.seconds = time;
            message.msgStatus = YDVoiceMessageStatusNormal;
            [message resetMessageFrame];
            message.sendState = YDMessageSending;
            
            NSString *amrPath = [NSFileManager pathUserChatVoice:[NSString stringWithFormat:@"%.0lf.amr", [NSDate date].timeIntervalSince1970 * 1000 + 1]];
            if ([VoiceConverter ConvertWavToAmr:message.path amrSavePath:amrPath]) {
                message.amrPath = amrPath;
            }
            NSLog(@"保存成功--filePath");
            [self sendVoiceMessage:message];
        }
    } cancelBlock:^{
        NSLog(@"取消录音");
        if (time_count >= 2) {
            [self.messageDisplayView deleteMessage:message];
        }
        [self.recorderIndicatorView removeFromSuperview];
    }];
    
}
//结束录音
- (void)chatBarFinishedRecoding:(YDChatBar *)chatBar
{
    [[YDAudioRecorder sharedRecorder] stopRecording];
}
//将要取消录音
- (void)chatBarWillCancelRecording:(YDChatBar *)chatBar cancel:(BOOL)cancel
{
    [self.recorderIndicatorView setStatus:cancel ? YDRecorderStatusWillCancel : YDRecorderStatusRecording];
}
//取消录音
- (void)chatBarDidCancelRecording:(YDChatBar *)chatBar
{
    [[YDAudioRecorder sharedRecorder] cancelRecording];
}

#pragma mark - 表情键盘
/**
 点击表情
 */
- (void)emojiKeyboard:(YDEmojiKeyboard *)emojiKB didSelectedEmojiItem:(YDEmoji *)emoji{
    if (emoji.type == YDEmojiTypeEmoji) {
        [self.chatBar addEmojiString:emoji.emojiName];
    }
}

/**
 点击发送
 */
- (void)emojiKeyboardSendButtonDown{
    [self.chatBar sendCurrentText];
}

/**
 点击删除
 */
- (void)emojiKeyboardDeleteButtonDown{
    [self.chatBar deleteLastCharacter];
}

#pragma mark - Getter
- (YDMoreKeyboard *)moreKeyboard{
    return [YDMoreKeyboard keyboard];
}

- (YDEmojiKeyboard *)emojiKeyboard{
    return [YDEmojiKeyboard keyboard];
}

@end

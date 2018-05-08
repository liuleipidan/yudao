//
//  YDChatBaseController+ChatBar.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatBaseController+ChatBar.h"
#import "WJCameraViewController.h"

@implementation YDChatBaseController (ChatBar)

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

#pragma mark - YDChatBarDelegate - 
#pragma mark - chatBar状态改变
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
        [self.moreKeyboard showInView:self.view withAnimation:YES];
    }
}

#pragma mark - 输入框高度改变
- (void)chatBar:(YDChatBar *)chatBar didChangeTextViewHeight:(CGFloat)height{
    [self.messageDisplayView scrollToBottomWithAnimation:NO];
}

#pragma mark - 发送文字
- (void)chatBar:(YDChatBar *)chatBar sendText:(NSString *)text{

}
//------------------------ 录音相关代理 ----------------------
#pragma mark - 开始录音
- (void)chatBarStartRecording:(YDChatBar *)chatBar{

}
#pragma mark - 将要取消录音
- (void)chatBarWillCancelRecording:(YDChatBar *)chatBar cancel:(BOOL)cancel{

}

#pragma mark - 已经取消录音
- (void)chatBarDidCancelRecording:(YDChatBar *)chatBar{

}

#pragma mark - 录音结束
- (void)chatBarFinishedRecoding:(YDChatBar *)chatBar{

}

#pragma mark - YDKeyboardDelegate - 基础键盘代理
- (void)chatKeyboardWillShow:(id)keyboard animated:(BOOL)animated{
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}
- (void)chatKeyboardDidShow:(id)keyboard animated:(BOOL)animated{
    if (_curStatus == YDChatBarStatusMore && _lastStatus == YDChatBarStatusEmoji) {
        //隐藏表情键盘
    }
    else if (_curStatus == YDChatBarStatusEmoji && _lastStatus == YDChatBarStatusMore){
        [self.moreKeyboard dismissWithAnimation:YES];
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

#pragma mark - YDMoreKeyboardDelegate - “更多“键盘代理
- (void)moreKeyboard:(YDMoreKeyboard *)keyboard didSelectedItem:(YDMoreKeyboardItem *)item{
    if (item.type == YDMoreKeyboardItemTypeCamera) {
        WJCameraViewController *cameraVC = [[WJCameraViewController alloc] init];
        [cameraVC setTakeImageBlock:^(UIImage *image){
            
        }];
        [self presentViewController:cameraVC animated:YES completion:nil];
    }
    else if (item.type == YDMoreKeyboardItemTypeImage){
        
    }
}

#pragma mark - YDEmojiKeyboardDelegate - “表情”键盘代理



@end

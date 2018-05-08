//
//  YDChatController.m
//  YuDao
//
//  Created by 汪杰 on 17/2/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatController.h"
#import "YDChatController+ChatBar.h"
#import "YDChatController+MessageDisplayView.h"
#import "YDChatController+Proxy.h"
#import "YDMoreKBHelper.h"
#import "YDEmojiKBHelper.h"
#import "YDChatHelper+ConversationRecord.h"

static YDChatController *chatVC;

@interface YDChatController ()

@property (nonatomic, strong) XMPPJID *toJid;

@property (nonatomic, strong) YDMoreKBHelper *moreKBHelper;

@property (nonatomic, strong) YDEmojiKBHelper *emojiKBHelper;

@end

@implementation YDChatController
{
    int _page;
}

+ (YDChatController *)shareChatVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatVC = [[YDChatController alloc] init];
    });
    return chatVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cc_initUI];
    
    [[YDChatHelper sharedInstance] addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)cc_initUI{
    [self.navigationItem setTitle:self.partner.chat_username];
    [self loadKeyboard];
    _moreKBHelper = [[YDMoreKBHelper alloc] init];
    [self.moreKeyboard setMoreKeyboardData:_moreKBHelper.chatMoreKBData];
    
    _emojiKBHelper = [YDEmojiKBHelper sharedInstance];
    [self.emojiKeyboard setEmojiGroupData:_emojiKBHelper.emojiGroupData];
    
    [self.view addSubview:self.messageDisplayView];
    [self.view addSubview:self.chatBar];
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(HEIGHT_CHATBAR);
    }];
    [self.messageDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.chatBar.mas_top);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyboardNotifications];
    
    //关闭键盘的toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //关闭消息菜单
    [[YDChatCellMenuView sharedMenuView] dismiss];
    //停止语音
    [[YDAudioPlayer sharedAudioPlayer] stopPlayingAudio];
    //关闭录音
    [[YDAudioRecorder sharedRecorder] stopRecording];
    
    //开启键盘的toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
}

- (void)dealloc{
    [[YDChatHelper sharedInstance] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSLog(@"dealloc class = %@",NSStringFromClass(self.class));
}

#pragma mark - Public Methods
- (void)setPartner:(YDChatPartner *)partner{
    YDChatMessage *currentLastMsg = nil;
    YDChatMessage *lastMsg = nil;
    if (self.messageDisplayView.data.count > 0) {
        currentLastMsg = self.messageDisplayView.data.lastObject;
    }
    
    lastMsg = [[YDChatHelper sharedInstance] getLastMessageByUid:YDUser_id fid:_partner.chat_userId];
    
    if (_partner && [_partner.chat_userId isEqual:partner.chat_userId] && currentLastMsg && lastMsg && [currentLastMsg.msgId isEqualToString:lastMsg.msgId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageDisplayView scrollToBottomWithAnimation:NO];
        });
        return;
    }
    _partner = partner;
    _chatBar.textView.text = @"";
    //更新消息列表此用户所有消息未已读
    [[YDChatHelper sharedInstance] updateConversationByUid:YDUser_id fid:self.partner.chat_userId];
    
    [self.navigationItem setTitle:_partner.chat_username];
    [self resetChatViewConroller];
}

#pragma mark Getters
- (YDChatBar *)chatBar{
    if (!_chatBar) {
        _chatBar = [[YDChatBar alloc] init];
        [_chatBar setDelegate: self];
        _curStatus = YDChatBarStatusInit;
    }
    return _chatBar;
}

- (YDChatMessageDisplayView *)messageDisplayView{
    if (!_messageDisplayView) {
        _messageDisplayView = [[YDChatMessageDisplayView alloc] init];
        [_messageDisplayView setDelegate:self];
    }
    return _messageDisplayView;
}


- (YDRecorderIndicatorView *)recorderIndicatorView{
    if (!_recorderIndicatorView) {
        _recorderIndicatorView = [[YDRecorderIndicatorView alloc] initWithFrame:CGRectZero];
    }
    return _recorderIndicatorView;
}

@end

//
//  YDChatBaseController.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatBaseController.h"
#import "YDChatBaseController+ChatBar.h"
#import "YDChatBaseController+MessageDisplayView.h"
#import "YDChatBaseController+SystemKeyboard.h"


@interface YDChatBaseController ()

@end

@implementation YDChatBaseController


- (void)loadView{
    [super loadView];
    
    [self.view addSubview:self.messageDisplayView];
    [self.view addSubview:self.chatBar];
    
    [self cbc_addMasonry];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadKeyboard];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //加入系统键盘监听
    [self addSystemKeyboardNotifications];
    
    //关闭键盘的toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //移除系统键盘监听
    [self removeSystemKeyboardNotifications];
    
    //开启键盘的toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

#pragma mark - Private Methods
- (void)cbc_addMasonry{
    
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(TABBAR_HEIGHT);
    }];
    
    [self.messageDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.chatBar.mas_top);
    }];
    
    [self.view layoutIfNeeded];
}

#pragma mark - Getters
- (YDChatBar *)chatBar{
    if (_chatBar == nil) {
        _chatBar = [[YDChatBar alloc] init];
        [_chatBar setDelegate:self];
        _curStatus = YDChatBarStatusInit;
    }
    return _chatBar;
}

- (YDChatMessageDisplayView *)messageDisplayView{
    if (_messageDisplayView == nil) {
        _messageDisplayView = [[YDChatMessageDisplayView alloc] init];
        [_messageDisplayView setDelegate:self];
    }
    return _messageDisplayView;
}

- (YDMoreKeyboard *)moreKeyboard{
    return [YDMoreKeyboard keyboard];
}

- (YDEmojiKeyboard *)emojiKeyboard{
    return [YDEmojiKeyboard keyboard];
}

@end

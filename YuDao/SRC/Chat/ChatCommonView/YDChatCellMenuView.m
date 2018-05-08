//
//  YDChatCellMenuView.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatCellMenuView.h"

@interface YDChatCellMenuView ()

@property (nonatomic, strong) UIMenuController *menuController;

@end

@implementation YDChatCellMenuView

+ (YDChatCellMenuView *)sharedMenuView{
    static YDChatCellMenuView *menuView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuView = [[YDChatCellMenuView alloc] init];
    });
    return menuView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.menuController = [UIMenuController sharedMenuController];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)showInView:(UIView *)view
  isFirstResponder:(BOOL)isFirstResponder
       messageType:(YDMessageType )messageType
              rect:(CGRect )rect
       actionBlcok:(void (^)(YDChatMenuItemType itemType))actionBlock
{
    if (_isShow) {
        return;
    }
    _isShow = YES;
    [self setFrame:view.bounds];
    [view addSubview:self];
    [self setActionBlcok:actionBlock];
    [self setMessageType:messageType];
    
    if (isFirstResponder) {
        [self becomeFirstResponder];
    }
    
    [self.menuController setTargetRect:rect inView:self];
    [self.menuController setMenuVisible:YES animated:YES];

}

- (void)show{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        
        //展示
        
    }];
}

- (void)setMessageType:(YDMessageType)messageType
{
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyButtonDown:)];
    //UIMenuItem *transmit = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transmitButtonDown:)];
    UIMenuItem *del = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteButtonDown:)];
    NSArray *items = nil;
    if (messageType == YDMessageTypeText) {
        items = @[copy,del];
    }else{
        items = @[del];
    }
    [self.menuController setMenuItems:items];
}

- (void)dismiss
{
    NSLog(@"dismiss");
    _isShow = NO;
    if (self.actionBlcok) {
        self.actionBlcok(YDChatMenuItemTypeCancel);
    }
    [self.menuController setMenuVisible:NO animated:YES];
    self.menuController.menuItems = nil;
    [self removeFromSuperview];
}

- (void)testDismiss{
    _isShow = NO;
    [self.menuController setMenuVisible:NO animated:YES];
    self.menuController.menuItems = nil;
    [self removeFromSuperview];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Event Response -
- (void)copyButtonDown:(UIMenuController *)sender
{
    [self p_clickedMenuItemType:YDChatMenuItemTypeCopy];
}

- (void)transmitButtonDown:(UIMenuController *)sender
{
    [self p_clickedMenuItemType:YDChatMenuItemTypeCopy];
}

- (void)collectButtonDown:(UIMenuController *)sender
{
    [self p_clickedMenuItemType:YDChatMenuItemTypeCopy];
}

- (void)deleteButtonDown:(UIMenuController *)sender
{
    [self p_clickedMenuItemType:YDChatMenuItemTypeDelete];
}

#pragma mark - Private Methods -
- (void)p_clickedMenuItemType:(YDChatMenuItemType)type
{
    NSLog(@"dismiss2");
    _isShow = NO;
    self.menuController.menuItems = nil;
    [self removeFromSuperview];
    if (self.actionBlcok) {
        self.actionBlcok(type);
    }
}

@end

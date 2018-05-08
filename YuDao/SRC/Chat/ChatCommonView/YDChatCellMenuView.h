//
//  YDChatCellMenuView.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YDChatMenuItemType) {
    YDChatMenuItemTypeCancel,
    YDChatMenuItemTypeCopy,
    YDChatMenuItemTypeDelete,
};

@interface YDChatCellMenuView : UIView

@property (nonatomic, assign) BOOL isShow;

/**
 记录键盘高度
 */
@property (nonatomic,assign) CGFloat keyboardHeight;

@property (nonatomic, assign) YDMessageType messageType;

@property (nonatomic, copy) void (^actionBlcok)(YDChatMenuItemType itemType);



+ (YDChatCellMenuView *)sharedMenuView;

- (void)showInView:(UIView *)view
  isFirstResponder:(BOOL)isFirstResponder
       messageType:(YDMessageType )messageType
              rect:(CGRect )rect
       actionBlcok:(void (^)(YDChatMenuItemType itemType))actionBlock;

- (void)dismiss;

- (void)testDismiss;

@end

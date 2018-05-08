//
//  YDPublishDynamicController.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDPublishDynamicCell.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "YDLimitTextField.h"
#import "WJCameraViewController.h"
#import "YDKeyboardControl.h"
#import "YDEmojiKeyboard.h"

@class YDPublishDynamicController;
@protocol YDPublishDynamicControllerDelegate <NSObject>

/**
 发布了新动态
 */
- (void)publishDynamicController:(YDPublishDynamicController *)controller publishedNewDynamic:(NSNumber *)userId;

@end

@interface YDPublishDynamicController : YDViewController

@property (nonatomic, weak  ) id<YDPublishDynamicControllerDelegate> delegate;

@property (nonatomic, strong) YDPublishDynamicModel *model;

@property (nonatomic, strong) WJCameraViewController *cameraVC;

@property (nonatomic, strong) YDTableView *tableView;

@property (nonatomic, weak  ) UIView *inputingView;

@property (nonatomic, strong) YDKeyboardControl *keyboardControl;

@property (nonatomic, strong) YDEmojiKeyboard *emojiKeyboard;

@end

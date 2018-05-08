//
//  YDEmojiKeyboard.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBaseKeyboard.h"
#import "YDEmojiKeyboardDelegate.h"
#import "YDEmojiGroupDisplayView.h"
#import "YDEmojiControl.h"

@interface YDEmojiKeyboard : YDBaseKeyboard<YDEmojiControlDelegate>

@property (nonatomic, weak  ) id<YDEmojiKeyboardDelegate> delegate;

@property (nonatomic, strong) YDEmojiGroupDisplayView *displayView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) YDEmojiControl *emojiControl;

@property (nonatomic, weak  ) NSMutableArray *emojiGroupData;

@property (nonatomic, copy  ) NSString *doneButtonTitle;

+ (YDEmojiKeyboard *)keyboard;


@end

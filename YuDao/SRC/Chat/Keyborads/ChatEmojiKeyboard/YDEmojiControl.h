//
//  YDEmojiControl.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/8.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YDEmojiControlDelegate <NSObject>

- (void)emojiControlClickedSendButton:(UIButton *)sender;

@end

@interface YDEmojiControl : UIView

@property (nonatomic, weak  ) id<YDEmojiControlDelegate> delegate;

@property (nonatomic, strong) UIButton *sendButton;

@end

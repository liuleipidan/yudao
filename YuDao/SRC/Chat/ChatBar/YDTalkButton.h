//
//  YDTalkButton.h
//  YuDao
//
//  Created by 汪杰 on 17/2/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDTalkButton : UIView

@property (nonatomic, strong) NSString *normalTitle;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) NSString *highlightTitle;

@property (nonatomic, strong) UIColor *highlightColor;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setTouchBeginAction:(void (^)())touchBegin
      willTouchCancelAction:(void (^)(BOOL cancel))willTouchCancel
             touchEndAction:(void (^)())touchEnd
          touchCancelAction:(void (^)())touchCancel;

@end

//
//  UITextField+Extension.m
//  YuDao
//
//  Created by 汪杰 on 17/3/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

//限制长度,到达长度后是否隐藏键盘
- (void)limtTextLength:(NSInteger )limit hideKeyboard:(BOOL )hideKeyboard{
    if (limit == 0) {
        return;
    }
    NSString *toString = self.text;
    NSString *lang = [self.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {//简体中文输入
        //获取高亮部分
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toString.length > limit) {
                self.text = [toString substringFromIndex:limit];
            }
        }
    }
    else{// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toString.length >= limit){
            NSRange rangeIndex = [toString rangeOfComposedCharacterSequenceAtIndex:limit];
            if (rangeIndex.length == 1){
                self.text = [toString substringToIndex:limit];
            }else{
                NSRange rangeRange = [toString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, limit)];
                self.text = [toString substringWithRange:rangeRange];
            }
            hideKeyboard == YES ? [self resignFirstResponder] : NO;
        }
    }
}

@end

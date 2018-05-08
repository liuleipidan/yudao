//
//  YDLimitTextField.m
//  YuDao
//
//  Created by 汪杰 on 17/2/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDLimitTextField.h"

@interface YDLimitTextField()

/**
 上一个text值,暂存来确认是否需要调起回调
 */
@property (nonatomic, copy  ) NSString *oldText;


@end

@implementation YDLimitTextField

- (instancetype)init{
    return [self initWithFrame:CGRectZero limit:0];
}

- (instancetype)initWithLimit:(NSInteger )limit{
    return [self initWithFrame:CGRectZero limit:limit];
}

- (instancetype)initWithFrame:(CGRect)frame limit:(NSInteger )limt{
    if(self = [super initWithFrame:frame]){
        _limit = limt;
       [self addNotification];
    }
    
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotification{
    [YDNotificationCenter addObserver:self selector:@selector(lt_textFidleEditChanged:) name:UITextFieldTextDidChangeNotification object:self];
    
}

- (void)lt_textFidleEditChanged:(NSNotification *)noti{
    UITextField *textField = (UITextField *)noti.object;
    NSString *toBeString = textField.text;
    //不限制直接返回
    if (self.limit == 0) {
        if (self.textDidChangeBlock) {
            self.textDidChangeBlock(textField.text);
        }
        return;
    }
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position || !selectedRange)
    {
        if (toBeString.length > _limit)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_limit];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:_limit];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _limit)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
    if (self.textDidChangeBlock && ![self.oldText isEqualToString:textField.text]) {
        self.textDidChangeBlock(textField.text);
    }
    
    self.oldText = textField.text;
}

//内容改变
- (void)textFiledEditChanged:(NSNotification *)noti{
    if (_limit == 0) {
        return;
    }
    UITextField *textField = (UITextField *)noti.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]){// 简体中文输入
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position){
            if (toBeString.length > _limit)
            {
                textField.text = [toBeString substringToIndex:_limit];
            }
        }
    }
    else{// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > _limit){
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_limit];
            if (rangeIndex.length == 1){
                textField.text = [toBeString substringToIndex:_limit];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _limit)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
            _hideKeyboard == YES ? [textField resignFirstResponder] : NO;
        }
    }
    
    if (_textDidChangeBlock) {
        _textDidChangeBlock(textField.text);
    }
}

@end

//
//  YDKeyboardControl.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDKeyboardControl.h"

@interface YDKeyboardControl()

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIButton *emojiBtn;

@property (nonatomic, strong) UIView *toolView;

@end

@implementation YDKeyboardControl

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _status = YDKeyboardControlStatusInit;
        self.backgroundColor = [UIColor grayBackgoundColor];
        
        [self yd_addSubviews:@[self.toolView,self.emojiBtn,self.topLine]];
        
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(KeyboardControlToolHeight);
        }];
        
        [self.emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_toolView);
            make.left.equalTo(_toolView.mas_left).offset(14);
            make.width.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)dismissWithAnimated:(BOOL)animated{
    if (self.superview == nil) {
        return;
    }
    _status = YDKeyboardControlStatusSystem;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }];
    }
    else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

- (void)setStatus:(YDKeyboardControlStatus)status{
    _status = status;
    if (status == YDKeyboardControlStatusEmoji) {
        self.emojiBtn.selected = YES;
    }
    else if (status == YDKeyboardControlStatusSystem){
        self.emojiBtn.selected = NO;
    }
}

- (void)emojiButtonDown:(UIButton *)emojiBtn{
    emojiBtn.selected = !emojiBtn.selected;
    _status = emojiBtn.isSelected ? YDKeyboardControlStatusEmoji : YDKeyboardControlStatusSystem;
    if (_delegate && [_delegate respondsToSelector:@selector(keyboardControl:didDidChangeStatus:)]) {
        [_delegate keyboardControl:self didDidChangeStatus:_status];
    }
}

#pragma mark - Getters
- (UIView *)topLine{
    if (_topLine == nil) {
        _topLine = [UIView new];
        _topLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLine;
}
- (UIView *)toolView{
    if (_toolView == nil) {
        _toolView = [UIView new];
        _toolView.backgroundColor = [UIColor whiteColor];
    }
    return _toolView;
}
- (UIButton *)emojiBtn{
    if (_emojiBtn == nil) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiBtn setImage:@"chat_toolbar_emoji" imageSelected:@"chat_toolbar_keyboard"];
        [_emojiBtn addTarget:self action:@selector(emojiButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiBtn;
}

@end

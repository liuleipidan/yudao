//
//  YDTextDisplayView.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTextDisplayView.h"

#define     WIDTH_TEXTVIEW          SCREEN_WIDTH * 0.94

@interface YDTextDisplayView ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation YDTextDisplayView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)showInView:(UIView *)view
          attrText:(NSAttributedString *)attrText
         animation:(BOOL)animation{
    [view addSubview:self];
    [self setFrame:view.bounds];
    [self setAttrString:attrText];
    [self setAlpha:0];
    [UIView animateWithDuration:0.1 animations:^{
        [self setAlpha:1.0];
    } completion:^(BOOL finished) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
#pragma clang diagnostic pop
    }];
}

- (void)setAttrString:(NSAttributedString *)attrString
{
    _attrString = attrString;
    NSMutableAttributedString *mutableAttrString = [[NSMutableAttributedString alloc] initWithAttributedString:attrString];
    [mutableAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.0f] range:NSMakeRange(0, attrString.length)];
    [self.textView setAttributedText:mutableAttrString];
    CGSize size = [self.textView sizeThatFits:CGSizeMake(WIDTH_TEXTVIEW, MAXFLOAT)];
    size.height = size.height > SCREEN_HEIGHT ? SCREEN_HEIGHT : size.height;
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
}

- (void)dismiss{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
#pragma clang diagnostic pop

    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Getter
- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [_textView setTextAlignment:NSTextAlignmentCenter];
        [_textView setEditable:NO];
    }
    return _textView;
}

@end

//
//  TLChatBar.m
//  TLChat
//
//  Created by 李伯坤 on 16/2/15.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "YDChatBar.h"
#import "YDTalkButton.h"
#import "YDChatCellMenuView.h"

@interface YDChatBar () <UITextViewDelegate>
{
    NSString *kVoiceImage;
    NSString *kVoiceImageHL;
    NSString *kEmojiImage;
    NSString *kEmojiImageHL;
    NSString *kMoreImage;
    NSString *kMoreImageHL;
    NSString *kKeyboardImage;
    NSString *kKeyboardImageHL;
}

@property (nonatomic, strong) UIButton *modeButton;

@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, strong) YDTalkButton *talkButton;

@property (nonatomic, strong) UIButton *emojiButton;

@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation YDChatBar

- (id)init
{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor colorGrayForChatBar]];
        [self p_initImage];
        
        [self addSubview:self.modeButton];
        [self addSubview:self.voiceButton];
        [self addSubview:self.textView];
        [self addSubview:self.talkButton];
        [self addSubview:self.emojiButton];
        [self addSubview:self.moreButton];
        
        [self p_addMasonry];
        
        self.status = YDChatBarStatusInit;
    }
    return self;
}

- (void)dealloc
{
#ifdef DEBUG_MEMERY
    NSLog(@"dealloc ChatBar");
#endif
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

#pragma mark - Public Methods
- (void)sendCurrentText{
    if (self.textView.text.length > 0) {// send Text
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:sendText:)]) {
            [_delegate chatBar:self sendText:self.textView.text];
        }
    }
    [self.textView setText:@""];
    [self p_reloadTextViewWithAnimation:YES];
}

- (void)addEmojiString:(NSString *)emojiString
{
    NSString *str = [NSString stringWithFormat:@"%@%@", self.textView.text, emojiString];
    [self.textView setText:str];
    [self p_reloadTextViewWithAnimation:YES];
}

- (void)deleteLastCharacter
{
    if([self textView:self.textView shouldChangeTextInRange:NSMakeRange(self.textView.text.length - 1, 1) replacementText:@""]){
        [self.textView deleteBackward];
    }
}

- (void)setActivity:(BOOL)activity
{
    _activity = activity;
    if (activity) {
        [self.textView setTextColor:[UIColor blackColor]];
    }
    else {
        [self.textView setTextColor:[UIColor grayColor]];
    }
}

- (BOOL)isFirstResponder
{
    if (self.status == YDChatBarStatusEmoji || self.status == YDChatBarStatusKeyboard) {
        return YES;
    }
    return NO;
}

- (BOOL)resignFirstResponder
{
    [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
    [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
    if (self.status == YDChatBarStatusKeyboard) {
        [self.textView resignFirstResponder];
        self.status = YDChatBarStatusInit;
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.delegate chatBar:self changeStatusFrom:self.status to:YDChatBarStatusInit];
        }
    }
    
    return [super resignFirstResponder];
}

#pragma mark - Delegate -
//MARK: UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self setActivity:YES];
    if (self.status != YDChatBarStatusKeyboard) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.delegate chatBar:self changeStatusFrom:self.status to:YDChatBarStatusKeyboard];
        }
        if (self.status == YDChatBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        }
        if (self.status == YDChatBarStatusMore) {
            [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        }
        self.status = YDChatBarStatusKeyboard;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.textView.overrideNext isKindOfClass:[YDChatCellMenuView class]]) {
        self.textView.overrideNext = nil;
        [[YDChatCellMenuView sharedMenuView] testDismiss];
    }
    
    if ([text isEqualToString:@"\n"]){
        [self sendCurrentText];
        return NO;
    }
    else if (textView.text.length > 0 && [text isEqualToString:@""]) {       // delete
        if ([textView.text characterAtIndex:range.location] == ']') {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            while (location != 0) {
                location --;
                length ++ ;
                char c = [textView.text characterAtIndex:location];
                if (c == '[') {
                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
                    [self p_reloadTextViewWithAnimation:YES];
                    return NO;
                }
                else if (c == ']') {
                    return YES;
                }
            }
        }
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self p_reloadTextViewWithAnimation:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self p_reloadTextViewWithAnimation:YES];
}

#pragma mark ================== Events ==================
- (void)modeButtonDown{
    if (self.status == YDChatBarStatusEmoji) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.delegate chatBar:self changeStatusFrom:self.status to:YDChatBarStatusInit];
        }
        [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        self.status = YDChatBarStatusInit;
    }
    else if (self.status == YDChatBarStatusMore){
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.delegate chatBar:self changeStatusFrom:self.status to:YDChatBarStatusInit];
        }
        [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        self.status = YDChatBarStatusInit;
    }
}
#pragma mark - voice button action
static NSString *textRec = @"";
- (void)voiceButtonDown{
    [self.textView resignFirstResponder];
    // 开始文字输入
    if (self.status == YDChatBarStatusVoice) {
        if (textRec.length > 0) {
            [self.textView setText:textRec];
            textRec = @"";
            [self p_reloadTextViewWithAnimation:YES];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.delegate chatBar:self changeStatusFrom:self.status to:YDChatBarStatusKeyboard];
        }
        [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
        [self.textView becomeFirstResponder];
        [self.textView setHidden:NO];
        [self.talkButton setHidden:YES];
        self.status = YDChatBarStatusKeyboard;
    }
    else {// 开始语音
        if (self.textView.text.length > 0) {
            textRec = self.textView.text;
            self.textView.text = @"";
            [self p_reloadTextViewWithAnimation:YES];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.delegate chatBar:self changeStatusFrom:self.status to:YDChatBarStatusVoice];
        }
        if (self.status == YDChatBarStatusKeyboard) {
            [self.textView resignFirstResponder];
        }
        else if (self.status == YDChatBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        }
        else if (self.status == YDChatBarStatusMore) {
            [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        }
        [self.talkButton setHidden:NO];
        [self.textView setHidden:YES];
        [self.voiceButton setImage:kKeyboardImage imageHL:kKeyboardImageHL];
        self.status = YDChatBarStatusVoice;
    }
}
#pragma mark - emoji button action
- (void)emojiButtonDown{
    // 开始文字输入
    if (self.status == YDChatBarStatusEmoji) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.delegate chatBar:self changeStatusFrom:self.status to:YDChatBarStatusKeyboard];
        }
        [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        [self.textView becomeFirstResponder];
        self.status = YDChatBarStatusKeyboard;
    }
    else { // 打开表情键盘
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.delegate chatBar:self changeStatusFrom:self.status to:YDChatBarStatusEmoji];
        }
        if (self.status == YDChatBarStatusVoice) {
            [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
            [self.talkButton setHidden:YES];
            [self.textView setHidden:NO];
        }
        else if (self.status == YDChatBarStatusMore){
            [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        }
        [self.emojiButton setImage:kKeyboardImage imageHL:kKeyboardImageHL];
        [self.textView resignFirstResponder];
        self.status = YDChatBarStatusEmoji;
    }
}
#pragma mark - more button action
- (void)moreButtonDown{
    //开始文字输入
    if (self.status == YDChatBarStatusMore) {
        if (self.delegate && self.delegate && [self.delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.delegate chatBar:self changeStatusFrom:self.status to:YDChatBarStatusKeyboard];
        }
        [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        [self.textView becomeFirstResponder];
        self.status = YDChatBarStatusKeyboard;
    }
    else{//打开更多键盘
        if (self.delegate && self.delegate && [self.delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.delegate chatBar:self changeStatusFrom:self.status to:YDChatBarStatusMore];
        }
        if (self.status == YDChatBarStatusVoice) {
            [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
            self.talkButton.hidden = YES;
            self.textView.hidden = NO;
        }
        else if (self.status == YDChatBarStatusEmoji){
            [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        }
        [self.moreButton setImage:kKeyboardImage imageHL:kKeyboardImageHL];
        [self.textView resignFirstResponder];
        self.status = YDChatBarStatusMore;
    }
}

#pragma mark - Private Methods
- (void)p_reloadTextViewWithAnimation:(BOOL)animation
{
    CGFloat textHeight = [self.textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)].height;
    CGFloat height = textHeight > HEIGHT_CHATBAR_TEXTVIEW ? textHeight : HEIGHT_CHATBAR_TEXTVIEW;
    height = (textHeight <= HEIGHT_MAX_CHATBAR_TEXTVIEW ? textHeight : HEIGHT_MAX_CHATBAR_TEXTVIEW);
    [self.textView setScrollEnabled:textHeight > height];
    if (height != self.textView.height) {
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(height);
                }];
                if (self.superview) {
                    [self.superview layoutIfNeeded];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeTextViewHeight:)]) {
                    [self.delegate chatBar:self didChangeTextViewHeight:self.textView.height];
                }
            } completion:^(BOOL finished) {
                if (textHeight > height) {
                    [self.textView setContentOffset:CGPointMake(0, textHeight - height) animated:YES];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeTextViewHeight:)]) {
                    [self.delegate chatBar:self didChangeTextViewHeight:height];
                }
            }];
        }
        else {
            [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            if (self.superview) {
                [self.superview layoutIfNeeded];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeTextViewHeight:)]) {
                [self.delegate chatBar:self didChangeTextViewHeight:height];
            }
            if (textHeight > height) {
                [self.textView setContentOffset:CGPointMake(0, textHeight - height) animated:YES];
            }
        }
    }
    else if (textHeight > height) {
        if (animation) {
            CGFloat offsetY = self.textView.contentSize.height - self.textView.height;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.textView setContentOffset:CGPointMake(0, offsetY) animated:YES];
            });
        }
        else {
            [self.textView setContentOffset:CGPointMake(0, self.textView.contentSize.height - self.textView.height) animated:NO];
        }
    }
}

- (void)p_addMasonry
{
    [self.modeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self).mas_offset(-4);
        make.width.mas_equalTo(0);
    }];
    
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).mas_offset(IS_IPHONEX ? -20 : -10);
        make.left.equalTo(self.modeButton.mas_right).mas_offset(1);
        make.width.mas_equalTo(38);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.mas_equalTo(self.voiceButton);
        make.right.mas_equalTo(self).mas_offset(-1);
        make.height.equalTo(self.moreButton.mas_width);
    }];
    
    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.mas_equalTo(self.voiceButton);
        make.right.mas_equalTo(self.moreButton.mas_left);
        make.height.equalTo(self.emojiButton.mas_width);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(7);
        make.bottom.equalTo(self).mas_offset(-7);
        make.left.equalTo(self.voiceButton.mas_right).mas_offset(4);
        make.right.equalTo(self.emojiButton.mas_left).mas_offset(-4);
        make.height.mas_equalTo(HEIGHT_CHATBAR_TEXTVIEW);
    }];
    
    [self.talkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.textView);
        make.size.equalTo(self.textView);
    }];
}

- (void)p_initImage
{
    kVoiceImage = @"chat_toolbar_voice";
    kVoiceImageHL = @"chat_toolbar_voice";
    kEmojiImage = @"chat_toolbar_emoji";
    kEmojiImageHL = @"chat_toolbar_emoji";
    kMoreImage = @"chat_toolbar_more";
    kMoreImageHL = @"chat_toolbar_more";
    kKeyboardImage = @"chat_toolbar_keyboard";
    kKeyboardImageHL = @"chat_toolbar_keyboard";
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorGrayLine].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, SCREEN_WIDTH, 0);
    CGContextStrokePath(context);
}

#pragma mark - Getter
- (UIButton *)modeButton
{
    if (_modeButton == nil) {
        _modeButton = [[UIButton alloc] init];
        //[_modeButton setImage:[UIImage imageNamed:@"chat_toolbar_texttolist"] imageHL:[UIImage imageNamed:@"chat_toolbar_texttolist_HL"]];
        [_modeButton addTarget:self action:@selector(modeButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeButton;
}

- (UIButton *)voiceButton
{
    if (_voiceButton == nil) {
        _voiceButton = [[UIButton alloc] init];
        [_voiceButton setImage:kVoiceImage imageHL:kVoiceImage];
        [_voiceButton addTarget:self action:@selector(voiceButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[YDChatTextView alloc] init];
        [_textView setFont:[UIFont systemFontOfSize:16.0f]];
        [_textView setReturnKeyType:UIReturnKeySend];
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setBorderWidth:BORDER_WIDTH_1PX];
        [_textView.layer setBorderColor:[UIColor colorWithWhite:0.0 alpha:0.3].CGColor];
        [_textView.layer setCornerRadius:4.0f];
        [_textView setDelegate:self];
        [_textView setScrollsToTop:NO];
    }
    return _textView;
}

- (YDTalkButton *)talkButton
{
    if (_talkButton == nil) {
        _talkButton = [[YDTalkButton alloc] init];
        [_talkButton setHidden:YES];
        __weak typeof(self) weakSelf = self;
        [_talkButton setTouchBeginAction:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarStartRecording:)]) {
                [weakSelf.delegate chatBarStartRecording:weakSelf];
            }
        } willTouchCancelAction:^(BOOL cancel) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarWillCancelRecording:cancel:)]) {
                [weakSelf.delegate chatBarWillCancelRecording:weakSelf cancel:cancel];
            }
        } touchEndAction:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarFinishedRecoding:)]) {
                [weakSelf.delegate chatBarFinishedRecoding:weakSelf];
            }
        } touchCancelAction:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarDidCancelRecording:)]) {
                [weakSelf.delegate chatBarDidCancelRecording:weakSelf];
            }
        }];
    }
    return _talkButton;
}

- (UIButton *)emojiButton
{
    if (_emojiButton == nil) {
        _emojiButton = [[UIButton alloc] init];
        [_emojiButton setImage:kEmojiImage imageHL:kEmojiImage];
        [_emojiButton addTarget:self action:@selector(emojiButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (UIButton *)moreButton
{
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:kMoreImage imageHL:kMoreImage];
        [_moreButton addTarget:self action:@selector(moreButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (NSString *)curText
{
    return self.textView.text;
}

@end

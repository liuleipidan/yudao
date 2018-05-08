//
//  YDEmojiKeyboard.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDEmojiKeyboard.h"
#import "YDEmojiKeyboard+DisplayView.h"

static YDEmojiKeyboard *emojiKB;

@implementation YDEmojiKeyboard

+ (YDEmojiKeyboard *)keyboard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojiKB = [[YDEmojiKeyboard alloc] init];
    });
    return emojiKB;
}
- (id)init
{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor colorGrayForChatBar]];
        [self addSubview:self.displayView];
        [self addSubview:self.pageControl];
        [self addSubview:self.emojiControl];
        [self p_addMasonry];
    }
    return self;
}

- (void)setEmojiGroupData:(NSMutableArray *)emojiGroupData
{
    _emojiGroupData = emojiGroupData;
    [self.displayView setData:emojiGroupData];
}

- (void)setDoneButtonTitle:(NSString *)doneButtonTitle{
    _doneButtonTitle = doneButtonTitle;
    [self.emojiControl.sendButton setTitle:doneButtonTitle forState:0];
}

#pragma mark - # Public Methods
- (void)reset
{
    //    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, self.collectionView.width, self.collectionView.height) animated:NO];
}

#pragma mark - # Event Response
- (void)pageControlChanged:(UIPageControl *)pageControl
{
    //    [self.collectionView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * pageControl.currentPage, 0, SCREEN_WIDTH, HEIGHT_PAGECONTROL) animated:YES];
}

#pragma mark - # Private Methods
- (void)p_addMasonry
{
    [self.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.pageControl.mas_top);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.emojiControl.mas_top);
        make.height.mas_equalTo(20);
    }];
    
    [self.emojiControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(37);
    }];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // 顶部直线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorGrayLine].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, SCREEN_WIDTH, 0);
    CGContextStrokePath(context);
}

#pragma mark - YDEmojiControlDelegate
- (void)emojiControlClickedSendButton:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(emojiKeyboardSendButtonDown)]) {
        [_delegate emojiKeyboardSendButtonDown];
    }
}

#pragma mark - # Getter
- (YDEmojiGroupDisplayView *)displayView
{
    if (_displayView == nil) {
        _displayView = [[YDEmojiGroupDisplayView alloc] init];
        [_displayView setDelegate:self];
    }
    return _displayView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.centerX = self.centerX;
        [_pageControl setPageIndicatorTintColor:[UIColor colorGrayLine]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
        
        [_pageControl setNumberOfPages:2];
    }
    return _pageControl;
}

- (YDEmojiControl *)emojiControl{
    if (_emojiControl == nil) {
        _emojiControl = [[YDEmojiControl alloc] initWithFrame:CGRectZero];
        _emojiControl.delegate = self;
    }
    return _emojiControl;
}

@end

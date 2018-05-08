//
//  YDTalkButton.m
//  YuDao
//
//  Created by 汪杰 on 17/2/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTalkButton.h"

@interface YDTalkButton()

@property (nonatomic, strong) void (^touchBegin)(void);
@property (nonatomic, strong) void (^touchMove)(BOOL cancel);
@property (nonatomic, strong) void (^touchCancel)(void);
@property (nonatomic, strong) void (^touchEnd)(void);

@end

@implementation YDTalkButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setNormalTitle:@"按住 说话"];
        [self setHighlightTitle:@"松开 结束"];
        [self setCancelTitle:@"松开 取消"];
        [self setHighlightColor:[UIColor colorWithWhite:0.0 alpha:0.1]];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4.0f];
        [self.layer setBorderWidth:BORDER_WIDTH_1PX];
        [self.layer setBorderColor:[UIColor colorWithWhite:0.0 alpha:0.3].CGColor];
        
        [self addSubview:self.titleLabel];
        [self p_addMasonry];
    }
    return self;
}

#pragma mark - # Public Methods
- (void)setTouchBeginAction:(void (^)())touchBegin willTouchCancelAction:(void (^)(BOOL))willTouchCancel touchEndAction:(void (^)())touchEnd touchCancelAction:(void (^)())touchCancel
{
    self.touchBegin = touchBegin;
    self.touchMove = willTouchCancel;
    self.touchCancel= touchCancel;
    self.touchEnd = touchEnd;
}

#pragma mark - # Event Response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesBegan");
    [self setBackgroundColor:self.highlightColor];
    [self.titleLabel setText:self.highlightTitle];
    if (self.touchBegin) {
        self.touchBegin();
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesMoved");
    if (self.touchMove) {
        CGPoint curPoint = [[touches anyObject] locationInView:self];
        BOOL moveIn = curPoint.x >= 0 && curPoint.x <= self.width && curPoint.y >= 0 && curPoint.y <= self.height;
        [self.titleLabel setText:(moveIn ? self.highlightTitle : self.cancelTitle)];
        self.touchMove(!moveIn);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesEnded");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setText:self.normalTitle];
    });
    
    
    CGPoint curPoint = [[touches anyObject] locationInView:self];
    BOOL moveIn = curPoint.x >= 0 && curPoint.x <= self.width && curPoint.y >= 0 && curPoint.y <= self.height;
    if (moveIn && self.touchEnd) {
        self.touchEnd();
    }
    else if (!moveIn && self.touchCancel) {
        self.touchCancel();
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesCancelled");
    [self setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setText:self.normalTitle];
    if (self.touchCancel) {
        self.touchCancel();
    }
}

#pragma mark - # Private Methods
- (void)p_addMasonry
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - # Getter
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_titleLabel setTextColor:[UIColor grayTextColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setText:self.normalTitle];
    }
    return _titleLabel;
}

@end

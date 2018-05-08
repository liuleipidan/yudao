//
//  YDIgnoreView.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDIgnoreView.h"

#define kRowHeight 50.0f

#define kAnimateDuration  0.3f

@interface YDIgnoreCell : UITableViewCell

@property (nonatomic, strong) UIButton *icon;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *line;

@end

@implementation YDIgnoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setup{
    _icon = [[UIButton alloc] init];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = YDColorString(@"#464646");
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    [self.contentView addSubview:_icon];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_line];
}

@end

@interface YDIgnoreView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UITableView *actionSheetView;

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic,copy) void (^clickedBlock) (NSUInteger index);

@end

@implementation YDIgnoreView

- (instancetype)initWithData:(NSArray *)data rect:(CGRect )rect clickedBlock:(void (^)(NSUInteger index))block{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.rect = rect;
        self.data = data;
        self.clickedBlock = block;
        self.alpha = 0.0f;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        //[self setBackgroundColor:[UIColor clearColor]];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //_bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        
        [self addSubview:_bgView];
        
        CGFloat height = data.count * kRowHeight + 10;
        CGFloat y;
        if ([self isTopFromFrame:self.rect height:height]) {
            y = self.rect.origin.y - height + 15;
        }else{
            y = CGRectGetMaxY(self.rect)-5;
        }
        CGRect asFrame = CGRectMake(26, y, SCREEN_WIDTH-26-10, height-10);
        _actionSheetView = [[UITableView alloc] initWithFrame:asFrame];
        _actionSheetView.dataSource = self;
        _actionSheetView.delegate = self;
        _actionSheetView.rowHeight = kRowHeight;
        _actionSheetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _actionSheetView.backgroundColor = [UIColor whiteColor];
        _actionSheetView.layer.cornerRadius = 4.0f;
        [_actionSheetView registerClass:[YDIgnoreCell class] forCellReuseIdentifier:@"YDIgnoreCell"];
        _actionSheetView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _actionSheetView.scrollEnabled = NO;
        [self addSubview:_actionSheetView];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGFloat startX = CGRectGetMaxX(self.actionSheetView.frame) - 11;
    CGFloat height = self.data.count * kRowHeight + 10;
    BOOL isTop = [self isTopFromFrame:self.rect height:height];
    CGFloat startY;
    CGFloat endY;
    if (isTop) {
        startY = CGRectGetMaxY(self.actionSheetView.frame) + 6;
        endY = CGRectGetMaxY(self.actionSheetView.frame);
    }else{
        startY = self.actionSheetView.frame.origin.y - 6;
        endY = self.actionSheetView.frame.origin.y;
    }
    
    CGFloat width = 5;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, startX + width, endY);
    CGContextAddLineToPoint(context, startX - width, endY);
    CGContextClosePath(context);
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}

+ (void)showAtFrame:(CGRect )rect type:(YDIgnoreViewType)type clickedBlock:(void (^)(NSUInteger index))block{
    NSDictionary *dic1 = @{@"iconPath":@"homePage_message_ignore",@"title":@"忽略此动态"};
    NSDictionary *dic2 = @{@"iconPath":@"homePage_message_forbid",@"title":@"不再接受这条动态"};
    NSArray *data = @[];
    if (type == YDIgnoreViewTypeDefault) {
        data = @[dic1];
    }
    else if (type == YDIgnoreViewTypeTwoRow){
        data = @[dic1,dic2];
    }
    
    YDIgnoreView *igView = [[YDIgnoreView alloc] initWithData:data rect:rect clickedBlock:block];
    [igView show];
}

- (BOOL)isTopFromFrame:(CGRect)rect height:(CGFloat )height{
    CGFloat topHeight = height + 64 + 20;
    if (rect.origin.y >= topHeight) {
        return YES;
    }
    return NO;
}

- (void)show{
    [self setNeedsDisplay];
    [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        
        [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0f;
            //self.actionSheetView.frame = CGRectMake(0, self.frame.size.height-self.actionSheetView.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
        } completion:nil];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:kAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0f;
        //self.actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.bgView];
    if (!CGRectContainsPoint(self.actionSheetView.frame, point))
    {
        [self dismiss];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDIgnoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDIgnoreCell"];
    if (indexPath.row == self.data.count - 1) {
        cell.line.hidden = YES;
    }
    NSDictionary *dic = self.data[indexPath.row];
    NSString *iconPath = [dic valueForKey:@"iconPath"];
    NSString *title = [dic valueForKey:@"title"];
    [cell.icon setImage:[UIImage imageNamed:iconPath] forState:0];
    cell.titleLabel.text = title;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickedBlock) {
        self.clickedBlock(indexPath.row + 1);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"YDIgnoreView dealloc");
#endif
}

@end

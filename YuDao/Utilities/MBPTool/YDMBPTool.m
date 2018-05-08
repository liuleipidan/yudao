//
//  YDMBPTool.m
//  YuDao
//
//  Created by 汪杰 on 16/11/17.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDMBPTool.h"

@interface YDMBPTool()<UIGestureRecognizerDelegate,MBProgressHUDDelegate>

@property (nonatomic, copy) void (^hideBlock) (void);

@property (nonatomic, copy) NSString *labelText;

//点击屏幕隐藏HUD
@property (nonatomic, strong) UITapGestureRecognizer *hideHUDTap;

//展示类型
@property (nonatomic,assign) YDMBPToolShowType showType;

@end

@implementation YDMBPTool

//hud的父视图
UIView *hudAddedView;

static YDMBPTool *hudManager = nil;

#pragma mark - 单例
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hudManager = [[self alloc] init];
    });
    return hudManager;
}

#pragma mark - 初始化
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - 纯文字
+ (MBProgressHUD *)showText:(NSString *)text{
    return [YDMBPTool showText:text inView:nil time:kHUDTextTime hideBlock:nil];
}

+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view{
    return [YDMBPTool showText:text inView:view time:kHUDTextTime hideBlock:nil];
}

+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view time:(NSTimeInterval)time{
    return [YDMBPTool showText:text inView:view time:time hideBlock:nil];
}

+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view time:(NSTimeInterval)time hideBlock:(MBPHideBlock)hideBlock{
    //隐藏前一个HUD
    [YDMBPTool hideAlert];
    
    //默认不可以点击隐藏
    [YDMBPTool shareManager].tapHide = NO;
    [YDMBPTool shareManager].showType = YDMBPToolShowTypeText;
    hudManager.hideBlock = hideBlock;
    
    //若父视图为空，添加到主window上
    view = view == nil ? [UIApplication sharedApplication].keyWindow : view;
    
    //暂存hud的父视图
    hudAddedView = view;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text == nil ? @"" : text;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
    
    //暂时注释掉，会影响到图+文显示时提前调用hideBlock
    //hud.delegate = hudManager;
    
    [hudManager addGestureInView:hud];
    
    return hud;
}

#pragma mark - 带菊花的加载中视图
+ (MBProgressHUD *)showLoading{
    return [YDMBPTool showLoadingInView:nil title:nil time:0 hideBlock:nil];
}

+ (MBProgressHUD *)showLoadingInView:(UIView *)view{
    return [YDMBPTool showLoadingInView:view title:nil time:0 hideBlock:nil];
}

+ (MBProgressHUD *)showLoadingInView:(UIView *)view title:(NSString *)title{
    return [YDMBPTool showLoadingInView:view title:title time:0 hideBlock:nil];
}

+ (MBProgressHUD *)showLoadingInView:(UIView *)view title:(NSString *)title time:(NSTimeInterval)time{
    return [YDMBPTool showLoadingInView:view title:title time:time hideBlock:nil];
}

+ (MBProgressHUD *)showLoadingInView:(UIView *)view title:(NSString *)title time:(NSTimeInterval)time hideBlock:(MBPHideBlock)hideBlock{
    
    //隐藏前一个HUD
    [YDMBPTool hideAlert];
    
    //默认不可以点击隐藏
    [YDMBPTool shareManager].tapHide = NO;
    [YDMBPTool shareManager].showType = YDMBPToolShowTypeLoading;
    hudManager.hideBlock = hideBlock;
    
    //若父视图为空，添加到主window上
    view = view == nil ? [UIApplication sharedApplication].keyWindow : view;
    
    //暂存hud的父视图
    hudAddedView = view;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.labelText = title;
    hud.removeFromSuperViewOnHide = YES;
    
    //暂时注释掉，会影响到图+文显示时提前调用hideBlock
    //hud.delegate = hudManager;
    
    [view addSubview:hud];
    
    [hud show:YES];
    
    if (time > 0) {
        [hud hide:YES afterDelay:time];
    }
    [hudManager addGestureInView:hud];
    
    return hud;
}

#pragma mark - 无背景框菊花
+ (MBProgressHUD *)showNoBackgroundViewInView:(UIView *)view{
    return [YDMBPTool showNoBackgroundViewInView:view offset:CGPointZero indicatorStyle:UIActivityIndicatorViewStyleWhite];
}

+ (MBProgressHUD *)showNoBackgroundViewInView:(UIView *)view offset:(CGPoint)offset{
    return [YDMBPTool showNoBackgroundViewInView:view offset:offset indicatorStyle:UIActivityIndicatorViewStyleWhite];
}

+ (MBProgressHUD *)showNoBackgroundViewInView:(UIView *)view offset:(CGPoint)offset indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle{
    if (view == nil) {
        return nil;
    }
    //隐藏前一个HUD
    [YDMBPTool hideAlert];
    
    //默认可以点击隐藏
    [YDMBPTool shareManager].tapHide = NO;
    
    //暂存hud的父视图
    hudAddedView = view;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = 0.0;
    hud.xOffset = offset.x;
    hud.yOffset = offset.y;
    hud.indicatorStyle = UIActivityIndicatorViewStyleWhite;
    [view addSubview:hud];
    [hud show:YES];
    [hudManager addGestureInView:hud];
    return hud;
}

#pragma mark - 图片+文字
+ (MBProgressHUD *)showSuccessImageWithMessage:(NSString *)message
                          hideBlock:(MBPHideBlock)hideBlock{
    
    return [YDMBPTool showAlertWithCustomImage:@"hud_success" title:message inView:nil hideBlock:hideBlock];
}

+ (MBProgressHUD *)showErrorImageWithMessage:(NSString *)message
                        hideBlock:(MBPHideBlock)hideBlock{
    
    return [YDMBPTool showAlertWithCustomImage:@"hud_error" title:message inView:nil hideBlock:hideBlock];
}

+ (MBProgressHUD *)showInfoImageWithMessage:(NSString *)message
                       hideBlock:(MBPHideBlock)hideBlock{
    
    return [YDMBPTool showAlertWithCustomImage:@"hud_info" title:message inView:nil hideBlock:hideBlock];
}

+(MBProgressHUD *)showAlertWithCustomImage:(NSString *)imageName
                          title:(NSString *)title
                         inView:(UIView *)view
                      hideBlock:(MBPHideBlock)hideBlock{
    
    //隐藏前一个HUD
    [YDMBPTool hideAlert];
    
    //默认可以点击隐藏
    [YDMBPTool shareManager].tapHide = YES;
    [YDMBPTool shareManager].showType = YDMBPToolShowTypeImageAndText;
    hudManager.hideBlock = hideBlock;
    
    //若父视图为空，添加到主window上
    view = view == nil ? [UIApplication sharedApplication].keyWindow : view;
    
    //暂存hud的父视图
    hudAddedView = view;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.frame = CGRectMake(0, 0, 44, 44);
    UIImageView *littleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    littleView.image = [UIImage imageNamed:imageName];
    
    [iconButton setImage:[UIImage imageNamed:imageName] forState:0];
    iconButton.userInteractionEnabled = NO;
    hud.customView = littleView;
    hud.removeFromSuperViewOnHide = YES;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.labelText = title;
    hud.labelFont = kHUDLabelTextFont;
    hud.mode = MBProgressHUDModeCustomView;
    [hud show:YES];
    [hud hide:YES afterDelay:kHUDImageAndTextTime];
    hud.delegate = hudManager;
    hud.color = [UIColor baseColor];
    hud.minSize = kHUDImageAndTextMiniSize;
    [hudManager addGestureInView:hud];
    
    return hud;
}

#pragma mark - 隐藏提示框
+ (void)hideAlert{
    NSLog(@"%s",__func__);
    //置空点击手势
    if ([YDMBPTool shareManager].hideHUDTap) {
        [[YDMBPTool shareManager].hideHUDTap removeTarget:nil action:nil];
        [YDMBPTool shareManager].hideHUDTap = nil;
    }
    
    UIView *view ;
    if (hudAddedView) {
        view = hudAddedView;
    }
    else{
        view = [[UIApplication sharedApplication] keyWindow];
    }
    [self hideHUDForView:view];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:animated];
        return YES;
    }
    return NO;
}

+ (MBProgressHUD *)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            return (MBProgressHUD *)subview;
        }
    }
    return nil;
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    NSLog(@"%s",__func__);
    NSLog(@"hudManager.showType = %ld",hudManager.showType);
    if (hudManager.hideBlock && hudManager.showType == YDMBPToolShowTypeImageAndText) {
        hudManager.hideBlock();
        hudManager.hideBlock = nil;
    }
    
}

#pragma mark - 添加手势,触摸屏幕将提示框隐藏
- (void)addGestureInView:(UIView *)view{
    if (_tapHide) {
        _hideHUDTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mbp_tapTheScreen:)];
        _hideHUDTap.delegate = self;
        [view addGestureRecognizer:_hideHUDTap];
    }
}

#pragma mark -点击屏幕
- (void)mbp_tapTheScreen:(UITapGestureRecognizer *)tap{
    YDLog(@"点击屏幕");
    [YDMBPTool hideAlert];
}

#pragma mark -UIGestureRecognizerDelegate - 解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"%s",__func__);
    if ([touch.view isKindOfClass:[MBProgressHUD class]]) {
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}


@end

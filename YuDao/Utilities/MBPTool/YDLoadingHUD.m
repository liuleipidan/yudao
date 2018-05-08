//
//  YDLoadingHUD.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/12.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDLoadingHUD.h"

@interface YDLoadingHUD()<MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray<YDProgressHUD *> *hudArray;

@end

static YDLoadingHUD *loadingHud = nil;

@implementation YDLoadingHUD

+ (YDLoadingHUD *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadingHud = [[YDLoadingHUD alloc] init];
    });
    return loadingHud;
}

- (id)init{
    if (self = [super init]) {
        _hudArray = [NSMutableArray array];
        
        //隐藏HUD
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lh_hidHUDNotification:) name:kLoadingHUDRequsetCompletion object:nil];
        
    }
    return self;
}

+ (YDProgressHUD *)showLoading{
    return [YDLoadingHUD showLoadingInView:nil];
}

+ (MBProgressHUD *)showLoadingInView:(UIView *)view{
    [YDLoadingHUD manager];
    
    YDProgressHUD *hud = [loadingHud hudByView:view];
    
    [hud show:YES];
    [hud hide:YES afterDelay:kLoadingHUDLongestShowTime];
    
    return hud;
}

+ (void)hide{
    [YDLoadingHUD manager];
    
    [loadingHud.hudArray enumerateObjectsUsingBlock:^(YDProgressHUD * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.disableAutoHide) {
            [obj hide:YES];
            [loadingHud.hudArray removeObject:obj];
        }
    }];
}

#pragma mark - Notification Events
- (void)lh_hidHUDNotification:(NSNotification *)noti{
    [YDLoadingHUD hide];
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    //关闭动画
    if ([hud.customView isKindOfClass:[UIImageView class]]) {
        UIImageView *animateImageView = (UIImageView *)hud.customView;
        if ([animateImageView isAnimating]) {
            [animateImageView stopAnimating];
        }
    }
}

#pragma mark - Private Methods
//生成hud
- (YDProgressHUD *)hudByView:(UIView *)view{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    YDProgressHUD *hud = [[YDProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.delegate = self;
    
    //标识符 == 时间戳
    hud.identifier = [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970] * 1000000)];
    
    //最小显示时间
    //hud.minShowTime = 1;
    //背景透明
    hud.opacity = 0.0f;
    //显示和消失动画
    hud.animationType = MBProgressHUDAnimationFade;
    
    //自定义动画
    UIImageView *animateImageView = [YDLoadingHUD animateImageView];
    hud.customView = animateImageView;
    //开始动画
    if (!animateImageView.isAnimating) {
        [animateImageView startAnimating];
    }
    
    [view addSubview:hud];
    
    [self.hudArray addObject:hud];
    
    return hud;
}
//图片数组
+ (NSArray *)loadingImages{
    static NSArray *loadingImages = nil;
    if (loadingImages == nil) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < 29; i++) {
            NSString *imageStr = [NSString stringWithFormat:@"loading_%d",i];
            UIImage *image = [UIImage imageNamed:imageStr];
            if (image) {
                [tempArr addObject:image];
            }
        }
        loadingImages = [NSArray arrayWithArray:tempArr];
    }
    return loadingImages;
}

#pragma mark - Getter
+ (UIImageView *)animateImageView{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 40, 40);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.animationImages = [YDLoadingHUD loadingImages];
    imageView.animationDuration = 1.0f;
    imageView.animationRepeatCount = 0;
    return imageView;
}

@end

//
//  YDProgressTool.m
//  YuDao
//
//  Created by 汪杰 on 17/3/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDProgressTool.h"
#import <MBProgressHUD.h>

static UIActivityIndicatorView *activityInView = nil;

@implementation YDProgressTool

+ (void)showInView:(UIView *)view withstyle:(UIActivityIndicatorViewStyle )style{
    if (view == nil) {
        view = [[UIApplication sharedApplication] windows].lastObject;
    }
    activityInView = [YDProgressTool activityIndicatorViewStyle:style];
    activityInView.center = view.center;
    
    [view addSubview:activityInView];
    [activityInView startAnimating];
}

+ (void)showInNavigationRightItem:(UINavigationBar *)navBar{
    activityInView = [YDProgressTool activityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    activityInView.frame = CGRectMake(SCREEN_WIDTH-44, 0, 44, 44);
    [navBar addSubview:activityInView];
    [activityInView startAnimating];
}

+ (void)hide{
    if (activityInView) {
        [activityInView stopAnimating];
        [activityInView removeFromSuperview];
        activityInView = nil;
    }
    
}

#pragma mark - Private Methods
+ (UIActivityIndicatorView *)activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style{
    UIActivityIndicatorView *acInView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    acInView.activityIndicatorViewStyle = style;
    acInView.backgroundColor = [UIColor clearColor];
    return acInView;
}

@end

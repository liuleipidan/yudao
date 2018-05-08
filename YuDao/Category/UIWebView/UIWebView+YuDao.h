//
//  UIWebView+YuDao.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (YuDao)

- (void)yd_loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

@end

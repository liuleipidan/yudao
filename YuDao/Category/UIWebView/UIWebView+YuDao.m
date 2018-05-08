//
//  UIWebView+YuDao.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "UIWebView+YuDao.h"

@implementation UIWebView (YuDao)

- (void)yd_loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL{
    
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {margin:0;padding:0;}\n"
                            //".border_p{border:1px solid #000;}\n"
                            "p {font-size: 14px;color:#000;font-weight: bold;line-height: 30px;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            " $img[p].style.width = '100%%';\n"
                            "$img[p].style.height ='auto'\n"
                            "}\n"
                            "}"
                            "</script>\n"
                            "<div class='border_p' id='webview_content_wrapper'>\n"
                            "%@</div>\n"
                            "</body>"
                            "</html>",string];
    
    [self loadHTMLString:htmlString baseURL:baseURL];
}

@end

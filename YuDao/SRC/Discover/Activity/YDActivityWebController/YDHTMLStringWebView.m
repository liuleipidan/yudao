//
//  YDHTMLStringWebView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/17.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHTMLStringWebView.h"

@implementation YDHTMLStringWebView

- (void)loadHTMLStringWithCssType:(NSString *)cssType
                       htmlString:(NSString *)htmlStr{
    NSString *string = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",YDNoNilString(cssType),htmlStr];
    [self loadHTMLString:string baseURL:nil];
    
}
//
- (void)loadHTMLStringWithHtmlString:(NSString *)htmlStr{
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body,div{margin:0;padding:0;}\n"
                       "p {font-size: 14px;color:#000;font-weight: bold;line-height: 30px;}\n"
                       ".border_p{border:1px solid #000;}\n"
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
                       "</script>%@"
                       "</body>"
                       "</html>",htmlStr];
    //NSString *string = [NSString stringWithFormat:@"<html><head><style> body{margin:0;padding:0;  } .border_p{border:1px solid #000;}.ishow{font-size:20px;color:red;}</style> <script>function getHeight(){var bodyHeight=document.body.offsetHeight;return bodyHeight;}</script> </head><body>%@</body></html>",htmlStr];
    [self loadHTMLString:htmls baseURL:nil];
}

@end

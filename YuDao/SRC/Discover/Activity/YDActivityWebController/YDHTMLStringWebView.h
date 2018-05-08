//
//  YDHTMLStringWebView.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/17.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <WebKit/WebKit.h>

@protocol YDHSWebViewDelegate <NSObject>

/**
 点击图片

 @param imageUrl 图片网址
 */
- (void)clickImageWithUrl:(NSString *)imageUrl;

/**
 点击超链接

 @param linkUrl 链接url
 */
- (void)clickHyperlinkUrl:(NSString *)linkUrl;

@end

@interface YDHTMLStringWebView : WKWebView<WKNavigationDelegate>

@property (nonatomic,weak) id<YDHSWebViewDelegate> webDelegate;


/**
 加载htmlstring内容

 @param cssType css样式链接
 @param htmlStr html字符串
 */
- (void)loadHTMLStringWithCssType:(NSString *)cssType
                       htmlString:(NSString *)htmlStr;

- (void)loadHTMLStringWithHtmlString:(NSString *)htmlStr;

@end

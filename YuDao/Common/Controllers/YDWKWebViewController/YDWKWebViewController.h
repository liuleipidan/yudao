//
//  YDWKWebViewController.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface YDWeakJSMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, assign) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scripteDelegate;

@end

#define     WEBVIEW_NAVBAR_ITEMS_FIXED_SPACE    9

#define     kCallHtmlMethodPrefix @"invocationHtmlMethod_dataTransfer(%@)"

#define     kRegisterMethodName_dataTransfer  @"invocationAppMethod_dataTransfer"
#define     kRegisterMethodName_login         @"invocationAppMethod_login"
#define     kRegisterMethodName_pageJump      @"invocationAppMethod_pageJump"

@interface YDWKWebViewController : UIViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
{
    NSString  *_urlString;
    WKWebView *_webView;
    UIProgressView *_progressView;
}
@property (nonatomic, copy  ) NSString *urlString;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;


/**
 是否显示加载进度，默认YES
 */
@property (nonatomic, assign) BOOL showLoadingProgress;

/**
 是否显示菊花加载视图，默认是NO；若使用菊花请先关闭 showLoadingProgress
 */
@property (nonatomic, assign) BOOL showMBProgressLoading;

/**
 是否使用网页标题作为nav标题，默认YES
 */
@property (nonatomic, assign) BOOL useMPageTitleAsNavTitle;

/**
 是否禁止历史记录，默认YES
 */
@property (nonatomic, assign) BOOL disableBackButton;

/**
 是否禁止禁止提供方网站，默认为YES
 */
@property (nonatomic, assign) BOOL disableAuthLabel;

/**
 返回按钮
 */
@property (nonatomic, strong) UIBarButtonItem *backButtonItem;

/**
 关闭按钮
 */
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;

/**
 注册一个方法给JS调用,控制器需实现-(void)userContentController: didReceiveScriptMessage:,用于方法的具体操作

 @param methodName 方法名
 */
- (void)registerAMethodToJS:(NSString *)methodName;

/**
 调用JS的方法

 @param methodName 方法名及参数，如showAlert('参数值')
 @param completionHandler 调用完的回调
 */
- (void)callJSMethod:(NSString *)methodName
   completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;

/**
 移除所有注册的js方法
 */
- (void)removeScriptMessageMethods;

/**
 清理缓存
 */
- (void)clearWebViewCache;

#pragma mark - 开放给子类使用代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

@end
NS_ASSUME_NONNULL_END

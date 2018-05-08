//
//  YDWKWebViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDWKWebViewController.h"
#import <WebKit/WebKit.h>

@implementation YDWeakJSMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scripteDelegate{
    if (self = [super init]) {
        _scriptDelegate = scripteDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end

@interface YDWKWebViewController ()

@property (nonatomic, strong) NSMutableArray<NSString *> *jsMethodNames;

@property (nonatomic, strong) UILabel *authLabel;

@end

@implementation YDWKWebViewController

- (id)init{
    if (self = [super init]) {
        self.useMPageTitleAsNavTitle = YES;
        self.showLoadingProgress = YES;
        self.showMBProgressLoading = NO;
        self.disableBackButton = YES;
        self.disableAuthLabel = YES;
    }
    return self;
}

- (void)loadView{
    [super loadView];
    [self.view addSubview:self.authLabel];
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.progressView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.webView.scrollView setBackgroundColor:[UIColor clearColor]];
    for (id vc in self.webView.scrollView.subviews) {
        NSString *className = NSStringFromClass([vc class]);
        if ([className isEqualToString:@"WKContentView"]) {
            [vc setBackgroundColor:[UIColor whiteColor]];
            break;
        }
    }
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:@"superTitle"];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:@"superEstimatedProgress"];
    [self.webView.scrollView addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:@"superBackgroundColor"];
    
    if (self.showMBProgressLoading) {
        [YDLoadingHUD showLoadingInView:_webView];
    }
    
    //适配iOS11.0，否则会自动往下偏移一个StatusBar的高度
    if (@available(iOS 11.0 , *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //侧滑返回
    //[self.webView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.screenEdgePanGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.disableBackButton && self.navigationItem.leftBarButtonItems.count <= 2) {
        [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem fixItemSpace:-WEBVIEW_NAVBAR_ITEMS_FIXED_SPACE], self.backButtonItem]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

- (void)dealloc{
    YDLog(@"父类 dealloc %@",self.class);
    /*
     dealloc 里禁用 __weak__
     */
    //移除监听
    [self.webView removeObserver:self forKeyPath:@"title" context:@"superTitle"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:@"superEstimatedProgress"];
    [self.webView.scrollView removeObserver:self forKeyPath:@"backgroundColor" context:@"superBackgroundColor"];
    
    //移除注册给JS用的方法
    [self removeScriptMessageMethods];
    [self clearWebViewCache];
}


- (void)setUrlString:(NSString *)urlString{
    if (urlString == nil || urlString.length == 0) {
        return;
    }
    _urlString = urlString;
    [self.progressView setProgress:0.0f];
    [self.webView loadRequest:[NSURLRequest requestWithURL:YDURL([self.urlString yd_URLEncode])]];
    
}

//清理缓存
- (void)clearWebViewCache{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        WKWebsiteDataTypeDiskCache,//磁盘缓存
                                                        //WKWebsiteDataTypeOfflineWebApplicationCache,//离线App缓存
                                                        WKWebsiteDataTypeMemoryCache,//内存缓存
                                                        //WKWebsiteDataTypeLocalStorage,//web local storage缓存
                                                        WKWebsiteDataTypeCookies,//web cookies缓存
                                                        //WKWebsiteDataTypeSessionStorage,//web session storage缓存
                                                        //WKWebsiteDataTypeIndexedDBDatabases,//索引DB缓存
                                                        //WKWebsiteDataTypeWebSQLDatabases//数据库缓存
                                                        ]];
        // Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        // Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            YDLog(@"clear webview cache");
        }];
    }
    else{
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }

        NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSString *webKitFolderInCachesfs = [NSString
                                            stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        NSError *error;
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        /* iOS7.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
        NSString *cookiesFolderPath = [libraryDir stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

#pragma mark - 注册方法给JS
- (void)registerAMethodToJS:(NSString *)methodName{
    if (!_jsMethodNames) {
        _jsMethodNames = [NSMutableArray array];
    }
    if (![_jsMethodNames containsObject:methodName]) {
        [_jsMethodNames addObject:methodName];
    }
    
    [_webView.configuration.userContentController addScriptMessageHandler:[[YDWeakJSMessageDelegate alloc] initWithDelegate:self] name:methodName];
    
}
#pragma mark - 调用JS的方法
- (void)callJSMethod:(NSString *)methodName
                completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler{
    [_webView evaluateJavaScript:methodName completionHandler:completionHandler];
}

#pragma mark - 移除所有注册的js方法
- (void)removeScriptMessageMethods{
    if (_jsMethodNames) {
        [_jsMethodNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.webView.configuration.userContentController removeScriptMessageHandlerForName:obj];
        }];
        [_jsMethodNames removeAllObjects];
        _jsMethodNames = nil;
    }
}

#pragma mark - WKScriptMessageHandler - JS调用OC方法的回调,在子控制器中覆盖此方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}

#pragma mark - Event Response -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.showLoadingProgress && [keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else if ([keyPath isEqualToString:@"backgroundColor"] && object == self.webView.scrollView) {
        UIColor *color = [change objectForKey:@"new"];
        if (!CGColorEqualToColor(color.CGColor, [UIColor clearColor].CGColor)) {
            [object setBackgroundColor:[UIColor clearColor]];
        }
    }
    else if (self.useMPageTitleAsNavTitle && [keyPath isEqualToString:@"title"]) {
        
        if (self.webView.title && self.webView.title.length > 0) {
            [self.navigationItem setTitle:self.webView.title];
        }
    }
}

- (void)navBackButotnDown{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem fixItemSpace:-WEBVIEW_NAVBAR_ITEMS_FIXED_SPACE], self.backButtonItem, self.closeButtonItem]];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)navCloseButtonDown{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.showMBProgressLoading) {
        [YDMBPTool hideAlert];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (!self.disableAuthLabel) {
        [self.authLabel setText:[NSString stringWithFormat:@"网页由 %@ 提供", webView.URL.host]];
        [self.authLabel setHeight:[self.authLabel sizeThatFits:CGSizeMake(self.authLabel.width, MAXFLOAT)].height];
    }
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (self.showMBProgressLoading) {
        [YDMBPTool hideAlert];
    }
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *currentUrl = navigationAction.request.URL.absoluteString;
    //根据交互原则，html界面链接都将拼入versionCode
    if ([currentUrl hasPrefix:@"https://"] || [currentUrl hasPrefix:@"http://"]) {
        if (![currentUrl containsString:@"versionCode="]) {
            
            currentUrl = [NSString stringWithFormat:@"%@%@versionCode=%@",
                          currentUrl,
                          [currentUrl containsString:@"?"] ? @"&" : @"?",
                          [YDShortcutMethod appVersion]];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentUrl]]];
            NSLog(@"currentUrl = %@",currentUrl);
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
    else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - WKUIDelegate
// 界面弹出警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)(void))completionHandler{
    [UIAlertController YD_OK_AlertController:self title:message ? message: @"提示" clickBlock:^{
        completionHandler();
    }];
}
// 界面弹出确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}
// 界面弹出输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"Client Not handler");
}

#pragma mark - Getters
- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *wkConfig = [[WKWebViewConfiguration alloc] init];
        wkConfig.userContentController = [[WKUserContentController alloc] init];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                      configuration:wkConfig];
        [_webView setAllowsBackForwardNavigationGestures:YES];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    return _webView;
}

- (UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0f)];
        [_progressView setTransform: CGAffineTransformMakeScale(1.0f, 2.0f)];
        [_progressView setProgressTintColor:[UIColor colorGreenDefault]];
        [_progressView setTrackTintColor:[UIColor clearColor]];
    }
    return _progressView;
}

- (UIBarButtonItem *)backButtonItem{
    if (_backButtonItem == nil) {
        _backButtonItem = [[UIBarButtonItem alloc] initWithBackTitle:@"返回" target:self action:@selector(navBackButotnDown)];
    }
    return _backButtonItem;
}

- (UIBarButtonItem *)closeButtonItem{
    if (_closeButtonItem == nil) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(navCloseButtonDown)];
    }
    return _closeButtonItem;
}

- (UILabel *)authLabel{
    if (_authLabel == nil) {
        _authLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, SCREEN_WIDTH - 40, 0)];
        [_authLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_authLabel setTextAlignment:NSTextAlignmentCenter];
        [_authLabel setTextColor:[UIColor colorTextGray]];
        [_authLabel setNumberOfLines:0];
    }
    return _authLabel;
}

@end

//
//  YDWebController.m
//  YuDao
//
//  Created by 汪杰 on 2017/5/17.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDWebController.h"
#import "WYWebProgressLayer.h"

@interface YDWebController ()<UIWebViewDelegate>

@end

@implementation YDWebController
{
    UIWebView *_webView;
    
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
    
    _webView.backgroundColor = [UIColor whiteColor];
    
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    [self.view addSubview:_webView];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}

- (void)dealloc {
    
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    NSLog(@"i am dealloc");
}


@end

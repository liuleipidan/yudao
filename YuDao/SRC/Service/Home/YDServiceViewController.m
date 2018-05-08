//
//  YDServiceViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDServiceViewController.h"
#import "YDServiceViewController+Proxy.h"

#import "YDServiceDetailsController.h"
#import "YDServiceMoreViewController.h"

#import "YDSystemTool.h"
#import "YDPayManager.h"

@interface YDServiceViewController ()

//将要进入的商品id
@property (nonatomic, copy  ) NSString *toGoodsId;


@end

@implementation YDServiceViewController

- (id)init{
    if (self = [super init]) {
        
        //用户登录代理
        [[YDUserDefault defaultUser] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //车辆代理
        [[YDCarHelper sharedHelper] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //登录了直接加载
        if (YDHadLogin) { [self loadUserHadLoginUrl]; }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"服务"];
    
    [self setUseMPageTitleAsNavTitle:NO];
    //[self setShowLoadingProgress:NO];
    [self.webView setAllowsBackForwardNavigationGestures:NO];
    
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-TABBAR_HEIGHT);
    }];
    
    //注册登录方法给JS用
    [self registerAMethodToJS:kRegisterMethodName_login];
    
    //注册打电话方法给JS用
    [self registerAMethodToJS:kRegisterMethodName_pageJump];
    
    [self setMj_header];
    [self setMj_footer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)dealloc{
    //移除代理
    [[YDUserDefault defaultUser] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[YDCarHelper sharedHelper] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)loadUserHadLoginUrl{
    YDCarDetailModel *car = [YDCarHelper sharedHelper].defaultCar;
    [self clearWebViewCache];
    NSString *urlString = [NSString stringWithFormat:kServiceHtmlURL,kMallEnvironmentalKey,YDNoNilNumber(car.channelid),YDUser_id,[YDShortcutMethod appVersion]];
    [self setUrlString:urlString];
}

//添加下拉刷新
- (void)setMj_header{
    if (self.webView.scrollView.mj_header) { return; }
    YDWeakSelf(self);
    MJRefreshGifHeader *header = [YDRefreshTool yd_MJheaderRefreshingBlock:^{
        [weakself clearWebViewCache];
        [weakself.webView reload];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.webView.scrollView.mj_header endRefreshing];
        });
    }];
    self.webView.scrollView.mj_header = header;
}

- (void)setMj_footer{
    YDWeakSelf(self);
    MJRefreshBackGifFooter *refreshFooter = [YDRefreshTool yd_MJfooterRefreshingBlock:^{
        NSDictionary *param = @{
                                @"webCode":@"AH_DATA_6"
                                };
        [weakself callJSMethod:[NSString stringWithFormat:kCallHtmlMethodPrefix,[param mj_JSONString]] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            NSDictionary *param = [obj mj_JSONObject];
            NSString *type = [param objectForKey:@"type"];
            if ([type isEqualToString:@"1"]) {
                YDNavigationController *navi = [[YDNavigationController alloc] initWithRootViewController:[[YDServiceMoreViewController alloc] init]];
                [weakself presentViewController:navi animated:YES completion:^{
                    
                }];
            }
            [weakself.webView.scrollView.mj_footer endRefreshing];
        }];
    }];
    [refreshFooter setTitle:@"上拉查看更多商品" forState:MJRefreshStateIdle];
    [refreshFooter setTitle:@"松开立即前往" forState:MJRefreshStatePulling];
    refreshFooter.ignoredScrollViewContentInsetBottom = 15.0f;
    self.webView.scrollView.mj_footer = refreshFooter;
}

#pragma mark - YDUserDefaultDelegate
- (void)defaultUserAlreadyLogged:(YDUser *)user{
    
    NSNumber *channelId = [YDCarHelper sharedHelper].defaultCar.channelid;
    NSDictionary *param = @{
                            @"webCode":@"AH_DATA_2",
                            @"userId": [NSString stringWithFormat:@"%@",YDNoNilNumber(YDUser_id)],
                            @"channelId": [NSString stringWithFormat:@"%@",YDNoNilNumber(channelId)],
                            @"goodsId": YDNoNilString(self.toGoodsId)
                            };
    
    NSString *methodStr = [NSString stringWithFormat:kCallHtmlMethodPrefix,[param mj_JSONString]];
    [self callJSMethod:methodStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
}

- (void)defaultUserExitingLogin{
    [self clearWebViewCache];
    [self setUrlString:[NSString stringWithFormat:kServiceHtmlURL,kMallEnvironmentalKey,@0,@0,[YDShortcutMethod appVersion]]];
}

- (void)defaultUserCancelLogin{
    self.toGoodsId = nil;
}

#pragma mark - YDCarHelperDelegate
- (void)carHelperLoginRequestGarageComplation{
    [self loadUserHadLoginUrl];
}
- (void)carHelperDefaultCarHadChanged:(YDCarDetailModel *)defCar{
    [self loadUserHadLoginUrl];
}

#pragma mark - WKScriptMessageHandler - JS调用OC方法的回调,在子控制器中覆盖此方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if (message == nil || message.body == nil) {
        return;
    }
    NSDictionary *param = [message.body mj_JSONObject];
    NSString *code = [param objectForKey:@"webCode"];
    if ([message.name isEqualToString:kRegisterMethodName_login]) {
        if ([code isEqualToString:@"HA_LOGIN_1"]) {
            self.toGoodsId = [param objectForKey:@"goodsId"];
            if (YDHadLogin) {
                [self defaultUserAlreadyLogged:[YDUserDefault defaultUser].user];
            }
            else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
        }
    }
    else if ([message.name isEqualToString:kRegisterMethodName_pageJump]){
        
        if ([code isEqualToString:@"HA_PJ_3"]) {
            [YDSystemTool st_callToSomeOneWithPhone:[param objectForKey:@"phoneNum"]];
        }
    }
}

#pragma mark - WKNavigatoinDelegate
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSDictionary *queryParam = [NSString yd_paramForURLQuery:navigationAction.request.URL.query];
    //a参数来判断是否是进入商城的子级界面
    NSString *a = [queryParam objectForKey:@"a"];
    
    if (a && a.length > 0) {
        decisionHandler(WKNavigationActionPolicyCancel);
        YDServiceDetailsController *serviceDetails = [[YDServiceDetailsController alloc] init];
        //根据交互原则，html界面链接将拼入versionCode
        NSString *subPageUrl = navigationAction.request.URL.absoluteString;
        if (![subPageUrl containsString:@"versionCode="]) {
            subPageUrl = [NSString stringWithFormat:@"%@&versionCode=%@",subPageUrl,[YDShortcutMethod appVersion]];
        }
        
        [serviceDetails setUrlString:subPageUrl];
        [self.navigationController pushViewController:serviceDetails animated:YES];
    }
    else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end

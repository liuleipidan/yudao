//
//  YDCardDetailsController.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCardDetailsController.h"
#import "YDCardDetailsView.h"

@interface YDCardDetailsController ()<YDCardDetailsViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic, strong) YDCardDetailsView *cardDetailsView;

@end

@implementation YDCardDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init UI
    [self.navigationItem setTitle:@"卡券详情"];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.cardDetailsView setCardDetails:self.coupon];
    
    [YDCardPackageProxy requestCardDetailsByCouponId:self.coupon.couponId success:^(YDCard *card) {
        
        [self.cardDetailsView setCardDetails:card];
    } failure:^{
        NSLog(@"failure");
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController yd_hiddenBottomImageView:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController yd_hiddenBottomImageView:NO];
}

#pragma mark - YDCardDetailsViewDelegate
- (void)cardDetailsView:(YDCardDetailsView *)view webViewLoadFinish:(CGFloat )webViewContentHeight{
    NSLog(@"webViewContentHeight = %f",webViewContentHeight);
    [self.cardDetailsView mas_updateConstraints:^(MASConstraintMaker *make) {
       make.height.mas_equalTo(webViewContentHeight);
    }];
    [self.view setNeedsLayout];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    [UIAlertController YD_OK_AlertController:self title:message ? message: @"提示" clickBlock:^{
        completionHandler();
    }];
}


- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = YDBaseColor;
        _containerView = [UIView new];
        [_scrollView addSubview:_containerView];
        
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView).insets(UIEdgeInsetsZero);
            //这一句一定要有，有看网上是不要这一句的，不知道他们是怎么实现的
            make.width.equalTo(_scrollView);
        }];
        
        [_containerView addSubview:self.cardDetailsView];
        [self.cardDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView).offset(20);
            make.right.equalTo(_containerView).offset(-20);
            make.top.equalTo(_containerView).offset(71);
            make.height.mas_equalTo(kCardDetailsViewHeight_default);
            //这一句也一定要有
            make.bottom.equalTo(_containerView).offset(-25);
        }];
    }
    return _scrollView;
}

- (YDCardDetailsView *)cardDetailsView{
    if (_cardDetailsView == nil) {
        _cardDetailsView = [[YDCardDetailsView alloc] initWithFrame:CGRectZero];
        _cardDetailsView.delegate = self;
    }
    return _cardDetailsView;
}

@end

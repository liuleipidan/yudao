//
//  YDCardDetailsView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/28.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCardDetailsView.h"
#import "YDHTMLStringWebView.h"

@interface YDCardDetailsView()<UIWebViewDelegate>

/**
 类型
 */
@property (nonatomic, strong) UILabel *typeLabel;

/**
 名字
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 使用
 */
@property (nonatomic, strong) UIButton *useButton;

/**
 卡密
 */
@property (nonatomic, strong) UILabel *secretLabel;

/**
 分割线
 */
@property (nonatomic, strong) UIImageView *separatorImageView;

/**
 头图（封面）
 */
@property (nonatomic, strong) UIImageView *headerImageView;

/**
 适用车系
 */
@property (nonatomic, strong) UILabel *applyLabel;

/**
 提供商
 */
@property (nonatomic, strong) UILabel *providerLabel;

/**
 时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 使用须知
 */
@property (nonatomic, strong) UILabel *useTitle;

/**
 使用简介
 */
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YDCardDetailsView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 8.0f;
        
        [self cd_initSubviews];
        [self cd_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setCardDetails:(YDCard *)cardDetails{
    _cardDetails = cardDetails;
    
    _typeLabel.text = cardDetails.typeTitle;
    
    _nameLabel.text = cardDetails.name;
    
    _secretLabel.text = cardDetails.secret;
    
    _applyLabel.text = cardDetails.apply.length > 0 ? cardDetails.apply : @"适用于所有车系";
    
    _providerLabel.text = [NSString stringWithFormat:@"服 务 商：%@",cardDetails.provider];
    
    if ([cardDetails.expires isEqual:@0]) {
        _timeLabel.text = @"无时间限制";
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"有 效 期：%@-%@",[NSDate formatYear_Month_Day:cardDetails.startTime],[NSDate formatYear_Month_Day:cardDetails.endTime]];
    }
    
    _useTitle.text = @"使用须知";
    
    //判断是否需要显示"立即使用"按钮
    if (cardDetails.isExpired || ![cardDetails.status isEqual:@1]) {
        _useButton.hidden = YES;
        _secretLabel.hidden = NO;
    }else{
        _useButton.hidden = NO;
        _secretLabel.hidden = YES;
    }
    
    _headerImageView.hidden = cardDetails.imageURL ? NO : YES;
    if (cardDetails.imageURL) {
        [_headerImageView yd_setImageWithString:cardDetails.imageURL showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        
        //图片高度
        CGFloat imageHeight = (SCREEN_WIDTH - 40) * cardDetails.imageHeight / cardDetails.imageWidth;
        [_headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageHeight);
        }];
        
        [_applyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatorImageView.mas_bottom).offset(5 + 15 + imageHeight);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kCardDetailsViewHeight_default + imageHeight);
        }];
    }
    else{
        [_applyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatorImageView.mas_bottom).offset(5);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kCardDetailsViewHeight_default);
        }];
    }
    
    [self.webView yd_loadHTMLString:YDNoNilString(cardDetails.desc) baseURL:nil];
    
}

#pragma mark - Events
- (void)cd_userButtonAction:(UIButton *)sender{
    sender.hidden = YES;
    _secretLabel.hidden = NO;
}

#pragma mark  - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.clientHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 80, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    NSLog(@"frame.height = %f",frame.height);
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').clientHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    
    float height = [height_str floatValue];
    
#pragma mark - 内容实际高度（像素）* 点和像素的比,这里在网页内容过多时会出现frame.height过高，所以目前先注释掉
    //height = height * frame.height / clientheight;
    
    //加上30的间距
    height = height == 0 ? height : height + 30;
    
    //再次设置WebView高度（点）
    webView.frame = CGRectMake(40, CGRectGetMaxY(_useTitle.frame) + 10, SCREEN_WIDTH - 80, height);
    
    [webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_useTitle.mas_bottom).offset(10);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(height);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardDetailsView:webViewLoadFinish:)]) {
        [self.delegate cardDetailsView:self webViewLoadFinish:CGRectGetMaxY(webView.frame)];
    }
}

#pragma mark - Private Methods
- (void)cd_initSubviews{
    _typeLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:24] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor orangeTextColor]];
    _typeLabel.layer.cornerRadius = 25.0f;
    _typeLabel.clipsToBounds = YES;
    
    _nameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont systemFontOfSize:20] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
    _nameLabel.numberOfLines = 2;
    
    _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_useButton setTitle:@"立即使用" forState:0];
    [_useButton setTitleColor:[UIColor whiteColor] forState:0];
    _useButton.backgroundColor = [UIColor orangeTextColor];
    _useButton.layer.cornerRadius = 16.0f;
    [_useButton addTarget:self action:@selector(cd_userButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _secretLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
    _secretLabel.hidden = YES;
    
    _separatorImageView = [[UIImageView alloc] initWithImage:YDImage(@"mine_coupon_details_separator")];
    
    _headerImageView = [UIImageView new];
        
    _applyLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]];
    
    _providerLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]];
    
    _timeLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]];
    
    _useTitle  = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]];
    
    [self yd_addSubviews:@[_typeLabel,_nameLabel,_useButton,_secretLabel,_separatorImageView,_headerImageView,_applyLabel,_providerLabel,_timeLabel,_useTitle,self.webView]];
    
}

- (void)cd_addMasonry{
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(-25);
        make.width.height.mas_equalTo(50);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel.mas_bottom).offset(25);
        make.left.right.equalTo(self);
        //make.height.mas_equalTo(28);
        make.height.mas_lessThanOrEqualTo(56);
    }];
    
    [_useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_nameLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(114, 32));
    }];
    
    [_secretLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(_useButton);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    [_separatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_useButton.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_separatorImageView.mas_bottom).offset(5);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(0);
    }];
    
    [_applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_separatorImageView.mas_bottom).offset(5);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(22);
    }];
    
    [_providerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_applyLabel);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(_applyLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_applyLabel);
        make.right.equalTo(_providerLabel);
        make.top.equalTo(_providerLabel.mas_bottom).offset(6);
        make.height.mas_equalTo(17);
    }];
    
    [_useTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_applyLabel);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(_timeLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(22);
    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_useTitle.mas_bottom).offset(10);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(0);
        
        //撑起父视图
        //make.bottom.equalTo(self);
    }];
}

#pragma mark  - Getters
- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.opaque = NO;
        [_webView sizeToFit];
    }
    return _webView;
}

@end

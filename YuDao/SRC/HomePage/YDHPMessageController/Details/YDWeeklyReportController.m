//
//  YDWeeklyReportController.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/5.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDWeeklyReportController.h"

@interface YDWeeklyReportController ()

@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation YDWeeklyReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backBtn];
    
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-20);
    }];
    
    [self.view addSubview:self.progressView];
    self.progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [self.view setNeedsDisplay];
    
    YDCarDetailModel *car = [YDCarHelper sharedHelper].defaultCar;
    NSString *url = [NSString stringWithFormat:kWeeklyReportHtmlURL,kHtmlEnvironmentalKey,YDAccess_token,car.ug_id,@1,[YDUserDefault defaultUser].user.ub_nickname,car.ug_series_name,YDUser_id,[YDShortcutMethod appVersion]];
    NSLog(@"url = %@",url);
    [self setUrlString:url];
    [self registerAMethodToJS:kRegisterMethodName_dataTransfer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)wr_backButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
- (void)shareWeeklyReportWithTimeString:(NSString *)time{
    NSString *title = @"一周用车小记，我的车况周报！";
    
    NSString *content = [NSString stringWithFormat:@"老司机%@%@的车辆使用周报。",[YDUserDefault defaultUser].user.ub_nickname,time];
    YDCarDetailModel *car = [YDCarHelper sharedHelper].defaultCar;
    NSString *url = [NSString stringWithFormat:kWeeklyReportHtmlURL,kHtmlEnvironmentalKey,YDAccess_token,car.ug_id,@0,[YDUserDefault defaultUser].user.ub_nickname,car.ug_series_name,YDUser_id,[YDShortcutMethod appVersion]];
    NSString *encodeUrl = [url yd_URLEncode];
    NSLog(@"encodeUrl = %@",encodeUrl);
    AWActionSheet *sheet = [AWActionSheet actionSheetWithTouchItemBlock:^(YDClickSharePlatformType index) {
        [YDShareManager shareToPlatform:index
                                  title:title
                                content:content
                                    url:encodeUrl
                             thumbImage:YDImage(@"YuDaoLogo")
                                  image:YDImage(@"YuDaoLogo")
                           musicFileURL:nil
                                extInfo:nil
                               fileData:nil
                           emoticonData:nil
                               latitude:0.0
                              longitude:0.0
                               objectID:nil];
    }];
    [sheet show];
}

#pragma mark - WKScriptMessageHandler - JS调用OC方法的回调,在子控制器中覆盖此方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //点击我要报名
    if ([message.name isEqualToString:kRegisterMethodName_dataTransfer]) {
        NSDictionary *param = [message.body mj_JSONObject];
        NSString *code = [param objectForKey:@"webCode"];
        if ([code isEqualToString:@"HA_DATA_2"]) {
            [self shareWeeklyReportWithTimeString:[param objectForKey:@"date"]];
        }
    }
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 25, 40, 30);
        [_backBtn setImage:@"navigation_back_image" imageHL:@"navigation_back_image"];
        [_backBtn addTarget:self action:@selector(wr_backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView *overView = [UIView new];
        overView.backgroundColor = [UIColor clearColor];
        overView.frame = CGRectMake(0, CGRectGetMaxY(_backBtn.frame), 20, SCREEN_HEIGHT-CGRectGetMaxY(_backBtn.frame));
        [self.view addSubview:overView];
    }
    return _backBtn;
}


@end

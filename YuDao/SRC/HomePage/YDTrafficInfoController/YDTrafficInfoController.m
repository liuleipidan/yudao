//
//  YDTrafficInfoController.m
//  YuDao
//
//  Created by 汪杰 on 16/12/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDTrafficInfoController.h"
#import "YDTrafficInfoController+Delegate.h"
#import "AppDelegate.h"
#import "YDIgnoreView.h"
#import "YDSettingHelper.h"

@interface YDTrafficInfoController ()

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *separatorLine;

@end

@implementation YDTrafficInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tic_initUI];
    
    //车库代理
    [[YDCarHelper sharedHelper] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //设置当前车辆
    [self.infoManager setCurrentCar:[YDCarHelper sharedHelper].defaultCar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)dealloc{
    
    [[YDCarHelper sharedHelper] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - Public Methods
- (void)requestTrafficInfo{
    YDLog();
    [self.infoManager requestCarDataCompletion:nil];
//    YDWeakSelf(self);
//    [_infoManager requestCarDataCompletion:^(NSNumber *code, NSString *status) {
////        [weakself.carInfoView updateDataAndUIByTrafficInfoManager:weakself.infoManager];
////        [weakself.carInfoView setScore:weakself.infoManager.score];
////        [weakself.carLocView updateRankingByTrafficInfoManager:weakself.infoManager];
//    }];
    
    //后台刷新
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    if (appDelegate.fetchCompletionHandler) {
//        appDelegate.fetchCompletionHandler(UIBackgroundFetchResultNewData);
//        appDelegate.fetchCompletionHandler = nil;
//    }
}

#pragma mark - 行车信息点击事件
- (void)ci_rightButtonAction:(UIButton *)sender{
    CGRect rect =  [self.view convertRect:sender.frame toView:[UIApplication sharedApplication].keyWindow];
    [YDIgnoreView showAtFrame:rect type:YDIgnoreViewTypeTwoRow clickedBlock:^(NSUInteger index) {
        
        //更新数据库
        YDHPIgnoreModel *ignore = [YDHPIgnoreModel createIgnoreModelByModuleType:YDHomePageModuleTypeCarInfo subType:0];
        ignore.ignore_type = @(index);
        [YDSettingHelper addHPIgnoreByIgnoreModel:ignore success:nil failure:nil];
        
        //更新UI
        [[YDHomePageManager manager] removeIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }];
}
//测一测
- (void)tapTestDataLabel:(UIGestureRecognizer *)tap{
    
    [self carInfoViewClickTest];
}

//初始化UI
- (void)tic_initUI{
    [self.view yd_addSubviews:@[self.titleLabel,self.rightBtn,self.carLocView,self.carInfoView,self.separatorLine]];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(10);
        make.height.mas_equalTo(21).priorityHigh();
        make.width.mas_equalTo(100);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(10).priorityHigh();
    }];
    
    [_carLocView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.separatorLine.mas_top);
        make.height.mas_equalTo(62);
    }];

    [_carInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        //make.bottom.equalTo(_carLocView.mas_top);
        make.height.mas_equalTo(148);
    }];
}

#pragma mark - Getters
- (YDTrafficInfoManager *)infoManager{
    if (_infoManager == nil) {
        _infoManager = [[YDTrafficInfoManager alloc] init];
        _infoManager.delegate = self;
    }
    return _infoManager;
}
- (YDCarInfoView *)carInfoView{
    if (!_carInfoView) {
        _carInfoView = [[YDCarInfoView alloc] init];
        _carInfoView.delegate = self;
    }
    return _carInfoView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:18]];
        _titleLabel.text = @"当前车况";
    }
    return _titleLabel;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"homePage_message_more_gray"] forState:0];
        [_rightBtn addTarget:self action:@selector(ci_rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (YDCarsLocationView *)carLocView{
    if (!_carLocView) {
        _carLocView = [[YDCarsLocationView alloc] init];
        _carLocView.delegate = self;
    }
    return _carLocView;
}

- (UIView *)separatorLine{
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor searchBarBackgroundColor];
    }
    return _separatorLine;
}


@end

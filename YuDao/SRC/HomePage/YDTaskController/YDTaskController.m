//
//  YDRankingListController.m
//  YuDao
//
//  Created by 汪杰 on 16/12/13.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDTaskController.h"
#import "YDTaskController+Delegate.h"
#import "YDDBTaskStore.h"
#import "YDIgnoreView.h"
#import "YDSettingHelper.h"

@interface YDTaskController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation YDTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = [UIColor searchBarBackgroundColor];
    [self.view sd_addSubviews:@[self.titleLabel,self.taskView,separatorView,self.rightBtn]];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [_taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(130);
    }];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(10);
    }];
    
    //用户登录代理
    [[YDUserDefault defaultUser] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //添加系统消息代理
    [[YDSystemMessageHelper sharedInstance] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self requestUserTask];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.rightBtn.hidden = !YDHadLogin;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc{
    [[YDUserDefault defaultUser] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [[YDSystemMessageHelper sharedInstance] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - YDUserDefaultDelegate
- (void)defaultUserAlreadyLogged:(YDUser *)user{
    [self requestUserTask];
}
- (void)defaultUserExitingLogin{
    [self requestUserTask];
}

#pragma mark - Private Methods
- (void)requestUserTask{
    self.rightBtn.hidden = !YDHadLogin;
    [self.taskView showLoadView];
    YDWeakSelf(self);
    [YDNetworking POST:kUserTaskURL parameters:@{@"access_token":YDAccess_token} success:^(NSNumber *code, NSString *status, id data) {
        [weakself.taskView hideLoadView];
        if ([code isEqual:@200] && data) {
            weakself.task = [YDTaskModel mj_objectWithKeyValues:data];
            [weakself.taskView setModel:weakself.task];
            [YDDBTaskStore insertTask:weakself.task];
            [[YDHomePageManager manager] insertIndexPath:nil identifier:@"task"];
        }
        else if (data == nil){
            [[YDHomePageManager manager] setCurrentUserNoTask:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[YDHomePageManager manager] removeIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            });
        }
    } failure:^(NSError *error) {
        [weakself.taskView hideLoadView];
        [weakself.taskView taskDataLoadFailure];
    }];
}

- (void)rightButtonAction:(UIButton *)sender{
    CGRect rect =  [self.view convertRect:sender.frame toView:[UIApplication sharedApplication].keyWindow];
    [YDIgnoreView showAtFrame:rect type:YDIgnoreViewTypeTwoRow clickedBlock:^(NSUInteger index) {
        //更新数据库
        YDHPIgnoreModel *ignore = [YDHPIgnoreModel createIgnoreModelByModuleType:YDHomePageModuleTypeTask subType:0];
        ignore.ignore_type = @(index);
        [YDSettingHelper addHPIgnoreByIgnoreModel:ignore success:nil failure:nil];
        
        //更新UI
        [[YDHomePageManager manager] removeIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }];
}

#pragma mark - Getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:18]];
        _titleLabel.text = @"用户任务";
        _titleLabel.frame = CGRectMake(10, 10, 150, 21);
    }
    return _titleLabel;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"homePage_message_more_gray"] forState:0];
        [_rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (YDTaskView *)taskView{
    if (!_taskView) {
        _taskView = [[YDTaskView alloc] init];
        _taskView.delegate = self;
    }
    return _taskView;
}

@end

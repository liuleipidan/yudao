//
//  YDVisitorsController.m
//  YuDao
//
//  Created by 汪杰 on 17/1/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDVisitorsController.h"
#import "YDVisitorsModel.h"
#import "YDContainerController.h"
#import "YDSingleVisitorController.h"

@interface YDVisitorsController ()<YDContainerControllerDelegate>

@property (nonatomic, strong) YDContainerController *containerVC;

@property (nonatomic, strong) YDSingleVisitorController *forMeVC;

@property (nonatomic, strong) YDSingleVisitorController *forOthersVC;

@end

@implementation YDVisitorsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"访客";
    
    [self.view addSubview:self.containerVC.view];
    
    [self.containerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - YDContainerControllerDelegate
- (void)containerViewItemIndex:(NSInteger )index currentController:(UIViewController *)controller{
    
}

- (YDContainerController *)containerVC{
    if (!_containerVC) {
        
        YDContainerController *containerVC = [[YDContainerController alloc] initWithControllers:@[self.forMeVC,self.forOthersVC] topBarHeight:[[UIApplication sharedApplication] statusBarFrame].size.height + NAVBAR_HEIGHT parentController:self];
        containerVC.delegate = self;
        containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];
        containerVC.menuItemTitleColor = [UIColor colorWithString:@"#F2B3552"];
        containerVC.scrollMenuViewHeight = 46.f;
        _containerVC = containerVC;
    }
    return _containerVC;
}

- (YDSingleVisitorController *)forMeVC{
    if (!_forMeVC) {
        _forMeVC = [[YDSingleVisitorController alloc] init];
        _forMeVC.title = @"看过我的";
        _forMeVC.visitorType = YDVisitorTypeForMe;
    }
    return _forMeVC;
}
- (YDSingleVisitorController *)forOthersVC{
    if (!_forOthersVC) {
        _forOthersVC = [[YDSingleVisitorController alloc] init];
        _forOthersVC.title = @"我看过的";
        _forOthersVC.visitorType = YDVisitorTypeForOthers;
    }
    return _forOthersVC;
}

@end

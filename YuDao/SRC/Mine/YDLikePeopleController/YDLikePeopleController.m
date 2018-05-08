//
//  YDLikePeopleController.m
//  YuDao
//
//  Created by 汪杰 on 17/1/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDLikePeopleController.h"
#import "YDContainerController.h"
#import "YDLikePersonController.h"

@interface YDLikePeopleController ()<YDContainerControllerDelegate>

@property (nonatomic, strong) YDContainerController *containerVC;

@property (nonatomic, strong) YDLikePersonController *oneVC;

@property (nonatomic, strong) YDLikePersonController *twoVC;

@property (nonatomic, strong) YDLikePersonController *threeVC;

@end

@implementation YDLikePeopleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"喜欢的人"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.containerVC.view];
    
    [self.containerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - YDContainerControllerDelegate
- (void)containerViewItemIndex:(NSInteger )index currentController:(UIViewController *)controller{
    
}

- (YDContainerController *)containerVC{
    if (!_containerVC) {
        
        YDContainerController *containerVC = [[YDContainerController alloc] initWithControllers:@[self.oneVC,self.twoVC,self.threeVC] topBarHeight:[[UIApplication sharedApplication] statusBarFrame].size.height + NAVBAR_HEIGHT parentController:self];
        containerVC.delegate = self;
        containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];
        containerVC.menuItemTitleColor = [UIColor colorWithString:@"#F2B3552"];
        containerVC.scrollMenuViewHeight = 46.f;
        containerVC.menuView.indicatorWidth = 70.0f;
        //containerVC.view.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
        _containerVC = containerVC;
    }
    return _containerVC;
}

- (YDLikePersonController *)oneVC{
    if (!_oneVC) {
        _oneVC = [[YDLikePersonController alloc] init];
        _oneVC.title = @"喜欢我的";
        _oneVC.likedType = YDLikedPeopleTypeLikeMe;
    }
    return _oneVC;
}
- (YDLikePersonController *)twoVC{
    if (!_twoVC) {
        _twoVC = [[YDLikePersonController alloc] init];
        _twoVC.title = @"我喜欢的";
        _twoVC.likedType = YDLikedPeopleTypeILike;
    }
    return _twoVC;
}
- (YDLikePersonController *)threeVC{
    if (!_threeVC) {
        _threeVC = [[YDLikePersonController alloc] init];
        _threeVC.title = @"相互喜欢";
        _threeVC.likedType = YDLikedPeopleTypeEachLike;
    }
    return _threeVC;
}

@end

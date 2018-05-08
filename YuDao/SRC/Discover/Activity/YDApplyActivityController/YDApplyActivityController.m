//
//  YDApplyActivityController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/17.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDApplyActivityController.h"

@interface YDApplyActivityController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YDApplyActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"活动报名"];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end

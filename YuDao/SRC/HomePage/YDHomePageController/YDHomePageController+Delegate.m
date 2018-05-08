//
//  YDHomePageController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHomePageController+Delegate.h"

@implementation YDHomePageController (Delegate)
- (void)registerCells{
    [self.tableView registerClass:[YDHomePageCell class] forCellReuseIdentifier:@"YDHomePageCell"];
}

#pragma mark - YDHomePageManagerDelegate
//数据改变
- (void)HomePageManager:(YDHomePageManager *)manager dataSourceDidChange:(NSIndexPath *)index{
    if (index) {
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [self.tableView reloadData];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

//插入行
- (void)HomePageManager:(YDHomePageManager *)manager insertIndexPath:(NSIndexPath *)index{
    if (index) {
        [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else{
        [self.tableView reloadData];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

}

//移除行
- (void)HomePageManager:(YDHomePageManager *)manager deleteIndexPath:(NSIndexPath *)index{
    if (index) {
        [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [self.tableView reloadData];
    }
    
}

//首页消息高度发生改变
- (void)HomePageManager:(YDHomePageManager *)manager messageViewHeightDidChanged:(CGFloat )height{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - YDRankingListControllerDelegate
//排行榜数据加载完成
- (void)rankingListControllerDataDidLoad:(YDRankingListController *)controller{
    [self.tableView reloadData];
}

#pragma mark - YDHPDynamicControllerDelegate
//动态数据加载完成
- (void)HPDynamicControllerDataDidLoad:(YDHPDynamicController *)controller viewHeight:(CGFloat)viewHeight{
    [self.tableView reloadData];
    self.tableView.tableFooterView.height = viewHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.phManager.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.phManager.data objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDHomePageCell"];
    YDHomePageModel *model = [[self.phManager.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self y_addChildContentViewController:model.vc];
    [cell setHostedView:model.vc.view];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDHomePageModel *model = [[self.phManager.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return model.viewHeight;
}


@end

//
//  YDSettingViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSettingViewController.h"
#import "YDSettingHeaderTitleView.h"
#import "YDSettingFooterTitleView.h"
#import "YDSettingButtonCell.h"

@interface YDSettingViewController ()

@end

@implementation YDSettingViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_SETTING_TOP_SPACE)]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_SETTING_BOTTOM_SPACE)]];
    [self.tableView setBackgroundColor:[UIColor colorGrayBG]];
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.tableView setSeparatorColor:[UIColor colorGrayLine]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[YDSettingHeaderTitleView class] forHeaderFooterViewReuseIdentifier:@"YDSettingHeaderTitleView"];
    [self.tableView registerClass:[YDSettingFooterTitleView class] forHeaderFooterViewReuseIdentifier:@"YDSettingFooterTitleView"];
    [self.tableView registerClass:[YDSettingCell class] forCellReuseIdentifier:@"YDSettingCell"];
    [self.tableView registerClass:[YDSettingButtonCell class] forCellReuseIdentifier:@"YDSettingButtonCell"];
    [self.tableView registerClass:[YDSettingSwitchCell class] forCellReuseIdentifier:@"YDSettingSwitchCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YDSettingSwitchCellDelegate
- (void)settingSwitchCell:(YDSettingSwitchCell *)cell item:(YDSettingItem *)item switchBtn:(UISwitch *)switchBtn{
    YDLog(@"子类未实现");
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:item.cellClassName];
    [cell setItem:item];
    if (item.type == YDSettingItemTypeSwitch) {
        [cell setDelegate:self];
    }
    return cell;
}

//MARK: UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YDSettingGroup *group = self.data[section];
    if (group.headerTitle == nil) {
        return nil;
    }
    YDSettingHeaderTitleView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YDSettingHeaderTitleView"];
    [view setText:group.headerTitle];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    YDSettingGroup *group = self.data[section];
    if (group.footerTitle == nil) {
        return nil;
    }
    YDSettingFooterTitleView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YDSettingFooterTitleView"];
    [view setText:group.footerTitle];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_SETTING_CELL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    YDSettingGroup *group = self.data[section];
    return 0.5 + (group.headerTitle == nil ? 0 : 5.0f + group.headerHeight);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    YDSettingGroup *group = self.data[section];
    return 20.0f + (group.footerTitle == nil ? 0 : 5.0f + group.footerHeight);
}

//MARK: YDSettingSwitchCellDelegate
- (void)settingSwitchCellForItem:(YDSettingItem *)item didChangeStatus:(BOOL)on{
    YDLog(@"子类未实现...");
}


@end

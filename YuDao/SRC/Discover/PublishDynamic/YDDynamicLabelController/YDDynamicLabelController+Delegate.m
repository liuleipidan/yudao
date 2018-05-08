//
//  YDDynamicLabelController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/3.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDynamicLabelController+Delegate.h"

@implementation YDDynamicLabelController (Delegate)

- (void)registerCells{
    [self.tableView registerClass:[YDDynamicHotLabelCell class] forCellReuseIdentifier:@"YDDynamicHotLabelCell"];
}

#pragma mark - YDDynamicHotLabelCellDelegate
- (void)dynamicHotLabelCell:(YDDynamicHotLabelCell *)cell didSelctedLabel:(NSString *)label{
    self.textField.text = label;
    [YDNotificationCenter postNotificationName:UITextFieldTextDidChangeNotification object:self.textField];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return self.viewModel.historyArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YDDynamicHotLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDDynamicHotLabelCell"];
        [cell setLabels:[self.viewModel hotButtonPropertys]];
        [cell setDelegate:self];
        return cell;
    }
    static NSString *const labelCellId = @"labelCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:labelCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:labelCellId];
        cell.textLabel.textColor = [UIColor blackTextColor];
        cell.textLabel.font = [UIFont font_16];
        //用缩进来调节textLabel的位置
        cell.indentationLevel = 1;
        cell.indentationWidth = 10;
        
        [cell.contentView layoutIfNeeded];
    }
    if (indexPath.row < self.viewModel.historyArr.count) {
        cell.textLabel.text = self.viewModel.historyArr[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSString *text = self.viewModel.historyArr[indexPath.row];
        [self.textField setText:text];
        [YDNotificationCenter postNotificationName:UITextFieldTextDidChangeNotification object:self.textField];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.viewModel.hotCellHeight;
    }
    return 52.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YDContactHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YDContactHeaderView"];
    [view setTitleColor:[UIColor grayTextColor]];
    [view setOffset_X:10];
    if (section == 0) {
        [view setTitle:@"热门"];
    }
    else if (section == 1){
        [view setTitle:@"历史"];
    }
    return view;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.row < self.viewModel.historyArr.count) {
        
        //移除缓存数据
        [self.viewModel removeUserDynamicLabel:self.viewModel.historyArr[indexPath.row]];
        //移除当前UI数据
        [self.viewModel.historyArr removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end

//
//  YDCarIllegalityController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/19.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarIllegalityController+Delegate.h"

@implementation YDCarIllegalityController (Delegate)

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDCarIllegalityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDCarIllegalityCell"];
    [cell setItem:self.data[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.data[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

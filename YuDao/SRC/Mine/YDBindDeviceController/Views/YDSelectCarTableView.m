//
//  YDSelectCarTableView.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSelectCarTableView.h"
#import "YDSelectCarCell.h"

@interface YDSelectCarTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) YDCarDetailModel *selectedCar;

@end

@implementation YDSelectCarTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.rowHeight = 69.0f;
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        self.dataSource = self;
        self.delegate = self;
        
        [self setScrollEnabled:NO];
        
        [self registerClass:[YDSelectCarCell class] forCellReuseIdentifier:@"YDSelectCarCell"];
    }
    return self;
}

- (void)reloadData:(NSArray *)data selectedCar:(YDCarDetailModel *)selectedCar{
    _data = data;
    _selectedCar = selectedCar;
    
    self.height = self.rowHeight * data.count;
    
    [self reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDSelectCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDSelectCarCell"];
    
    if (indexPath.row < self.data.count) {
        YDCarDetailModel *item = self.data[indexPath.row];
        [cell setItem:item];
        
        if ([item.ug_id isEqual:self.selectedCar.ug_id]) {
            cell.promptButton.selected = YES;
        }
        else{
            cell.promptButton.selected = NO;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:indexPath];
    
    if (indexPath.row < self.data.count && self.didSelectedCarBlock) {
        YDCarDetailModel *item = self.data[indexPath.row];
        self.selectedCar = item;
        [tableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.didSelectedCarBlock(item);
        });
    }
}

@end

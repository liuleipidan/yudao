//
//  YDPopTableView.m
//  YuDao
//
//  Created by 汪杰 on 16/12/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDPopTableView.h"
#import "YDChooseCarCell.h"


@interface YDPopTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;

@end

@implementation YDPopTableView
{
    NSInteger _index;
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

- (id)initWithDataSource:(NSArray *)data selectedIndex:(NSInteger )index{
    if (self = [super init]) {
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.tableFooterView = [UIView new];
        self.backgroundColor = [UIColor whiteColor];
        self.rowHeight = 70.0f;
        self.layer.cornerRadius = 8.0f;
        
        self.data = data;
        _index = index;
        
        [self registerClass:[YDChooseCarCell class] forCellReuseIdentifier:@"YDChooseCarCell"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data? self.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDChooseCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDChooseCarCell"];
    YDCarDetailModel *model = self.data[indexPath.row];
    cell.model = model;
    if (indexPath.row == _index) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    if (indexPath.row == 0) {
        cell.topLineView.hidden = YES;
    }
    if (indexPath.row == self.data.count-1) {
        cell.bottomLineView.hidden = YES;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDChooseCarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray<YDChooseCarCell *> *cells = tableView.visibleCells;
    [cells enumerateObjectsUsingBlock:^(YDChooseCarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:cell]) {
            obj.selectBtn.selected = YES;
        }else{
            obj.selectBtn.selected = NO;
        }
    }];
    
    YDCarDetailModel *model = self.data[indexPath.row];
    if (self.selectedCarBlock) {
        self.selectedCarBlock(model);
    }
}
@end

//
//  YDSelectCarTableView.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDSelectCarTableView : UITableView

@property (nonatomic,copy) void (^didSelectedCarBlock )(YDCarDetailModel *item);

- (void)reloadData:(NSArray *)data selectedCar:(YDCarDetailModel *)selectedCar;


@end

//
//  YDPopTableView.h
//  YuDao
//
//  Created by 汪杰 on 16/12/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDPopTableView : UITableView

@property (nonatomic, copy  ) void (^selectedCarBlock)(YDCarDetailModel *model);

- (id)initWithDataSource:(NSArray *)data selectedIndex:(NSInteger )index;

@end

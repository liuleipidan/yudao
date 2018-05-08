//
//  YDLabelViewModel.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/3.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDLabelViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *hotArr;

@property (nonatomic, strong) NSMutableArray *historyArr;

#pragma mark - UI
@property (nonatomic, strong) NSMutableArray *hotButtonPropertys;

@property (nonatomic, assign) CGFloat hotCellHeight;

//插入用户历史动态标签
- (void)insertUserDynamicLabel:(NSString *)label;
//删除用户历史动态标签
- (void)removeUserDynamicLabel:(NSString *)label;

@end

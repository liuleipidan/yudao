//
//  YDHomePageManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/28.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDHomePageModel.h"
#import "YDTrafficInfoController.h"
#import "YDTaskController.h"
#import "YDRankingListController.h"
#import "YDHPMessageController.h"

@class YDHomePageManager;
@protocol YDHomePageManagerDelegate <NSObject>

- (void)HomePageManager:(YDHomePageManager *)manager dataSourceDidChange:(NSIndexPath *)index;

@optional;

- (void)HomePageManager:(YDHomePageManager *)manager insertIndexPath:(NSIndexPath *)index;

- (void)HomePageManager:(YDHomePageManager *)manager deleteIndexPath:(NSIndexPath *)index;

- (void)HomePageManager:(YDHomePageManager *)manager messageViewHeightDidChanged:(CGFloat )height;

@end

@interface YDHomePageManager : NSObject

@property (nonatomic,weak) id<YDHomePageManagerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *data;

/**
 当前用户已经没有任务，默认为NO,在用户登录和退出登录时需要置NO
 */
@property (nonatomic, assign) BOOL currentUserNoTask;

+ (YDHomePageManager *)manager;

- (void)insertIndexPath:(NSIndexPath *)index identifier:(NSString *)identifier;

- (void)removeIndexPath:(NSIndexPath *)index;

- (void)reloadDataSourceCompletion:(void (^)(void))completion;

- (void)reloadViewControllerData;

@end

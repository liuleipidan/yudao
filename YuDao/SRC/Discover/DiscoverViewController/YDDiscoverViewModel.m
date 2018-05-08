//
//  YDDiscoverViewModel.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/25.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDiscoverViewModel.h"

@interface YDDiscoverViewModel()

@property (nonatomic, strong) NSMutableArray *first;

@property (nonatomic, strong) NSMutableArray *second;

@property (nonatomic, strong) NSMutableArray *third;

@property (nonatomic, strong) NSMutableArray *fourth;

@end

@implementation YDDiscoverViewModel

- (id)init{
    if (self = [super init]) {
        _data = [NSMutableArray arrayWithObjects:self.first,self.second,self.fourth,nil];
    }
    return self;
}


- (void)reloadDataSource:(void (^)(void))completion{
    //未登录或没有车辆,不显示测一测
    BOOL hadTest = NO;
    for (YDCarDetailModel *car in [YDCarHelper sharedHelper].carArray) {
        if (car.boundDeviceType != YDCarBoundDeviceTypeNone) {
            hadTest = YES;
        }
    }
    BOOL needreload = NO;
    if (hadTest && ![_data containsObject:self.third]) {
        needreload = YES;
        [_data insertObject:self.third atIndex:2];
    }
    else if ((!hadTest || !YDHadLogin) && [_data containsObject:self.third]){
        needreload = YES;
        [_data removeObject:self.third];
    }
    if (completion && needreload) {
        completion();
    }
}

#pragma mark - Getters - Secotions
- (NSMutableArray *)first{
    if (!_first) {
        _first = [NSMutableArray arrayWithObjects:@{@"image":@"discover_rankingList",@"title":@"排行榜"}, nil];
    }
    return _first;
}
- (NSMutableArray *)second{
    if (!_second) {
        //@{@"image":@"discover_bibi",@"title":@"哔哔"},
        _second = [NSMutableArray arrayWithObjects:
                   @{@"image":@"disconver_shualian",@"title":@"刷脸"},
                   @{@"image":@"discover_guang",@"title":@"逛一逛"},nil];
    }
    return _second;
}
- (NSMutableArray *)third{
    if (!_third) {
        _third = [NSMutableArray arrayWithObjects:@{@"image":@"discover_ceyice",@"title":@"测一测"}, nil];
    }
    return _third;
}
- (NSMutableArray *)fourth{
    if (!_fourth) {
        _fourth = [NSMutableArray arrayWithObjects:
                   @{@"image":@"discover_play",@"title":@"玩一把"},
                   @{@"image":@"disconver_game",@"title":@"游戏"},nil];
    }
    return _fourth;
}

@end

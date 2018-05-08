//
//  YDHomePageManager.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/28.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHomePageManager.h"

@interface YDHomePageManager()<YDHPMessageControllerDelegate>

@property (nonatomic, strong) NSMutableArray *section_1;
@property (nonatomic, strong) NSMutableArray *section_2;
@property (nonatomic, strong) NSMutableArray *section_3;
@property (nonatomic, strong) NSMutableArray *section_4;


/**
 行车信息
 */
@property (nonatomic, strong) YDHomePageModel *row_1;

/**
 任务
 */
@property (nonatomic, strong) YDHomePageModel *row_2;

/**
 首页消息
 */
@property (nonatomic, strong) YDHomePageModel *row_3;

/**
 排行榜
 */
@property (nonatomic, strong) YDHomePageModel *row_4;

@end

static YDHomePageManager *hpManager = nil;

@implementation YDHomePageManager

+ (YDHomePageManager *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hpManager = [[YDHomePageManager alloc] init];
    });
    return hpManager;
}

- (id)init{
    if (self = [super init]) {
        [self y_initData];
        [[YDUserDefault defaultUser] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //添加首页模块被关闭或打开的通知
        [YDNotificationCenter addObserver:self selector:@selector(hpm_homePageModuleHadChangeNotificatoinAction:) name:kHPModuleHadChangeNotificatoin object:nil];
    }
    return self;
}

//初始化数据
- (void)y_initData{
    _section_1 = [NSMutableArray array];
    _section_2 = [NSMutableArray array];
    _section_3 = [NSMutableArray array];
    _section_4 = [NSMutableArray array];
    _data = [NSMutableArray arrayWithObjects:_section_1,
                                       _section_2,
                                       _section_3,
                                       _section_4, nil];

    [self reloadDataSourceCompletion:nil];
}

- (void)dealloc{
    [[YDUserDefault defaultUser] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    [YDNotificationCenter removeObserver:self name:kHPModuleHadChangeNotificatoin object:nil];
}

#pragma mark - Public Methods
- (void)reloadDataSourceCompletion:(void (^)(void))completion{
    if (YDHadLogin) {
        //父级类型():1->行车信息,2->任务,3->消息,4->排行榜
        //子级类型(默认为0，7000->天气,2001->周报)
        
        //行车信息
        YDHPIgnoreModel *carInfoIgnore = YDCheckHPIgnoreModel(YDUser_id, 1, 0);
        if (carInfoIgnore && [carInfoIgnore.ignore_type isEqual:@1]) {
            [self checkHPIgnoreModelMore24HourWithModel:carInfoIgnore section:_section_1 row:self.row_1];
        }
        else if (carInfoIgnore && [carInfoIgnore.ignore_type isEqual:@2]){//永久
            [self section:_section_1 removeObject:self.row_1];
        }
        else{
            if ([YDUserDefault defaultUser].user.ub_auth_grade.integerValue > 4) {
                [self section:_section_1 addObject:self.row_1];
            }
        }
        
        //用户任务，当用户有任务的时候才去检测设置里是否关闭了用户任务模块
        if (!self.currentUserNoTask) {
            YDHPIgnoreModel *taskIgnore = YDCheckHPIgnoreModel(YDUser_id, 2, 0);
            if (taskIgnore && [taskIgnore.ignore_type isEqual:@1]) {//24小时内
                
                [self checkHPIgnoreModelMore24HourWithModel:taskIgnore section:_section_2 row:self.row_2];
            }
            else if (taskIgnore && [taskIgnore.ignore_type isEqual:@2]){//永久
                [self section:_section_2 removeObject:self.row_2];
            }
            else{
                NSLog(@"%s --- requestUserTask",__func__);
                [(YDTaskController *)self.row_2.vc requestUserTask];
                //[self section:_section_2 addObject:self.row_2];
            }
        }
        
        //首页消息，默认此行存在，具体显示或隐藏用消息数据是否为空控制
        [self section:_section_3 addObject:self.row_3];
        
        //排行榜
        YDHPIgnoreModel *rankIgnore = YDCheckHPIgnoreModel(YDUser_id, 4, 0);
        if (rankIgnore && [rankIgnore.ignore_type isEqual:@1]) {
            [self checkHPIgnoreModelMore24HourWithModel:rankIgnore section:_section_4 row:self.row_4];
        }
        else if (rankIgnore && [rankIgnore.ignore_type isEqual:@2]){//永久
            [self section:_section_4 removeObject:self.row_4];
        }
        else{
            [self section:_section_4 addObject:self.row_4];
        }
        
    }else{
        [self section:_section_2 addObject:self.row_2];
        [self section:_section_4 addObject:self.row_4];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(HomePageManager:dataSourceDidChange:)]) {
        [self.delegate HomePageManager:self dataSourceDidChange:nil];
    }
    else if (completion){
        completion();
    }
}

- (void)reloadViewControllerData{
    if ([self.section_1 containsObject:self.row_1]) {
        [(YDTrafficInfoController *)self.row_1.vc requestTrafficInfo];
    }
    if ([self.section_2 containsObject:self.row_2]) {
        NSLog(@"%s --- requestUserTask",__func__);
        [(YDTaskController *)self.row_2.vc requestUserTask];
    }
    if ([self.section_3 containsObject:self.row_3]) {
        [[YDPushMessageManager sharePushMessageManager] post_requestHomePageMessagesByCurrentUserToken:YDAccess_token];
    }
    if ([self.section_4 containsObject:self.row_4]) {
        [(YDRankingListController *)self.row_4.vc downloadRankingListData];
    }
}

#pragma mark - YDUserDefaultDelegate
// - 用户设置加载完毕
- (void)defaultUserSettingLoaded{
    [self reloadDataSourceCompletion:nil];
}
// - 用户登录成功
- (void)defaultUserAlreadyLogged:(YDUser *)user{
    self.currentUserNoTask = NO;
}
// - 用户退出登录
- (void)defaultUserExitingLogin{
    self.currentUserNoTask = NO;
    for (NSMutableArray *section in self.data) {
        [section removeAllObjects];
    }
    
    [self section:_section_2 addObject:self.row_2];
    [self section:_section_4 addObject:self.row_4];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HomePageManager:dataSourceDidChange:)]) {
        [self.delegate HomePageManager:self dataSourceDidChange:nil];
    }
}

#pragma mark - Private Methods
//首页模块改变的通知回调
- (void)hpm_homePageModuleHadChangeNotificatoinAction:(NSNotification *)noti{
    YDHPIgnoreModel *ignore = noti.object;
    if ([ignore.ptype isEqual:@3]) {
        [[YDPushMessageManager sharePushMessageManager] post_requestHomePageMessagesByCurrentUserToken:YDAccess_token];
    }
    [self reloadDataSourceCompletion:nil];
}
/**
 忽略超过24小时
 */
- (void)checkHPIgnoreModelMore24HourWithModel:(YDHPIgnoreModel *)model
                                      section:(NSMutableArray *)section
                                          row:(id )row{
    NSDate *date = [NSDate stringToDate:model.time withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSUInteger hour = [NSDate differFirstDate:[NSDate date] secondDate:date differType:YDDifferDateTypeHour];
    if (hour >= 24) {
        YDHPIgnoreStore *store = [YDHPIgnoreStore manager];
        if ([store deleteHPIgnore:model.rid userId:model.uid]) {
            NSLog(@"删除本地设置表成功");
        }
        NSDictionary *para = @{@"access_token":YDAccess_token,
                               @"hm_id":model.rid};
        [YDNetworking GET:kDeleteUserHPIgnoreURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
            if ([code isEqual:@200]) {
                YDLog(@"超过24小时服务器同步成功");
            }
            else{
                YDLog(@"超过24小时服务器同步失败");
            }
        } failure:^(NSError *error) {
            YDLog(@"超过24小时服务器同步失败");
        }];
        [self section:section addObject:row];
    }else{
        [self section:_section_4 removeObject:self.row_4];
    }
}

- (void)insertIndexPath:(NSIndexPath *)index identifier:(NSString *)identifier{
    if ([identifier isEqualToString:@"task"]) {
        [self section:self.section_2 addObject:self.row_2];
        if (self.delegate && [self.delegate respondsToSelector:@selector(HomePageManager:insertIndexPath:)]) {
            [self.delegate HomePageManager:self insertIndexPath:index];
        }
    }
}

- (void)removeIndexPath:(NSIndexPath *)index{
    if (index) {
        NSMutableArray *sectionArr = [self.data objectAtIndex:index.section];
        if (sectionArr.count > index.row) {
            [sectionArr removeObjectAtIndex:index.row];
            if (self.delegate && [self.delegate respondsToSelector:@selector(HomePageManager:deleteIndexPath:)]) {
                [self.delegate HomePageManager:self deleteIndexPath:index];
            }
        }
    }
}

- (void)section:(NSMutableArray *)section addObject:(id)obj{
    if (![section containsObject:obj]) {
        [section addObject:obj];
    }
}

- (void)section:(NSMutableArray *)section removeObject:(id)obj{
    if ([section containsObject:obj]) {
        [section removeObject:obj];
    }
}

#pragma mark - YDHPMessageControllerDelegate
- (void)HPMessageController:(YDHPMessageController *)controller dataSourceDidChanged:(CGFloat )contentHeight{
    self.row_3.viewHeight = contentHeight;
    if (self.delegate && [self.delegate respondsToSelector:@selector(HomePageManager:messageViewHeightDidChanged:)]) {
        [self.delegate HomePageManager:self messageViewHeightDidChanged:contentHeight];
    }
}

#pragma mark - Getters
- (YDHomePageModel *)row_1{
    if (!_row_1) {
        _row_1 = [[YDHomePageModel alloc] init];
        _row_1.vc = [YDTrafficInfoController new];
        _row_1.title = @"行车信息";
        _row_1.viewHeight = 255.0f;
    }
    return _row_1;
}

- (YDHomePageModel *)row_2{
    if (!_row_2) {
        _row_2 = [[YDHomePageModel alloc] init];
        _row_2.vc = [YDTaskController new];
        _row_2.title = @"用户任务";
        _row_2.viewHeight = 190.0f;
    }
    return _row_2;
}

- (YDHomePageModel *)row_3{
    if (!_row_3) {
        _row_3 = [[YDHomePageModel alloc] init];
        YDHPMessageController *vc = [YDHPMessageController new];
        vc.messageDelegate = self;
        _row_3.vc = vc;
        _row_3.title = @"首页消息";
        _row_3.viewHeight = 0.0f;
    }
    return _row_3;
}

- (YDHomePageModel *)row_4{
    if (!_row_4) {
        _row_4 = [[YDHomePageModel alloc] init];
        _row_4.vc = [YDRankingListController new];
        _row_4.title = @"排行榜";
        _row_4.viewHeight = 264.0f;
    }
    return _row_4;
}

@end

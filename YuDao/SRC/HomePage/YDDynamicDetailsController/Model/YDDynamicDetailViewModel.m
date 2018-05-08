//
//  YDDynamicDetailViewModel.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDynamicDetailViewModel.h"

@interface YDDynamicDetailViewModel()

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation YDDynamicDetailViewModel

- (instancetype)initWithDynamicId:(NSNumber *)dy_id{
    if(self = [super init]){
        _dy_id = dy_id;
        _imageIndex = 0;
    }
    return self;
}

- (instancetype)initWithMoment:(YDMoment *)moment{
    if(self = [super init]){
        _moment = moment;
        _dy_id = moment.d_id;
        _dy_userId = moment.ub_id;
        _dy_userIcon = moment.ud_face;
        _dy_userName = moment.ub_nickname;
        _dy_label = moment.d_label;
        _dy_time = moment.d_time;
        _imageIndex = 0;
    }
    return self;
}

- (instancetype)initWithDyId:(NSNumber *)dyId
                    userId:(NSNumber *)userId
                  userIcon:(NSString *)userIcon
                  nickname:(NSString *)nickname
                     label:(NSString *)label
                      time:(NSString *)time{
    if(self = [super init]){
        _dy_id = dyId;
        _dy_userId = userId;
        _dy_userIcon = userIcon;
        _dy_userName = nickname;
        _dy_label = label;
        _dy_time = time;
        _imageIndex = 0;
    }
    return self;
}

- (void)requestDynamicFinish:(void (^)(YDRequestDyDetailFinishType type))finish{
    YDWeakSelf(self);
    _task = [YDNetworking GET:kDynamicDetailURL parameters:@{@"d_id":_dy_id} success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            weakself.dyDetailModel = [YDDynamicDetailModel mj_objectWithKeyValues:data];
            finish(YDRequestDyDetailFinishTypeSuccess);
        }
        else if ([code isEqual:@2007]){//动态不存在
            finish(YDRequestDyDetailFinishTypeNonexistent);
        }
        else{
            finish(YDRequestDyDetailFinishTypeFailure);
        }
    } failure:^(NSError *error) {
        finish(YDRequestDyDetailFinishTypeFailure);
    }];
}

- (void)cancelCurrentTask{
    if (_task) {
        [_task cancel];
        _task = nil;
    }
}

#pragma mark - Getter
- (NSUInteger)rowNumber{
    return 4 + self.dyDetailModel.commentdynamic.count;
}

@end

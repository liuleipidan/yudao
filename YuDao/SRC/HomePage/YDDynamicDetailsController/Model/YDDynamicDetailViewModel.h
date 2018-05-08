//
//  YDDynamicDetailViewModel.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDDynamicDetailModel.h"
#import "YDMoment.h"

typedef NS_ENUM(NSInteger, YDRequestDyDetailFinishType) {
    YDRequestDyDetailFinishTypeSuccess,
    YDRequestDyDetailFinishTypeFailure,
    YDRequestDyDetailFinishTypeNonexistent,
};

@interface YDDynamicDetailViewModel : NSObject

//动态id
@property (nonatomic, strong) NSNumber *dy_id;
//此条动态的用户id
@property (nonatomic, strong) NSNumber *dy_userId;
//用户头像
@property (nonatomic, copy  ) NSString *dy_userIcon;
//用户昵称
@property (nonatomic, copy  ) NSString *dy_userName;
//动态发布时间
@property (nonatomic, copy  ) NSString *dy_time;
//标签
@property (nonatomic, copy  ) NSString *dy_label;

//由逛一逛、我的动态、档案动态传递
@property (nonatomic, strong) YDMoment *moment;

//点击的图片索引,默认为0
@property (nonatomic, assign) NSInteger imageIndex;

//是否滑动到评论
@property (nonatomic, assign) BOOL scrollToComment;

//是否滑动到喜欢
@property (nonatomic, assign) BOOL scrollToLike;

#pragma mark - UI
@property (nonatomic, assign, readonly) NSUInteger rowNumber;

//具体动态内容
@property (nonatomic, strong) YDDynamicDetailModel *dyDetailModel;

- (instancetype)initWithDynamicId:(NSNumber *)dy_id;

- (instancetype)initWithMoment:(YDMoment *)moment;

- (instancetype)initWithDyId:(NSNumber *)dyId
                      userId:(NSNumber *)userId
                    userIcon:(NSString *)userIcon
                    nickname:(NSString *)nickname
                       label:(NSString *)label
                        time:(NSString *)time;

- (void)requestDynamicFinish:(void (^)(YDRequestDyDetailFinishType type))finish;

- (void)cancelCurrentTask;

@end

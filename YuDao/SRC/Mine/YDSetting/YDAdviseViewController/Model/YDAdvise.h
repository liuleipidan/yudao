//
//  YDAdvise.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDAdviseAnswer;
@interface YDAdvise : NSObject

//主id
@property (nonatomic, strong) NSNumber *fb_id;

//用户id
@property (nonatomic, strong) NSNumber *ub_id;

//反馈内容
@property (nonatomic, copy  ) NSString *content;

//反馈内容高度
@property (nonatomic, assign) CGFloat contentHeight;

//0 未回复 1已回复
@property (nonatomic, strong) NSNumber *type;

//提问时间（10位时间戳）
@property (nonatomic, strong) NSNumber *time;

//顶部高度（用户头像及问题高度）
@property (nonatomic, assign) CGFloat topPartHeight;

//回复
@property (nonatomic, strong) NSArray<YDAdviseAnswer *> *answers;

//所有内容高度
@property (nonatomic, assign) CGFloat wholeHeight;

@end


@interface YDAdviseAnswer : NSObject

//回复人id
@property (nonatomic, strong) NSNumber *ub_id;

//回复人名
@property (nonatomic, copy  ) NSString *name;

//回复内容
@property (nonatomic, copy  ) NSString *content;

//回复高度
@property (nonatomic, assign) CGFloat contentHeight;

//所有内容高度
@property (nonatomic, assign) CGFloat allHeight;

//回复时间
@property (nonatomic, strong) NSNumber *time;

@end

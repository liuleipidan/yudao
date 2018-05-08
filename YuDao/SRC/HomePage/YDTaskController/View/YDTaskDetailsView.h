//
//  YDTaskDetailsView.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/2.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDTaskModel.h"

@protocol YDTaskDetailsViewDelegate <NSObject>

- (void)taskDetailsReviewClickCancel;

- (void)taskDetailsReviewClickGO:(YDTaskModel *)model;

@end

/**
 任务详情弹出层
 */
@interface YDTaskDetailsView : UIView

@property (nonatomic,weak) id<YDTaskDetailsViewDelegate> delegate;

@property (nonatomic, strong) YDTaskModel *model;

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<YDTaskDetailsViewDelegate>)delegate;

@end

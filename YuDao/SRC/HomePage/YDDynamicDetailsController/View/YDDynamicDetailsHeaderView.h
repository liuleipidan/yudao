//
//  YDDynamicDetailsHeaderView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/20.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDynamicDetailModel.h"

@interface YDDynamicDetailsHeaderView : UIView

@property (nonatomic,copy) void (^DHClickedAvatarBlock )(YDDynamicDetailModel *item);

@property (nonatomic, strong) YDDynamicDetailModel *item;

@end

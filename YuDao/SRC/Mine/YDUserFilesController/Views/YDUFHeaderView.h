//
//  YDUFHeaderView.h
//  YuDao
//
//  Created by 汪杰 on 16/12/29.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDUFHeaderView;
@protocol YDUFHeaderViewDelegate <NSObject>

@optional
- (void)UFHeaderView:(YDUFHeaderView *)headerView didSelectedHeaderImageView:(UIImageView *)headerImageV;

@end

@interface YDUFHeaderView : UIView

@property (nonatomic,weak) id<YDUFHeaderViewDelegate> subDelegate;

@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UIView *bottomBgView;

@property (nonatomic, strong) UIImageView *backImageV;//背景
@property (nonatomic, strong) UIImageView *headerImageV;//头像
@property (nonatomic, strong) UIImageView *genderImageV;//性别

@property (nonatomic, strong) UIImageView *scrollImage;//滑动按钮

@property (nonatomic, strong) UILabel *nameLabel;//名字
@property (nonatomic, strong) UILabel *startLabel;//星座

@property (nonatomic, strong) UILabel  *levelLabel;//等级
@property (nonatomic, strong) UILabel *likeLabel;//喜欢
@property (nonatomic, strong) UILabel *scoreLabel;//积分

@property (nonatomic, strong) UIView *overView;//灰色覆盖视图

//刷新视图数据
- (void)updateDataWith:(NSString *)headerUrl name:(NSString *)name start:(NSString *)start gender:(NSInteger )gender level:(NSString *)level likeNum:(NSNumber *)likeNum score:(NSNumber *)score backgroudImageUrl:(NSString *)backgroudImageUrl;

@end

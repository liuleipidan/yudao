//
//  YDGaragesCell.h
//  YuDao
//
//  Created by 汪杰 on 17/1/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDGaragesCell;
@protocol YDGaragesCellDelegate <NSObject>

- (void)garagesCell:(YDGaragesCell *)cell didTouchButton:(UIButton *)sender;

@end

@interface YDGaragesCell : UITableViewCell

@property (nonatomic, copy  ) void (^garagesCellDeleteCarBlock)(YDCarDetailModel *model);

@property (nonatomic, weak ) id<YDGaragesCellDelegate> delegate;

@property (nonatomic, strong) UIView     *backgView; //背景图

@property (nonatomic, strong) UIImageView *authImageV;//是否认证图片

@property (nonatomic, strong) UILabel    *seriesLabel;//车系名

@property (nonatomic, strong) UIView     *buttonsView;//里面可能有多个button

@property (nonatomic, strong) UIButton   *deleteButton; //删除按钮

@property (nonatomic, strong) UIButton   *promptBtn;//状态提示栏

@property (nonatomic, strong) YDCarDetailModel *model;

@end

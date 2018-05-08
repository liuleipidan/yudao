//
//  YDUserBaseInfoCell.h
//  YuDao
//
//  Created by 汪杰 on 16/12/30.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDUserBaseInfoModel : NSObject

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *subTitle;

+ (YDUserBaseInfoModel *)userInfoModelWith:(NSString *)title subTitle:(NSString *)subTitle;

@end


@interface YDUserBaseInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;   //标题
@property (nonatomic, strong) UILabel *subTitleLabel;//副标题
@property (nonatomic, strong) UIView  *bottomLine;   //底部分割线

@property (nonatomic, strong) YDUserBaseInfoModel *model;

@end

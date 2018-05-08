//
//  YDScannerButton.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDScannerButton : UIButton

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, copy  ) NSString *iconPath;

@property (nonatomic, copy  ) NSString *iconHLPath;

@property (nonatomic, assign) YDScannerType type;

@property (nonatomic, strong) UIColor *textHLColor;

#pragma mark - 开发给子类调用
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *textLabel;

- (id)initWithType:(YDScannerType)type title:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath;

- (id)initWithTitle:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath;

@end

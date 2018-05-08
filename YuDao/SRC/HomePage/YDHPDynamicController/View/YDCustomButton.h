//
//  YDCustomButton.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/19.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

//Icon相对文字的位置
typedef NS_ENUM(NSInteger, YDCustomButtonIconType) {
    YDCustomButtonIconTypeTop = 0,
    YDCustomButtonIconTypeLeft,
    YDCustomButtonIconTypeBottom,
    YDCustomButtonIconTypeRight,
};

@interface YDCustomButton : UIButton

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, copy  ) NSString *iconPath;

@property (nonatomic, copy  ) NSString *iconHLPath;

@property (nonatomic, assign, readonly) YDCustomButtonIconType iconType;

//图片与文字的间距，默认是5
@property (nonatomic, assign) CGFloat iconTextSpace;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *textHLColor;

- (id)initWithTitle:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath iconType:(YDCustomButtonIconType)iconType;

@end

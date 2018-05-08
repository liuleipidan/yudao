//
//  YDThirdLoginView.h
//  YuDao
//
//  Created by 汪杰 on 2017/5/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YDThirdLoginPlatformType) {
    YDThirdLoginPlatformTypeWechat = 1,
    YDThirdLoginPlatformTypeQQ,
    YDThirdLoginPlatformTypeWebo,
};

@class YDThirdLoginView;
@protocol YDThirdLoginViewDelegate <NSObject>

@optional
- (void)thirdLoginView:(YDThirdLoginView *)view didSelectedPlatform:(YDThirdLoginPlatformType )platform;

@end

@interface YDThirdLoginView : UIView

@property (nonatomic,weak) id<YDThirdLoginViewDelegate> delegate;

@end

//
//  YDCardDetailsView.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/28.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDCard.h"

//默认高度，不包括卡券封面图片高度，webView预留最少一行的高度
#define kCardDetailsViewHeight_default 304

@class YDCardDetailsView;
@protocol YDCardDetailsViewDelegate <NSObject>

- (void)cardDetailsView:(YDCardDetailsView *)view webViewLoadFinish:(CGFloat )webViewContentHeight;

@end

@interface YDCardDetailsView : UIView

@property (nonatomic, weak  ) id<YDCardDetailsViewDelegate> delegate;

@property (nonatomic, strong) YDCard *cardDetails;

@end

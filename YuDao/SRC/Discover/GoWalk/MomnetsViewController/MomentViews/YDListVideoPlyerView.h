//
//  YDListVideoPlyerView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/12.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDListVideoPlyerView;
@protocol YDListVideoPlyerViewDelegate<NSObject>

- (void)listVideoPlyerViewDidClickedPlay:(YDListVideoPlyerView *)view;

@end


@interface YDListVideoPlyerView : UIView

+ (YDListVideoPlyerView *)sharedPlyerView;

@property (nonatomic, weak  ) id<YDListVideoPlyerViewDelegate> delegate;

- (void)showInView:(UIView *)view videoURL:(NSURL *)videoURL;

- (void)stopPlay;

@end

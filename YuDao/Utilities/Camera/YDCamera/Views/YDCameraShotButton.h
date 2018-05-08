//
//  YDCameraShotButton.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const outerRingMax = 88.0f;
static CGFloat const outerRingMin = 68.0f;

static CGFloat const innerRingMax = 50.0f;
static CGFloat const innerRingMin = 34.0f;

@class YDCameraShotButton;
@protocol YDCameraShotButtonDelegate<NSObject>

- (void)cameraShotButtonSingleClicked:(YDCameraShotButton *)button;

- (void)cameraShotButtonStartRecord:(YDCameraShotButton *)button;

- (void)cameraShotButtonEndRecord:(YDCameraShotButton *)button;

@end

@interface YDCameraShotButton : UIView

@property (nonatomic, weak  ) id<YDCameraShotButtonDelegate> delegate;

//禁止长按
@property (nonatomic, assign) BOOL disableLongpress;

- (void)startRecordCompletion:(void (^)(BOOL finished))completion;

- (void)endRecord;

@end

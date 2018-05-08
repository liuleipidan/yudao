//
//  YDRecorderIndicatorView.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YDRecorderStatus) {
    YDRecorderStatusRecording,
    YDRecorderStatusWillCancel,
    YDRecorderStatusTooShort,
};

@interface YDRecorderIndicatorView : UIView

@property (nonatomic, assign) YDRecorderStatus status;

/**
 音量（0-1)
 */
@property (nonatomic, assign) CGFloat volume;

@end

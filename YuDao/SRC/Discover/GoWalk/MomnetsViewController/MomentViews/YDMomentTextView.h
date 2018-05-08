//
//  YDMomentTextView.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDMomentFrame.h"

@interface YDMomentTextView : UIView

@property (nonatomic, strong) YDMomentFrame *momentFrame;

- (void)setText:(NSAttributedString *)text location:(NSString *)location;

@end

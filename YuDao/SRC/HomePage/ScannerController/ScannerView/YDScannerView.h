//
//  YDScannerView.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDScannerView : UIView

/**
 *  隐藏扫描指示器，默认NO
 */
@property (nonatomic, assign) BOOL hiddenScannerIndicator;

- (void)startScanner;

- (void)stopScanner;

@end

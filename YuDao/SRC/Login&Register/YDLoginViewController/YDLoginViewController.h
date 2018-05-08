//
//  YDLoginViewController.h
//  YuDao
//
//  Created by 汪杰 on 16/10/11.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDViewController.h"


#define kLoginURL [kOriginalURL stringByAppendingString:@"login"]

#define kAcountsPasswordWidth  38 * widthHeight_ratio
#define kAcountsPasswordHeight 18 * widthHeight_ratio

@interface YDLoginViewController : YDViewController

@property (nonatomic, strong) NSString *account;

@end

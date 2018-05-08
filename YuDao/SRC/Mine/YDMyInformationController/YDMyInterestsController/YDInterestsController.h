//
//  YDInterestsController.h
//  YuDao
//
//  Created by 汪杰 on 17/1/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTableViewController.h"

@class YDInterestsController;
@protocol YDInterestsControllerDelegate <NSObject>

- (void)interestsControllerDidChanged:(YDInterestsController *)controller
                                 ftag:(NSString *)ftag
                                  tag:(NSString *)tag
                             tag_name:(NSString *)tag_name;

@end

@interface YDInterestsController : YDTableViewController

@property (nonatomic, weak  ) id<YDInterestsControllerDelegate> delegate;

@end

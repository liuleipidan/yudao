//
//  YDTextDisplayView.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDTextDisplayView : UIView

@property (nonatomic, strong) NSAttributedString *attrString;

- (void)showInView:(UIView *)view
          attrText:(NSAttributedString *)attrText
         animation:(BOOL)animation;

@end

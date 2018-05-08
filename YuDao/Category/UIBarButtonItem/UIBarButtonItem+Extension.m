//
//  UIBarButtonItem+Extension.m
//  YuDao
//
//  Created by 汪杰 on 16/12/28.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (id)fixItemSpace:(CGFloat)space
{
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fix.width = space;
    return fix;
}

+ (instancetype)itemOffsetLeftWith:(NSString *)imageStr
                            target:(id)target
                            action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, kWidth(-25), 0, 0);
    btn.frame = CGRectMake(0, 0, 32, 32);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (instancetype)itemOffsetRightWith:(NSString *)imageStr
                             target:(id)target
                             action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kWidth(-25));
    btn.frame = CGRectMake(0, 0, 32, 32);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button sizeToFit];
    //button.frame = CGRectMake(0,0,18,18);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)itemWithImage:(NSString *)image target:(id)target action:(SEL)action{
    return [[self alloc] initWithImage:[UIImage imageNamed:image] style:UIBarButtonItemStylePlain target:target action:action];
}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    return [[self alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

- (id)initWithBackTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *view = [[UIButton alloc] init];
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_back_image"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setTextColor:[UIColor whiteColor]];
    [view addSubview:label];
    
    if (self = [self initWithCustomView:view]) {
        [imageView setFrame:CGRectMake(0, (34-19)/2.0, 11, 19)];
        CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        [label setFrame:CGRectMake(17, 0, size.width, 34)];
        [view setFrame:CGRectMake(0, 0, label.right, 34)];
    }
    return self;
}

@end

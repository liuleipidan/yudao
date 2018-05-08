//
//  YDBiBiTabBar.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBiBiTabBar.h"

@interface YDBiBiTabBar()

@property (nonatomic, strong) UIImageView *bgImgV;
@property (nonatomic, strong) UIButton *centerBtn;

@end

@implementation YDBiBiTabBar

- (instancetype)init{
    if (self = [super init]) {
        [self initItems];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initItems];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"layoutSubviews");
    //UIBarButtonItem *centerItem = [self.items objectAtIndex:2];
    CGPoint temp = self.center;
    _centerBtn.frame = CGRectMake(temp.x, temp.y, 60, 60);
    
    // 2.设置其它UITabBarButton的位置和尺寸
    CGFloat tabbarButtonW = self.frame.size.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            CGRect temp1=child.frame;
            temp1.size.width=tabbarButtonW;
            temp1.origin.x=tabbarButtonIndex * tabbarButtonW;
            child.frame=temp1;
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}

- (void)initItems{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTintColor:YDBaseColor];
    //去掉顶部横线
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setBackgroundImage:img];
    [self setShadowImage:img];
    
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"我的爱车" image:[UIImage imageNamed:@"discover_lovecar_normal"] tag:1000];
    [item1 setSelectedImage:[UIImage imageNamed:@"discover_lovecar_selected"]];
    
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"救援" image:[UIImage imageNamed:@"discover_rescue_normal"] tag:1001];
    [item2 setSelectedImage:[UIImage imageNamed:@"discover_rescue_selected"]];
    
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"打招呼" image:[UIImage imageNamed:@"discover_sayhi_normal"] tag:1003];
    [item4 setSelectedImage:[UIImage imageNamed:@"discover_sayhi_selected"]];
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:@"停车场" image:[UIImage imageNamed:@"discover_parkinglot_normal"] tag:1004];
    [item5 setSelectedImage:[UIImage imageNamed:@"discover_parkinglot_selected"]];
    [self setItems:@[item1,item2,item4,item5]];
    
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_centerBtn setImage:@"discover_add_icon" imageHL:@"discover_add_icon"];
    [self addSubview:_centerBtn];
    [self bringSubviewToFront:_centerBtn];
    
}


@end

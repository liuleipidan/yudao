//
//  YDBiBiPopViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBiBiPopViewController.h"
#import "MenuButton.h"
#import "FXBlurView.h"

@interface YDBiBiPopViewController ()

@property (nonatomic, strong) UIImageView *bgImgV;

@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic, strong) FXBlurView *blurView;

@property (nonatomic, strong) NSTimer *upTimer;

@property (nonatomic, strong) NSTimer *downTimer;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIImageView *closeImgV;

@property (nonatomic, assign) NSUInteger upIndex;

@property (nonatomic, assign) NSUInteger downIndex;


@end

@implementation YDBiBiPopViewController

- (instancetype)initWithBackgroundImage:(UIImage *)image{
    if (self = [super init]) {
        _bgImage = image;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = NO;
    
    //self.blurView.hidden = YES;
    _images = @[@"dicover_pop_gasstation",
                @"dicover_pop_4s",
                @"dicover_pop_help"];
    _titles = @[@"加油站",@"4S店",@"救助"];
    _items = [NSMutableArray arrayWithCapacity:_images.count];
    [self initBackgroundImage];
    [self initItems];
    [self initCloseImg];
    
    _upTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(popupBtn) userInfo:nil repeats:YES];
    
    //添加手势点击事件
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [self.view addGestureRecognizer:touch];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.6 animations:^{
        
        _closeImgV.transform = CGAffineTransformRotate(_closeImgV.transform, M_PI);
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_upTimer) {
        [_upTimer invalidate];
        _upTimer = nil;
    }
    if (_downTimer) {
        [_downTimer invalidate];
        _downTimer = nil;
    }
}

//背景图片
- (void)initBackgroundImage{
    _bgImgV = [UIImageView new];
    _bgImgV.image = _bgImage;
    [self.view addSubview:_bgImgV];
    [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _blurView = [FXBlurView new];
    _blurView.tintColor = nil;
    _blurView.blurRadius = 20.0;
    [self.view addSubview:_blurView];
    [_blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
//添加item
- (void)initItems{
    int cols = 3;
    int col = 0;
    int row = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat wh = 90;
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - cols * wh) / (cols + 1);
    CGFloat oriY = SCREEN_HEIGHT-(90 + 120);
    for (int i = 0; i < _images.count; i++) {
        MenuButton *btn = [MenuButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:_images[i]];
        NSString *title = _titles[i];
        [btn setImage:img forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        
        col = i % cols;
        row = i / cols;
        x = margin + col * (margin + wh);
        y = row * (margin + wh) + oriY;
        btn.frame = CGRectMake(x, y, wh, wh);
        btn.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(touchDownBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_items addObject:btn];
        [self.view addSubview:btn];
    }
}
//关闭按钮
- (void)initCloseImg{
    _closeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dicover_pop_close"]];
    [self.view addSubview:_closeImgV];
    [_closeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-12);
        make.width.height.mas_equalTo(25);
    }];
}

//点击按钮进行放大动画效果直到消失
- (void)touchDownBtn:(MenuButton *)btn{
    [UIView animateWithDuration:0.5 animations:^{
        btn.transform = CGAffineTransformMakeScale(2.0, 2.0);
        btn.alpha = 0;
    } completion:^(BOOL finished) {
        [self touchesBegan:nil];
        if (_selectedItemBlock) {
            _selectedItemBlock(btn.tag-1000);
        }
    }];
}

- (void)popupBtn{
    if (_upIndex == _items.count) {
        [_upTimer invalidate];
        _upTimer = nil;
        _upIndex = 0;
        return;
    }
    MenuButton *btn = _items[_upIndex];
    [self setUpOneBtnAnim:btn];
    _upIndex++;
}
//设置按钮从第一个开始向上滑动显示
- (void)setUpOneBtnAnim:(UIButton *)btn{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        btn.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        //获取当前显示的菜单控件的索引
        _downIndex = _items.count - 1;
        //当最后一个item加载完，view可点击
        if ([btn isEqual:_items.lastObject]) {self.view.userInteractionEnabled = YES;}
    }];
    
}
//点击事件返回上一控制器,并且旋转145弧度关闭按钮
-(void)touchesBegan:(UITapGestureRecognizer *)touches{
    _downTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(returnUpVC) userInfo:nil repeats:YES];
    [UIView animateWithDuration:0.3 animations:^{
        _closeImgV.transform = CGAffineTransformRotate(_closeImgV.transform, -M_PI_2*1.5);
    }];
    
}
//设置按钮从后往前下落
- (void)returnUpVC{
    if (_downIndex == -1) {
        [_downTimer invalidate];
        _downTimer = nil;
        return;
    }
    MenuButton *btn = _items[_downIndex];
    [self setDownOneBtnAnim:btn];
    _downIndex--;
}

//按钮下滑并返回上一个控制器
- (void)setDownOneBtnAnim:(UIButton *)btn{
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
}

@end

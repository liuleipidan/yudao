//
//  YDLaunchImageAdTool.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDLaunchImageAdTool.h"

@interface YDLaunchImageAdTool()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) YDLaunchImageDismissType dismissType;

@property (nonatomic, copy  ) NSString *placeholderImage;

@end

@implementation YDLaunchImageAdTool

- (id)init{
    if (self = [super init]) {
        
        kDefaultAdImageTime = 5;
        
        [self.bgView addSubview:self.imageView];
        [self.bgView addSubview:self.button];
        
        [self li_addMasonry];
        
        /*
        //获取所有启动图片信息数组NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSArray *launchImagesArr = infoDict[@"UILaunchImages"];
        NSLog(@"launchImagesArr: %@", launchImagesArr);
         */
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)showImageByLocalPath:(NSString *)path dismissBlock:(YDLaunchImageDismissBlock)dismissBlock{
    self.isShow = YES;
    
    self.imageView.image = [UIImage imageNamed:path];
    
    [self showImageByDismissBlock:dismissBlock];
}

- (void)showImageByURL:(NSString *)url dismissBlock:(YDLaunchImageDismissBlock)dismissBlock{
    self.isShow = YES;
    
    [self.imageView yd_setImageWithString:url placeholaderImageString:self.placeholderImage];
    
    [self showImageByDismissBlock:dismissBlock];
}

- (void)showAdImageByDismissBlock:(YDLaunchImageDismissBlock)dismissBlock{
    self.dismissBlock = dismissBlock;
    if (self.imageURL.length == 0) {
        [YDLaunchImageAdTool getLaunchImageUrlSuccess:^(NSString *defaultImageUrl, NSString *iPhoneXImageUrl) {
            if (defaultImageUrl.length == 0 || iPhoneXImageUrl.length == 0) {
                if (self.imageURL) {
                    [YDStandardUserDefaults removeObjectForKey:kAlreadyHadLaunchImageURL];
                }
                dismissBlock(YDLaunchImageDismissTypeNone);
            }
            else{
                [YDStandardUserDefaults setObject:IS_IPHONEX ? iPhoneXImageUrl : defaultImageUrl forKey:kAlreadyHadLaunchImageURL];
                [YDStandardUserDefaults synchronize];
                dismissBlock(YDLaunchImageDismissTypeFirstTime);
//                [self showImageByURL:self.imageURL dismissBlock:dismissBlock];
//                [YDLaunchImageAdTool downloadImageByUrl:self.imageURL];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    dismissBlock(YDLaunchImageDismissTypeNone);
//                });
            }
        } failure:^{
            dismissBlock(YDLaunchImageDismissTypeNone);
        }];
    }
    else{
        [self showImageByURL:self.imageURL dismissBlock:dismissBlock];
        [YDLaunchImageAdTool getLaunchImageUrlSuccess:^(NSString *defaultImageUrl, NSString *iPhoneXImageUrl) {
            if (defaultImageUrl.length == 0 || iPhoneXImageUrl.length == 0) {
                if (self.imageURL) {
                    [YDStandardUserDefaults removeObjectForKey:kAlreadyHadLaunchImageURL];
                }
            }
            else {
                if (IS_IPHONEX && ![iPhoneXImageUrl isEqualToString:self.imageURL]) {
                    [YDStandardUserDefaults setObject:iPhoneXImageUrl forKey:kAlreadyHadLaunchImageURL];
                }
                else if (!IS_IPHONEX && ![defaultImageUrl isEqualToString:self.imageURL]){
                    [YDStandardUserDefaults setObject:defaultImageUrl forKey:kAlreadyHadLaunchImageURL];
                }
                [YDStandardUserDefaults synchronize];
            }
        } failure:^{
            
        }];
    }
}

- (void)dismiss{
    self.isShow = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [UIView animateWithDuration:dismissDuration animations:^{
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.dismissBlock(self.dismissType);
        [self.bgView removeFromSuperview];
    }];
}

#pragma mark - Private Methods
+ (void)getLaunchImageUrlSuccess:(void (^)(NSString *defaultImageUrl,NSString *iPhoneXImageUrl))success
                         failure:(void (^)(void))failure
{
    [YDNetworking GET:kGetLaunchImageURL parameters:nil success:^(NSNumber *code, NSString *status, id data) {
        
        if ([code isEqual:@200]) {
            NSString *defaultImage = [data objectForKey:@"defaultImage"];
            NSString *iPhoneXImage = [data objectForKey:@"iPhoneXImage"];
            if (success) {
                success(defaultImage,iPhoneXImage);
            }
        }
        else{
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

+ (void)downloadImageByUrl:(NSString *)imageUrl{
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    if (image == nil) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:YDURL(imageUrl) options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl toDisk:YES completion:nil];
            }
        }];
    }
}

+ (BOOL)canShow{
    NSDate *showDate = [YDStandardUserDefaults objectForKey:kAdImageFirstShowTime];
    if (showDate == nil) {
        [YDStandardUserDefaults setObject:[NSDate date] forKey:kAdImageFirstShowTime];
        return YES;
    }
    
    if ([showDate isToday]) {
        return NO;
    }
    
    return YES;
}
- (void)showImageByDismissBlock:(YDLaunchImageDismissBlock)dismissBlock{
    
    [self.button setTitle:[NSString stringWithFormat:@"跳过 %lds",kDefaultAdImageTime] forState:0];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.bgView setFrame:window.bounds];
    [window addSubview:self.bgView];
    if (self.timer == nil) {
        YDWeakSelf(self);
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer *timer) {
            kDefaultAdImageTime--;
            [weakself.button setTitle:[NSString stringWithFormat:@"跳过 %lds",kDefaultAdImageTime] forState:0];
            if (kDefaultAdImageTime == 0) {
                weakself.dismissType = YDLaunchImageDismissTypeTimeout;
                [weakself dismiss];
            }
            
        } repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
- (void)li_addMasonry{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(STATUSBAR_HEIGHT);
        make.right.equalTo(self.bgView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
}

#pragma mark - Events
- (void)li_clickImageView:(UIGestureRecognizer *)tap{
    //self.dismissType = YDLaunchImageDismissTypeClickImage;
    //[self dismiss];
}

- (void)li_clickButton:(UIButton *)sender{
    self.dismissType = YDLaunchImageDismissTypeClickButton;
    [self dismiss];
}

#pragma mark - Getters
- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(li_clickImageView:)]];
    }
    return _imageView;
}

- (UIButton *)button{
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitle:@"开始了" forState:0];
        [_button addTarget:self action:@selector(li_clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_button.layer setCornerRadius:8.0f];
        [_button.titleLabel setFont:[UIFont font_16]];
    }
    return _button;
}

- (NSString *)placeholderImage{
    if (_placeholderImage == nil) {
        _placeholderImage = IS_IPHONEX ? @"LaunchImage-1100-Portrait-2436h" : @"LaunchImage-800-667h";
    }
    return _placeholderImage;
}

- (NSString *)imageURL{
    return [YDStandardUserDefaults objectForKey:kAlreadyHadLaunchImageURL];
}

@end

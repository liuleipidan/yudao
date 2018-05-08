//
//  YDMomentMultilImagesView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMomentMultilImagesView.h"

@interface YDMomentMultilImagesView()

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation YDMomentMultilImagesView

- (instancetype)init{
    if (self = [super init]) {
        _imageViews = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

#pragma mark - Events
- (void)mm_itemAction:(UIGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(momentImagesViewClickImageMoment:atIndex:)]) {
        [self.delegate momentImagesViewClickImageMoment:nil atIndex:tap.view.tag];
    }
}

- (void)setImages:(NSArray *)images{
    if (images.count == 0) {
        return;
    }
    if (images.count == self.imageViews.count) {
        
        [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *item = self.imageViews[idx];
            [item sd_setImageWithURL:YDURL(obj)];
        }];
        return;
    }
    [self.imageViews removeAllObjects];
    [self removeAllSubViews];
    CGFloat width = SCREEN_WIDTH - 2 * 9;
    NSUInteger count = images.count;
    
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *item;
        if (idx < self.images.count) {
            item = self.imageViews[idx];
        }else{
            item = [UIImageView new];
            item.backgroundColor = [UIColor grayBackgoundColor];
            item.contentMode = UIViewContentModeScaleAspectFill;
            item.layer.borderWidth = 1.0f;
            item.layer.borderColor = [UIColor whiteColor].CGColor;
            item.clipsToBounds = YES;
            item.userInteractionEnabled = YES;
            [item setTag:idx];
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mm_itemAction:)]];
            [self.imageViews addObject:item];
        }
        //[item yd_setImageFadeinWithString:obj];
        [item sd_setImageWithURL:YDURL(obj)];
        [self addSubview:item];
        CGRect frame;
        if (count == 1) {
            frame = CGRectMake(0, 0, width, width);
        }
        else if (count == 2){
            if (idx == 0) {
                frame = CGRectMake(0, 0, width/2, width);
            }else{
                frame = CGRectMake(width/2, 0, width/2, width);
            }
        }
        else if (count == 3){
            if (idx == 0) {
                frame = CGRectMake(0, 0, width/2, width);
            }
            else if (idx == 1){
                frame = CGRectMake(width/2, 0, width/2, width/2 );
            }
            else{
                frame = CGRectMake(width/2, width/2 ,width/2, width/2);
            }
        }
        else if (count == 4){
            if (idx == 0) {
                frame = CGRectMake(0, 0, width/2 , width/2);
            }else if (idx == 1){
                frame = CGRectMake(width/2, 0, width/2 , width/2);
            }else if (idx == 2){
                frame = CGRectMake(0, width/2, width/2 , width/2);
            }else{
                frame = CGRectMake(width/2 , width/2, width/2 , width/2 );
            }
        }
        else if (count == 5){
            if (idx == 0) {
                frame = CGRectMake(0, 0, width/2 , width/2 );
            }else if (idx == 1){
                frame = CGRectMake(0, width/2 , width/2 , width/2 );
            }else if (idx == 2){
                frame = CGRectMake(width/2 , 0, width/2 , width/3);
            }else if (idx == 3){
                frame = CGRectMake(width/2 , width/3,  width/2 , width/3 );
            }else{
                frame = CGRectMake(width/2 , 2*width/3, width/2 , width/3);
            }
        }
        else if (count == 6){
            if (idx == 0) {
                frame = CGRectMake(0, 0, 2*width/3, 2*width/3);
            }else if (idx == 1){
                frame = CGRectMake(2*width/3, 0, width/3, width/3);
            }else if (idx == 2){
                frame = CGRectMake(2*width/3, width/3, width/3, width/3);
            }else if (idx == 3){
                frame = CGRectMake(0, 2*width/3, width/3, width/3);
            }else if (idx == 4){
                frame = CGRectMake(width/3, 2*width/3, width/3, width/3);
            }else {
                frame = CGRectMake(2*width/3, 2*width/3, width/3, width/3);
            }
        }
        else if (count == 7){
            if (idx == 0) {
                frame = CGRectMake(0, 0, width/3, width/2);
            }else if (idx == 1){
                frame = CGRectMake(width/3, 0, width/3, width/2);
            }else if (idx == 2){
                frame = CGRectMake(2*width/3, 0, width/3, width/2);
            }else if (idx == 3){
                frame = CGRectMake(0, width/2, width/4, width/2);
            }else if (idx == 4){
                frame = CGRectMake(width/4, width/2, width/4, width/2);
            }else if (idx == 5){
                frame = CGRectMake(2*width/4, width/2, width/4, width/2);
            }else {
                frame = CGRectMake(3*width/4, width/2, width/4, width/2);
            }
        }
        else if (count == 8){
            if (idx == 0) {
                frame = CGRectMake(0, 0, width/2, width/2);
            }else if (idx == 1){
                frame = CGRectMake(width/2, 0, width/2, width/2);
            }else if (idx == 2){
                frame = CGRectMake(0, width/2, width/3, width/4);
            }else if (idx == 3){
                frame = CGRectMake(width/3, width/2, width/3, width/4);
            }else if (idx == 4){
                frame = CGRectMake(2*width/3, width/2, width/3, width/4);
            }else if (idx == 5){
                frame = CGRectMake(0, 3*width/4, width/3, width/4);
            }else if (idx == 6){
                frame = CGRectMake(width/3, 3*width/4, width/3, width/4);
            }else {
                frame = CGRectMake(2*width/3, 3*width/4, width/3, width/4);
            }
        }
        else {
            if (idx == 0) {
                frame = CGRectMake(0, 0, width/3, width/3);
            }else if (idx == 1){
                frame = CGRectMake(width/3, 0, width/3, width/3);
            }else if (idx == 2){
                frame = CGRectMake(2*width/3, 0, width/3, width/3);
            }else if (idx == 3){
                frame = CGRectMake(0, width/3, width/3, width/3);
            }else if (idx == 4){
                frame = CGRectMake(width/3, width/3, width/3, width/3);
            }else if (idx == 5){
                frame = CGRectMake(2*width/3, width/3, width/3, width/3);
            }else if (idx == 6){
                frame = CGRectMake(0, 2*width/3, width/3, width/3);
            }else if (idx == 7){
                frame = CGRectMake(width/3, 2*width/3, width/3, width/3);
            }else {
                frame = CGRectMake(2*width/3, 2*width/3, width/3, width/3);
            }
        }
        item.frame = frame;
    }];
    
}


@end

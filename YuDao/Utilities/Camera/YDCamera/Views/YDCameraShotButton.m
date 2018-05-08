//
//  YDCameraShotButton.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCameraShotButton.h"

@interface YDCameraShotButton()

@property (nonatomic, strong) UIImageView *outerRing;

@property (nonatomic, strong) UIImageView *innerRing;

@property (nonatomic, strong) UILongPressGestureRecognizer *press;

@end

@implementation YDCameraShotButton

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self yd_addSubviews:@[self.outerRing,self.innerRing]];
        
        [self.outerRing mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(outerRingMin);
        }];
        
        [self.innerRing mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(innerRingMax);
        }];
        
        [self csb_addGestureRecongizers];
    }
    return self;
}


#pragma mark - Public Methods
- (void)setDisableLongpress:(BOOL)disableLongpress{
    _disableLongpress = disableLongpress;
    if (disableLongpress) {
        [self.press removeTarget:nil action:nil];
    }
}

- (void)startRecordCompletion:(void (^)(BOOL finished))completion{
    [UIView animateWithDuration:0.25 animations:^{
        [self.outerRing mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(outerRingMax);
        }];
        
        [self.innerRing mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(innerRingMin);
        }];
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
    
}

- (void)endRecord{

    [self.outerRing mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(outerRingMin);
    }];
    
    [self.innerRing mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(innerRingMax);
    }];
}

#pragma mark - Private Methods
- (void)csb_addGestureRecongizers{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(csb_singleTapAction:)];
    [self addGestureRecognizer:tap];
    
    _press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(csb_longPressAction:)];
    _press.minimumPressDuration = 1.0f;
    _press.allowableMovement = 80.0f;
    
    [self addGestureRecognizer:_press];
}

//单击
- (void)csb_singleTapAction:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(cameraShotButtonSingleClicked:)]) {
        [_delegate cameraShotButtonSingleClicked:self];
    }
}

//双击
- (void)csb_longPressAction:(UILongPressGestureRecognizer *)press{
    switch (press.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self startRecordCompletion:^(BOOL finished) {
                if (finished) {
                    if (_delegate && [_delegate respondsToSelector:@selector(cameraShotButtonStartRecord:)]) {
                        [_delegate cameraShotButtonStartRecord:self];
                    }
                }
            }];
            
            break;}
        case UIGestureRecognizerStateChanged:
            
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self endRecord];
            if (_delegate && [_delegate respondsToSelector:@selector(cameraShotButtonEndRecord:)]) {
                [_delegate cameraShotButtonEndRecord:self];
            }
            break;}
        default:
        break;
    }
}

#pragma mark - Getter
- (UIView *)outerRing{
    if (_outerRing == nil) {
        _outerRing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_circle_outside"]];
        _outerRing.backgroundColor = [UIColor clearColor];
//        _outerRing.layer.cornerRadius = outerRingMin/2.0;
//        _outerRing.layer.borderColor = [UIColor whiteColor].CGColor;
//        _outerRing.layer.borderWidth = 6.0f;
//        _outerRing.clipsToBounds = YES;
    }
    return _outerRing;
}

- (UIView *)innerRing{
    if (_innerRing == nil) {
        _innerRing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_circle_inside"]];
        _innerRing.backgroundColor = [UIColor clearColor];
//        _innerRing.layer.cornerRadius = innerRingMax/2.0;
//        _innerRing.clipsToBounds = YES;
    }
    return _innerRing;
}

@end

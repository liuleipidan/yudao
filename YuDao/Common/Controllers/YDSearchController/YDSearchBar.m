//
//  YDSearchBar.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/26.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSearchBar.h"

// icon宽度
static CGFloat const searchIconW = 20.0;
// icon与placeholder间距
static CGFloat const iconSpacing = 10.0;
// 占位文字的字体大小
static CGFloat const placeHolderFont = 15.0;

@interface YDSearchBar ()

// placeholder 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;

@end


@implementation YDSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *view in [self.subviews lastObject].subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            // 重设field的frame
            field.frame = CGRectMake(15.0, 7.5, self.frame.size.width-30.0, self.frame.size.height-15.0);
            [field setBackgroundColor:[UIColor whiteColor]];
            field.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            
            field.borderStyle = UITextBorderStyleNone;
            field.layer.cornerRadius = 2.0f;
            field.layer.masksToBounds = YES;
            
            // 设置占位文字字体颜色
            [field setValue:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            [field setValue:[UIFont systemFontOfSize:placeHolderFont] forKeyPath:@"_placeholderLabel.font"];
            
            if (@available(iOS 11.0, *)) {
                // 先默认居中placeholder
                [self setPositionAdjustment:UIOffsetMake((field.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
            }
        }
    }
}

// 开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    }
    // 继续传递代理方法
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        return [self.delegate searchBarShouldBeginEditing:self];
    }
   
    return YES;
}
// 结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [self.delegate searchBarShouldEndEditing:self];
    }
    
    return YES;
}

// 计算placeholder、icon、icon和placeholder间距的总宽度
- (CGFloat)placeholderWidth {
    if (!_placeholderWidth) {
        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
        _placeholderWidth = size.width + iconSpacing + searchIconW;
    }
    return _placeholderWidth;
}

@end

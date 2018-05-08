//
//  YDDynamicLabelButton.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/3.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDynamicLabelButton.h"

@interface YDDynamicLabelButton()

@property (nonatomic, strong) UILabel *textLabel;

@end


@implementation YDDynamicLabelButton

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.textLabel];
        [self.textLabel setFrame:CGRectMake(10, 0, frame.size.width - 30, frame.size.height)];
        
        UIImage *image = [UIImage imageNamed:@"discover_pd_labelBG"];
        UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        [self setBackgroundImage:newImage forState:0];
        
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text;
    _textLabel.text = text;
}

#pragma mark - Getter
- (UILabel *)textLabel{
    if (_textLabel == nil) {
        
        _textLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    }
    return _textLabel;
}

@end

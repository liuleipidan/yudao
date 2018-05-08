//
//  YDUserBaseInterestCell.m
//  YuDao
//
//  Created by 汪杰 on 16/12/30.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUserBaseInterestCell.h"

#define kInMargin 15

@implementation YDUserBaseInterestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)setInterestArray:(NSArray *)interestArray{
    _interestArray = interestArray;
    if (self.contentView.subviews.count > 0) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.contentView addSubview:self.titleLabel];
    }
    __block CGFloat wy = 0;
    [_interestArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *string = obj;
        if (string.length > 0) {
            NSDictionary *attribute =@{NSFontAttributeName:kFont(14),
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
            UILabel *label = [UILabel new];
            label.text = obj;
            label.textColor = [UIColor whiteColor];
            UIColor *backgroundColor = nil;
            if (self.f_tags && self.f_tags.count == _interestArray.count) {
                NSString *fid = [self.f_tags objectAtIndex:idx];
                if ([fid isEqualToString:@"1"]) {
                    backgroundColor = [UIColor colorWithString:@"#7B90D2"];
                }else if ([fid isEqualToString:@"2"]){
                    backgroundColor = [UIColor orangeTextColor];
                }else if ([fid isEqualToString:@"3"]){
                    backgroundColor = [UIColor colorWithString:@"#ABDA78"];
                }else{
                    backgroundColor = [UIColor colorWithString:@"#7B90D2"];
                }
            }else{
                backgroundColor = [UIColor colorWithString:@"#7B90D2"];
            }
            label.backgroundColor = backgroundColor;
            label.layer.cornerRadius = 8.f;
            label.layer.masksToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            CGSize titleSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
            label.size = CGSizeMake(titleSize.width+17, 28);
            label.y = 41;
            
            if (idx == 0) {
                label.x = kInMargin;
            }else{
                label.x = wy + kInMargin;
            }
            wy += label.size.width + kInMargin;
            
            [self.contentView addSubview:label];
        }
        
    }];
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:15];
        _titleLabel.frame = CGRectMake(20, 10, 150, 21);
        _titleLabel.text = @"个人兴趣";
    }
    return _titleLabel;
}


@end

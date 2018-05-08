//
//  YDTableViewCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/5/18.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTableViewCell.h"

@implementation YDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        self.opaque = YES;
    }
    return self;
}

- (void)setSubviewsOpaque:(BOOL )opaque{
    for (UIView *subview in self.contentView.subviews) {
        subview.opaque = YES;
    }
}

@end

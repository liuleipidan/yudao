//
//  YDSettingButtonCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSettingButtonCell.h"

@implementation YDSettingButtonCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

- (void) setItem:(YDSettingItem *)item{
    _item = item;
    [self.textLabel setText:item.title];
}

@end

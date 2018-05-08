//
//  YDDDLocationCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDDLocationCell.h"
#import "YDCustomButton.h"

@interface YDDDLocationCell()

@property (nonatomic, strong) YDCustomButton *locationButton;

@end

@implementation YDDDLocationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setClipsToBounds:YES];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView yd_addSubviews:@[self.locationButton]];
        
        [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(17);
            make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-20);
        }];
    }
    return self;
}

- (void)setLocationText:(NSString *)locationText{
    _locationText = locationText;
    [_locationButton setTitle:locationText];
}

- (YDCustomButton *)locationButton{
    if (_locationButton == nil) {
        _locationButton = [[YDCustomButton alloc] initWithTitle:@"" iconPath:@"discover_pd_location" iconHLPath:@"discover_pd_location" iconType:YDCustomButtonIconTypeLeft];
    }
    return _locationButton;
}



@end

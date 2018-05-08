//
//  YDDDVideoCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/20.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDDVideoCell.h"

@interface YDDDVideoCell()



@end

@implementation YDDDVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = 0;
        self.backgroundColor = [UIColor whiteColor];
        
        _thumbnailImageView = [UIImageView new];
        _thumbnailImageView.backgroundColor = [UIColor blackColor];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbnailImageView.userInteractionEnabled = YES;
        
        _playIcon = [[UIImageView alloc] initWithImage:YDImage(@"video_icon_play")];
        _playIcon.userInteractionEnabled = YES;
        [_playIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vc_videoIconAction:)]];
        
        [self.contentView addSubview:_thumbnailImageView];
        [_thumbnailImageView addSubview:_playIcon];
        
        [_thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
        }];
        
        [_playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_thumbnailImageView);
            make.width.height.mas_equalTo(50);
        }];
    }
    return self;
}

#pragma mark - Event
- (void)vc_videoIconAction:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(dynamicVideoCellDidClickedVideo:)]) {
        [_delegate dynamicVideoCellDidClickedVideo:self];
    }
}

- (void)setItem:(YDDynamicDetailModel *)item{
    if (_item && [_item.d_id isEqual:item.d_id]) {
        NSLog(@"%s _item.d_id isEqual:item.d_id",__func__);
        return;
    }
    if (item.imagesDicArray.count > 0) {
        NSDictionary *dic = item.imagesDicArray.firstObject;
        [self.thumbnailImageView yd_setImageFadeinWithString: [dic valueForKey:@"url"]];
    }
}


@end

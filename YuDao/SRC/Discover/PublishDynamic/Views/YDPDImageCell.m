//
//  YDPDImageCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPDImageCell.h"

@interface YDPDImageCell()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *deleteItem;

@property (nonatomic, strong) UIImageView *videoIcon;

@end

@implementation YDPDImageCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _isVideo = NO;
        
        [self.contentView yd_addSubviews:@[self.imageView,self.deleteItem,self.videoIcon]];
        [self pdi_addMasonry];
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

- (void)setIsVideo:(BOOL)isVideo{
    _isVideo = isVideo;
    _videoIcon.hidden = !isVideo;
}

- (void)pdi_clickedDeleteItem:(UIGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(clickedDelete:)]) {
        [_delegate clickedDelete:self.imageIndex];
    }
}

- (void)pdi_addMasonry{
    [self.deleteItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.top.equalTo(self.deleteItem.mas_bottom).offset(-10);
        make.right.equalTo(self.deleteItem.mas_left).offset(10);
    }];
    
    [self.videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
        make.width.height.mas_equalTo(25);
    }];
}

#pragma mark - Getters
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UIImageView *)deleteItem{
    if (_deleteItem == nil) {
        _deleteItem = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_pd_deleteIcon"]];
        _deleteItem.userInteractionEnabled = YES;
        [_deleteItem addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pdi_clickedDeleteItem:)]];
    }
    return _deleteItem;
}

- (UIImageView *)videoIcon{
    if (_videoIcon == nil) {
        _videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_icon_play"]];
        _videoIcon.hidden = YES;
    }
    return _videoIcon;
}

@end

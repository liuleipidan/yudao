//
//  YDDDImagesCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/20.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDDImagesCell.h"

@interface YDDDImagesCell()



@end

@implementation YDDDImagesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = 0;
        self.backgroundColor = [UIColor whiteColor];
        
        _imageViews = [UIView new];
        [self.contentView addSubview:_imageViews];
        
        [_imageViews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsZero);
        }];
        
    }
    return self;
}

- (void)ic_clickedImageView:(UITapGestureRecognizer *)tap{
    NSUInteger index = tap.view.tag - 1000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicImagesCell:selectedImageIndex:)]) {
        [self.delegate dynamicImagesCell:self selectedImageIndex:index];
    }
}

- (void)setItem:(YDDynamicDetailModel *)item{
    if (_item && [_item.d_id isEqual:item.d_id]) {
        NSLog(@"%s _item.d_id isEqual:item.d_id",__func__);
        return;
    }
    [_imageViews removeAllSubViews];
    [item.imagesDicArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageV = [UIImageView new];
        imageV.userInteractionEnabled = YES;
        [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ic_clickedImageView:)]];
        imageV.tag = 1000 + idx;
        NSString *url = [obj valueForKey:@"url"];
        CGFloat width = [[obj valueForKey:@"width"] floatValue];
        CGFloat height = [[obj valueForKey:@"height"] floatValue];
        CGFloat x = [[obj valueForKey:@"x"] floatValue];
        CGFloat y = [[obj valueForKey:@"y"] floatValue];
        
        [imageV yd_setImageFadeinWithString:url];
        imageV.frame = CGRectMake(x, y, width, height);
        
        [_imageViews addSubview:imageV];
    }];
}

@end

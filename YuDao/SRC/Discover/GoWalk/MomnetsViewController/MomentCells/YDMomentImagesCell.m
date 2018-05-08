//
//  YDMomentImagesCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/13.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDMomentImagesCell.h"

@interface YDMomentImagesCell()

@property (nonatomic, strong) YDMomentMultilImagesView *imagesView;

@end

@implementation YDMomentImagesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imagesView = [[YDMomentMultilImagesView alloc] init];
        _imagesView.delegate = self;
        _imagesView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imagesView];
        
        [_imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom).offset(9);
            make.left.equalTo(self.contentView).offset(9);
            make.right.equalTo(self.contentView).offset(-9);
            make.height.mas_equalTo(_imagesView.mas_width);
        }];
    }
    return self;
}

- (void)setMoment:(YDMoment *)moment{
    [super setMoment:moment];
    
    [_imagesView setImages:moment.imagesURL];
}

#pragma mark - YDMomentImagesViewDelegate
- (void)momentImagesViewClickImageMoment:(YDMoment *)moment atIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(momentImagesViewClickImageMoment:atIndex:)]) {
        [self.delegate momentImagesViewClickImageMoment:self.moment atIndex:index];
    }
}

@end

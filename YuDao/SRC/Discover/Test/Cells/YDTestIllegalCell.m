//
//  YDTestIllegalCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestIllegalCell.h"

#define kIllegalViewHeight 38

@interface YDTestIllegalCell()

@property (nonatomic, strong) UIView *illegalContentView;

@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation YDTestIllegalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.bgImageView setImage:YDImage(@"test_illegal_bg")];
        
        self.titleLabel.text = @"车辆违章";
        
        [self.contentView yd_addSubviews:@[self.illegalContentView,self.promptLabel]];
        [self.illegalContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.contentView).offset(-30);
            make.bottom.equalTo(self).offset(-10);
        }];
        
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(25);
            make.left.equalTo(self.titleLabel.mas_left);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(150);
        }];
    }
    return self;
}

- (void)setModel:(YDTestsModel *)model{
    [super setModel:model];
    
    [self.illegalContentView removeAllSubViews];
    
    self.illegalContentView.hidden = !(model.illegalArray.count > 0);
    self.promptLabel.hidden = (model.illegalArray.count > 0);
    
    if (self.illegalContentView.isHidden) {
        return;
    }
    NSMutableArray *tempViews = [NSMutableArray array];
    [model.illegalArray enumerateObjectsUsingBlock:^(YDIllegalModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 2) {
            YDTestIllegalView *view = [[YDTestIllegalView alloc] initWithFrame:CGRectZero];
            [view setModel:obj];
            [tempViews addObject:view];
        }
        else{
            *stop = YES;
        }
    }];

    [self.illegalContentView yd_addSubviews:tempViews];
    
    if (tempViews.count == 1) {
        YDTestIllegalView *view = tempViews.firstObject;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.illegalContentView);
            make.height.mas_equalTo(kIllegalViewHeight);
        }];
    }
    else if (tempViews.count == 2) {
        [tempViews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.illegalContentView);
        }];
        
        [tempViews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
    }
}

#pragma mark - Getters
- (UIView *)illegalContentView{
    if (_illegalContentView == nil) {
        _illegalContentView = [UIView new];
    }
    return _illegalContentView;
}

- (UILabel *)promptLabel{
    if (_promptLabel == nil) {
        _promptLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
        _promptLabel.text = @"您目前没有违章记录";
    }
    return _promptLabel;
}

@end

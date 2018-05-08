//
//  YDInterestsCell.m
//  YuDao
//
//  Created by 汪杰 on 17/1/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDInterestsCell.h"

#define marginX 15.f
#define marginY 12.f

@interface YDInterestButton : UIButton

@property (nonatomic, strong) YDInterest *interest;

@end

@implementation YDInterestButton

@end

@implementation YDInterestsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self.contentView sd_addSubviews:@[self.labelImageV,self.containerView,self.title]];
        _containerView.frame = CGRectMake(77, 20, SCREEN_WIDTH-77-28, 148-40);
        
        _containerView.sd_layout
        .leftSpaceToView(self.contentView,77)
        .topSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,28);
        
        [_labelImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(28);
            make.width.height.mas_equalTo(26);
        }];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labelImageV.mas_bottom).offset(2);
            make.centerX.equalTo(_labelImageV);
            make.width.mas_lessThanOrEqualTo(30);
            make.height.mas_lessThanOrEqualTo(20);
        }];
    }
    return self;
}
//点击兴趣按钮
- (void)interestBtnAction:(YDInterestButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(interestsCell:selectedBtn:selectedItem:)]) {
        [self.delegate interestsCell:self selectedBtn:sender selectedItem:sender.interest];
    }
    
}

- (void)setModel:(YDInterestModel *)model{
    _model = model;
    self.labelImageV.image = [UIImage imageNamed:model.iconPath];
    self.title.text = model.p_model.t_name;
    self.title.textColor = model.color;
    
    NSInteger row = 0;
    NSInteger btnYW = 0;
    for (int i = 0; i < model.interests.count; i++) {
        YDInterest *inter = [model.interests objectAtIndex:i];
        NSString *sonTitle = inter.t_name;
        YDInterestButton *btn = [YDInterestButton buttonWithType:UIButtonTypeCustom];
        [btn setInterest:inter];
        [btn setTitle:sonTitle forState:0];
        [btn setTitleColor:model.color forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(interestBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.layer.cornerRadius = 8.f;
        btn.layer.borderWidth = 1.f;
        btn.layer.borderColor = model.color.CGColor;
        
        [model.selectedInterests enumerateObjectsUsingBlock:^(YDInterest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.t_id isEqual:inter.t_id]) {
                btn.selected = YES;
                [btn setBackgroundColor:model.color];
            }
        }];
        
        CGSize strsize = [sonTitle sizeWithAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0] }];
        btn.width = strsize.width + marginX;
        btn.height = 28.f;
        
        if (i == 0) {
            btn.x = marginX;
            btnYW += CGRectGetMaxX(btn.frame);
        }else{
            btnYW += CGRectGetMaxX(btn.frame)+marginX;
            if (btnYW > self.containerView.width) {
                row++;
                btn.x = marginX;
                btnYW = CGRectGetMaxX(btn.frame);
            }
            else{
                btn.x += btnYW - btn.width;
            }
        }
        btn.y += row * (btn.height + marginY);
        
        [_containerView addSubview:btn];
        if (i == model.interests.count-1) {
            [_containerView setupAutoHeightWithBottomView:btn bottomMargin:0];
        }
    }
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:15];
}

- (UIImageView *)labelImageV{
    if (!_labelImageV) {
        _labelImageV = [[UIImageView alloc] init];
    }
    return _labelImageV;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UILabel *)title{
    if (!_title) {
        _title = [YDUIKit labelTextColor:[UIColor whiteColor] fontSize:14 textAlignment:NSTextAlignmentCenter];
    }
    return _title;
}


@end

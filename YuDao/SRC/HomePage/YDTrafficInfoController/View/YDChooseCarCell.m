//
//  YDChooseCarCell.m
//  YuDao
//
//  Created by 汪杰 on 16/12/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDChooseCarCell.h"

@interface YDChooseCarCell()



@end

@implementation YDChooseCarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.backgroundColor = [UIColor clearColor];
        
        [self y_layoutSubviews];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setModel:(YDCarDetailModel *)model{
    _model = model;
    [_carIcon sd_setImageWithURL:YDURL(model.ug_brand_logo) forState:0];
    
    NSString *carName = [NSString stringWithFormat:@"%@",model.ug_series_name ?model.ug_series_name : @""];
    _label.text = carName;
    self.selectBtn.selected = model.ug_status.integerValue==1 ? YES : NO;
    
//    if (!model.ug_brand_logo) {
//        self.carIcon.sd_layout
//        .centerYEqualToView(self.contentView)
//        .leftSpaceToView(self.contentView,18)
//        .heightIs(15)
//        .widthIs(0);
//    }
    
}

#pragma mark - Private Methods
- (void)y_layoutSubviews{
    [self.contentView yd_addSubviews:@[self.carIcon,self.label,self.selectBtn,self.topLineView,self.bottomLineView]];
    CGFloat cellHeight = 70.0;
    CGFloat cellWidth = SCREEN_WIDTH-20;
    _carIcon.frame = CGRectMake(15, (cellHeight-43)/2, 43, 43);
//    [_carIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.left.equalTo(self.contentView).offset(15);
//        make.width.height.mas_equalTo(43);
//    }];
//    self.carIcon.sd_layout
//    .centerYEqualToView(self.contentView)
//    .leftSpaceToView(self.contentView,15)
//    .heightIs(43)
//    .widthIs(43);
    
    _selectBtn.frame = CGRectMake(cellWidth-30, (cellHeight-20)/2, 20, 20);
//    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.right.equalTo(self.contentView).offset(-10);
//        make.height.width.mas_equalTo(20);
//    }];
//    self.selectBtn.sd_layout
//    .centerYEqualToView(self.contentView)
//    .rightSpaceToView(self.contentView,10)
//    .heightIs(20)
//    .widthEqualToHeight();
//    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.centerY.equalTo(self.contentView);
//        make.left.equalTo(_carIcon.mas_right).offset(15);
//        make.right.equalTo(_selectBtn.mas_left).offset(-10);
//        make.height.mas_equalTo(21);
//    }];
    _label.frame = CGRectMake(CGRectGetMaxX(_carIcon.frame)+15, (cellHeight-21)/2, 200, 21);
//    self.label.sd_layout
//    .centerYEqualToView(self.contentView)
//    .leftSpaceToView(self.carIcon,15)
//    .rightSpaceToView(self.selectBtn,10)
//    .heightIs(21);
//    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView);
//        make.left.equalTo(_carIcon);
//        make.right.equalTo(_selectBtn);
//        make.height.mas_equalTo(0.5);
//    }];
    _topLineView.frame = CGRectMake(_carIcon.x, 0, CGRectGetMaxX(_selectBtn.frame)-_carIcon.x, 0.5);
//    self.topLineView.sd_layout
//    .topEqualToView(self.contentView)
//    .leftEqualToView(self.carIcon)
//    .rightEqualToView(self.selectBtn)
//    .heightIs(0.5);
//    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView);
//        make.left.right.equalTo(_topLineView);
//        make.height.mas_equalTo(0.5);
//    }];
    _bottomLineView.frame = CGRectMake(_carIcon.x, cellHeight-0.5, CGRectGetMaxX(_selectBtn.frame)-_carIcon.x, 0.5);
//    self.bottomLineView.sd_layout
//    .bottomEqualToView(self.contentView)
//    .leftEqualToView(self.carIcon)
//    .rightEqualToView(self.selectBtn)
//    .heightIs(0.5);
}

#pragma mark - Getters
- (UILabel *)label{
    if (!_label) {
        _label = [YDUIKit labelTextColor:YDBaseColor fontSize:14 textAlignment:0];
    }
    return _label;
}

- (UIButton *)carIcon{
    if (!_carIcon) {
        _carIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _carIcon;
}
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [YDUIKit buttonWithImage:[UIImage imageNamed:@"cardriving_chooseBtn_normal"] selectedImage:[UIImage imageNamed:@"cardriving_chooseBtn_selected"] selector:nil  target:self];
        _selectBtn.userInteractionEnabled = NO;
    }
    return _selectBtn;
}

- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = YDBaseColor;
    }
    return _topLineView;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = YDBaseColor;
    }
    return _bottomLineView;;
}

@end

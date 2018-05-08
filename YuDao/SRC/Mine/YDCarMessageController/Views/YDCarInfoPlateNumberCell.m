//
//  YDCarInfoPlateNumberCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarInfoPlateNumberCell.h"
#import "YDLimitTextField.h"
#import "NinaSelectionView.h"

@interface YDCarInfoPlateNumberCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *prefixLabel;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) YDLimitTextField *textField;

@property (nonatomic, strong) NinaSelectionView *selectionView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation YDCarInfoPlateNumberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self pn_initSubviews];
        [self pn_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setItem:(YDCarInfoItem *)item{
    _item = item;
    
    _titleLabel.text = item.title;
    _prefixLabel.text = item.prefix.length > 0 ? item.prefix : @"沪";
    
    _textField.placeholder = item.placeholder;
    _textField.text = item.subTitle.length > 0 ? item.subTitle : @"";
    
}

#pragma mark - Events
- (void)prefixDidSelected{
    if (self.selectionView.superview == nil) {
        UIViewController *currentVC = [UIViewController yd_getTheCurrentViewController];
        [currentVC.view endEditing:YES];
        [currentVC.view addSubview:self.selectionView];
    }
    
    NSInteger selectedIndex = 1;
    for (int i = 0; i < _titles.count; i++) {
        NSString *str = _titles[i];
        if ([str isEqualToString:self.prefixLabel.text]) {
            selectedIndex = i + 1;
            break;
        }
    }
    [self.selectionView setDefaultSelected:selectedIndex];
    [self.selectionView showOrDismissNinaViewWithDuration:0.5 usingNinaSpringWithDamping:0.8 initialNinaSpringVelocity:0.3];
}

#pragma mark - Private Methods
- (void)pn_initSubviews{
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16] textAlignment:0];
    
    _prefixLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_16] textAlignment:0];
    _prefixLabel.userInteractionEnabled = YES;
    [_prefixLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prefixDidSelected)]];
    
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_garage_bottomArrow"]];
    _arrowImageView.userInteractionEnabled = YES;
    [_arrowImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prefixDidSelected)]];
    
    _textField = [[YDLimitTextField alloc] initWithLimit:6];
    _textField.textColor = [UIColor grayTextColor];
    _textField.placeholder = @"如：A12345";
    YDWeakSelf(self);
    [_textField setTextDidChangeBlock:^(NSString *text) {
        weakself.item.subTitle = text;
    }];
    
    [self.contentView yd_addSubviews:@[_titleLabel,_prefixLabel,_arrowImageView,_textField]];
}

- (void)pn_addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_prefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(140);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(20);
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_prefixLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(9, 5));
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_arrowImageView.mas_right).offset(12);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(22);
    }];
}

#pragma mark - Getter
- (NSString *)prefix{
    return self.prefixLabel.text;
}

- (NSString *)plateNumber{
    return self.textField.text;
}

- (NinaSelectionView *)selectionView{
    if (_selectionView == nil) {
        _titles = @[@"京",@"津",@"沪",@"渝",@"冀",@"豫",@"云",@"辽",@"黑",@"湘",@"皖",@"鲁",@"新",@"苏",@"浙",@"赣",@"鄂",@"桂",@"甘",@"晋",@"蒙",@"陕",@"吉",@"闽",@"贵",@"粤",@"青",@"藏",@"川",@"宁",@"琼"];
        _selectionView = [[NinaSelectionView alloc] initWithTitles:_titles PopDirection:NinaPopFromBelowToBottom];
        
        _selectionView.shadowEffect = YES;
        _selectionView.shadowAlpha = 0.5;
        
        YDWeakSelf(self);
        [_selectionView setDidSelectedButtonBlock:^(UIButton *selectedBtn) {
            weakself.prefixLabel.text = selectedBtn.titleLabel.text;
            weakself.item.prefix = selectedBtn.titleLabel.text;
        }];
    }
    return _selectionView;
}

@end

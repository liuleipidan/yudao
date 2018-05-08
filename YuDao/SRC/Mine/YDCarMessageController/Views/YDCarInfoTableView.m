//
//  YDCarInfoTableView.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarInfoTableView.h"
#import "YDCarInfoPlateNumberCell.h"
#import "YDCarInfoTextFieldCell.h"
#import "YDCarInfoCell.h"
#import "YDDatePickerTool.h"

@interface YDCarInfoTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *defaultButton;

@property (nonatomic, strong) NSArray<YDCarInfoItem *> *data;

@property (nonatomic, strong) YDDatePickerTool *datePickerTool;

@end

@implementation YDCarInfoTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = 52.0f;
        
        [self ci_registerCells];
        
        [self setTableHeaderView:self.titleLabel];
        
        [self setTableFooterView:({
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            [footerView addSubview:self.defaultButton];
            footerView;
        })];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setData:(NSArray<YDCarInfoItem *> *)data title:(NSString *)title isDefault:(BOOL)isDefault{
    _data = data;
    self.titleLabel.text = title;
    self.defaultButton.selected = isDefault;
    [self reloadData];
}

#pragma mark - Events
- (void)ci_defaultButtonAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
}

#pragma mark - Private Methods
- (void)ci_registerCells{
    
    [self registerClass:[YDCarInfoPlateNumberCell class] forCellReuseIdentifier:@"YDCarInfoPlateNumberCell"];
    
    [self registerClass:[YDCarInfoTextFieldCell class] forCellReuseIdentifier:@"YDCarInfoTextFieldCell"];
    
    [self registerClass:[YDCarInfoCell class] forCellReuseIdentifier:@"YDCarInfoCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.data.count) {
        YDCarInfoItem *item = self.data[indexPath.row];
        if (item.type == YDCarInfoItemTypePlateNumber) {
            YDCarInfoPlateNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDCarInfoPlateNumberCell"];
            [cell setItem:item];
            return cell;
        }
        else if (item.type == YDCarInfoItemTypeInput){
            YDCarInfoTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDCarInfoTextFieldCell"];
            [cell setItem:item];
            return cell;
        }
        else if (item.type == YDCarInfoItemTypeArrow){
            YDCarInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDCarInfoCell"];
            [cell setItem:item];
            return cell;
        }
    }
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDCarInfoItem *item = self.data[indexPath.row];
    YDWeakSelf(self);
    if ([item.title isEqualToString:@"年检时间"]) {
        if (self.inspect_time) {
            [self.datePickerTool setStartDate:self.inspect_time];
        }
        [self.datePickerTool show];
        [self.datePickerTool setDoneButtonAction:^(NSDate *date) {
            weakself.inspect_time = date;
            item.subTitle = [NSDate formatYear_Month_Day:date];
            [weakself reloadData];
        }];
    }
    else if ([item.title isEqualToString:@"上次保养时间"]){
        if (self.maintain_time) {
            [self.datePickerTool setStartDate:self.maintain_time];
        }
        [self.datePickerTool show];
        [self.datePickerTool setDoneButtonAction:^(NSDate *date) {
            weakself.maintain_time = date;
            item.subTitle = [NSDate formatYear_Month_Day:date];
            [weakself reloadData];
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
        [scrollView setContentOffset:offset];
    }
}

#pragma mark - Getter
- (NSString *)plate_number_header{
    if (self.data.count < 1) {
        return @"";
    }
    return [self.data[0] prefix] ? : @"";
}

- (NSString *)plate_number{
    if (self.data.count < 1) {
        return @"";
    }
    return [self.data[0] subTitle] ? : @"";
}

- (NSString *)frame_number{
    if (self.data.count < 2) {
        return @"";
    }
    return [self.data[1] subTitle] ? : @"";
}

- (NSString *)engine_number{
    if (self.data.count < 3) {
        return @"";
    }
    return [self.data[2] subTitle] ? : @"";
}

- (BOOL)isDefault{
    return self.defaultButton.isSelected;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
        _titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 52.0);
        _titleLabel.layer.shadowColor = [UIColor grayTextColor].CGColor;
        _titleLabel.layer.shadowOpacity = 0.8f;
        _titleLabel.layer.shadowOffset = CGSizeMake(0.0,0.0);
    }
    return _titleLabel;
}

- (UIButton *)defaultButton{
    if (_defaultButton == nil) {
        _defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultButton setImage:@"bindOBD_defaultCar_normal" imageSelected:@"bindOBD_defaultCar_selected"];
        [_defaultButton setTitle:@"设为默认车辆" forState:0];
        [_defaultButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [_defaultButton setTitleColor:[UIColor blackTextColor] forState:0];
        [_defaultButton.titleLabel setFont:[UIFont font_12]];
        _defaultButton.frame = CGRectMake(20,10, 94, 30);
        [_defaultButton addTarget:self action:@selector(ci_defaultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultButton;
}

- (YDDatePickerTool *)datePickerTool{
    if (_datePickerTool == nil) {
        _datePickerTool = [[YDDatePickerTool alloc] init];
    }
    return _datePickerTool;
}

@end

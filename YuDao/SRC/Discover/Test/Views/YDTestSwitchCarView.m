//
//  YDTestSwitchCarView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/28.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestSwitchCarView.h"

@interface YDTestSwitchCarCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *text;

@end


@implementation YDTestSwitchCarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self cc_initSubviews];
    }
    return self;
}

- (void)cc_initSubviews{
    _icon = [[UIImageView alloc] initWithImage:YDImage(@"cardriving_chooseBtn_normal")];
    [_icon setHighlightedImage:YDImage(@"cardriving_chooseBtn_selected")];
    
    _text = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    [self.contentView yd_addSubviews:@[_icon,_text]];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(24);
    }];
    
    [_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(20);
    }];
}

@end

@interface YDTestSwitchCarView()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation YDTestSwitchCarView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tapGR.delegate = self;
        [self addGestureRecognizer:tapGR];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(40);
            make.right.equalTo(self).offset(-40);
            make.top.equalTo(self).offset(80);
            make.height.mas_equalTo(0);
        }];
    }
    return self;
}

#pragma mark - Public Methods
- (void)showInView:(UIView *)view data:(NSArray *)data{
    if (view == nil || data.count == 0) {
        return;
    }
    [view addSubview:self];
    [self setNeedsDisplay];
    [self setFrame:view.bounds];
    
    self.data = data;
    [self.tableView reloadData];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.tableView.rowHeight * data.count);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDTestSwitchCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDTestSwitchCarCell"];
    YDCarDetailModel *car = [self.data objectAtIndex:indexPath.row];
    cell.text.text = car.ug_series_name;
    if (self.selectedCar && [self.selectedCar.ug_id isEqual:car.ug_id]) {
        [cell.icon setHighlighted:YES];
    }
    else{
        [cell.icon setHighlighted:NO];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YDCarDetailModel *car = [self.data objectAtIndex:indexPath.row];
    if (self.SCDidSelectedCarBlack && ![self.selectedCar.ug_id isEqual:car.ug_id]) {
        self.SCDidSelectedCarBlack(car);
    }
    
    self.selectedCar = car;
    [tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Getters
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.layer.cornerRadius = 8.0f;
        _tableView.rowHeight = 46.f;
        
        [_tableView registerClass:[YDTestSwitchCarCell class] forCellReuseIdentifier:@"YDTestSwitchCarCell"];
    }
    return _tableView;
}

- (BOOL)isShow{
    return self.superview != nil;
}

@end

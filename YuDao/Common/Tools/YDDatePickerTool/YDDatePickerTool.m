//
//  YDDatePickerTool.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDatePickerTool.h"

@interface YDDatePickerTool()

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) YDPopupController *popupController;

@property (nonatomic, strong) YDActionSheetToolBar *toolBar;

@end

@implementation YDDatePickerTool

- (instancetype)init{
    if (self = [super init]) {
        
        //工具条
        _toolBar = [[YDActionSheetToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [_toolBar setCancelButtonTarget:self action:@selector(dismiss)];
        [_toolBar setDoneButtonTarget:self action:@selector(doneButtonItemAction:)];
        _toolBar.doneButton.enabled = NO;
        
        //时间选择器
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        //最小时间
        [self setMinInterval:100];
        //最大时间
        [_datePicker setMaximumDate:[NSDate date]];
        
        //弹出控制器
        _popupController = [[YDPopupController alloc] initWithContents:@[_toolBar,_datePicker]];
        _popupController.theme = [YDPopupTheme defaultTheme];
        
    }
    return self;
}

- (void)setDoneButtonAction:(void (^)(NSDate *))doneButtonAction{
    _doneButtonAction = doneButtonAction;
}

- (void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    [_datePicker setDate:startDate];
}

- (void)setMaxInterval:(NSInteger)maxInterval{
    _maxInterval = maxInterval;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:maxInterval];
    [_datePicker setMaximumDate:[calendar dateByAddingComponents:comps toDate:[NSDate date] options:0]];
}

- (void)setMinInterval:(NSInteger)minInterval{
    _minInterval = minInterval;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-minInterval];
    [_datePicker setMinimumDate:[calendar dateByAddingComponents:comps toDate:[NSDate date] options:0]];
}

- (void)doneButtonItemAction:(UIBarButtonItem *)item{
    if (_doneButtonAction) {
        _doneButtonAction(_datePicker.date);
    }
    [self dismiss];
}

- (void)dateChanged:(UIDatePicker *)datePicker{
    _toolBar.doneButton.enabled = ![self.startDate isEqual:datePicker.date];
}

- (void)show{
    _toolBar.doneButton.enabled = NO;
    [_popupController presentPopupControllerAnimated:YES];
}

- (void)dismiss{
    [_popupController dismissPopupControllerAnimated:YES];
}

@end

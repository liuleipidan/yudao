//
//  YDTitlePickerTool.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/25.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTitlePickerTool.h"

static CGFloat const kTitlePickToolHeight = 216.0f;

@interface YDTitlePickerTool()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) YDPopupController *popupController;

@property (nonatomic, strong) YDActionSheetToolBar *toolBar;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) NSString *selectedTitle;

@end

@implementation YDTitlePickerTool
- (instancetype)init{
    if (self = [super init]) {
        
        //工具条
        _toolBar = [[YDActionSheetToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [_toolBar setCancelButtonTarget:self action:@selector(dismiss)];
        [_toolBar setDoneButtonTarget:self action:@selector(doneButtonItemAction:)];
        _toolBar.doneButton.enabled = NO;
        
        //选择视图
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTitlePickToolHeight)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
        
        //弹出控制器
        _popupController = [[YDPopupController alloc] initWithContents:@[_toolBar,_pickerView]];
        _popupController.theme = [YDPopupTheme defaultTheme];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)show{
    _toolBar.doneButton.enabled = NO;
    [_popupController presentPopupControllerAnimated:YES];
}

- (void)dismiss{
    [_popupController dismissPopupControllerAnimated:YES];
}

- (void)setDoneButtonActionBlock:(void (^)(NSString *, NSInteger))doneButtonActionBlock{
    _doneButtonActionBlock = doneButtonActionBlock;
}

- (void)setType:(YDTitlePickerToolType)type{
    _type = type;
    if (type == YDTitlePickerToolTypeGender) {
        self.data = @[
                      @"男",
                      @"女"
                      ];
    }
    else if (type == YDTitlePickerToolTypeEmotion){
        self.data = @[
                      @"保密",
                      @"单身",
                      @"已婚",
                      @"离异",
                      @"恋爱"
                      ];
    }
    else{
        self.data = nil;
    }
    
    [self.pickerView reloadAllComponents];
}

- (void)setOriginalTitle:(NSString *)originalTitle{
    _originalTitle = originalTitle;
    for (int i = 0; i < self.data.count ; i++) {
        NSString *title = self.data[i];
        if ([title isEqualToString:originalTitle]) {
            [self.pickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
}

#pragma mark - Events
- (void)doneButtonItemAction:(UIBarButtonItem *)item{
    if (_doneButtonActionBlock) {
        _doneButtonActionBlock(self.selectedTitle,[self.data indexOfObject:self.selectedTitle]);
    }
    [self dismiss];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.data ? self.data.count : 0;
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    return [self.data objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    self.selectedTitle = self.data[row];
    BOOL doneItemEnabled = [self.originalTitle isEqualToString:self.selectedTitle];
    _toolBar.doneButton.enabled = !doneItemEnabled;
    
}

@end

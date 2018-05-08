//
//  YDPlacePickerTool.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/26.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPlacePickerTool.h"
#import "YDActionSheetToolBar.h"
#import "YDPopupController.h"

//省市区数据总数量
#define kPlacesCount 3515

@interface YDPlacePickerTool()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) YDDBPlaceStore *placeStore;

@property (nonatomic, strong) YDActionSheetToolBar *toolBar;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) YDPopupController *popupController;

//省
@property (nonatomic, strong) NSArray<YDPlace *> *provinces;

//市
@property (nonatomic, strong) NSArray<YDPlace *> *citys;

//区
@property (nonatomic, strong) NSArray<YDPlace *> *areas;

@end

static YDPlacePickerTool *placePickerTool = nil;

@implementation YDPlacePickerTool

+ (YDPlacePickerTool *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        placePickerTool = [[YDPlacePickerTool alloc] init];
    });
    return placePickerTool;
}

- (id)init{
    if (self = [super init]) {
        _placeStore = [[YDDBPlaceStore alloc] init];
        [self requestPlaceData];
    }
    return self;
}

- (void)setSelectedProvinName:(NSString *)provinceName cityName:(NSString *)cityName areaName:(NSString *)areaName{
    [self ppt_init];
    NSLog(@"[self.placeStore countPlaces] = %lu",[self.placeStore countPlaces]);
    if (provinceName) {
        [_provinces enumerateObjectsUsingBlock:^(YDPlace * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:provinceName]) {
                _citys = [_placeStore placesByCurrentId:obj.currentId];
                [_pickerView reloadComponent:1];
                [_pickerView selectRow:idx inComponent:0 animated:NO];
                
                *stop = YES;
            }
        }];
    }
    else{
        [_pickerView selectRow:0 inComponent:0 animated:NO];
    }
    
    if (cityName) {
        [_citys enumerateObjectsUsingBlock:^(YDPlace * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:cityName]) {
                _areas = [_placeStore placesByCurrentId:obj.currentId];
                [_pickerView reloadComponent:2];
                [_pickerView selectRow:idx inComponent:1 animated:NO];
                *stop = YES;
            }
        }];
    }
    else{
        [_pickerView selectRow:0 inComponent:1 animated:NO];
    }
    
    if (areaName) {
        [_areas enumerateObjectsUsingBlock:^(YDPlace * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:areaName]) {
                [_pickerView selectRow:idx inComponent:2 animated:NO];
                *stop = YES;
            }
        }];
    }
    else{
        [_pickerView selectRow:0 inComponent:2 animated:NO];
    }
    
    [_pickerView reloadAllComponents];
}

- (void)show{
    
    [self.popupController presentPopupControllerAnimated:YES];
}

- (void)dismiss{
    [self.popupController dismissPopupControllerAnimated:YES];
    self.popupController = nil;
    self.toolBar = nil;
    self.pickerView.dataSource = nil;
    self.pickerView.delegate = nil;
    self.pickerView = nil;
    self.provinces = nil;
    self.citys = nil;
    self.areas = nil;
}

#pragma mark - Privated Methods
- (void)ppt_init{
//-------------------------- INIT_DATA ------------------------
    _provinces = [_placeStore provinces];
    
    if (_provinces.count > 0) {
        YDPlace *firstPro = _provinces.firstObject;
        _citys = [_placeStore placesByCurrentId:firstPro.currentId];
    }
    
    if (_citys.count > 0) {
        YDPlace *firstCity = _citys.firstObject;
        _areas = [_placeStore placesByCurrentId:firstCity.currentId];
    }
    
//-------------------------- INIT_UI ------------------------
    //工具条
    _toolBar = [[YDActionSheetToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [_toolBar setCancelButtonTarget:self action:@selector(dismiss)];
    [_toolBar setDoneButtonTarget:self action:@selector(doneButtonItemAction:)];
    
    //选择视图
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 216)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
    
    //弹出控制器
    _popupController = [[YDPopupController alloc] initWithContents:@[_toolBar,_pickerView]];
    _popupController.theme = [YDPopupTheme defaultTheme];
    
    [_pickerView reloadAllComponents];
}

- (void)doneButtonItemAction:(UIBarButtonItem *)item{
    NSInteger provinceRow = [_pickerView selectedRowInComponent:0];
    NSInteger cityRow = [_pickerView selectedRowInComponent:1];
    NSInteger areaRow = [_pickerView selectedRowInComponent:2];
    
    YDPlace *province = nil;
    if (_provinces.count > provinceRow) {
        province = [_provinces objectAtIndex:provinceRow];
    }
    YDPlace *city = nil;
    if (_citys.count > cityRow) {
        city = [_citys objectAtIndex:cityRow];
    }
    YDPlace *area = nil;
    if (_areas.count > areaRow) {
        area = [_areas objectAtIndex:areaRow];
    }
    
    if (_doneButtonActionBlock) {
        _doneButtonActionBlock(province.currentId,province.name,city.currentId,city.name,area.currentId,area.name);
    }
    
    [self dismiss];
}

- (void)requestPlaceData{
    if ([self.placeStore countPlaces] < kPlacesCount) {
        NSLog(@"省市区数据不完整，少于3515");
        [YDNetworking GET:kPlaceURL parameters:nil success:^(NSNumber *code, NSString *status, id data) {
            if ([code isEqual:@200]) {
                NSArray *places = [YDPlace mj_objectArrayWithKeyValuesArray:data];
                
                if ([self.placeStore insertPlaces:places]) {
                    NSLog(@"所有省市区插入成功");
                }
                else{
                    NSLog(@"所有省市区插入失败");
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)addPlaces:(NSArray *)places{
    if (places.count == 0) {
        return;
    }
    
    for (YDPlace *model in places) {
        if (![self.placeStore addPlace:model]) {
            NSLog(@"省市区插入失败!!!");
        }
    }
    NSLog(@"地点插入完成 places.count = %ld",places.count);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _provinces.count;
    }
    else if (component == 1){
        return _citys.count;
    }
    else if (component == 2){
        return _areas.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    YDPlace *place = nil;
    if (component == 0) {
        place = [_provinces objectAtIndex:row];
        return place.name;
    }
    else if (component == 1){
        place = [_citys objectAtIndex:row];
        return place.name;
    }
    else if (component == 2){
        place = [_areas objectAtIndex:row];
        return place.name;
    }
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
    }
    YDPlace *place = nil;
    if (component == 0) {
        place = [_provinces objectAtIndex:row];
    }
    else if (component == 1){
        place = [_citys objectAtIndex:row];
    }
    else if (component == 2){
        place = [_areas objectAtIndex:row];
    }
    label.text = place.name;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    
    YDPlace *place = nil;
    if (component == 0) {
        place = [_provinces objectAtIndex:row];
        _citys = [_placeStore placesByCurrentId:place.currentId];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        [pickerView reloadComponent:1];
        if (_citys.count > 0) {
            YDPlace *firstCity = _citys.firstObject;
            _areas = [_placeStore placesByCurrentId:firstCity.currentId];
            [pickerView reloadComponent:2];
        }
    }
    else if (component == 1){
        place = [_citys objectAtIndex:row];
        _areas = [_placeStore placesByCurrentId:place.currentId];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        [pickerView reloadComponent:2];
    }
}

@end

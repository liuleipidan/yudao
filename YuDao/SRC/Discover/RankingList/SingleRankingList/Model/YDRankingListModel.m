//
//  YDRankingListModel.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDRankingListModel.h"

@implementation YDRankingListModel

+ (YDRankingListModel *)createRankingModelByType:(YDRankingListDataType )type{
    YDRankingListModel *model = [YDRankingListModel new];
    model.type = type;
    
    return model;
}

- (void)setRankingText:(NSString *)rankingText{
    _rankingText = rankingText;
    NSInteger ranking = rankingText.integerValue;
    if (ranking == 1) {
        _rankingIconPath = @"rankinglist_1st";
    }
    else if (ranking == 2){
        _rankingIconPath = @"rankinglist_2sd";
    }
    else if (ranking == 3){
        _rankingIconPath = @"rankinglist_3th";
    }
    else{
        _rankingIconPath = nil;
    }
}

#pragma mark - Getters
- (NSString *)address{
    if (_address == nil) {
        if (self.ud_often_province_name.length == 0) {
            _address = @"上海";
        }
        else{
            NSArray *citys = @[@"上海市",@"北京市",@"天津市",@"重庆市"];
            if ([citys containsObject:self.ud_often_province_name]) {
                _address = self.ud_often_province_name;
            }
            else{
                _address = [NSString stringWithFormat:@"%@·%@",self.ud_often_province_name,self.ud_often_city_name];
            }
        }
    }
    return _address;
}

- (NSString *)dataString{
    if (_dataString == nil) {
        switch (self.type) {
            case YDRankingListDataTypeMileage:
            {
                _dataString = [NSString stringWithFormat:@"%.1fKM",self.oti_mileage?self.oti_mileage.floatValue:0.f];
                break;}
            case YDRankingListDataTypeSpeed:
            {
                _dataString = [NSString stringWithFormat:@"%@KM/H",YDNoNilNumber(self.oti_speed)];
                break;}
            case YDRankingListDataTypeOilwear:
            {
                _dataString = [NSString stringWithFormat:@"%.1fL",self.oti_oilwear?self.oti_oilwear.floatValue:0.f];
                break;}
            case YDRankingListDataTypeStop:
            {
                _dataString = [NSString stringWithFormat:@"%@分钟",YDNoNilNumber(self.oti_stranded)];
                break;}
            case YDRankingListDataTypeScore:
            {
                _dataString = [NSString stringWithFormat:@"%@",YDNoNilNumber(self.ud_credit)];
                break;}
            case YDRankingListDataTypeLike:
            {
                _dataString = [NSString stringWithFormat:@"%@",YDNoNilNumber(self.enjoynum)];
                break;}
            default:
                break;
        }
    }
    return _dataString;
}

@end

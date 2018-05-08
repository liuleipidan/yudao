//
//  YDCarInfoItem.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/17.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarInfoItem.h"

@implementation YDCarInfoItem

+ (YDCarInfoItem *)createItemTitle:(NSString *)title subTitle:(NSString *)subTitle type:(YDCarInfoItemType)type{
    YDCarInfoItem *item = [YDCarInfoItem new];
    item.title = title;
    item.subTitle = subTitle;
    item.type = type;
    item.showDisclosureIndicator = YES;
    return item;
}

+ (NSArray *)createItemsByCarInfo:(YDCarDetailModel *)carInfo isAddCar:(BOOL)isAddCar{
    if (carInfo == nil) {
        return nil;
    }
    
    YDCarInfoItem *plateNumber = YDCreateCarInfoItem(@"车牌号", carInfo.ug_plate, YDCarInfoItemTypePlateNumber);
    plateNumber.prefix = carInfo.ug_plate_title.length > 0 ? carInfo.ug_plate_title : @"沪";
    plateNumber.placeholder = @"如：A12345";
    
    YDCarInfoItem *frameNumber = YDCreateCarInfoItem(@"车架号", carInfo.ug_frame_number, YDCarInfoItemTypeInput);
    frameNumber.placeholder = @"请输入车架号";
    
    YDCarInfoItem *engineNumber = YDCreateCarInfoItem(@"发动机号", carInfo.ug_engine, YDCarInfoItemTypeInput);
    engineNumber.placeholder = @"请输入发动机号";
    
    YDCarInfoItem *wzDate = YDCreateCarInfoItem(@"违章时间", carInfo.wz_date.length > 0 ?carInfo.wz_date : @"暂无", YDCarInfoItemTypeArrow);
    wzDate.showDisclosureIndicator = NO;
    
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat =@"YYYY-MM-dd";
    
    NSString *inspectTimeStr = carInfo.ug_annual_inspection.integerValue > 0 ? [matter stringFromDate:[NSDate dateFromTimeStamp:carInfo.ug_annual_inspection]] : @"";
    YDCarInfoItem *inspectTime = YDCreateCarInfoItem(@"年检时间", inspectTimeStr, YDCarInfoItemTypeArrow);
    
    NSString *maintainTimeStr = carInfo.ug_maintenance.integerValue > 0 ? [matter stringFromDate:[NSDate dateFromTimeStamp:carInfo.ug_maintenance]] : @"";
    YDCarInfoItem *maintainTime = YDCreateCarInfoItem(@"上次保养时间", maintainTimeStr, YDCarInfoItemTypeArrow);
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:
                               plateNumber,
                               frameNumber,
                               engineNumber,
                               wzDate,
                               inspectTime,
                               maintainTime,nil];
    if (isAddCar) {
        [tempArr removeObject:wzDate];
    }
    return [NSArray arrayWithArray:tempArr];
}

@end

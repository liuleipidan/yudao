//
//  YDMyInformationController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/18.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMyInformationController+Delegate.h"
#import "YDPlacePickerTool.h"

@implementation YDMyInformationController (Delegate)

- (void)mic_registerCells{
    [self.tableView registerClass:[YDMyInfoCell class] forCellReuseIdentifier:@"YDMyInfoCell"];
    [self.tableView registerClass:[YDMyTextFieldCell class] forCellReuseIdentifier:@"YDMyTextFieldCell"];
    [self.tableView registerClass:[YDMyInfoAvatarCell class] forCellReuseIdentifier:@"YDMyInfoAvatarCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}

#pragma mark - YDMyTextFieldCellDelegate
- (void)myTextFieldCell:(YDMyTextFieldCell *)cell  textDidChanged:(NSString *)text{
    NSLog(@"cell.item.title = %@,text = %@",cell.item.title,text);
    if ([cell.item.title isEqualToString:@"昵称"]) {
        self.myInfo.tempUserInfo.ub_nickname = text;
    }
    else if ([cell.item.title isEqualToString:@"真实姓名"]){
        self.myInfo.tempUserInfo.ud_realname = text;
    }
    
    YDMyInfoItem *avatarItem = [self.myInfo.data objectAtIndex:0];
    [self checkTempUserInformation:self.myInfo.tempUserInfo avatar:avatarItem.avatarImage tableViewNeedReload:NO];
}

#pragma mark - YDInterestsControllerDelegate
- (void)interestsControllerDidChanged:(YDInterestsController *)controller
                                 ftag:(NSString *)ftag
                                  tag:(NSString *)tag
                             tag_name:(NSString *)tag_name{
    YDUser *tempUser = self.myInfo.tempUserInfo;
    tempUser.ud_ftag = ftag;
    tempUser.ud_tag = tag;
    tempUser.ud_tag_name = tag_name;
    YDMyInfoItem *avatarItem = [self.myInfo.data objectAtIndex:0];
    [self checkTempUserInformation:tempUser avatar:avatarItem.avatarImage tableViewNeedReload:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myInfo.data ? self.myInfo.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDMyInfoItem *item = [self.myInfo.data objectAtIndex:indexPath.row];
    if (item.type == YDMyInfoItemTypeAvatar) {
        YDMyInfoAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDMyInfoAvatarCell"];
        [cell setItem:item];
        return cell;
    }
    else if (item.type == YDMyInfoItemTypeInput){
        YDMyTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDMyTextFieldCell"];
        [cell setItem:item];
        [cell setDelegate:self];
        return cell;
    }
    else if (item.type == YDMyInfoItemTypeDefault){
        YDMyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDMyInfoCell"];
        [cell setItem:item];
        return cell;
    }
    
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YDMyInfoItem *item = [self.myInfo.data objectAtIndex:indexPath.row];
    YDMyInfoItem *avatarItem = [self.myInfo.data objectAtIndex:0];
    YDWeakSelf(self);
    
    if ([item.title isEqualToString:@"头像"]) {
        [self.imagePickerTool showActionSheet:^(UIImage *image, NSURL *url) {
            item.avatarImage = image;
            [weakself checkTempUserInformation:weakself.myInfo.tempUserInfo avatar:avatarItem.avatarImage tableViewNeedReload:YES];
        }];
    }
    else if ([item.title isEqualToString:@"昵称"]){
    
    }
    else if ([item.title isEqualToString:@"真实姓名"]){
        
    }
    else if ([item.title isEqualToString:@"年龄"]){
        if ([self checkUserAuthStatus]) {
            if (self.myInfo.tempUserInfo.ud_birth.integerValue > 0) {
                [self.datePickerTool setStartDate:[NSDate dateFromTimeStamp:self.myInfo.tempUserInfo.ud_birth]];
            }
            [self.datePickerTool show];
            [self.datePickerTool setDoneButtonAction:^(NSDate *date){
                [weakself calculationAgeAndConstellations:date];
                [weakself checkTempUserInformation:weakself.myInfo.tempUserInfo avatar:avatarItem.avatarImage tableViewNeedReload:YES];
            }];
        }
    }
    else if ([item.title isEqualToString:@"性别"]){
        if ([self checkUserAuthStatus]) {
            [self.titlePickerTool setType:YDTitlePickerToolTypeGender];
            [self.titlePickerTool setOriginalTitle:self.myInfo.tempUserInfo.ud_sex.integerValue == 1 ? @"男" : @"女"];
            [self.titlePickerTool setDoneButtonActionBlock:^(NSString *selectedTitle, NSInteger row){
                weakself.myInfo.tempUserInfo.ud_sex = @(row + 1);
                [weakself checkTempUserInformation:weakself.myInfo.tempUserInfo avatar:avatarItem.avatarImage tableViewNeedReload:YES];
            }];
            [self.titlePickerTool show];
        }
    }
    else if ([item.title isEqualToString:@"情感状态"]){
        [self.titlePickerTool setType:YDTitlePickerToolTypeEmotion];
        [self.titlePickerTool setOriginalTitle:self.myInfo.tempUserInfo.emotionString];
        [self.titlePickerTool setDoneButtonActionBlock:^(NSString *selectedTitle, NSInteger row){
            weakself.myInfo.tempUserInfo.ud_emotion = @(row);
            [weakself checkTempUserInformation:weakself.myInfo.tempUserInfo avatar:avatarItem.avatarImage tableViewNeedReload:YES];
        }];
        [self.titlePickerTool show];
    }
    else if ([item.title isEqualToString:@"常出没地点"]){
        [[YDPlacePickerTool sharedInstance] setSelectedProvinName:self.myInfo.tempUserInfo.ud_often_province_name cityName:self.myInfo.tempUserInfo.ud_often_city_name areaName:self.myInfo.tempUserInfo.ud_often_area_name];
        YDWeakSelf(self);
        [[YDPlacePickerTool sharedInstance] setDoneButtonActionBlock:^(NSNumber *proId,NSString *proName,NSNumber *cityId,NSString *cityName,NSNumber *areaId,NSString *areaName){
            weakself.myInfo.tempUserInfo.ud_often_province = proId;
            weakself.myInfo.tempUserInfo.ud_often_province_name = proName;
            weakself.myInfo.tempUserInfo.ud_often_city = cityId;
            weakself.myInfo.tempUserInfo.ud_often_city_name = cityName;
            weakself.myInfo.tempUserInfo.ud_often_area = areaId;
            weakself.myInfo.tempUserInfo.ud_often_area_name = areaName;
            [weakself checkTempUserInformation:weakself.myInfo.tempUserInfo avatar:avatarItem.avatarImage tableViewNeedReload:YES];
        }];
        [[YDPlacePickerTool sharedInstance] show];
    }
    else if ([item.title isEqualToString:@"感兴趣的事"]){
        [self.navigationController pushViewController:self.interestsVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 72.0f;
    }
    return 52.0f;
}

#pragma mark - Private Methods
- (BOOL)checkUserAuthStatus{
    if ([[YDUserDefault defaultUser].user.ud_userauth isEqual:@1]) {
        [YDMBPTool showInfoImageWithMessage:@"已认证不可修改" hideBlock:nil];
        return NO;
    }
    else if([[YDUserDefault defaultUser].user.ud_userauth isEqual:@2]){
        [YDMBPTool showInfoImageWithMessage:@"认证中不可修改" hideBlock:nil];
        return NO;
    }
    return YES;
}
- (void)calculationAgeAndConstellations:(NSDate *)date{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];//日历
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    if (month < 0) {
        year -= 1;
    }
    
    //年龄
    self.myInfo.tempUserInfo.ud_age = @(year);
    
    //出生年月日十位时间戳
    self.myInfo.tempUserInfo.ud_birth = @(YDTimeStamp(date).integerValue);
    
    //星座
    NSString *star = [NSDate calculateConstellationWithDate:date];
    self.myInfo.tempUserInfo.ud_constellation = star;
}

@end

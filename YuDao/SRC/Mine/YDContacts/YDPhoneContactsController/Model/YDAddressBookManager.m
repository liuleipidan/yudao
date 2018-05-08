//
//  YDAddressBookManager.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/26.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAddressBookManager.h"
#import <AddressBook/AddressBook.h>


@implementation YDAddressBookManager

- (void)getContactsFinish:(finishBlock )finish{
    YDWeakSelf(self);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            if (granted) {
                [weakself copyAddressBook:addressBookRef finish:finish];
            }else{
                finish(NO);
            }
        });
    }else {
        finish(NO);
    }
#pragma clang diagnostic pop
    
}

- (void)uploadContactsString:(void (^)())finish{
    if (_dataSource.count == 0) {
        return;
    }
    YDWeakSelf(self);
    NSDictionary *param = @{@"access_token":YDAccess_token,@"contacts":YDNoNilString(_contactsStr)};
    [YDNetworking POST:kUploadPhoneContactsURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        NSArray *joinedArr = data;
        for (YDContactsModel *model in weakself.dataSource) {
            for (NSDictionary *dic in joinedArr) {
                NSNumber *ud_id = [dic valueForKey:@"ub_id"];
                NSString *nickName = [dic valueForKey:@"ub_nickname"];
                NSString *phoneNumber = [dic valueForKey:@"ub_cellphone"];
                NSString *ud_face = [dic valueForKey:@"ud_face"];
                NSNumber *status = [dic valueForKey:@"friend"];
                if ([phoneNumber isEqualToString:model.phoneNumber] && ![ud_id isEqual:[YDUserDefault defaultUser].user.ub_id]) {
                    [model setUb_id:ud_id];
                    [model setNickName:nickName];
                    [model setAvatarURL:ud_face];
                    [model setStatus:status.integerValue];
                    //已经是好友
                    if ([[YDFriendHelper sharedFriendHelper] friendIsInExistenceByUid:ud_id]) {
                        [model setStatus:YDContactStatusFriend];
                    }
                    //已发过好友申请
                    else if ([YDDBSendFriendRequestStore checkSenderFriendRequsetExistOrNeedDeleteBySenderID:[YDUserDefault defaultUser].user.ub_id receiverID:ud_id]){
                        [model setStatus:YDContactStatusWait];
                    }
                    
                }
            }
        }
        finish();
    } failure:^(NSError *error) {
        finish();
    }];
}

- (void)showMessageViewInViewController:(UIViewController *)preVC
                                phones:(NSArray<NSString *> *)phones
                                 title:(NSString *)title
                                  body:(NSString *)body{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        
        [preVC presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

+ (void)addFriend:(YDContactsModel *)model
           finish:(void (^)(BOOL success, NSString *status))finish{
    NSDictionary *param = @{@"access_token":YDAccess_token,@"f_ub_id":YDNoNilNumber(model.ub_id)};
    [YDNetworking GET:kAddFriendURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        finish(YES,status);
    } failure:^(NSError *error) {
        finish(NO,nil);
    }];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSLog(@"result = %ld",result);
    if (result == MessageComposeResultSent) {
        
    }else{
    
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

/**
 获取每个联系人

 @param addressBook 通讯录地址
 @param finish 获取完成
 */
- (void)copyAddressBook:(ABAddressBookRef)addressBook finish:(finishBlock )finish{
    _dataSource = [NSMutableArray array];
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for ( int i = 0; i < numberOfPeople; i++){
        YDContactsModel *model = [[YDContactsModel alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        model.name = [NSString stringWithFormat:@"%@%@",lastName?lastName:@"",firstName?firstName:@""];
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            CFStringRef label = ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            NSString * personPhoneLabel = (__bridge NSString*)label;
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            
            if ([personPhoneLabel isEqualToString:@"mobile"] || [personPhoneLabel isEqualToString:@"手机"] || [personPhoneLabel isEqualToString:@"住宅"] || [personPhoneLabel isEqualToString:@"工作"] || [personPhoneLabel isEqualToString:@"iPhone"] || [personPhoneLabel isEqualToString:@"主要"]) {
                
                personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                model.phoneNumber = personPhone;
            }
            CFRelease(label);
            
        }
        if(ABPersonHasImageData(person)) {//本地头像
            NSData *imageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
            NSString *imageName = [NSString stringWithFormat:@"%.0lf.jpg", [NSDate date].timeIntervalSince1970 * 10000];
            NSString *imagePath = [NSFileManager pathContactsAvatar:imageName];
            [imageData writeToFile:imagePath atomically:YES];
            model.avatarPath = imageName;
        }
        if (model.phoneNumber && model.name) {
            model.status = 0;
            [_dataSource addObject:model];
        }
        
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (YDContactsModel *model in _dataSource) {
        if (model.phoneNumber) {
            [tempArr addObject:model.phoneNumber];
        }
    }
    if (tempArr.count > 0) {
        _contactsStr = [tempArr componentsJoinedByString:@","];
    }else{
        _contactsStr = @"";
    }
    
    _indexArr = [YDContactsModel IndexArray:_dataSource];
    _letterArr = [YDContactsModel LetterSortArray:_dataSource];
    
    
    finish(YES);
    
    CFRelease(people);
    CFRelease(addressBook);
}

@end

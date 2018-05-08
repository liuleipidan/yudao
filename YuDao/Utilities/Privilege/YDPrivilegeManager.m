//
//  YDPrivilegeManager.m
//  YuDao
//
//  Created by 汪杰 on 2017/3/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPrivilegeManager.h"
#import <AddressBook/AddressBook.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
@import Photos;
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CLLocationManager.h>

@implementation YDPrivilegeManager

+ (BOOL)checkCameraPrivilege{
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        //无权限
        return NO;
    }
    return YES;
}

+ (BOOL)checkPhotoLibraryPrivilege{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (BOOL)allowAccessToAlbums{
    return [YDPrivilegeManager albumAuthorizationStatus] == 3;
}

+ (NSInteger)albumAuthorizationStatus{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return [PHPhotoLibrary authorizationStatus];
    }
    else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [ALAssetsLibrary authorizationStatus];
#pragma clang diagnostic pop
    }
}

+ (BOOL)checkLocationPrivilege{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if ([CLLocationManager locationServicesEnabled] && (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        return YES;
        
    }else{
        return NO;
    }
}



+ (void)checkPrivilegeByType:(YDPrivilegeType )type
                 compeletion:(void (^)(BOOL granted))completion{
    if (type == YDPrivilegeTypeAddressBook) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //通讯录
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                CFRelease(addressBook);
            }
        });
#pragma clang diagnostic pop
    }else if (type == YDPrivilegeTypeMicrophone){
        //麦克风权限
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (completion) {
                completion(granted);
            }
        }];
    }else if (type == YDPrivilegeTypePhotoLibrary){
        //相册
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            BOOL granted;
            if (status == PHAuthorizationStatusAuthorized) {
                granted = YES;
            }else{
                granted = NO;
            }
            if (completion) {
                completion(granted);
            }
        }];
    }else if (type == YDPrivilegeTypeCamera){
        //相机
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (completion) {
                completion(granted);
            }
        }];
    }
}



@end

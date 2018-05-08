//
//  YDPrivilegeManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/3/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YDPrivilegeType){
    YDPrivilegeTypeAddressBook = 1,//通讯录
    YDPrivilegeTypeMicrophone,     //麦克风
    YDPrivilegeTypePhotoLibrary,   //相册
    YDPrivilegeTypeCamera,         //相机
};

@interface YDPrivilegeManager : NSObject

#pragma mark - 权限管理

/**
 检查相机权限

 @return yes or no
 */
+ (BOOL)checkCameraPrivilege;

/**
 检查相册权限

 @return yes or no
 */
+ (BOOL)checkPhotoLibraryPrivilege;


/**
 是否运行访问相册
 */
+ (BOOL)allowAccessToAlbums;

/**
 相册权限状态
 */
+ (NSInteger)albumAuthorizationStatus;

+ (void)checkPrivilegeByType:(YDPrivilegeType )type
                 compeletion:(void (^)(BOOL granted))completion;

/**
 检查位置权限
 
 @return yes or no
 */
+ (BOOL)checkLocationPrivilege;

@end

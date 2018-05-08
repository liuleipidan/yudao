//
//  CBPeripheral+YuDao.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/28.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "CBPeripheral+YuDao.h"

static const void *kCBPeripheral_Mac = @"kCBPeripheral_Mac";

@implementation CBPeripheral (YuDao)

- (void)setMacAddress:(NSString *)macAddress{
    objc_setAssociatedObject(self, &kCBPeripheral_Mac, macAddress, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)macAddress{
    return objc_getAssociatedObject(self, &kCBPeripheral_Mac);
}

@end

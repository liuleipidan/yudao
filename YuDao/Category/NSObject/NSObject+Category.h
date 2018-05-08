//
//  NSObject+Category.h
//  YuDao
//
//  Created by 汪杰 on 17/2/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)


/**
 获取对象所有属性名

 @return 属性名数组
 */
- (NSArray *)getObjectProperty;


/**
 检查并修改对象的成员变量
 */
- (id )checkAndChangeObjectPropertyValue;

- (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array;

- (NSMutableArray *)getFriendListSectionBy:(NSMutableArray *)array;

@end

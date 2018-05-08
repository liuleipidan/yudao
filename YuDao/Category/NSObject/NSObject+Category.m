//
//  NSObject+Category.m
//  YuDao
//
//  Created by 汪杰 on 17/2/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "YDFriendModel.h"

@implementation NSObject (Category)

- (NSArray *)getObjectProperty{
    unsigned int count = 0;
    // 获得所有的成员变量
    // ivars是一个指向成员变量的指针
    // ivars默认指向第0个成员变量（最前面）
    
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = propertys[i];
        const char *propertyName = property_getName(property);
        NSString *propertyString = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        [tempArray addObject:propertyString];
    }
    free(propertys);
    
    return tempArray;
}

- (id )checkAndChangeObjectPropertyValue{
    NSArray *propertyArray = [self getObjectProperty];
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.mj_keyValues];
    
    for (int i = 0; i < propertyArray.count; i++) {
        //获取Get方法
        SEL getSel = [self creatGetterWithPropertyName:propertyArray[i]];
        
        if ([self respondsToSelector:getSel]) {
            //获取类和方法的签名
            NSMethodSignature *signature = [self methodSignatureForSelector:getSel];
            //从签名获取调用对象
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            
            //设置target
            [invocation setTarget:self];
            //设置selector
            [invocation setSelector:getSel];
            
            //接受返回的值
            NSObject *__unsafe_unretained returnValue = nil;
            //调用方法
            [invocation invoke];
            //接收返回值
            [invocation getReturnValue:&returnValue];
            
            //属性类型字符串
            objc_property_t property = propertys[i];
            const char *propertyClass = property_getAttributes(property);
            NSString *classString = [NSString stringWithCString:propertyClass encoding:NSUTF8StringEncoding];
            NSArray *attributes = [classString componentsSeparatedByString:@","];
            classString = [attributes objectAtIndex:0];
            
            NSString *propertyName = propertyArray[i];
            //判断类型
            if ([classString isEqualToString:@"T@\"NSString\""]) {
                if (!returnValue) {
                    [tempDic setObject:@"" forKey:propertyName];
                }
            }else if ([classString isEqualToString:@"T@\"NSNumber\""]){
                if (!returnValue) {
                    [tempDic setObject:@0 forKey:propertyName];
                }
            }else if ([classString isEqualToString:@"T@\"NSDate\""]){
                if (!returnValue) {
                    YDLog(@"NSDate 为空!");
                }
            }else if ([classString isEqualToString:@"T@\"NSArray\""]){
                if (!returnValue) {
                    YDLog(@"NSArray 为空!");
                }
            }
        }
    }
    
    id tempClass = [[self class] new];
    tempClass = [[tempClass class] mj_objectWithKeyValues:tempDic];
    
    return tempClass;
}

#pragma mark -- 通过字符串来创建该字符串的Getter方法，并返回
- (SEL)creatGetterWithPropertyName: (NSString *) propertyName{
    
    //1.返回get方法: oc中的get方法就是属性的本身
    return NSSelectorFromString(propertyName);
}
#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
- (SEL)creatSetterWithPropertyName: (NSString *) propertyName{
    
    //1.返回get方法: oc中的get方法就是属性的本身
    return NSSelectorFromString(propertyName);
}

//重设值
- (void)resetPropertyValue:(NSString *)propertyName value:(id )value{
    objc_setAssociatedObject(self, [propertyName UTF8String], value, OBJC_ASSOCIATION_ASSIGN);
}

//获取好友列表数据
- (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//排序
        int i;
        NSString *strA = ((YDFriendModel *)obj1).pinyin;
        NSString *strB = ((YDFriendModel *)obj2).pinyin;
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;//上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;//下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    for (YDFriendModel *user in serializeArray) {
        char c = '#';
        if (user.pinyin.length != 0) {
            c = [user.pinyin characterAtIndex:0];
        }
        if (!isalpha(c)) {
            c = '#';
        }
        if (!isalpha(c)) {
            [oth addObject:user];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:user];
        }
        else {
            [data addObject:user];
        }
    }
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    return ans;
}
//获取每组的标题
- (NSMutableArray *)getFriendListSectionBy:(NSMutableArray *)array{
    NSMutableArray *section = [[NSMutableArray alloc] init];
    for (NSArray *item in array) {
        YDFriendModel *user = [item objectAtIndex:0];
        char c = '#';
        if (user.pinyin.length != 0) {
            c = [user.pinyin characterAtIndex:0];
        }
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return section;
}



@end


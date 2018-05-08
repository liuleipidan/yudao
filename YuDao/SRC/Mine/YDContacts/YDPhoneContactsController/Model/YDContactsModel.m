//
//  ContactsModel.m
//  YuDao
//
//  Created by 汪杰 on 16/9/28.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDContactsModel.h"
#import "pinyin.h"
@implementation YDContactsModel


#pragma mark - 返回tableview右方 indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray *A_Result = [NSMutableArray array];
    NSString *tempString ;
    
    for (YDContactsModel* model in tempArray)
    {
        NSString *pinyin = [model.pinYin substringToIndex:1];
        //不同
        if(![tempString isEqualToString:pinyin])
        {
            [A_Result addObject:pinyin];
            tempString = pinyin;
        }
    }
    
    return A_Result;
}

#pragma mark - 返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray *LetterResult = [NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString;
    //拼音分组
    for (YDContactsModel *model in tempArray) {
        
        NSString *pinyin = [model.pinYin substringToIndex:1];
        //不同
        if(![tempString isEqualToString:pinyin])
        {
            //分组
            item = [NSMutableArray array];
            [item  addObject:model];
            [LetterResult addObject:item];
            //遍历
            tempString = pinyin;
        }else//相同
        {
            [item  addObject:model];
        }
    }
    
    return LetterResult;
}


///////////////////
//
//返回排序好的字符拼音
//
///////////////////
+(NSMutableArray*)ReturnSortChineseArrar:(NSArray*)stringArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *tempArray =[NSMutableArray array];
    for(int i=0;i<[stringArr count];i++)
    {
        YDContactsModel *model = [stringArr objectAtIndex:i];
        if(model.name.length == 0 || model.name == nil){
            model.name = @"无名字";
        }
        //去除两端空格和回车
        model.name  = [model.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //这里我自己写了一个递归过滤指定字符串   removeSpecialCharacter
        model.name = [NSString removeSpecialCharacter:model.name];
        
        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        NSString *initialStr = [model.name length]?[model.name substringToIndex:1]:@"";
        if ([predicate evaluateWithObject:initialStr])
        {
            //首字母大写
            model.pinYin = [model.name capitalizedString] ;
        }else{
            if(![model.name isEqualToString:@""]){
                NSString *pinYinResult = [NSString string];
                for(int j=0;j<model.name.length;j++){
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                     
                                                     pinyinFirstLetter([model.name characterAtIndex:j])]uppercaseString];
                    
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                model.pinYin = pinYinResult;
            }else{
                model.pinYin = @"";
            }
        }
        [tempArray addObject:model];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [tempArray sortUsingDescriptors:sortDescriptors];
    return tempArray;
}

+(NSMutableArray*)TestLetterSortArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray *LetterResult = [NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString;
    //拼音分组
    for (NSString* object in tempArray) {
        
        NSString *pinyin = [((YDContactsModel*)object).pinYin substringToIndex:1];
        NSString *string = ((YDContactsModel*)object).name;
        //不同
        if(![tempString isEqualToString:pinyin])
        {
            //分组
            item = [NSMutableArray array];
            [item  addObject:string];
            [LetterResult addObject:item];
            //遍历
            tempString = pinyin;
        }else//相同
        {
            [item  addObject:string];
        }
    }
    return LetterResult;
}


///////////////////
//
//返回排序好的字符拼音
//
///////////////////
+(NSMutableArray*)TestReturnSortChineseArrar:(NSArray*)stringArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringArr count];i++)
    {
        YDContactsModel *chineseString = [[YDContactsModel alloc]init];
        chineseString.name = [NSString stringWithString:[stringArr objectAtIndex:i]];
        if(chineseString.name == nil){
            chineseString.name = @"";
        }
        //去除两端空格和回车
        chineseString.name  = [chineseString.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //这里我自己写了一个递归过滤指定字符串   removeSpecialCharacter
        chineseString.name = [NSString removeSpecialCharacter:chineseString.name];
        
        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        NSString *initialStr = [chineseString.name length]?[chineseString.name substringToIndex:1]:@"";
        if ([predicate evaluateWithObject:initialStr])
        {
            //首字母大写
            chineseString.pinYin = [chineseString.name capitalizedString] ;
        }else{
            if(![chineseString.name isEqualToString:@""]){
                NSString *pinYinResult = [NSString string];
                for(int j=0;j<chineseString.name.length;j++){
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                     
                                                     pinyinFirstLetter([chineseString.name characterAtIndex:j])]uppercaseString];
                    
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                chineseString.pinYin = pinYinResult;
            }else{
                chineseString.pinYin = @"";
            }
        }
        [chineseStringsArray addObject:chineseString];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    return chineseStringsArray;
}

#pragma mark - 返回一组字母排序数组
+(NSMutableArray*)SortArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    
    //把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result = [NSMutableArray array];
    for(int i=0;i<[stringArr count];i++){
        [result addObject:((YDContactsModel*)[tempArray objectAtIndex:i]).name];
    }
    return result;
}

@end

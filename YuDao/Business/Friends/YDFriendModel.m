//
//  YDFriendModel.m
//  YuDao
//
//  Created by 汪杰 on 16/11/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDFriendModel.h"
#import "NSString+PinYin.h"

@implementation YDFriendModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"friendid":@"f_ub_id",
             @"friendImage":@"ud_face",
             @"friendName":@"ub_nickname",
             @"friendGrade":@"ub_auth_grade",
             @"firstchar":@"f_firstchar",
             @"currentUserid":@"ub_id"};
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",self.friendid,self.friendImage,self.friendName,self.friendGrade,self.firstchar,self.currentUserid];
}

- (XMPPJID *)jid{
    return [XMPPJID jidWithUser:[NSString stringWithFormat:@"%@",self.friendid] domain:kHostName resource:@"iphone"];
}

- (NSString *)pinyin{
    return [self.friendName pinyin];
}

- (NSString *)pinyinInitial{
    return [self.friendName pinyinInitial];
}

//获取好友列表数据
+ (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array{
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
+ (NSMutableArray *)getFriendListSectionBy:(NSMutableArray *)array{
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

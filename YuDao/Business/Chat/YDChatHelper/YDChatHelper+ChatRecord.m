//
//  YDChatHelper+ChatRecord.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatHelper+ChatRecord.h"

@implementation YDChatHelper (ChatRecord)

- (void)chatMessageByUserId:(NSNumber *)userId
                        fid:(NSNumber *)fid
                   fromDate:(NSDate *)date
                      count:(NSUInteger )count
                 completion:(void (^)(NSArray *data, BOOL hasMore))completion{
    [self.messageStore chatMessageByUserId:userId fid:fid fromDate:date count:10 completion:completion];
}

- (void)chatImagesForFid:(NSString *)fid
               completed:(void (^)(NSArray *))completed{
    NSArray *data = [self.messageStore chatImagesAndVideosByUserId:YDUser_id fid:fid];
    completed(data);
}

@end

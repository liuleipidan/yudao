//
//  YDXMPPHelper+Room.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDXMPPHelper.h"



@interface YDXMPPHelper (Room)

/**
 加入群组

 @param roomName 群组名
 @param nickName 群组显示的昵称    
 */
- (void)joinRoom:(NSString *)roomName usingNickname:(NSString *)nickName;

@end

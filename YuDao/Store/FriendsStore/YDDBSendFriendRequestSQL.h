//
//  YDDBSendFriendRequestSQL.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#ifndef YDDBSendFriendRequestSQL_h
#define YDDBSendFriendRequestSQL_h

#define SEND_FRIEND_REQUEST_TABLE_NAME     @"sendFriendsRequest"

#define SQL_CREATE_ADD_FRIENDS_TABLE  @"CREATE TABLE IF NOT EXISTS %@ (\
                                    senderID INTEGER,\
                                    receiverID INTEGER,\
                                    time TEXT,\
                                    PRIMARY KEY(senderID,receiverID))"

#define SQL_INSERT_FRIEND_REQUEST     @"REPLACE INTO %@ (senderID,receiverID,time) VALUES ( ?, ?, ?)"

//select isnull((select top(1) 1 from tableName where conditions), 0)
//上面这个事网上查是否存在的，但是目前还不会用
#define SQL_SELECT_EXISTS_REQUEST     @"SELECT COUNT(*) FROM %@ WHERE senderID = %@ and receiverID = %@"

//查出此条好友请求
#define SQL_SELECT_CHECK_REQUEST      @"SELECT * FROM %@ WHERE senderID = %@ and receiverID = %@"

#define SQL_DELETE_FRIEND_REQUEST     @"DELETE FROM %@ WHERE senderID = %@ and receiverID = %@"

#define SQL_DELETE_CURRENT_USER_ALL   @"DELETE FROM %@ WHERE senderID = %@"

#define SQL_DELETE_ALL                @"DELETE FROM %@"

#endif /* YDDBSendFriendRequestSQL_h */

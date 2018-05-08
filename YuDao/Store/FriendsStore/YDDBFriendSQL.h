//
//  YDDBFriendSQL.h
//  YuDao
//
//  Created by 汪杰 on 16/11/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#ifndef YDDBFriendSQL_h
#define YDDBFriendSQL_h


#define     FRIENDS_TABLE_NAME              @"friends"

#define     SQL_CREATE_FRIENDS_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
                                                friendid INTEGER,\
                                                currentUserid INTEGER,\
                                                friendImage TEXT,\
                                                friendName TEXT,\
                                                friendGrade INTEGER, \
                                                firstchar TEXT,\
                                                PRIMARY KEY(friendid))"

#define     SQL_UPDATE_FRIEND               @"REPLACE INTO %@ ( friendid, currentUserid, friendImage, friendName, friendGrade, firstchar) VALUES ( ?, ?, ?, ?, ?, ?)"

#define     SQL_SELECT_FRIENDS              @"SELECT * FROM %@ WHERE currentUserid = %ld"

#define     SQL_SELECT_FRIEND               @"SELECT * FROM %@ WHERE currentUserid = %@ and friendid = %@"

#define     SQL_DELETE_FRIEND               @"DELETE FROM %@ WHERE currentUserid = '%ld' and friendid = '%ld'"

#define     SQL_DELETE_ALL_FRIENDS          @"DELETE FROM %@ WHERE currentUserid = %@"

#endif /* YDDBFriendSQL_h */

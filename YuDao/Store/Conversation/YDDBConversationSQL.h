//
//  YDDBConversationSQL.h
//  YuDao
//
//  Created by 汪杰 on 16/11/17.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#ifndef YDDBConversationSQL_h
#define YDDBConversationSQL_h

#define     CONV_TABLE_NAME             @"conversation"


#define     SQL_CREATE_CONV_TABLE       @"CREATE TABLE IF NOT EXISTS %@(\
                                        uid       INTEGER,\
                                        fid       INTEGER,\
                                        fname     TEXT,\
                                        fimage    TEXT,\
                                        content    TEXT,\
                                        conv_type INTEGER DEFAULT (0), \
                                        date TEXT,\
                                        unread_count INTEGER DEFAULT (0),\
                                        PRIMARY KEY(fid))"


#define     SQL_ADD_CONV                @"REPLACE INTO %@ ( uid, fid, fname, fimage,content ,conv_type, date, unread_count) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?)"


#define     SQL_SELECT_CONVS            @"SELECT * FROM %@ WHERE uid = %@ ORDER BY date DESC"
#define     SQL_SELECT_ONE_CONVS        @"SELECT * FROM %@ WHERE uid = '%@' and fid = '%@'"
#define     SQL_SELECT_CONV_UNREAD      @"SELECT unread_count FROM %@ WHERE uid = '%@' and fid = '%@'"
//更新好友请求为已读
#define     SQL_UPDATE_CONVS             @"update %@ set unread_count = 0 where uid = '%@' and fid = '%@'"

//所有未读消息数量
#define     SQL_SUM_CONV_UNREADCOUNT    @"SELECT SUM(unread_count) FROM %@ where uid = '%@' and unread_count > 0"

#define     SQL_DELETE_CONV             @"DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"
#define     SQL_DELETE_ALL_CONVS        @"DELETE FROM %@ WHERE uid = '%@'"



#endif /* YDDBConversationSQL_h */

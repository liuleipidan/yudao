//
//  YDDBChatMessageSQL.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#ifndef YDDBChatMessageSQL_h
#define YDDBChatMessageSQL_h

#define CHAT_MESSAGE_TABLE_NAME  @"chatMessage"

#define SQL_CREATE_MESSAGE_TABLE @"CREATE TABLE IF NOT EXISTS %@(\
                                msgid TEXT,\
                                uid INTEGER,\
                                fid INTEGER,\
                                date TEXT,\
                                own_type INTEGER DEFAULT (0),\
                                msg_type INTEGER DEFAULT (0),\
                                content TEXT,\
                                send_status INTEGER DEFAULT (0),\
                                read_status INTEGER DEFAULT (0),\
                                PRIMARY KEY(msgid,uid,fid))"

#define SQL_ADD_CHAT_MESSAGE_TABLE   @"REPLACE INTO %@ (msgid,uid,fid,date,own_type,msg_type,content,send_status,read_status) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define SQL_SELECT_CHAT_MESSAGE_PAGE @"SELECT * FROM %@ WHERE uid = %@ and fid = %@ and date < %@ ORDER BY date desc,msgid desc LIMIT %ld"

#define SQL_SELECT_CHAT_IMAGES       @"SELECT * FROM %@ WHERE uid = %@ and fid = %@ and msg_type = 10003 ORDER BY date desc,msgid desc"

#define SQL_UPDATE_MESSAGE_SENDS_STATUS @"UPDATE %@ SET send_status = %ld WHERE msgid = %@ and uid = %@"

#define SQL_UPDATE_MESSAGE_READ_STATUS  @"UPDATE %@ SET read_status = %ld WHERE msgid = %@ and uid = %@"

//最后一条系统消息
#define SQL_SELECT_LAST_CHAT_MESSAGE   @"SELECT * FROM %@ WHERE date = (SELECT MAX(date) FROM %@ WHERE uid = %@ and fid = %@)"

#define SQL_DELETE_ONE_MESSAGE             @"DELETE FROM %@ WHERE msgid = %@ and uid = %@ and fid = %@"

#define SQL_SELECT_ONE_MESSAGE             @"SELECT *  FROM %@ WHERE msgid = %@ and uid = %@ and fid = %@"

#define SQL_DELETE_MESSAGES             @"DELETE FROM %@ WHERE uid = %@ and fid = %@"



#endif /* YDDBChatMessageSQL_h */

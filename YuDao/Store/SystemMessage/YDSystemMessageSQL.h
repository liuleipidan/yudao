//
//  YDSystemMessageSQL.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#ifndef YDSystemMessageSQL_h
#define YDSystemMessageSQL_h

#define SYSTEM_MESSAGE_TABLE_NAME          @"system_message"


#define SQL_CREAT_SYSTEM_MESSAGE_TABLE     @"CREATE TABLE IF NOT EXISTS %@(\
                                            msgid INTEGER,\
                                            msgtype INTEGER DEFAULT (1),\
                                            msgsubtype INTEGER,\
                                            userid INTEGER DEFAULT (0),\
                                            time INTEGER,\
                                            content TEXT,\
                                            readState  INTEGER DEFAULT (0),\
                                            PRIMARY KEY(msgid))"


#pragma mark - msgtype - 消息主类型 - 1、系统 2、社交

#define SQL_ADD_SYSTEM_MESSAGE               @"REPLACE INTO %@ ( msgid, msgtype, msgsubtype, userid, time, content, readState) VALUES ( ?, ?, ?, ?, ?, ?, ?)"

#pragma mark - 系统消息操作 - 暂定为只要不是好友请求（msgsubtype != 1001）都算系统消息
//系统消息列表
#define SQL_SELECT_SYSTEM_MESSAGE          @"SELECT * FROM %@ WHERE msgtype = 1 and userid = %@ ORDER BY time DESC LIMIT '%ld'"

//未读系统消息数量
#define SQL_COUNT_UNREAD_SYSTEM_MESSAGE    @"SELECT COUNT(*) FROM %@ WHERE msgtype = 1 and userid = %@ and readState = 0"

//最后一条系统消息
#define SQL_SELECT_LAST_SYSTEM_MESSAGE     @"SELECT * FROM %@ WHERE time = (SELECT MAX(time) FROM %@ WHERE msgtype = 1 and userid = %@)"

//刷新所有已读系统消息
#define SQL_UPDATE_SYSTEM_MESSAGE          @"UPDATE %@ SET readState = 1 WHERE msgtype = 1 and userid = %@ and  readState = 0"

//删除一条消息
#define SQL_DELETE_SYSTEM_MESSAGE          @"DELETE FROM %@ WHERE msgtype = 1 and msgid = %@ and  userid = %@"

//删除所有系统消息
#define SQL_DELETE_ALL_SYSTEM_MESSAGE      @"DELETE FROM %@ WHERE msgtype = 1 and userid = %@"

#endif /* YDSystemMessageSQL_h */

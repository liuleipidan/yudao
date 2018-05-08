//
//  YDPushMessageSQL.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#ifndef YDPushMessageSQL_h
#define YDPushMessageSQL_h

#define PUSH_MESSAGE_TABLE_NAME       @"pushMessage"

#define FRIEND_REQUEST_TABLE_NAME     @"friendRequest"

#define SQL_CREAT_FRIEND_REQUES_TABLE  @"CREATE TABLE IF NOT EXISTS %@(\
                                    msgid INTEGER,\
                                    msgtype INTEGER DEFAULT (1),\
                                    msgsubtype INTEGER,\
                                    userid INTEGER DEFAULT (0),\
                                    senderid INTEGER,\
                                    receiverid INTEGER,\
                                    content TEXT,\
                                    time INTEGER,\
                                    name TEXT,\
                                    avatar TEXT,\
                                    readState       INTEGER DEFAULT (0),\
                                    frStatus        INTEGER DEFAULT (0),\
                                    PRIMARY KEY(senderid))"

#define SQL_CREAT_PUSH_MESSAGE_TABLE  @"CREATE TABLE IF NOT EXISTS %@(\
                                    msgid INTEGER,\
                                    msgtype INTEGER DEFAULT (1),\
                                    msgsubtype INTEGER,\
                                    userid INTEGER DEFAULT (0),\
                                    senderid INTEGER,\
                                    receiverid INTEGER,\
                                    content TEXT,\
                                    time INTEGER,\
                                    name TEXT,\
                                    avatar TEXT,\
                                    readState       INTEGER DEFAULT (0),\
                                    frStatus        INTEGER DEFAULT (0),\
                                    PRIMARY KEY(msgid))"

#pragma mark - msgtype - 消息主类型 - 1、系统 2、社交

#define SQL_ADD_PUSH_MESSAGE     @"REPLACE INTO %@ ( msgid, msgtype, msgsubtype, userid, senderid, receiverid, content, time, name, avatar, readState,frStatus) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"


#pragma mark - 系统消息操作 - 暂定为只要不是好友请求（msgsubtype != 1001）都算系统消息
//系统消息列表
#define SQL_SELECT_PUSH_MESSAGE_SYSTEM  @"SELECT * FROM %@ WHERE msgtype = 1 and userid = %@ and receiverid = %@  ORDER BY time DESC LIMIT '%ld'"

//未读系统消息数量
#define SQL_COUNT_PUSH_MESSAGE_SYSTEM   @"SELECT COUNT(*) FROM %@ WHERE  msgtype = 1 and userid = %@ and receiverid = %@  and readState = 0"

//最后一条系统消息
#define SQL_SELECT_LAST_PUSH_MESSAGE_SYSTEM    @"SELECT * FROM %@ WHERE time = (SELECT MAX(time) FROM %@ WHERE  msgtype = 1  and userid = %@ and receiverid = %@)"

//成功去重SELECT *,COUNT(DISTINCT senderid) FROM %@ WHERE msgtype = 2 and msgsubtype = 1001 and userid = %@ and receiverid = %@  GROUP BY senderid ORDER BY time DESC LIMIT '%ld'

//刷新所有已读系统消息
#define SQL_UPDATE_PUSH_MESSAGE_SYSTEM          @"UPDATE %@ SET readState = 1 WHERE msgsubtype != 1001 and userid = %@ and receiverid = %@"

#pragma mark - 好友请求操作
//好友请求
#define SQL_SELECT_PUSH_MESSAGE_Friend_REQUEST  @"SELECT * FROM %@ WHERE msgtype = 2 and msgsubtype = 1001 and userid = %@ and receiverid = %@ ORDER BY time DESC LIMIT '%ld'"

//刷新好友请求为已添加
#define SQL_UPDATE_PUSH_MESSAGE_FRIEND_REQUEST_READ @"UPDATE %@ SET frStatus = 2 WHERE msgtype = 2 and msgsubtype = 1001 and userid = %@ and receiverid = %@ and senderid = %@"

//通过名字搜索好友请求
#define SQL_SEARCH_PUSH_MESSAGE_FRIEND_REQUEST  @"SELECT * FROM %@ WHERE msgtype = 2 and msgsubtype = 1001 and userid = %@  and name like '%%%@%%'"

//去除重复好友推送
#define SQL_DELETE_REPEAT_PUSH_MESSAGE_FRIEND_REQUEST @"DELETE FROM pushMessage a WHERE senderid IN (SELECT senderid,COUNT(*) FROM pushMessage WHERE msgtype = 2 and msgsubtype = 1001 and userid = %@ and receiverid = %@ GROUP BY senderid HAVING COUNT(*) > 1)"

//统计好友请求
#define SQL_COUNT_PUSH_MESSAGE_Friend_REQUEST   @"SELECT COUNT(*) FROM %@ WHERE msgtype = 2 and msgsubtype = 1001 and userid = %@ and receiverid = %@ and readState = 0"

//刷新所有已读好友请求
#define SQL_UPDATE_PUSH_MESSAGE_Friend_REQUEST  @"UPDATE %@ SET readState = 1 WHERE msgtype = 2 and msgsubtype = 1001 and userid = %@ and receiverid = %@"

//成为好友
#define SQL_SELECT_PUSH_MESSAGE_Friend_ACCEPT  @"SELECT * FROM %@ WHERE msgtype = 2 and msgsubtype = 1002 and userid = %@ and receiverid = %@  LIMIT '%ld' ORDER BY time DESC"

//对方删除本用户
#define SQL_SELECT_PUSH_MESSAGE_Friend_DELETE  @"SELECT * FROM %@ WHERE msgtype = 2 and msgsubtype = 1003 and userid = %@ and receiverid = %@  LIMIT '%ld' ORDER BY time DESC"

//删除一条消息
#define SQL_DELETE_PUSH_MESSAGE  @"DELETE FROM %@ WHERE msgid = %@"

//删除系统消息
#define SQL_DELETE_PUSH_MESSAGE_SYSTEM  @"DELETE FROM %@ WHERE msgtype = 1 and userid = %@"

#define SQL_DELETE_ALL_PUSH_MESSAGE @"DELETE FROM %@"


#endif /* YDPushMessageSQL_h */

//
//  YDDBHomePageModuleSQL.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#ifndef YDHPIgnoreStoreSQL_h
#define YDHPIgnoreStoreSQL_h

#define HOME_PAGE_MODULE_TABLE_NAME        @"homePageModule"

#define SQL_CREATE_HOME_PAGE_MODULE_TABLE  @"CREATE TABLE IF NOT EXISTS %@ (\
                                            rid          INTEGER,\
                                            uid          INTEGER,\
                                            ptype        INTEGER,\
                                            subtype      INTEGER DEFAULT (0),\
                                            ignore_type  INTEGER DEFAULT (0),\
                                            time         TEXT,\
                                            PRIMARY KEY(rid,uid))"

#define SQL_INSERT_HOME_PAGE_MODULE        @"REPLACE INTO %@ (rid,uid,ptype,subtype,ignore_type,time) VALUES ( ?, ?, ?, ?, ?, ?)"

//查出此条好友请求
#define SQL_SELECT_CHECK_HOME_PAGE_MODULE      @"SELECT * FROM %@ WHERE uid = %@ and module_type = %ld"

#define SQL_SELECT_HOME_PAGE_IGNORE_LIST      @"SELECT * FROM %@ WHERE uid = %@"

#define SQL_SELECT_CHECK_HOME_PAGE_TYPE_SUBTYPE @"SELECT * FROM %@ WHERE uid = %@ and ptype = %ld and subtype = %ld and ignore_type = %ld"

#define SQL_SELECT_CHECK_HOME_PAGE_MODEL @"SELECT * FROM %@ WHERE uid = %@ and ptype = %ld and subtype = %ld"

#define SQL_DELETE_HOME_PAGE_MODULE            @"DELETE FROM %@ WHERE rid = %@ and uid = %@"

#define SQL_DELETE_CURRENT_USER_ALL            @"DELETE FROM %@ WHERE uid = %@"

#define SQL_DELETE_ALL                         @"DELETE FROM %@"

#endif /* YDHPIgnoreStoreSQL_h */

//
//  YDDBPlaceSQL.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/26.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#ifndef YDDBPlaceSQL_h
#define YDDBPlaceSQL_h

#define     PLACE_TABLE_NAME              @"place"

#define     SQL_CREATE_PLACE_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
                                            currentid INTEGER,\
                                            pid INTEGER,\
                                            name TEXT,\
                                            PRIMARY KEY(currentid))"

#define     SQL_UPDATE_PLACE              @"REPLACE INTO %@ ( currentid, pid, name) VALUES ( ?, ?, ?)"

#define     SQL_SELECT_PLACE_PROVINCES    @"SELECT * FROM %@ WHERE currentid != 0 and pid = 0"

#define     SQL_SELECT_PLACE              @"SELECT * FROM %@ WHERE pid = %@"

#define     SQL_SELECT_COUNT_PLACE        @"SELECT COUNT(*) FROM %@"

#define     SQL_DELETE_ALL_PLACE          @"DELETE FROM %@"

#endif /* YDDBPlaceSQL_h */

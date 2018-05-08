//
//  YDDBUserSQL.h
//  YuDao
//
//  Created by 汪杰 on 16/11/7.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#ifndef YDDBUserSQL_h
#define YDDBUserSQL_h

#define     USER_TABLE_NAME             @"user"


#define     SQL_CREATE_USER_TABLE       @"CREATE TABLE IF NOT EXISTS %@(\
                                        ub_id INTEGER,\
                                        access_token TEXT,\
                                        ub_name TEXT,\
                                        ub_nickname TEXT,\
                                        ub_cellphone TEXT,\
                                        ub_password TEXT,\
                                        ud_face TEXT,\
                                        ud_realname TEXT,\
                                        ud_age INTEGER,\
                                        ud_sex INTEGER,\
                                        ud_emotion INTEGER,\
                                        ud_tag_name TEXT,\
                                        ud_userauth INTEGER,\
                                        ud_often_province INTEGER,\
                                        ud_often_province_name TEXT,\
                                        ud_often_city INTEGER,\
                                        ud_often_city_name TEXT,\
                                        ud_often_area INTEGER,\
                                        ud_often_area_name TEXT,\
                                        ud_tag TEXT,\
                                        ud_age_display INTEGER,\
                                        ud_constellation TEXT,\
                                        PRIMARY KEY(ub_id))"


#define     SQL_ADD_USER                @"REPLACE INTO %@ ( ub_id, access_token, ub_name, ub_nickname, ub_cellphone, ub_password, ud_face, ud_realname, ud_age, ud_sex,ud_emotion, ud_tag_name, ud_userauth, ud_often_province, ud_often_province_name, ud_often_city, ud_often_city_name, ud_often_area, ud_often_area_name, ud_tag, ud_age_display, ud_constellation) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"


#define     SQL_SELECT_USER            @"SELECT * FROM %@ WHERE ub_id = %ld"


#define     SQL_DELETE_USER             @"DELETE FROM %@ WHERE ub_id = '%@'"
#define     SQL_DELETE_ALL_USERS        @"DELETE FROM %@ "

#endif /* YDDBUserSQL_h */

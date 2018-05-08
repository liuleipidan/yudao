//
//  YDDBCarBrandStoreSQL.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#ifndef YDDBCarBrandStoreSQL_h
#define YDDBCarBrandStoreSQL_h

#define     CARBRAND_TABLE_NAME           @"carBrand"

#define     SQL_CREATE_PLACE_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
                                            brand_id INTEGER,\
                                            brand_name TEXT,\
                                            brand_firstletter TEXT,\
                                            brand_logo TEXT,\
                                            disabled INTEGER,\
                                            PRIMARY KEY(brand_id))"

#define     SQL_UPDATE_CARBRAND           @"REPLACE INTO %@ ( brand_id, brand_name, brand_firstletter, brand_logo, disabled) VALUES ( ?, ?, ?, ?, ?)"

#define     SQL_SELECT_CARBRAND           @"SELECT * FROM %@ ORDER BY brand_firstletter"

#define     SQL_SELECT_COUNT_CARBRAND     @"SELECT COUNT(*) FROM %@"

#define     SQL_DELETE_ALL_CARBRAND       @"DELETE FROM %@"

#endif /* YDDBCarBrandStoreSQL_h */

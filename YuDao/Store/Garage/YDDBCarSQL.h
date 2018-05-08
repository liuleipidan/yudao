//
//  YDDBCarSQL.h
//  YuDao
//
//  Created by 汪杰 on 16/11/21.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#ifndef YDDBCarSQL_h
#define YDDBCarSQL_h
#define     CAR_TABLE_NAME             @"car"

#define     SQL_CREATE_CAR_TABLE       @"CREATE TABLE IF NOT EXISTS %@(\
                                            ug_status INTEGER,\
                                            ug_boundtype INTEGER,\
                                            ug_plate_title TEXT,\
                                            ug_city INTEGER,\
                                            ug_brand_logo TEXT,\
                                            ug_province INTEGER,\
                                            ug_city_name TEXT,\
                                            ug_brand_name TEXT,\
                                            vb_id INTEGER,\
                                            vm_id INTEGER,\
                                            ug_vehicle_auth INTEGER,\
                                            ug_series_name TEXT,\
                                            ug_plate TEXT,\
                                            ug_province_name TEXT,\
                                            ug_engine TEXT,\
                                            wz_date TEXT,\
                                            ug_annual_inspection INTEGER,\
                                            ug_maintenance INTEGER,\
                                            ug_id INTEGER,\
                                            ub_id INTEGER,\
                                            vs_id INTEGER,\
                                            ug_model_name TEXT,\
                                            ug_frame_number TEXT,\
                                            ug_positive TEXT,\
                                            ug_negative TEXT,\
                                            bo_imei TEXT,\
                                            channelid INTEGER,\
                                            ug_bind_air INTEGER,\
                                            airInfo TEXT,\
                                            PRIMARY KEY(ug_id))"

#define     SQL_ADD_CAR                @"REPLACE INTO %@ (ug_status, ug_boundtype,ug_plate_title,ug_city,ug_brand_logo,ug_province,ug_city_name,ug_brand_name,vb_id,vm_id,ug_vehicle_auth,ug_series_name,ug_plate,ug_province_name,ug_engine,wz_date,ug_annual_inspection,ug_maintenance,ug_id,ub_id,vs_id,ug_model_name,ug_frame_number,ug_positive,ug_negative,bo_imei,channelid,ug_bind_air,airInfo) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"


#define     SQL_SELECT_CAR            @"SELECT * FROM %@ WHERE ug_id = %ld and ub_id = %ld"

#define     SQL_SELECT_CARS           @"SELECT * FROM %@ WHERE ub_id = %ld"

#define     SQL_SELECT_DEFAULT_CAR    @"SELECT * FROM %@ WHERE ub_id = %@ and ug_status = 1"

#define     SQL_SELECT_BOUNDOBD_CAR   @"SELECT * FROM %@ WHERE ub_id = %@ and ug_boundtype = 1"

#define     SQL_UPDATE_DEFAULT_CAR    @"UPDATE %@ set ug_status = 1 where ug_id = %@ and ug_id = %@"

#define     SQL_UPDATE_CAR_OBD_STATUS @"UPDATE %@ set ug_boundtype = %ld where ub_id = %@ and ug_id = %@"

#define     SQL_DELETE_CAR            @"DELETE FROM %@ WHERE ug_id = %@ and ub_id = %@"
#define     SQL_DELETE_ALL_CARS       @"DELETE FROM %@ "

#endif /* YDDBCarSQL_h */

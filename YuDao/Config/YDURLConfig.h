//
//  YDURLConfig.h
//  YuDao
//
//  Created by 汪杰 on 16/10/26.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#ifndef YDURLConfig_h
#define YDURLConfig_h

/*
 #ifdef DEVELOP //开发环境
 #define kEnvironmentalKey     @"ydapi.test.ve-link.com"
 #define kEnvironmentalApiKey  @"api"
 #define kHtmlEnvironmentalKey @"ydapp.test.ve-link.com"//网页环境变量
 #define kMallEnvironmentalKey @"test.ve-link.com/"     //积分商城环境变量
 */

#ifdef DEVELOP //开发环境
#define kEnvironmentalKey     @"ydapi.test.ve-link.com"  //API
#define kEnvironmentalApiKey  @"api"
#define kHtmlEnvironmentalKey @"ydapp.test.ve-link.com"//网页环境变量
#define kMallEnvironmentalKey @"test.ve-link.com/"     //积分商城环境变量
#elif  TEST    //测试环境
#define kEnvironmentalKey     @"ydapinew.ve-link.com"//API
#define kEnvironmentalApiKey  @"api"
#define kHtmlEnvironmentalKey @"ydapp.test.ve-link.com"//网页环境变量
#define kMallEnvironmentalKey @"test.ve-link.com/"     //积分商城环境变量
#else          //生产环境
#define kEnvironmentalKey     @"ydapi.www.ve-link.com" //API
#define kEnvironmentalApiKey  @"api"
#define kHtmlEnvironmentalKey @"ydapp.www.ve-link.com" //网页环境变量
#define kMallEnvironmentalKey @"www.ve-link.com/"      //积分商城环境变量
#endif

//所有数据接口
#define kOriginalURL [NSString stringWithFormat:@"http://%@/%@/",kEnvironmentalKey,kEnvironmentalApiKey]

#import "YDHtmlURLs.h"

#import "YDApiURLs.h"


#endif /* YDURLConfig_h */

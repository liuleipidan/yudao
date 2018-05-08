//
//  YDNetworking.h
//  YuDao
//
//  Created by 汪杰 on 16/10/26.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum : NSInteger{
    StatusUnknown = 0,//未知状态
    StatusNotReachable,//无网状态
    StatusReachableViaWWAN,//手机网络
    StatusReachableViaWiFi,//Wifi网络
} NetworkStatus;

@interface YDNetworking : NSObject

//刷新用户token
+ (void)refreshUserToken;


/**
 上传当前设备的极光推送注册码

 @param dicPara 参数
 */
+ (void)uploadJpushRegisterID:(NSDictionary *)dicPara;

+ (NSURLSessionDataTask *)postUrl:(NSString *)urlString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (NSURLSessionDataTask *)getUrl:(NSString *)urlString
                      parameters:(id)parameters
                        progress:(void (^)(NSProgress * progress))downloadProgress
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (NSURLSessionDataTask *)POST:(NSString *)url
 parameters:(id)parameters
    success:(void (^)(NSNumber *code, NSString *status, id data))success
    failure:(void (^)(NSError *error))failure;

+ (NSURLSessionDataTask *)GET:(NSString *)url
    parameters:(id)parameters
       success:(void (^)(NSNumber *code, NSString *status, id data))success
       failure:(void (^)(NSError *error))failure;

/**
 上传消息数据，例如：图片、语言

 @param messageData 数据
 @param dataName 数据名（有api决定）
 @param url api链接
 @param success 成功
 @param failure 失败
 */
+ (void)uploadMessageData:(id )messageData
                 dataName:(NSString *)dataName
                      url:(NSString *)url
                  success:(void (^)(NSDictionary *data, NSString *dataUrl))success
                  failure:(void(^)(void))failure;

/**
 上传视频（mp4）和视频的第一桢

 @param videoPath 视频沙盒路径
 @param thumbnailImage 缩略图
 @param dataName 数据名
 @param url 路由
 @param success 成功
 @param failure 失败
 */
+ (void)uploadVideoData:(NSString *)videoPath
         thumbnailImage:(UIImage *)thumbnailImage
               dataName:(NSString *)dataName
                    url:(NSString *)url
                success:(void (^)(NSString *videoUrl, NSString *thumbnailImageUrl))success
                failure:(void(^)(void))failure;

+ (void)uploadVoiceFile:(NSString *)localPath
               dataName:(NSString *)dataName
                    url:(NSString *)url
                success:(void (^)(NSString *dataUrl))success
                failure:(void(^)(void))failure;


/**
 *  上传单张图片
 *
 *  @param image 图片
 *  @param url   网址
 */
+ (void)uploadImage:(UIImage *)image
                url:(NSString *)url
            success:(void (^)(NSString *imageUrl))success
            failure:(void(^)(void))failure;

//上传用户背景
+ (void)uploadUserBackgroudImage:(UIImage *)image url:(NSString *)url success:(void (^)(NSString *imageURL))success failure:(void(^)(void))failure;

//上传用户认证图片
+ (void)uploadUserTwoImage:(UIImage *)oneImage
                  twoImage:(UIImage *)twoImage
                       url:(NSString *)url
                   success:(void (^)(NSDictionary *response))sucess
                   failure:(void (^)(NSString *failMessage))failure;

//上传车辆认证图片
+ (void)uploadCarTwoImage:(UIImage *)oneImage twoImage:(UIImage *)twoImage url:(NSString *)url ug_id:(NSNumber *)ug_id success:(void (^)(void))sucess failure:(void (^)(NSString *failMessage))failure;

/**
 *  上传动态多张图片
 *
 *  @param imageArray 图片数组
 *  @param prefix     文件头
 *  @param url        url
 *  @param otherDic   其它数据（此处为上传图片成功后返回的图片网址，再次上传所需参数)
 */
+ (void)uploadImages:(NSMutableArray<UIImage *> *)imageArray prefix:(NSString *)prefix url:(NSString *)url otherData:(NSDictionary *)otherDic success:(void (^)(void))success failure:(void (^)(void))failure;


/**
 下载语言文件

 @param url 请求路径
 @param success 成功
 @param failure 失败
 */
+ (void)downloadVoiceFileWithURL:(NSString *)url
                         success:(void (^)(NSString *filePath))success
                         failure:(void (^)(void))failure;

@end

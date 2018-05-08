//
//  YDNetworking.m
//  YuDao
//
//  Created by 汪杰 on 16/10/26.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDNetworking.h"
#import "YDLoginViewController.h"
#import "AppDelegate.h"

@implementation YDNetworking

//刷新用户token
+ (void)refreshUserToken{
    if (!YDHadLogin) {
        return;
    }
    
    [YDNetworking POST:kRefreshTokenURL parameters:@{@"access_token":YDAccess_token} success:nil failure:nil];
    
    
    //更新每日登陆
}

+ (NSURLSessionDataTask *)postUrl:(NSString *)urlString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask *, id))success
                          failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    
    return [manager POST:urlString parameters:parameters progress:nil success:success failure:failure];
}

+ (NSURLSessionDataTask *)getUrl:(NSString *)urlString
                      parameters:(id)parameters
                        progress:(void (^)(NSProgress * progress))downloadProgress
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    
    return  [manager GET:urlString parameters:parameters progress:downloadProgress success:success failure:failure];
}
+ (NSURLSessionDataTask *)POST:(NSString *)url
  parameters:(id)parameters
     success:(void (^)(NSNumber *code, NSString *status, id data))success
     failure:(void (^)(NSError *error))failure{
    NSURLSessionDataTask *task = [YDNetworking postUrl:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response = [responseObject mj_JSONObject];
        NSNumber *code = [response valueForKey:@"status_code"];
        NSString *status = [response valueForKey:@"status"];
        id data = [response objectForKey:@"data"];
        //检查code
        NSString *access_token = [parameters valueForKey:@"access_token"];
        if (access_token && access_token.length > 1) {
            [YDNetworking yd_checkCode:code];
        }
        if (success) {
            success(code,status,data);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        YDLog(@"url = %@ error = %@",url,error);
        if (failure) {
            failure(error);
        }
    }];
    return task;
}
+ (NSURLSessionDataTask *)GET:(NSString *)url
    parameters:(id)parameters
       success:(void (^)(NSNumber *code, NSString *status, id data))success
       failure:(void (^)(NSError *error))failure{
    NSURLSessionDataTask *task = [YDNetworking getUrl:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response = [responseObject mj_JSONObject];
        NSNumber *code = [response valueForKey:@"status_code"];
        NSString *status = [response valueForKey:@"status"];
        id data = [response objectForKey:@"data"];
        
        //如果用户时登录状态需要检查token
        NSString *access_token = [parameters valueForKey:@"access_token"];
        if (access_token.length > 10) {
            [YDNetworking yd_checkCode:code];
        }
        
        if (success) {
           success(code,status,data);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        YDLog(@"url = %@ error = %@",url,error);
        if (failure) {
            failure(error);
        }
    }];
    return task;
}

/**
 检查code

 @param code 服务器返回的错误码
 */
+ (void)yd_checkCode:(NSNumber *)code{
    //当前登录的用户已经失效
    if (code.integerValue == YDServerMessageTypeUserInvalid) {
        if (YDHadLogin) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController YD_OK_AlertController:[YDRootViewController sharedRootViewController] title:@"用户已失效\n或在其他设备上登录" clickBlock:^{
                    //移除用户信息
                    [[YDUserDefault defaultUser] removeUser];
                    UIViewController *currentVC = [UIViewController yd_getTheCurrentViewController];
                    //如果当前界面非登录界面
                    if (currentVC == nil || ![currentVC isKindOfClass:[YDLoginViewController class]]) {
                        if (![currentVC isKindOfClass:[YDLoginViewController class]]) {
                            [[YDRootViewController sharedRootViewController] presentViewController:[YDLoginViewController new] animated:YES completion:^{
                                [[YDRootViewController sharedRootViewController] releaseNavigationControllerAndShowViewControllerWithIndex:0];
                            }];
                        }
                    }
                }];
            });
        }
    }
}



+ (void)uploadJpushRegisterID:(NSDictionary *)dicPara{
    [YDNetworking getUrl:kBindJPushIDURL parameters:dicPara progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        YDLog(@"绑定JPushID: 失败 error = %@",error);
    }];
}

+ (void)uploadMessageData:(id )messageData
                 dataName:(NSString *)dataName
                      url:(NSString *)url
                  success:(void (^)(NSDictionary *data, NSString *dataUrl))success
                  failure:(void(^)(void))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:url parameters:@{@"access_token":YDAccess_token} constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSString *classStr = NSStringFromClass([messageData class]);
        if (messageData && [classStr isEqualToString:@"UIImage"]) {
            NSData *imageData = UIImageJPEGRepresentation(messageData, 0.5);
            
            NSString *str = [NSString stringWithFormat:@"%@",[YDUserDefault defaultUser].user.ub_id];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:dataName
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        }
        else if ([dataName isEqualToString:@"video"]){
            NSData *videoData = [NSData dataWithContentsOfFile:messageData options:NSMappedRead error:nil];
            NSString *str = [NSString stringWithFormat:@"%@",[YDUserDefault defaultUser].user.ub_id];
            NSString *fileName = [NSString stringWithFormat:@"%@.mp4",str];
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:videoData
                                        name:dataName
                                    fileName:fileName
                                    mimeType:@"video/quicktime"];
        }
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSDictionary *response = [responseObject mj_JSONObject];
        NSDictionary *data = [response objectForKey:@"data"];
        NSString *dataUrl = nil;
        if ([dataName isEqualToString:@"img"]) {
            dataUrl = [data objectForKey:@"recording"];
        }
        else if ([dataName isEqualToString:@"video"]){
            dataUrl = [data objectForKey:@"video"];
        }
        YDLog(@"response = %@",response);
        data ? success(data,dataUrl) : failure();
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        YDLog(@"上传消息数据失败,error = %@",error);
        failure();
    }];
    [task resume];
}

+ (void)uploadVideoData:(NSString *)videoPath
         thumbnailImage:(UIImage *)thumbnailImage
               dataName:(NSString *)dataName
                    url:(NSString *)url
                success:(void (^)(NSString *videoUrl, NSString *thumbnailImageUrl))success
                failure:(void(^)(void))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:url parameters:@{@"access_token":YDAccess_token} constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        if ([dataName isEqualToString:@"video"]){
            
            NSData *videoData = [NSData dataWithContentsOfFile:videoPath options:NSMappedRead error:nil];
            YDLog(@"videoData = %f M",videoData.length/1000.f/1000.f);
            YDLog(@"NSFileManager = %f M",[NSFileManager fileSizeWithFilePath:videoPath]);
            NSString *str = [NSString stringWithFormat:@"%@",YDUser_id];
            NSString *videoFileName = [NSString stringWithFormat:@"video%@.mp4",str];
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:videoData
                                        name:@"video"
                                    fileName:videoFileName
                                    mimeType:@"video/quicktime"];
            
            NSData *imageData = UIImageJPEGRepresentation(thumbnailImage, 0.5);
            YDLog(@"imageData = %f M",imageData.length/1000.f/1000.f);
            NSString *imageFileName = [NSString stringWithFormat:@"image%@.jpg", str];
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:@"image"
                                    fileName:imageFileName
                                    mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSDictionary *response = [responseObject mj_JSONObject];
        NSDictionary *data = [response objectForKey:@"data"];
        YDLog(@"response = %@",response);
        data ? success([data objectForKey:@"video"],[data objectForKey:@"image"]) : failure();
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        YDLog(@"上传消息数据失败,error = %@",error);
        failure();
    }];
    [task resume];
}

+ (void)uploadVoiceFile:(NSString *)localPath
               dataName:(NSString *)dataName
                    url:(NSString *)url
                success:(void (^)(NSString *dataUrl))success
                failure:(void(^)(void))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *para = @{@"access_token":YDAccess_token};
    [manager POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *voiceData = [NSData dataWithContentsOfFile:localPath options:NSMappedRead error:nil];
        NSString *str = [NSString stringWithFormat:@"%@",[YDUserDefault defaultUser].user.ub_id];
        NSString *fileName = [NSString stringWithFormat:@"%@.amr", str];
        [formData appendPartWithFileData:voiceData name:dataName fileName:fileName mimeType:@"application/octet-stream"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [responseObject mj_JSONObject];
        YDLog(@"voice dic = %@",dic);
        NSString *dataUrl = [[dic objectForKey:@"data"] objectForKey:@"recording"];
        if (dataUrl && dataUrl.length > 0) {
            success(dataUrl);
        }else{
            failure();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YDLog(@"上传消息数据失败,error = %@",error);
        failure();
    }];
    
}

+ (void)uploadImage:(UIImage *)image
                url:(NSString *)url
            success:(void (^)(NSString *imageUrl))success
            failure:(void(^)(void))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:url parameters:@{@"access_token":YDAccess_token} constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(image, 0.5);
        
        NSString *str = [NSString stringWithFormat:@"%@",[YDUserDefault defaultUser].user.ub_id];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"ud_face"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSDictionary *dic = [responseObject mj_JSONObject];
        YDLog(@"status = %@",[dic valueForKey:@"status"]);
        YDLog(@"status_code = %@",[dic valueForKey:@"status_code"]);
        if ([[dic valueForKey:@"status_code"] isEqual:@200]) {
            NSString *imageURL = [[dic objectForKey:@"data"] valueForKey:@"ud_face"];
            YDLog(@"imageURL = %@",imageURL);
            success(imageURL);
        }else{
            failure();
        }
        
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        YDLog(@"上传失败,error = %@",error);
        failure();
    }];
    [task resume];
}

//上传用户背景
+ (void)uploadUserBackgroudImage:(UIImage *)image url:(NSString *)url success:(void (^)(NSString *imageURL))success failure:(void(^)(void))failure{
    __weak YDUserDefault *weakUser = [YDUserDefault defaultUser];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:url parameters:@{@"access_token":YDAccess_token} constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(image, 0.5);
        
        NSString *str = [NSString stringWithFormat:@"%@",[YDUserDefault defaultUser].user.ub_id];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"ud_background"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSDictionary *dic = [responseObject mj_JSONObject];
        NSString *imageURL = [[dic objectForKey:@"data"] valueForKey:@"ud_background"];
        YDLog(@"imageURL = %@",imageURL);
        if (imageURL.length > 0) {
            YDUser *user = [YDUserDefault defaultUser].user;
            user.ud_background = imageURL;
            weakUser.user = user;
            success(imageURL);
        }
        else{
            failure();
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        failure();
        YDLog(@"上传失败,error = %@",error);
    }];
    [task resume];
}

//上传用户认证图片
+ (void)uploadUserTwoImage:(UIImage *)oneImage
                  twoImage:(UIImage *)twoImage
                       url:(NSString *)url
                   success:(void (^)(NSDictionary *response))sucess
                   failure:(void (^)(NSString *failMessage))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:url parameters:@{@"access_token":YDAccess_token} constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        //压缩一半
        NSData *oneImageData = UIImageJPEGRepresentation(oneImage, 0.7);
        NSData *twoImageData = UIImageJPEGRepresentation(twoImage, 0.7);
        
        NSString *str = [NSString stringWithFormat:@"%@",[YDUserDefault defaultUser].user.ub_id];
        NSString *oneFileName = [NSString stringWithFormat:@"%@/one/%@.jpg",YDTimeStamp([NSDate date]),str];
        NSString *twoFileName = [NSString stringWithFormat:@"%@/two/%@.jpg",YDTimeStamp([NSDate date]),str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:oneImageData
                                    name:@"ud_positive"
                                fileName:oneFileName
                                mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:twoImageData
                                    name:@"ud_negative"
                                fileName:twoFileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSDictionary *dic = [responseObject mj_JSONObject];
        if ([[dic valueForKey:@"status_code"] isEqual:@200]) {
            sucess([dic objectForKey:@"data"]);
        }else{
            failure([dic valueForKey:@"status"]);
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        YDLog(@"上传用户认证图片失败");
        failure(@"上传失败");
    }];
    [task resume];
}

//上传车辆认证图片
+ (void)uploadCarTwoImage:(UIImage *)oneImage twoImage:(UIImage *)twoImage url:(NSString *)url ug_id:(NSNumber *)ug_id success:(void (^)(void))sucess failure:(void (^)(NSString *failMessage))failure{
    [YDLoadingHUD showLoading];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    YDLog(@"autn_para = %@",@{@"access_token":YDAccess_token,@"ug_id":ug_id});
    NSURLSessionDataTask *task = [manager POST:url parameters:@{@"access_token":YDAccess_token,@"ug_id":ug_id} constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *oneImageData =UIImageJPEGRepresentation(oneImage, 0.5);
        NSData *twoImageData =UIImageJPEGRepresentation(twoImage, 0.5);
        
        NSString *str = [NSString stringWithFormat:@"%@_%@",[YDUserDefault defaultUser].user.ub_id,ug_id];
        NSString *oneFileName = [NSString stringWithFormat:@"%@/one/%@.jpg",YDTimeStamp([NSDate date]), str];
        NSString *twoFileName = [NSString stringWithFormat:@"%@/two/%@.jpg",YDTimeStamp([NSDate date]), str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:oneImageData
                                    name:@"ug_positive"
                                fileName:oneFileName
                                mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:twoImageData
                                    name:@"ug_negative"
                                fileName:twoFileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
       
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [YDLoadingHUD hide];
        NSDictionary *dic = [responseObject mj_JSONObject];
        YDLog(@"上传车辆认证response = %@",dic);
        YDLog(@"上传车辆认证图片status = %@",[dic valueForKey:@"status"]);
        YDLog(@"status_code = %@",[dic valueForKey:@"status_code"]);
        YDCarDetailModel *car = [[YDCarHelper sharedHelper] getOneCarWithCarid:ug_id];
        if ([[dic valueForKey:@"status_code"] isEqual:@200]) {
            NSDictionary *response = [dic objectForKey:@"data"];
            NSString *positive = [response valueForKey:@"positive"];
            NSString *negative = [response valueForKey:@"negative"];
            car.ug_vehicle_auth = @2;
            car.ug_positive = positive;
            car.ug_negative = negative;
            [[YDCarHelper sharedHelper] insertOneCar:car];
            sucess();
        }
        else{
            failure([dic valueForKey:@"status"]);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        [YDLoadingHUD hide];
        failure(@"上传失败");
        YDLog(@"上传车辆认证图片失败 error = %@",error);
    }];
    [task resume];
}

/**
 *  上传动态多张图片
 *
 *  @param imageArray 图片数组
 *  @param prefix     文件头
 *  @param url        url
 *  @param otherDic   其它数据（此处为上传图片成功后返回的图片网址，再次上传所需参数)
 */
+ (void)uploadImages:(NSMutableArray<UIImage *> *)imageArray prefix:(NSString *)prefix url:(NSString *)url otherData:(NSDictionary *)otherDic success:(void (^)(void))success failure:(void (^)(void))failure{
    __block NSMutableArray *images = [imageArray mutableCopy];
    __block NSMutableDictionary *parameterDic = [otherDic mutableCopy];
    
    //UIView *view = [[UIApplication sharedApplication] windows].lastObject;
    //MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    //[view addSubview:hud];
    //hud.mode = MBProgressHUDModeDeterminate;
    //[hud show:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    NSURLSessionDataTask *task = [manager POST:url parameters:@{@"access_token":YDAccess_token} constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        for (int i = 0; i < images.count;  i++) {
            UIImage *image = images[i];
            UIImage *fixiImage = [UIImage fixOrientation:image];
            NSData *ImageData =UIImageJPEGRepresentation(fixiImage, 0.5);
            
            NSString *prefixString = [NSString stringWithFormat:@"%@%d",prefix,i+1];
            
            NSString *str = YDTimeStamp([NSDate date]);
            NSString *fileName = [NSString stringWithFormat:@"%@/%@%@.jpg",YDTimeStamp([NSDate date]),prefixString,str];
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:ImageData
                                        name:prefixString
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //hud.progress = uploadProgress.fractionCompleted * 0.99f;
        });
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        
        NSDictionary *dic = [responseObject mj_JSONObject];
        
        NSString *imageString = [[dic objectForKey:@"data"] componentsJoinedByString:@","];
        if (imageString) {
            [parameterDic setObject:imageString forKey:@"d_image"];
            [YDNetworking POST:kAddDynamicURL parameters:parameterDic success:^(NSNumber *code, NSString *status, id data) {
                if ([code isEqual:@200]) {
                    success();
                }else{
                    failure();
                }
            } failure:^(NSError *error) {
                YDLog(@"上传动态失败,error = %@",error);
                if (error.code == -1001) {
                    [YDMBPTool showText:@"请求超时"];
                }
                failure();
            }];
        }else{
            failure();
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        YDLog(@"上传动态图片失败,error = %@",error);
        if (error.code == -1001) {
            [YDMBPTool showText:@"请求超时"];
        }
        failure();
    }];
    [task resume];
}

+ (void)downloadVoiceFileWithURL:(NSString *)url
                         success:(void (^)(NSString *filePath))success
                         failure:(void (^)(void))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:YDURL(url)];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fileName = [NSString stringWithFormat:@"%.0lf.amr", [NSDate date].timeIntervalSince1970 * 1000];
        NSString *path = [NSFileManager pathUserChatVoice:fileName];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failure();
        }else{
            success([filePath.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""]);
        }
    }];
    [task resume];
}

@end

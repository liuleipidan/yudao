//
//  YDShareManager.m
//  YuDao
//
//  Created by 汪杰 on 2017/5/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDShareManager.h"

#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#define kShareSDKKey  @"15e4b88fc0e9a"
#define kWeiboAppKey  @"2548781475"
#define kWeiboSecret  @"15f4b3d1d7ca05c8b78e66dfb5e65868"
#define kWeChatAppId  @"wx0e255252ca6a45b9"
#define kWeChatSecret @"52d5ffc0761af496404be59fb3696fb8"
#define kQQAppId      @"1106014109"
#define kQQAppKey     @"2HN7Ft5gywdAAbZg"

@implementation YDShareManager
+ (void)registerShareSDK{
    [ShareSDK registerApp:kShareSDKKey
          activePlatforms:@[   @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType) {
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType) {
                  case SSDKPlatformTypeSinaWeibo:
                      [appInfo SSDKSetupSinaWeiboByAppKey:kWeiboAppKey
                                                appSecret:kWeiboSecret
                                              redirectUri:@"https://itunes.apple.com/cn/app/hun-lian-dui-xiang/id1197257950?mt=8"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:kWeChatAppId
                                            appSecret:kWeChatSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:kQQAppId
                                           appKey:kQQAppKey
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
}

+ (BOOL)isInstalledPlatformType:(YDThirdPlatformType)type{
    NSString *urlStr = nil;
    switch (type) {
        case YDThirdPlatformTypeWechat: urlStr = @"weixin://"; break;
        case YDThirdPlatformTypeQQ:    urlStr = @"mqqapi://"; break;
        case YDThirdPlatformTypeWeibo:  urlStr = @"sinaweibo://"; break;
        default: urlStr = @""; break;
    }
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]];
}

+ (BOOL)isNotDeviceInstalledPlatformType:(SSDKPlatformType )type{
    BOOL showAlert = NO;
    NSString *alertStr = nil;
    YDThirdPlatformType needCheckType = 1000;
    switch (type) {
        case SSDKPlatformSubTypeWechatSession:
        case SSDKPlatformSubTypeWechatTimeline:
        case SSDKPlatformTypeWechat:
        {
            needCheckType = YDThirdPlatformTypeWechat;
            alertStr = @"设备未安装微信";
            break;}
        case SSDKPlatformSubTypeQQFriend:
        case SSDKPlatformSubTypeQZone:
        case SSDKPlatformTypeQQ:
        {
            needCheckType = YDThirdPlatformTypeQQ;
            alertStr = @"设备未安装QQ";
            break;}
        case SSDKPlatformTypeSinaWeibo:
        {
            needCheckType = YDThirdPlatformTypeWeibo;
            alertStr = @"设备未安装新浪微博";
            break;}
        default:
            break;
    }
    showAlert = ![YDShareManager isInstalledPlatformType:needCheckType];
    if (showAlert && alertStr) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:alertStr preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            
            
        }];
        [alertController addAction:okAction];
        [[UIViewController yd_getTheCurrentViewController] presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
    return showAlert;
}

+ (void)thirdPlatformLoginBy:(SSDKPlatformType)platformType
                     success:(void (^)(SSDKUser *user, id data))success
                     failure:(void (^)(void))failure{
    [YDMBPTool showText:@"跳转中..."];
    
    [SSEThirdPartyLoginHelper loginByPlatform:platformType onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
        if (user.uid && user.uid.length > 0) {
            [YDLoadingHUD showLoading];
            NSNumber *source = nil;
            if (platformType == SSDKPlatformTypeWechat) {
                source = @1;
            }else if (platformType == SSDKPlatformTypeQQ){
                source = @2;
            }else if (platformType == SSDKPlatformTypeSinaWeibo){
                source = @3;
            }else{
                source = @0;
            }
            NSDictionary *param = @{@"esmark":YDNoNilString(user.uid),
                                    @"source":source};
            YDLog(@"param = %@",param);
            [YDNetworking POST:kHadBindThirdPlatformURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
                if ([code isEqual:@200]) {
                    success(user,data);
                }else{
                    failure();
                }
            } failure:^(NSError *error) {
                failure();
            }];
        }
    } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
        
        if (state == SSDKResponseStateFail) {
            [YDMBPTool showInfoImageWithMessage:@"获取第三方信息失败" hideBlock:^{
                
            }];
        }
        else if (state == SSDKResponseStateCancel){
            failure();
        }
    }];
}

+ (void)shareToPlatform:(YDClickSharePlatformType )platformType
                  title:(NSString *)title
                content:(NSString *)content
                    url:(NSString *)url
             thumbImage:(id)thumbImage
                  image:(id)image
           musicFileURL:(NSURL *)musicFileURL
                extInfo:(NSString *)extInfo
               fileData:(id)fileData
           emoticonData:(id)emoticonData
               latitude:(double)latitude
              longitude:(double)longitude
               objectID:(NSString *)objectID{
    switch (platformType) {
        case YDClickSharePlatformTypeWechat://微信好友
        {
            [YDShareManager shareWeChatParamsByText:content title:title url:[NSURL URLWithString:url] thumbImage:thumbImage image:image musicFileURL:musicFileURL extInfo:extInfo fileData:fileData emoticonData:emoticonData type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            break;}
        case YDClickSharePlatformTypeWechatFriend://朋友圈
        {
            [YDShareManager shareWeChatParamsByText:content title:title url:[NSURL URLWithString:url] thumbImage:thumbImage image:image musicFileURL:musicFileURL extInfo:extInfo fileData:fileData emoticonData:emoticonData type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            break;}
        case YDClickSharePlatformTypeQQFriend://QQ好友
        {
            [YDShareManager shareQQShareParamsByText:content title:title url:[NSURL URLWithString:url] thumbImage:thumbImage image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
            break;}
        case YDClickSharePlatformTypeQQZone://QQ空间
        {
            [YDShareManager shareQQShareParamsByText:content title:title url:[NSURL URLWithString:url] thumbImage:thumbImage image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
            break;}
        case YDClickSharePlatformTypeWeibo://新浪微博
        {
            [YDShareManager shareSinaWeiboShareParamsbyText:content title:title image:image url:[NSURL URLWithString:url] latitude:latitude longitude:longitude objectID:objectID type:SSDKContentTypeAuto];
            break;}
        default:
            break;
    }
}

+ (void)shareWeChatParamsByText:(NSString *)text
                          title:(NSString *)title
                            url:(NSURL *)url
                     thumbImage:(id)thumbImage
                          image:(id)image
                   musicFileURL:(NSURL *)musicFileURL
                        extInfo:(NSString *)extInfo
                       fileData:(id)fileData
                   emoticonData:(id)emoticonData
                           type:(SSDKContentType)type
             forPlatformSubType:(SSDKPlatformType)platformSubType{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeChatParamsByText:text
                                   title:title
                                     url:url
                               thumbImage:thumbImage
                                   image:image
                             musicFileURL:musicFileURL
                                 extInfo:extInfo
                                fileData:fileData
                             emoticonData:emoticonData
                                    type:type
                      forPlatformSubType:platformSubType];
    [shareParams SSDKEnableUseClientShare];
    [YDShareManager showShareEditorBy:platformSubType shareParams:shareParams];
    
}

+ (void)shareSinaWeiboShareParamsbyText:(NSString *)text
                                  title:(NSString *)title
                                  image:(id)image
                                    url:(NSURL *)url
                               latitude:(double)latitude
                              longitude:(double)longitude
                               objectID:(NSString *)objectID
                                   type:(SSDKContentType)type{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    Class imageClass = [image class];
    id newImage = nil;
    if ([imageClass isSubclassOfClass:[UIImage class]] || [imageClass isSubclassOfClass:[NSString class]]){
        newImage = image;
    }
    else if ([imageClass isSubclassOfClass:[NSArray class]] || [imageClass isSubclassOfClass:[NSMutableArray class]]){
        if ([(NSArray*)image count] > 0) {
            newImage = [(NSArray*)image firstObject];
        }else{
            newImage = YDImage(@"YuDaoLogo");
        }
    }
    else{
        newImage = YDImage(@"YuDaoLogo");
    }
    text = [text stringByAppendingString:url.absoluteString];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:text
                                               title:title
                                               image:newImage
                                                 url:url
                                            latitude:latitude
                                           longitude:longitude
                                            objectID:objectID
                                                type:type];
    [shareParams SSDKEnableUseClientShare];
    [YDShareManager showShareEditorBy:SSDKPlatformTypeSinaWeibo shareParams:shareParams];
}

+ (void)shareQQShareParamsByText:(NSString *)text
                           title:(NSString *)title
                             url:(NSURL *)url
                      thumbImage:(id)thumbImage
                           image:(id)image
                            type:(SSDKContentType)type
              forPlatformSubType:(SSDKPlatformType)platformSubType{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupQQParamsByText:text
                                   title:title
                                     url:url
                              thumbImage:thumbImage
                                   image:image
                                    type:type
                      forPlatformSubType:platformSubType];
    [shareParams SSDKEnableUseClientShare];
    [YDShareManager showShareEditorBy:platformSubType shareParams:shareParams];
}

#pragma mark Private Methods
/**
 弹出分享视图

 @param type 分享到平台
 @param shareParams 分享参数
 */
+ (void)showShareEditorBy:(SSDKPlatformType )type
              shareParams:(NSMutableDictionary *)shareParams{
    NSString *title = nil;
    switch (type) {
        case SSDKPlatformTypeSinaWeibo:
            title = @"新浪微博";
            break;
        case SSDKPlatformSubTypeQQFriend:
            title = @"QQ好友";
            break;
        case SSDKPlatformSubTypeQZone:
            title = @"QQ空间";
            break;
        case SSDKPlatformSubTypeWechatSession:
            title = @"微信好友";
            break;
        case SSDKPlatformSubTypeWechatTimeline:
            title = @"朋友圈";
            break;
        default:
            title = @"分享内容";
            break;
    }
    [SSUIEditorViewStyle setTitle:title];
    [SSUIEditorViewStyle setTitleColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setCancelButtonLabelColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setShareButtonLabelColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:[UIColor colorWithString:@"#F2B3552"]];
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        YDLog(@"userData = %@",userData);
        YDLog(@"contentEntity: cid = %@ text = %@",contentEntity.cid,contentEntity.text);
        YDLog(@"error = %@",error);
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [YDNotificationCenter postNotificationName:kActivitySharedSuccessfulNotification object:nil];
                [YDMBPTool showSuccessImageWithMessage:@"分享成功" hideBlock:^{
                    
                }];
                break;}
            case SSDKResponseStateFail:
            {
                [YDMBPTool showSuccessImageWithMessage:@"分享失败" hideBlock:^{
                    
                }];
                break;
            }
            default:
                break;
        }
    }];
//    [ShareSDK showShareEditor:type
//           otherPlatformTypes:nil
//                  shareParams:shareParams
//          onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//              YDLog(@"userData = %@",userData);
//              YDLog(@"contentEntity: cid = %@ text = %@",contentEntity.cid,contentEntity.text);
//              YDLog(@"error = %@",error);
//              switch (state) {
//                  case SSDKResponseStateSuccess:
//                  {
//                      [YDMBPTool showSuccessImageWithMessage:@"分享成功" hideBlock:^{
//                          
//                      }];
//                      break;}
//                  case SSDKResponseStateFail:
//                  {
//                      [YDMBPTool showSuccessImageWithMessage:@"分享失败" hideBlock:^{
//                          
//                      }];
//                      break;
//                  }
//                  default:
//                      break;
//              }
//          }];
}


@end

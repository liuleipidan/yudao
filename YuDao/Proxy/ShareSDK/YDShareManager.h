//
//  YDShareManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/5/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

typedef NS_ENUM(NSInteger, YDThirdPlatformType) {
    YDThirdPlatformTypeWechat,
    YDThirdPlatformTypeQQ,
    YDThirdPlatformTypeWeibo,
};

@interface YDShareManager : NSObject


/**
  注册ShareSDK
 */
+ (void)registerShareSDK;

/**
 监测设备是否安装对应的第三方应用

 @param type 第三方应用类型
 @return YES->安装了，NO->没安装
 */
+ (BOOL)isInstalledPlatformType:(YDThirdPlatformType)type;

#pragma mark - 第三方登录
+ (void)thirdPlatformLoginBy:(SSDKPlatformType)platformType
                     success:(void (^)(SSDKUser *user, id data))success
                     failure:(void (^)(void))failure;

#pragma mark - 第三方分享
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
               objectID:(NSString *)objectID;
/**
 设置微信分享参数

 @param text         文本
 @param title        标题
 @param url          分享链接
 @param thumbImage   缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 @param image        图片，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 @param musicFileURL 音乐文件链接地址
 @param extInfo      扩展信息
 @param fileData     文件数据，可以为NSData、UIImage、NSString、NSURL（文件路径）、SSDKData、SSDKImage
 @param emoticonData 表情数据，可以为NSData、UIImage、NSURL（文件路径）、SSDKData、SSDKImage
 @param type         分享类型，支持SSDKContentTypeText、SSDKContentTypeImage、SSDKContentTypeWebPage、SSDKContentTypeApp、SSDKContentTypeAudio和SSDKContentTypeVideo
 @param platformSubType 平台子类型，只能传入SSDKPlatformSubTypeWechatSession、SSDKPlatformSubTypeWechatTimeline和SSDKPlatformSubTypeWechatFav其中一个
 */
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
             forPlatformSubType:(SSDKPlatformType)platformSubType;

/**
 设置新浪微博分享参数

 @param text 文本
 @param title 标题
 @param image 图片对象，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 @param url 分享链接
 @param latitude 纬度
 @param longitude 经度
 @param objectID 对象ID，表示系统内内容唯一性，应传入系统内分享内容的唯一标识，没有可以传nil
 @param type 分享类型，仅支持Text、Image、WebPage（客户端分享时）类型
 */
+ (void)shareSinaWeiboShareParamsbyText:(NSString *)text
                                  title:(NSString *)title
                                  image:(id)image
                                    url:(NSURL *)url
                               latitude:(double)latitude
                              longitude:(double)longitude
                               objectID:(NSString *)objectID
                                   type:(SSDKContentType)type;

/**
 设置QQ分享参数

 @param text 分享内容
 @param title 分享标题
 @param url 分享链接
 @param thumbImage 缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 @param image 图片，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 @param type 分享类型, 仅支持Text（仅QQFriend）、Image（仅QQFriend）、WebPage、Audio、Video类型
 @param platformSubType 平台子类型，只能传入SSDKPlatformSubTypeQZone或者SSDKPlatformSubTypeQQFriend其中一个
 */
+ (void)shareQQShareParamsByText:(NSString *)text
                           title:(NSString *)title
                             url:(NSURL *)url
                      thumbImage:(id)thumbImage
                           image:(id)image
                            type:(SSDKContentType)type
              forPlatformSubType:(SSDKPlatformType)platformSubType;
@end

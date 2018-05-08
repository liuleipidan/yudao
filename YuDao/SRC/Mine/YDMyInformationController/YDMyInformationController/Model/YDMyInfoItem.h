//
//  YDMyInfoItem.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/18.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YDCreateMyInfoItem(title) [YDMyInfoItem createItemWithTitle:title]

/**
 我的资料Item的类型
 */
typedef NS_ENUM(NSInteger, YDMyInfoItemType) {
    YDMyInfoItemTypeDefault = 0, //默认，subTitle+箭头
    YDMyInfoItemTypeAvatar,      //头像，avatar+箭头
    YDMyInfoItemTypeInput,       //输入框，textField
    YDMyInfoItemTypeOther,       //其他
};

@interface YDMyInfoItem : NSObject

//主标题
@property (nonatomic, copy  ) NSString *title;

//副标题
@property (nonatomic, copy  ) NSString *subTitle;

//暂存需要保存的内容
@property (nonatomic, copy  ) NSString *tempSubTitle;

//占位符，用于Cell是输入框时使用
@property (nonatomic, copy  ) NSString *placeholder;

//输入框限制长度
@property (nonatomic, assign) NSUInteger limit;

//右图片（本地路径）
@property (nonatomic, copy  ) NSString *avatarPath;

//右图片（网络）
@property (nonatomic, copy  ) NSString *avatarURL;

//右图片（拍照或相册里的图片）
@property (nonatomic, strong) UIImage *avatarImage;

//是否显示箭头，默认YES
@property (nonatomic, assign) BOOL showDisclosureIndicator;

//停用高亮，默认NO
@property (nonatomic, assign) BOOL disableHighlight;

//停用副标题可编辑，这里是基于副标题是输入框内容时，默认是NO
@property (nonatomic, assign) BOOL disableSubTitle;

//item的类型，用于限定cell的UI
@property (nonatomic, assign) YDMyInfoItemType type;

/**
 根据类型取相应的cell的类名
 */
- (NSString *)cellClassName;

+ (YDMyInfoItem *)createItemWithTitle:(NSString *)title;


@end

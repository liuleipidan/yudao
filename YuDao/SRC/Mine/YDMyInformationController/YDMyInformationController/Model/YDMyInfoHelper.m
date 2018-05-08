//
//  YDMyInfoHelper.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMyInfoHelper.h"

@interface YDMyInfoHelper()

@property (nonatomic, strong) YDMyInfoItem *avatar;

@property (nonatomic, strong) YDMyInfoItem *nickName;

@property (nonatomic, strong) YDMyInfoItem *realName;

@property (nonatomic, strong) YDMyInfoItem *age;

@property (nonatomic, strong) YDMyInfoItem *sex;

@property (nonatomic, strong) YDMyInfoItem *emotion;

@property (nonatomic, strong) YDMyInfoItem *place;

@property (nonatomic, strong) YDMyInfoItem *interests;

@end

@implementation YDMyInfoHelper

- (instancetype)init{
    if (self = [super init]) {
        _data = [self myInformationDataByUserInfo:[YDUserDefault defaultUser].user];
        _tempUserInfo = [[YDUserDefault defaultUser].user getTempUserData];
    }
    return self;
}

- (NSArray *)myInformationDataByUserInfo:(YDUser *)user{
    _avatar = YDCreateMyInfoItem(@"头像");
    _avatar.type = YDMyInfoItemTypeAvatar;
    
    _nickName = YDCreateMyInfoItem(@"昵称");
    _nickName.type = YDMyInfoItemTypeInput;
    
    _realName = YDCreateMyInfoItem(@"真实姓名");
    _realName.type = YDMyInfoItemTypeInput;
    
    _age = YDCreateMyInfoItem(@"年龄");
    _age.showDisclosureIndicator = !([user.ud_userauth isEqual:@1] || [user.ud_userauth isEqual:@2]);
    
    _sex = YDCreateMyInfoItem(@"性别");
    _sex.showDisclosureIndicator = !([user.ud_userauth isEqual:@1] || [user.ud_userauth isEqual:@2]);
    
    _emotion = YDCreateMyInfoItem(@"情感状态");
    
    _place = YDCreateMyInfoItem(@"常出没地点");
    
    _interests = YDCreateMyInfoItem(@"感兴趣的事");
    
    [self reloadUserInfo:user avatar:nil];
    
    _data = @[_avatar,_nickName,_realName,_age,_sex,_emotion,_place,_interests];
    
    return _data;
}

- (void)reloadUserInfo:(YDUser *)user avatar:(UIImage *)avatarImage{
    _avatar.avatarURL = user.ud_face;
    _avatar.avatarImage = avatarImage;
    
    _nickName.subTitle = user.ub_nickname.length > 0 ? user.ub_nickname : @"";
    _nickName.placeholder = @"请输入昵称";
    _nickName.limit = 16;
    
    _realName.subTitle = user.ud_realname.length > 0 ? user.ud_realname : @"";
    _realName.placeholder = @"请输入真实姓名";
    _realName.limit = 8;
    
    _age.subTitle = [NSString stringWithFormat:@"%@",user.ud_age.integerValue == 0 ? @"未设置" : user.ud_age];
    
    _sex.subTitle = user.ud_sex.integerValue == 1 ? @"男" : @"女";
    
    _emotion.subTitle = user.emotionString;
    
    _place.subTitle = user.oftenPlace;
    
    //_interests.subTitle = user.ud_tag_name.length > 0 ? [user.ud_tag_name stringByReplacingOccurrencesOfString:@"," withString:@"、"] : @"";
    _interests.subTitle = user.ud_tag_name.length > 0 ? user.ud_tag_name : @"";
}

@end

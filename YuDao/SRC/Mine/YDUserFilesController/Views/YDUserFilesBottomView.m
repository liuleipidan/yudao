//
//  YDUserFilesBottomView.m
//  YuDao
//
//  Created by 汪杰 on 17/1/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDUserFilesBottomView.h"

@implementation YDUserFilesBottomView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor whiteColor];
        [self sd_addSubviews:@[self.leftBtn,self.rightBtn]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self sd_addSubviews:@[self.leftBtn,self.rightBtn]];
    }
    return self;
}

- (void)showInView:(UIView *)view
          userInfo:(YDUserInfoModel *)userInfo{
    NSNumber *currentUid = [YDUserDefault defaultUser].user.ub_id;
    if (currentUid && [currentUid isEqual:userInfo.ub_id]) {
        return;
    }
    //是好友
    if (userInfo.uFriend && [userInfo.uFriend isEqual:@2]) {
        [YDDBSendFriendRequestStore deleteSenderFriendRequestSenderID:currentUid receiverID:userInfo.ub_id];
        [self.rightBtn setTitle:@"发消息" forState:0];
    }
    else{//不是好友
        //已经申请过添加好友
        BOOL exsit = [YDDBSendFriendRequestStore checkSenderFriendRequsetExistOrNeedDeleteBySenderID:currentUid receiverID:userInfo.ub_id];
        if (exsit) {
            [self.rightBtn setTitle:@"已申请" forState:0];
        }else{
            [self.rightBtn setTitle:@"加好友" forState:0];
        }
    }
    //已喜欢
    if (userInfo.ud_enjoy && [userInfo.ud_enjoy isEqual:@1]) {
        self.leftBtn.selected = YES;
    }else{//未喜欢
        self.leftBtn.selected = NO;
    }
    [view addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)updateViewWithCurrentUserID:(NSNumber *)userid
                           friendID:(NSNumber *)fid
                              enjoy:(NSNumber *)enjoy
                       friendStatus:(NSNumber *)fStatus{
    //点击的是当前用户
    if (userid && [userid isEqual:fid]) {
        [self removeFromSuperview];
        return;
    }
    //是好友
    if (fStatus && [fStatus isEqual:@2]) {
        [YDDBSendFriendRequestStore deleteSenderFriendRequestSenderID:userid receiverID:fid];
        [self.rightBtn setTitle:@"发消息" forState:0];
    }
    else{//不是好友
        //已经申请过添加好友
        BOOL exsit = [YDDBSendFriendRequestStore checkSenderFriendRequsetExistOrNeedDeleteBySenderID:userid receiverID:fid];
        if (exsit) {
            [self.rightBtn setTitle:@"已申请" forState:0];
        }else{
            [self.rightBtn setTitle:@"加好友" forState:0];
        }
    }
    //已喜欢
    if (enjoy && [enjoy isEqual:@1]) {
        self.leftBtn.selected = YES;
    }else{//未喜欢
        self.leftBtn.selected = NO;
    }
}

- (void)userFilesBottomViewAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userFilesBottomView:didSelectedButton:)]) {
        [self.delegate userFilesBottomView:self didSelectedButton:sender];
    }
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [YDUIKit buttonWithTitle:@"喜欢" image:[UIImage imageNamed:@"dynamic_likeButton_normal"] selectedImage:[UIImage imageNamed:@"dynamic_likeButton_selected"]  target:self];
        [_leftBtn setTitle:@"已喜欢" forState:UIControlStateSelected];
        _leftBtn.backgroundColor = [UIColor whiteColor];
        [_leftBtn setTitleColor:YDBaseColor forState:0];
        [_leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        _leftBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.382, self.frame.size.height);
       [_leftBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [_leftBtn addTarget:self action:@selector(userFilesBottomViewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [YDUIKit buttonWithTitle:@"加好友" image:[UIImage imageNamed:@"mine_contacts_addfriend"]  target:self];
        _rightBtn.backgroundColor = YDBaseColor;
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH*0.382, 0, SCREEN_WIDTH*0.618, self.frame.size.height);
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_rightBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [_rightBtn addTarget:self action:@selector(userFilesBottomViewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end

//
//  YDMineViewController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMineViewController+Delegate.h"
#import "YDQRCodeController.h"
#import "YDLikePeopleController.h"
#import "YDIntegralController.h"

@implementation YDMineViewController (Delegate)

#pragma mark - YDMineHeaderBlurViewDelegate
//点击头像
- (void)mineHeaderBlurView:(YDMineHeaderBlurView *)view clickedUserAvatar:(UIImageView *)imageView{
    [self.avatarBrowser showByImageView:imageView inView:[YDRootViewController sharedRootViewController].view];
}
//点击背景图片
- (void)mineHeaderBlurView:(YDMineHeaderBlurView *)view clickedBackgroundImageView:(UIImageView *)imageView{
    [UIAlertController YD_alertController:self title:@"修改背景图片" subTitle:nil items:@[@"拍照",@"从手机相册选择"] style:UIAlertControllerStyleActionSheet clickBlock:^(NSInteger index) {
        if (index == 1) {
            
            [self.imagePickerTool showCameraFinishPickingBlock:^(UIImage *image, NSURL *url) {
                [self uploadUserBackgroundImage:image];
            }];
        }
        else if (index == 2){
            
            [self.imagePickerTool showPhotoLibraryFinishPickingBlock:^(UIImage *image, NSURL *url) {
                [self uploadUserBackgroundImage:image];
            }];
        }
    }];
}

//点击二维码
- (void)mineHeaderBlurView:(YDMineHeaderBlurView *)view clickedErCode:(UIImageView *)imageView{
    [self.navigationController pushViewController:[YDQRCodeController new] animated:YES];
}
//点击喜欢的人
- (void)mineHeaderBlurViewClickedLikeLabel:(YDMineHeaderBlurView *)view{
    [self.navigationController pushViewController:[YDLikePeopleController new] animated:YES];
}
//点击积分
- (void)mineHeaderBlurViewClickedScoreLabel:(YDMineHeaderBlurView *)view{
    YDIntegralController *integralVC = [YDIntegralController new];
    [self.navigationController pushViewController:integralVC animated:YES];
}

#pragma mark - YDAvatarBrowserDelegate
- (void)avatarBrowser:(YDAvatarBrowser *)browser didClickedBottomButton:(UIButton *)button{
    
    [UIAlertController YD_alertController:[YDRootViewController sharedRootViewController] title:nil subTitle:nil items:@[@"拍照",@"从手机相册选择"] style:UIAlertControllerStyleActionSheet clickBlock:^(NSInteger index) {
        if (index == 1) {
            [self.avatarBrowser dismiss];
            [self.imagePickerTool showCameraFinishPickingBlock:^(UIImage *image, NSURL *url) {
                [self uploadUserAvatarByImage:image];
            }];
        }
        else if (index == 2){
            [self.avatarBrowser dismiss];
            [self.imagePickerTool showPhotoLibraryFinishPickingBlock:^(UIImage *image, NSURL *url) {
                [self uploadUserAvatarByImage:image];
            }];
        }
    }];
}

- (void)uploadUserAvatarByImage:(UIImage *)image{
    
    [YDNetworking uploadImage:image url:kUploadUserHeaderImageURL success:^(NSString *imageUrl) {
        YDUser *user = [YDUserDefault defaultUser].user;
        user.ud_face = YDNoNilString(imageUrl);
        [YDUserDefault defaultUser].user = user;
        [self.headerView.avatarImageView yd_setImageFadeinWithString:imageUrl];
    } failure:^{
        [YDMBPTool showText:@"修改头像失败"];
    }];
}

- (void)uploadUserBackgroundImage:(UIImage *)image{
    [YDNetworking uploadUserBackgroudImage:image url:kChangeUserBackgroudImageURL success:^(NSString *imageURL){
        [self.headerView.bgImageView yd_setImageFadeinWithString:imageURL];
    } failure:^{
        [YDMBPTool showText:@"修改背景失败"];
    }];
}

@end

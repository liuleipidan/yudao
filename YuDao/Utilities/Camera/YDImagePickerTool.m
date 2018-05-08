//
//  YDImagePickerTool.m
//  YuDao
//
//  Created by 汪杰 on 2017/5/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//


#import "YDImagePickerTool.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>

@interface YDImagePickerTool()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIViewController *presentingeVC;

@property (nonatomic, strong) UIImagePickerController *ipVC;

@property (nonatomic,copy) void (^didFinishPickingBlock) (UIImage *image, NSURL *url);

@end

@implementation YDImagePickerTool

- (instancetype)initWithPresentingViewController:(UIViewController *)presentingVC{
    
    if(self = [super init]){
        _allowEdit = YES;
        _presentingeVC = presentingVC;
        [self initImagePickerController];
    }
    return self;
    
}

- (void)dealloc{
    NSLog(@"dealloc");
}

#pragma mark Private Methods
- (void)initImagePickerController{
    _ipVC = [[UIImagePickerController alloc] init];
    [_ipVC setAllowsEditing:_allowEdit];// 设置是否可以管理已经存在的图片或者视频
    [_ipVC setDelegate:self];// 设置代理
    
}

- (void)showActionSheetWithTitle:(NSString *)title didFinishPickingBlock:(void (^)(UIImage *image, NSURL *url))didFinishPickingImage{
    _didFinishPickingBlock = didFinishPickingImage;
    [_ipVC setAllowsEditing:_allowEdit];
    [LPActionSheet showActionSheetWithTitle:title cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册中选择"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {
            [_ipVC setSourceType:UIImagePickerControllerSourceTypeCamera];// 设置类型
            // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
            _ipVC.mediaTypes = @[(NSString *)kUTTypeImage];
            [_presentingeVC presentViewController:_ipVC animated:YES completion:nil];
            if (![YDPrivilegeManager checkCameraPrivilege]) {
                [UIAlertController YD_OK_AlertController:_ipVC title:@"请在iPhone的\"设置-隐私-相机\"选项中，允许遇道访问你的相机" clickBlock:^{
                    [_ipVC dismissViewControllerAnimated:YES completion:nil];
                }];
            }
        }
        else if (index == 2){
            if ([YDPrivilegeManager checkPhotoLibraryPrivilege]) {
                [_ipVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [_presentingeVC presentViewController:_ipVC animated:YES completion:nil];
            }else{
                [UIAlertController YD_OK_AlertController:_presentingeVC title:@"请在iPhone的\"设置-隐私-相机\"选项中，允许遇道访问你的手机相册" clickBlock:^{
                    //[_ipVC dismissViewControllerAnimated:YES completion:nil];
                }];
            }
        }
    }];
}

- (void)showActionSheet:(void (^)(UIImage *image, NSURL *url))didFinishPickingImage{
    [self showActionSheetWithTitle:nil didFinishPickingBlock:didFinishPickingImage];
}

- (void)showCameraFinishPickingBlock:(void (^)(UIImage *image, NSURL *url))didFinishPickingImage{
    _didFinishPickingBlock = didFinishPickingImage;
    [_ipVC setSourceType:UIImagePickerControllerSourceTypeCamera];// 设置类型
    // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
    _ipVC.mediaTypes = @[(NSString *)kUTTypeImage];
    [_presentingeVC presentViewController:_ipVC animated:YES completion:nil];
    if (![YDPrivilegeManager checkCameraPrivilege]) {
        [UIAlertController YD_OK_AlertController:_ipVC title:@"请在iPhone的\"设置-隐私-相机\"选项中，允许遇道访问你的相机" clickBlock:^{
            [_ipVC dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)showPhotoLibraryFinishPickingBlock:(void (^)(UIImage *image, NSURL *url))didFinishPickingImage{
    _didFinishPickingBlock = didFinishPickingImage;
    if ([YDPrivilegeManager checkPhotoLibraryPrivilege]) {
        [_ipVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [_presentingeVC presentViewController:_ipVC animated:YES completion:nil];
    }else{
        [UIAlertController YD_OK_AlertController:_presentingeVC title:@"请在iPhone的\"设置-隐私-相机\"选项中，允许遇道访问你的手机相册" clickBlock:^{
            //[_ipVC dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

#pragma mark  - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = nil;
    if (_allowEdit) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//如果是拍照则保存到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    if (_didFinishPickingBlock) {
        _didFinishPickingBlock(image,url);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }
    else{
        msg = @"保存图片成功" ;
    }
    YDLog(@"%@",msg);
}


@end

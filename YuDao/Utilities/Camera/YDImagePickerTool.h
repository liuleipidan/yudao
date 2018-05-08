//
//  YDImagePickerTool.h
//  YuDao
//
//  Created by 汪杰 on 2017/5/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDImagePickerTool : NSObject

- (instancetype)initWithPresentingViewController:(UIViewController *)presentingVC;

- (void)showActionSheet:(void (^)(UIImage *image, NSURL *url))didFinishPickingImage;

- (void)showActionSheetWithTitle:(NSString *)title didFinishPickingBlock:(void (^)(UIImage *image, NSURL *url))didFinishPickingImage;

- (void)showCameraFinishPickingBlock:(void (^)(UIImage *image, NSURL *url))didFinishPickingImage;

- (void)showPhotoLibraryFinishPickingBlock:(void (^)(UIImage *image, NSURL *url))didFinishPickingImage;

/**
 是否可编辑，默认YES
 */
@property (nonatomic, assign) BOOL allowEdit;

@end

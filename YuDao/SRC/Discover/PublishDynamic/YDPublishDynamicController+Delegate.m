//
//  YDPublishDynamicController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPublishDynamicController+Delegate.h"
#import "WWVideoPlayerViewController.h"
#import "YDDynamicLabelController.h"
#import "YDSelectLocationController.h"

//视频文件最大10M
#define kVideoFileSizeMax 10.0

@implementation YDPublishDynamicController (Delegate)

#pragma mark - Private Methods
- (BOOL)pd_checkVideoFileSizeByPath:(NSString *)outputPath{
    CGFloat   fileSize = ([[NSFileManager defaultManager] attributesOfItemAtPath:outputPath error:nil].fileSize) / 1000.0 / 1000.0;
    if (fileSize > kVideoFileSizeMax) {
        return NO;
    }
    return YES;
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    NSLog(@"%s",__func__);
}
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    NSLog(@"%s",__func__);
}

// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset{
    [YDLoadingHUD showLoading];
    if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
        YDWeakSelf(self);
        [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
            [YDLoadingHUD hide];
            if ([weakself pd_checkVideoFileSizeByPath:outputPath]) {
                weakself.model.videoLocalURL = YDURL(outputPath);
                weakself.model.images = [NSMutableArray arrayWithObject:coverImage ? : [UIImage imageWithColor:[UIColor lightGrayColor]]];
                
                [weakself.tableView reloadData];
            }
            else{
                [YDMBPTool showInfoImageWithMessage:@"视频文件过大" hideBlock:nil];
            }
        }];
    }
}

// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset{
    NSLog(@"%s",__func__);
}

#pragma mark - YDCameraViewControllerDelegate
//拍摄照片
- (void)cameraViewController:(YDCameraViewController *)controller didTakeImage:(UIImage *)image{
    UIImage *messageImage = [UIImage fixOrientation:image];
    [self nd_saveImage:messageImage];
}
//拍摄视频
- (void)cameraViewController:(YDCameraViewController *)controller didTakeVideo:(NSURL *)videoURL{
   
    UIImage *thumbnailImage = [UIImage getThumbnailImage:videoURL];
    self.model.videoLocalURL = videoURL;
    self.model.images = [NSMutableArray arrayWithObject:thumbnailImage ? : [UIImage imageWithColor:[UIColor lightGrayColor]]];

    [self.tableView reloadData];
}

#pragma mark - YDPublishDynamicCellDelegate
- (void)clickedAdd{
    //YDWeakSelf(self);
    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍摄",@"从手机相册选择"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {
            YDCameraViewController *camera = [[YDCameraViewController alloc] init];
            camera.delegate = self;
            if (self.model.images.count > 0 && !self.model.isVideo) {
                [camera setDisableVideo:YES];
            }
            [self presentViewController:camera animated:YES completion:^{
                
            }];
//            self.cameraVC = [[WJCameraViewController alloc] init];
//            self.cameraVC.disableAutoSaveImage = YES;
//            if (self.model.images.count > 0 && !self.model.isVideo) {
//                [self.cameraVC setDisableVideo:YES];
//            }
//            [self.cameraVC setTakeImageBlock:^(UIImage *image){
//                UIImage *messageImage = [UIImage fixOrientation:image];
//                [weakself nd_saveImage:messageImage];
//            }];
//            [self.cameraVC setTakeVideoBlock:^(NSURL *videoUrl, UIImage *thumbnailImage) {
//                if (thumbnailImage) {
//                    weakself.model.videoLocalURL = videoUrl;
//                    weakself.model.images = [NSMutableArray arrayWithObject:thumbnailImage];
//                    [weakself.tableView reloadData];
//                }
//                else{
//                    [YDMBPTool showInfoImageWithMessage:@"无相册访问权限" hideBlock:^{
//
//                    }];
//
//                }
//            }];
//
//            [self presentViewController:self.cameraVC animated:YES completion:nil];
        }
        else if (index == 2){
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
            imagePickerVc.selectedAssets = self.model.assets;
            //关闭视频选择
            //imagePickerVc.allowPickingVideo = NO;
            YDWeakSelf(self);
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
                NSLog(@"%s",__func__);
                self.model.assets = [NSMutableArray arrayWithArray:assets];
                self.model.images = [NSMutableArray arrayWithArray:photos];
                [weakself.tableView reloadData];
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }];
}
     
//点击删除视频或图片
- (void)clickedDelete:(NSInteger)imageIndex{
    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == -1) {
            if (imageIndex < self.model.images.count) {
                [self.model.images removeObjectAtIndex:imageIndex];
            }
            if (imageIndex < self.model.assets.count) {
                [self.model.assets removeObjectAtIndex:imageIndex];
            }
            if (self.model.isVideo) {
                self.model.videoLocalURL = nil;
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)clickedImage:(NSInteger)index{
    NSLog(@"%s index = %ld",__func__,index);
}

- (void)clickedVideo:(NSURL *)videoURL{
    
    WWVideoPlayerViewController *videoVC = [[WWVideoPlayerViewController alloc] initWithVideoURL:videoURL];
    [self presentViewController:videoVC animated:YES completion:^{
        
    }];
}

- (BOOL)cellTextViewShouldBeginEditing:(UITextView *)textView{
    self.inputingView = textView;
    
    return YES;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YDPublishDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDPublishDynamicCell"];
        [cell setItem:self.model];
        [cell setDelegate:self];
        return cell;
    }
    static NSString *pdCellId = @"pdCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pdCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:pdCellId];
        cell.textLabel.font = [UIFont pingFangSC_RegularFont:16];
        cell.textLabel.textColor = [UIColor blackTextColor];
        cell.detailTextLabel.font = [UIFont font_14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"discover_pd_location"];
        cell.textLabel.text = @"所在位置";
        cell.detailTextLabel.text = self.model.address;
    }
    else if (indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"discover_pd_label"];
        cell.textLabel.text = @"添加标签";
        cell.detailTextLabel.text = self.model.label;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.model.cellHeight;
    }
    return 52.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        YDSelectLocationViewModel *viewModel = [[YDSelectLocationViewModel alloc] initWithUserCity:[YDUserLocation sharedLocation].userCity selectedPoi:[YDUserLocation sharedLocation].selectedPoi];
        YDSelectLocationController *vc = [[YDSelectLocationController alloc] initWitViewModel:viewModel];
        YDWeakSelf(self);
        [vc setSLDidSelectedLoationBlock:^(YDPoiInfo *poi) {
            weakself.model.address = poi.name;
            weakself.model.lng = [NSString stringWithFormat:@"%f",poi.pt.longitude];
            weakself.model.lat = [NSString stringWithFormat:@"%f",poi.pt.latitude];
            [weakself.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        YDDynamicLabelController *labelController = [YDDynamicLabelController new];
        YDWeakSelf(self);
        [labelController setDLCDidSelectedBlock:^(NSString *label) {
            weakself.model.label = label;
            [weakself.tableView reloadData];
        }];
        [self.navigationController pushViewController:labelController animated:YES];
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    if (self.emojiKeyboard.isShow) {
        [self.emojiKeyboard dismissWithAnimation:YES];
        [self.keyboardControl dismissWithAnimated:YES];
    }
}

#pragma mark - Private Methods
- (void)nd_saveImage:(UIImage *)image{
    YDWeakSelf(self);
    [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
     if (error) {
         [weakself.model.images addObject:image];
         [weakself.tableView reloadData];
         YDLog(@"图片保存失败 %@",error);
     } else {
         [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
             [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                 TZAssetModel *assetModel = [models lastObject];
                 [weakself.model.assets addObject:assetModel.asset];
                 [weakself.model.images addObject:image];
                 [weakself.tableView reloadData];
             }];
         }];
     }
    }];
}
     
@end

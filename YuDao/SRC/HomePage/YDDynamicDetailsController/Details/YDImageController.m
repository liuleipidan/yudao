//
//  YDImageController.m
//  YuDao
//
//  Created by 汪杰 on 16/12/30.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDImageController.h"
#import "TZImageManager.h"

@interface YDImageController ()

@end

@implementation YDImageController

- (id)init{
    if (self = [super init]) {
        
        [self.view addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Event
- (void)ic_tapScreen:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 3dTouch 上滑拉出来的两个按钮
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems{
    YDWeakSelf(self);
    UIPreviewAction *action0 = [UIPreviewAction actionWithTitle:@"保存" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        YDLog(@"%s, line = %d, action0 = %@, previewViewController = %@", __FUNCTION__, __LINE__, action, previewViewController);
        [[TZImageManager manager] savePhotoWithImage:weakself.imageV.image completion:^(NSError *error) {
            if (error) {
                YDLog(@"保存图片失败!");
            }else{
                [YDMBPTool showSuccessImageWithMessage:@"保存成功" hideBlock:nil];
            }
        }];
    }];
    
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"取消" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        YDLog(@"%s, line = %d, action1 = %@, previewViewController = %@", __FUNCTION__, __LINE__, action, previewViewController);
    }];
    
    
    return  @[action0,action1];
}

#pragma mark - Getter
- (UIImageView *)imageV{
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageV.backgroundColor = [UIColor blackColor];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ic_tapScreen:)]];
    }
    return _imageV;
}

@end

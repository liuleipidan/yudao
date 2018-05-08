//
//  YDCarAuthenticateController.m
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCarAuthenticateController.h"
#import "YDAuthenticateTableView.h"
#import "YDAuthenticateCell.h"
#import "YDImagePickerTool.h"

@interface YDCarAuthenticateController ()<YDAuthenticateTableViewCustomDelegate>

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) YDAuthenticateTableView *tableView;

@property (nonatomic, strong) YDImagePickerTool *ipTool;

@end

@implementation YDCarAuthenticateController
{
    YDAuthenticateModel *_selectedCellModel;
    NSInteger         _selectedIndex;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"车辆认证"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setCarInfo:(YDCarDetailModel *)carInfo{
    if (carInfo == nil) {
        return;
    }
    _carInfo = carInfo;
    
    YDAuthenticateModel *model1 = [YDAuthenticateModel modelWithImageType:YDAuthenticateImageTypePositive title:@"请上传行驶证正本" image:nil imageUrl:carInfo.ug_positive authStatus:carInfo.ug_vehicle_auth.integerValue];
    
    YDAuthenticateModel *model2 = [YDAuthenticateModel modelWithImageType:YDAuthenticateImageTypeNegative title:@"请上传行驶证副本" image:nil imageUrl:carInfo.ug_negative authStatus:carInfo.ug_vehicle_auth.integerValue];
    
    self.data = [NSMutableArray arrayWithObjects:model1,model2, nil];
}

//打开相机或相册
- (void)openCameraOrAlbum:(NSInteger )imageIndex model:(YDAuthenticateModel *)model{
    _selectedCellModel = model;
    _selectedIndex = imageIndex;
    [self.ipTool showActionSheet:^(UIImage *image, NSURL *url) {
        _selectedCellModel.image = image;
        [self.tableView reloadData];
    }];
}

#pragma mark - YDAuthenticateTableViewCustomDelegate
- (void)authenticateTableView:(YDAuthenticateTableView *)tableView ClickPopPromptViewType:(YDAuthenticateImageType )ViewType{
    NSLog(@"ViewType = %ld",ViewType);
}

#pragma mark - Getters
- (YDAuthenticateTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDAuthenticateTableView alloc] initWithFrame:self.view.bounds data:self.data];
       [_tableView setAuthStatus:self.carInfo.ug_vehicle_auth.integerValue];
        YDWeakSelf(self);
        //点击图片
        [_tableView setDidSelectBlock:^(NSInteger index, YDAuthenticateModel *model) {
            [weakself openCameraOrAlbum:index model:model];
        }];
        //点击提交
        [_tableView setTouchedUploadBtn:^(UIButton *btn) {
            for (YDAuthenticateModel *model in weakself.data) {
                if (model.image == nil) {
                    [YDMBPTool showInfoImageWithMessage:@"图片不可为空" hideBlock:nil];
                    return ;
                }
            }
            YDAuthenticateModel *model1 = weakself.data.firstObject;
            YDAuthenticateModel *model2 = weakself.data.lastObject;
            //上传车辆认证图片
            [YDNetworking uploadCarTwoImage:model1.image twoImage:model2.image url:kUpuploadCarCardImageURL ug_id:weakself.carInfo.ug_id success:^{
                if (weakself.didUploadNewImagesBlock) {
                    weakself.didUploadNewImagesBlock();
                }
                [YDMBPTool showSuccessImageWithMessage:@"上传成功" hideBlock:^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                }];
                
            } failure:^(NSString *failMessage){
                
                [YDMBPTool showErrorImageWithMessage:failMessage hideBlock:nil];
            }];
        }];
    }
    return _tableView;
}

- (YDImagePickerTool *)ipTool{
    if (!_ipTool) {
        _ipTool = [[YDImagePickerTool alloc] initWithPresentingViewController:self];
    }
    return _ipTool;
}

@end

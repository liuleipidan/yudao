//
//  YDPersonalAuthController.m
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPersonalAuthController.h"
#import "YDAuthenticateTableView.h"
#import "YDAuthenticateCell.h"
#import "YDImagePickerTool.h"
#import "YDAuthenticatePromptView.h"
#import "XLPhotoBrowser.h"

@interface YDPersonalAuthController ()<YDAuthenticateTableViewCustomDelegate>

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) YDAuthenticateTableView *tableView;

@property (nonatomic, strong) YDImagePickerTool *ipTool;

@end

@implementation YDPersonalAuthController
{
    YDAuthenticateModel *_selectedCellModel;
    NSInteger         _selectedIndex;
    
    NSString          *_positiveKey;//用于存取图片
    NSString          *_negativeKey;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人认证";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)dealloc{
    NSLog(@"dealloc self.class = %@",self.class);
}

//打开相机或相册
- (void)openCameraOrAlbum:(NSInteger )imageIndex model:(YDAuthenticateModel *)model{
    _selectedCellModel = model;
    _selectedIndex = imageIndex;
    
    YDWeakSelf(self);
    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册中选择"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {
            if (![YDPrivilegeManager checkCameraPrivilege]) {
                [UIAlertController YD_OK_AlertController:self title:@"请在iPhone的\"设置-隐私-相机\"选项中，允许遇道访问你的相机" clickBlock:^{
                }];
            }else{
                YDClipCameraController *cameraVC = [[YDClipCameraController alloc] init];
                [cameraVC setTakeImageBlock:^(UIImage *image){
                    
                    //旋转方向
                    UIImage *messageImage = [UIImage fixOrientation:image] ;
                    //调整尺寸
                    UIImage *scaleImage = [messageImage scaleToSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
                    CGFloat x = (SCREEN_WIDTH - kWidth(345)) / 2;
                    CGFloat y = (SCREEN_HEIGHT - kHeight(219)) / 2;
                    //截取图片
                    UIImage *clipedImage = [UIImage yd_clipImageFromImage:scaleImage inRect:CGRectMake(x, y, kWidth(345), kHeight(219))];
                    
                    _selectedCellModel.image = clipedImage;
                    
                    [weakself.tableView reloadData];
                }];
                [self presentViewController:cameraVC animated:YES completion:nil];
            }
        }
        else if (index == 2){
            if ([YDPrivilegeManager allowAccessToAlbums]) {
                [self.ipTool showPhotoLibraryFinishPickingBlock:^(UIImage *image, NSURL *url) {
                    _selectedCellModel.image = image;
                    [weakself.tableView reloadData];
                }];
            }else{
                [UIAlertController YD_OK_AlertController:self title:@"请在iPhone的\"设置-隐私-相机\"选项中，允许遇道访问你的手机相册" clickBlock:^{
                    
                }];
            }
        }
    }];
}

#pragma mark - YDAuthenticateTableViewCustomDelegate
- (void)authenticateTableView:(YDAuthenticateTableView *)tableView ClickPopPromptViewType:(YDAuthenticateImageType )ViewType{
    NSLog(@"personal ViewType = %ld",ViewType);
    if (ViewType == YDAuthenticateImageTypePositive) {
        [YDAuthenticatePromptView showWithImage:YDImage(@"mine_auth_personal_positive")];
    }else{
        [YDAuthenticatePromptView showWithImage:YDImage(@"mine_auth_personal_nagitive")];
    }
}

#pragma mark - Getters
- (YDAuthenticateTableView *)tableView{
    if (!_tableView) {
        _tableView = [[YDAuthenticateTableView alloc] initWithFrame:self.view.bounds data:self.data];
        [_tableView setAuthStatus:[YDUserDefault defaultUser].user.ud_userauth.integerValue];
        [_tableView setCustomDelegate:self];
        YDWeakSelf(self);
        //点击图片
        [_tableView setDidSelectBlock:^(NSInteger index, YDAuthenticateModel *model) {
            [weakself openCameraOrAlbum:index model:model];
        }];
        
        //点击提交
        [_tableView setTouchedUploadBtn:^(UIButton *btn) {
            
            YDAuthenticateModel *model1 = weakself.data.firstObject;
            YDAuthenticateModel *model2 = weakself.data.lastObject;
            if (model1.image == nil) {
                [YDMBPTool showText:@"第一张图片为空或是认证失败的图片"];
                return ;
            }
            else if (model2.image == nil){
                [YDMBPTool showText:@"第二张图片为空或是认证失败的图片"];
                return ;
            }
            
            [YDLoadingHUD showLoading];
            //上传用户认证图片
            [YDNetworking uploadUserTwoImage:model1.image twoImage:model2.image url:kUpuploadUserImageURL success:^(NSDictionary *response){
                
                NSString *positive = [response valueForKey:@"positive"];
                NSString *negative = [response valueForKey:@"negative"];
                
                YDUser *user = [YDUserDefault defaultUser].user;
                user.ud_userauth = @2;
                [YDUserDefault defaultUser].tempUser.ud_userauth = @2;
                user.ud_positive = positive;
                user.ud_negative = negative;
                [[YDUserDefault defaultUser] setUser:user];
                
                [YDMBPTool showSuccessImageWithMessage:@"上传成功" hideBlock:^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                }];
                
            } failure:^(NSString *failMessage) {
                [YDMBPTool showErrorImageWithMessage:failMessage hideBlock:nil];
            }];
            
        }];
    }
    return _tableView;
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray arrayWithCapacity:2];
        YDUser *user = [YDUserDefault defaultUser].user;
        
        YDAuthenticateModel *model1 = [YDAuthenticateModel modelWithImageType:YDAuthenticateImageTypePositive title:@"请拍照上传身份证头像页或驾驶证正本" image:nil imageUrl:user.ud_positive authStatus:user.ud_userauth.integerValue];
        
        YDAuthenticateModel *model2 = [YDAuthenticateModel modelWithImageType:YDAuthenticateImageTypeNegative title:@"请拍照上传身份证国徽页或驾驶证副本" image:nil imageUrl:user.ud_negative authStatus:user.ud_userauth.integerValue];
        
        [_data addObjectsFromArray:@[model1,model2]];
    }
    return _data;
}

- (YDImagePickerTool *)ipTool{
    if (!_ipTool) {
        _ipTool = [[YDImagePickerTool alloc] initWithPresentingViewController:self];
    }
    return _ipTool;
}

@end

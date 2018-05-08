//
//  YDPublishDynamicController.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPublishDynamicController.h"
#import "YDPublishDynamicController+Delegate.h"
#import "YDPublishDynamicController+Keyboard.h"
#import "YDVideoUtil.h"
#import "YDEmojiKBHelper.h"

@interface YDPublishDynamicController ()



@end

@implementation YDPublishDynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self pb_initUI];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"取消" target:self action:@selector(pb_leftBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"发表" target:self action:@selector(pb_rightBarButtonItemAction:)];
    
    [self addKeyboardNotifications];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //关闭键盘的toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关闭键盘的toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)dealloc{
    [YDNotificationCenter removeObserver:self];
}

#pragma mark - Events
//发布
- (void)pb_rightBarButtonItemAction:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    
    if (self.model.images.count == 0) {
        [YDMBPTool showText:@"图片不可为空!"];
        return;
    }
    
    if (self.model.label.length == 0) {
        [YDMBPTool showText:@"标签不可为空!"];
        return;
    }
    
    if (self.model.text.length > 0) {
        self.model.text = [self.model.text yd_stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.model.text = [self.model.text yd_stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    NSMutableDictionary *param = [self pd_uploadParameters];
    
    [YDLoadingHUD showLoading];
    
    if (self.model.videoLocalURL) {
        if ([self.model.videoLocalURL.absoluteString hasSuffix:@".mp4"] || [self.model.videoLocalURL.absoluteString hasSuffix:@".MP4"]) {
            [self pd_uploadVideoToServer:param videoPath:self.model.videoLocalURL.absoluteString];
        }
        else if ([self.model.videoLocalURL.absoluteString hasSuffix:@".MOV"] || [self.model.videoLocalURL.absoluteString hasSuffix:@".mov"]){
            [YDVideoUtil ConvertMovToMp4:self.model.videoLocalURL completion:^(AVAssetExportSessionStatus status, NSString *exportPath) {
                if (status == AVAssetExportSessionStatusCompleted) {
                    [self pd_uploadVideoToServer:param videoPath:exportPath];
                }
                else{
                    [YDMBPTool showErrorImageWithMessage:@"格式转换失败" hideBlock:nil];
                }
                
            }];
        }
        else{
            [YDMBPTool showErrorImageWithMessage:@"不支持的文件格式" hideBlock:nil];
        }
    }
    else{
        [self pd_uploadImagesToServer:param];
    }
}
//取消
- (void)pb_leftBarButtonItemAction:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    if (self.model.images.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [UIAlertController YD_alertController:self title:@"退出此次编辑" subTitle:nil items:@[@"退出"] style:UIAlertControllerStyleAlert clickBlock:^(NSInteger index) {
        if (index == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - Private Methods
- (void)pb_initUI{
    [self.navigationItem setTitle:@"发布动态"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.keyboardControl];
    [self.keyboardControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
}
//上传图片到服务器
- (void)pd_uploadImagesToServer:(NSMutableDictionary *)param{
    [YDNetworking uploadImages:self.model.images prefix:@"d_image" url:kCommitDynamicImageURL otherData:param success:^{
        //想代理发送发布了新动态的通知
        if (self.delegate && [self.delegate respondsToSelector:@selector(publishDynamicController:publishedNewDynamic:)]) {
            [self.delegate publishDynamicController:self publishedNewDynamic:YDUser_id];
        }
        [YDMBPTool showSuccessImageWithMessage:@"发布成功" hideBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
    } failure:^{
        [YDMBPTool showErrorImageWithMessage:@"发布失败" hideBlock:nil];
    }];
}
//上传视频到服务器
- (void)pd_uploadVideoToServer:(NSMutableDictionary *)param videoPath:(NSString *)videoPath{
    [YDNetworking uploadVideoData:videoPath thumbnailImage:self.model.images.firstObject dataName:@"video" url:kUploadVideoDataURL success:^(NSString *videoUrl, NSString *thumbnailImageUrl) {
        [param setObject:videoUrl forKey:@"d_video"];
        [param setObject:thumbnailImageUrl forKey:@"d_image"];
        [param setObject:@2 forKey:@"d_type"];
        
        [YDNetworking POST:kAddDynamicURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
            if ([code isEqual:@200]) {
                //想代理发送发布了新动态的通知
                if (self.delegate && [self.delegate respondsToSelector:@selector(publishDynamicController:publishedNewDynamic:)]) {
                    [self.delegate publishDynamicController:self publishedNewDynamic:YDUser_id];
                }
                [YDMBPTool showSuccessImageWithMessage:@"发布成功" hideBlock:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            else{
                [YDMBPTool showErrorImageWithMessage:status.length > 0 ? status : @"发布失败" hideBlock:nil];
            }
        } failure:^(NSError *error) {
            [YDMBPTool showErrorImageWithMessage:@"发布失败" hideBlock:nil];
        }];
        
    } failure:^{
        [YDMBPTool showErrorImageWithMessage:@"视频上传失败" hideBlock:nil];
    }];
}
//上传参数
- (NSMutableDictionary *)pd_uploadParameters{
    NSNumber *hideLoc = @0;
    if (self.model.address.length == 0 || [self.model.address isEqualToString:@"不显示位置"]) {
        hideLoc = @1;
    }
    return [NSMutableDictionary dictionaryWithDictionary:@{@"d_details":YDNoNilString(self.model.text),
                                                           @"access_token":YDAccess_token,
                                                           @"d_address":self.model.address ? : @"上海",
                                                           @"lng":self.model.lng,
                                                           @"lat":self.model.lat,
                                                           @"d_label":self.model.label,
                                                           @"hide":hideLoc,
                                                           @"d_type":@1
                                                           }];
}

#pragma mark - Getters
- (YDTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDTableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[YDPublishDynamicCell class] forCellReuseIdentifier:@"YDPublishDynamicCell"];
    }
    return _tableView;
}

- (YDPublishDynamicModel *)model{
    if (_model == nil) {
        _model = [[YDPublishDynamicModel alloc] init];
        _model.address = [YDUserLocation sharedLocation].address;
        _model.lng = [NSString stringWithFormat:@"%f",[YDUserLocation sharedLocation].userCoor.longitude];
        _model.lat = [NSString stringWithFormat:@"%f",[YDUserLocation sharedLocation].userCoor.latitude];
    }
    return _model;
}


- (YDEmojiKeyboard *)emojiKeyboard{
    if (_emojiKeyboard == nil) {
        _emojiKeyboard = [[YDEmojiKeyboard alloc] init];
        _emojiKeyboard.keyboardDelegate = self;
        _emojiKeyboard.delegate = self;
        [_emojiKeyboard setDoneButtonTitle:@"完成"];
        [_emojiKeyboard setEmojiGroupData:[YDEmojiKBHelper sharedInstance].emojiGroupData];
    }
    return _emojiKeyboard;
}

- (YDKeyboardControl *)keyboardControl{
    if (_keyboardControl == nil) {
        _keyboardControl = [[YDKeyboardControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 48)];
        _keyboardControl.delegate = self;
    }
    return _keyboardControl;
}

@end

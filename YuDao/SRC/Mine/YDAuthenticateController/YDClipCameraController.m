//
//  YDClipCameraController.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDClipCameraController.h"

@interface YDClipCameraController ()

@end

@implementation YDClipCameraController

- (id)init{
    if (self = [super init]) {
        [self.preview setDisableSwitchButton:YES];
        [self.preview setOpenClip:YES];
        
        [self setDisableVideo:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}




@end

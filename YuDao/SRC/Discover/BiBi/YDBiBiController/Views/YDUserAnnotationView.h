//
//  YDUserAnnotationView.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>

///用户标注视图
@interface YDUserAnnotationView : BMKPinAnnotationView

@property (nonatomic, copy  ) NSString *avatarUrl;

- (void)customSelected;

@end

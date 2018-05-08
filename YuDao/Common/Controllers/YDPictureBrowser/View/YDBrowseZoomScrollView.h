//
//  YDBrowseZoomScrollView.h
//  YDTransitionDemo
//
//  Created by liyang on 16/10/12.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YDBrowseZoomScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *zoomImageView;
@property (nonatomic,copy)   void (^tapBlock)(void);

@end

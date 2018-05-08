//
//  YDAuthenticateTableView.h
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDAuthenticateCell.h"

@class YDAuthenticateTableView;
@protocol YDAuthenticateTableViewCustomDelegate <NSObject>

@optional
- (void)authenticateTableView:(YDAuthenticateTableView *)tableView ClickPopPromptViewType:(YDAuthenticateImageType )ViewType;

@end

@interface YDAuthenticateTableView : UITableView<UITableViewDataSource,UITableViewDelegate,YDAuthenticateCellDelegate,YDAuthenticateCellDelegate>

@property (nonatomic, weak  ) id<YDAuthenticateTableViewCustomDelegate> customDelegate;

@property (nonatomic, copy  ) void (^didSelectBlock)(NSInteger index,YDAuthenticateModel *model);

@property (nonatomic, copy  ) void (^touchedUploadBtn)(UIButton *btn);

@property (nonatomic, assign) YDAuthenticateStatus authStatus;

- (instancetype)initWithFrame:(CGRect)frame data:(NSMutableArray *)data;


@end

//
//  YDDynamicDetailsController+Delgate.h
//  YuDao
//
//  Created by 汪杰 on 16/12/20.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDynamicDetailsController.h"
#import "XLPhotoBrowser.h"

@interface YDDynamicDetailsController (Delgate)<UITableViewDataSource,UITableViewDelegate,YDDDLikerCellDelegate,systemActionSheetDelegate,UIViewControllerPreviewingDelegate,YDDDCommentCellDelegate,YDDDImagesCellDelegate,YDDDVideoCellDelegate,XLPhotoBrowserDatasource,XLPhotoBrowserDelegate,YDDynamicDetailsBottomViewDelegate,YDDynamicCommentViewDelegate>

//注册单元格
- (void)registeCellClass;

@end

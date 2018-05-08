//
//  YDDynamicDetailsController.h
//  YuDao
//
//  Created by 汪杰 on 16/12/20.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDDynamicDetailsHeaderView.h"
#import "YDDynamicDetailsBottomView.h"

#import "YDDynamicDetailModel.h"

#import "YDDDLabelContentCell.h"
#import "YDDDImagesCell.h"
#import "YDDDVideoCell.h"
#import "YDDDLocationCell.h"
#import "YDDDLikerCell.h"
#import "YDDDCommentCell.h"

#import "YDDynamicDetailViewModel.h"

#import "YDMoment.h"
#import "YDUserFilesController.h"

#import "YDDynamicCommentView.h"

@protocol YDDynamicDetailsControllerDelegate <NSObject>

@optional

/**
 动态被删除

 @param moment 动态   
 */
- (void)momentHadDeleted:(YDMoment *)moment;


/**
 动态评论数量改变

 @param moment 动态
 @param count 新的评论数
 */
- (void)moment:(YDMoment *)moment commentCountChanged:(NSInteger )count;


/**
 动态喜欢数量改变

 @param moment 动态
 @param count 新的喜欢数
 @param isLike 是喜欢还是取消喜欢
 */
- (void)moment:(YDMoment *)moment likeCountChanged:(NSInteger )count isLike:(BOOL)isLike;

@end

@interface YDDynamicDetailsController : YDViewController
{
    YDDynamicDetailViewModel *_viewModel;
    YDDynamicCommentModel *_comtentTo;
    NSMutableArray *_browerPhotos;
    NSArray    *_cellImageViews;
}

- (instancetype)initWithViewModel:(YDDynamicDetailViewModel *)viewModel;

@property (nonatomic, weak  ) id<YDDynamicDetailsControllerDelegate> delegate;

@property (nonatomic, strong) YDTableView *tableView;

@property (nonatomic, strong) YDDynamicCommentView *commentView;

@property (nonatomic, strong) YDDynamicDetailsBottomView *bottomView;

@property (nonatomic, strong) YDDynamicDetailViewModel *viewModel;

//动态详情
@property (nonatomic, strong) YDDynamicDetailModel  *dyModel;

@property (nonatomic, strong) NSMutableArray *browerPhotos;

@property (nonatomic, strong) NSArray *cellImageViews;

@property (nonatomic, copy  ) void(^needRefreshBlock)(void);

@end

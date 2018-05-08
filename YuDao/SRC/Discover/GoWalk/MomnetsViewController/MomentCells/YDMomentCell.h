//
//  YDMomentCell.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDMomentHeaderView.h"
#import "YDMomentMultilImagesView.h"
#import "YDMomentBottomView.h"
#import "YDMomentTextView.h"
#import "YDMomentViewDelegate.h"
#import "YDMoment.h"

@interface YDMomentCell : UITableViewCell<YDMomentCellDelegate>
{
    YDMoment *_moment;
    YDMomentHeaderView *_headerView;
    YDMomentTextView *_textView;
    YDMomentBottomView *_bottomView;
}
@property (nonatomic, weak  ) id<YDMomentCellDelegate> delegate;

@property (nonatomic, strong) YDMoment *moment;

@property (nonatomic, strong) YDMomentHeaderView *headerView;

@property (nonatomic, strong) YDMomentTextView *textView;

@property (nonatomic, strong) YDMomentBottomView *bottomView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

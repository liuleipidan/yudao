//
//  YDDynamicsTableView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/29.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDMomentImagesCell.h"
#import "YDMomentVideoCell.h"
#import "UITableView+VideoPlay.h"

@class YDDynamicsTableView;
@protocol YDDynamicsTableViewDelegate <YDMomentCellDelegate>

@optional
- (void)dynamicsTableViewDidScroll:(YDDynamicsTableView *)tableView;

- (void)dynamicsTableView:(YDDynamicsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)dynamicsTableViewDidEndDragging:(YDDynamicsTableView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)dynamicsTableViewDidEndDecelerating:(YDDynamicsTableView *)scrollView;

- (void)dynamicsTableViewWillBeginDragging:(YDDynamicsTableView *)scrollView;

@end

@interface YDDynamicsTableView : UITableView

@property (nonatomic, weak  ) id<YDDynamicsTableViewDelegate> yd_delegate;


@property (nonatomic, strong) NSMutableArray<YDMoment *> *data;

@end

//
//  YDHPDynamicController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHPDynamicController.h"
#import "YDHPDynamicCell.h"
#import "YDPHDynamicViewModel.h"
#import "YDDynamicDetailsController.h"
#import "YDUserFilesController.h"

@interface YDHPDynamicController ()<UITableViewDataSource,UITableViewDelegate,YDHPDynamicCellDelegate>

@property (nonatomic, strong) UILabel          *titleLabel;

@property (nonatomic, strong) YDPHDynamicViewModel *viewModel;

@end

@implementation YDHPDynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    _viewModel = [[YDPHDynamicViewModel alloc] init];
    [self requestHomePageDynamics];
    
    [self.tableView reloadData];
    
    [self layoutViewHeight];
}

- (void)requestHomePageDynamics{
    YDWeakSelf(self);
    [_viewModel requsetHomePageDynamicsCompletion:^(NSArray *dynamics) {
        [weakself.tableView reloadData];
        
        [weakself layoutViewHeight];
    }];
}

/**
 重置tableView和self.view的高度
 */
- (void)layoutViewHeight{
    //延迟获取tableView的高度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.height = self.tableView.contentSize.height;
        self.view.height = CGRectGetMaxY(self.titleLabel.frame) + self.tableView.height+10;
        if (self.delegate && [self.delegate respondsToSelector:@selector(HPDynamicControllerDataDidLoad:viewHeight:)]) {
            [self.delegate HPDynamicControllerDataDidLoad:self viewHeight:self.view.height];
        }
    });
}

#pragma mark - YDHPDynamicCellDelegate
- (void)HPDynamicCell:(YDHPDynamicCell *)cell didClickedUserAvatar:(YDDynamicModel *)model{
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:model.ub_id];
    viewM.userName = model.u_name;
    viewM.userHeaderUrl = model.ud_face;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    [self.parentViewController.navigationController pushViewController:userVC animated:YES];
}

- (void)HPDynamicCell:(YDHPDynamicCell *)cell didClickedPlayButton:(YDDynamicModel *)model{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _viewModel.dynamics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _viewModel.dynamics.count) {
        YDDynamicModel *model = _viewModel.dynamics[indexPath.row];
        YDHPDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDHPDynamicCell"];
        [cell setModel:model];
        [cell setDelegate:self];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDDynamicModel *model = _viewModel.dynamics[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDDynamicModel *model = _viewModel.dynamics[indexPath.row];
    YDDynamicDetailViewModel *dyViewModel = [[YDDynamicDetailViewModel alloc] initWithDynamicId:model.d_id];
    [dyViewModel setDy_userId:model.ub_id];
    [dyViewModel setDy_userIcon:model.ud_face];
    [dyViewModel setDy_userName:model.u_name];
    [dyViewModel setDy_time:model.d_issuetime];
    [dyViewModel setDy_label:model.d_label];
    YDDynamicDetailsController *detailVC = [[YDDynamicDetailsController alloc] initWithViewModel:dyViewModel];
    YDWeakSelf(self);
    [detailVC setNeedRefreshBlock:^{
        [weakself requestHomePageDynamics];
    }];
    [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:18]];
        _titleLabel.text = @"最新动态";
        _titleLabel.frame = CGRectMake(10, 10, 150, 21);
    }
    return _titleLabel;
}

- (YDTableView *)tableView{
    if (!_tableView) {
        _tableView = [[YDTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain dataSource:self delegate:self];
        
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[YDHPDynamicCell class] forCellReuseIdentifier:@"YDHPDynamicCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

@end

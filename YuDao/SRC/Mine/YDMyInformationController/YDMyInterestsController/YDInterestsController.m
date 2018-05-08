//
//  YDInterestsController.m
//  YuDao
//
//  Created by 汪杰 on 17/1/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDInterestsController.h"
#import "YDInterestsCell.h"

#define kInterestURL [kOriginalURL stringByAppendingString:@"tag"]

@interface YDInterestsController ()<YDInterestsCellDelegate>

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSMutableArray<YDInterestModel *> *data;

/**
 已选择的兴趣，可变
 */
@property (nonatomic, strong) NSMutableArray *allSelectedInterests;

/**
 暂存用户已选择的兴趣，不可变，在当前视图消失时复制=allSelectedInterests
 */
@property (nonatomic, strong) NSMutableArray *checkInterests;

@end

@implementation YDInterestsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"兴趣标签"];
    
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView registerClass:[YDInterestsCell class] forCellReuseIdentifier:@"YDInterestsCell"];
    
    UIBarButtonItem *rightBarItem = [UIBarButtonItem itemWithTitle:@"完成" target:self action:@selector(interestsCompleteAction:)];
    rightBarItem.enabled = NO;
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    _allSelectedInterests = [NSMutableArray array];
    _checkInterests = [NSMutableArray array];
    [self downloadInterestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)downloadInterestData{
    [YDLoadingHUD showLoadingInView:self.view];
    
    YDWeakSelf(self);
    [YDNetworking GET:kInterestURL parameters:@{@"access_token":YDAccess_token} success:^(NSNumber *code, NSString *status, id data) {
        NSMutableArray<YDInterest *> *datas = [YDInterest mj_objectArrayWithKeyValuesArray:data];
        NSMutableArray<YDInterestModel *> *tempModels = [NSMutableArray array];
        NSMutableArray<YDInterest *> *subModels = [NSMutableArray array];
        [datas enumerateObjectsUsingBlock:^(YDInterest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.t_pid isEqual:@0]) {//父级
                YDInterestModel *model = [[YDInterestModel alloc] init];
                model.p_model = obj;
                [tempModels addObject:model];
            }
            else{//子级
                [subModels addObject:obj];
            }
        }];
        //获取我的兴趣
        NSMutableArray<NSString *> *userTags = [NSMutableArray arrayWithArray:[[YDUserDefault defaultUser].user.ud_tag componentsSeparatedByString:@","]];
        [userTags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //移除空字符
            if ([[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
                [userTags removeObject:obj];
            }
        }];
        [tempModels enumerateObjectsUsingBlock:^(YDInterestModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (YDInterest *interest in subModels) {
                if ([obj.p_model.t_id isEqual:interest.t_pid]) {
                    [obj.interests addObject:interest];
                }
            }
        }];
        [tempModels enumerateObjectsUsingBlock:^(YDInterestModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (YDInterest *interest in obj.interests) {
                for (NSString *tag in userTags) {
                    NSNumber *tag_num = @(tag.integerValue);
                    if ([interest.t_id isEqual:tag_num]) {
                        [obj.selectedInterests addObject:interest];
                        [weakself.allSelectedInterests addObject:interest];
                        [weakself.checkInterests addObject:interest];
                    }
                }
            }
        }];
        weakself.data = tempModels;
        [weakself.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Events
//完成事件
- (void)interestsCompleteAction:(UIBarButtonItem *)sender{
    YDUser *user = [[YDUserDefault defaultUser].user getTempUserData];
    
    NSMutableArray *ftagArr = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *tagArr = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *tag_nameArr = [NSMutableArray arrayWithCapacity:5];
    for (YDInterest *interest in self.allSelectedInterests) {
        NSString *ftag = [NSString stringWithFormat:@"%@",interest.t_pid];
        NSString *tag = [NSString stringWithFormat:@"%@",interest.t_id];
        NSString *tag_name = [NSString stringWithFormat:@"%@",interest.t_name];
        [ftagArr addObject:ftag];
        [tagArr addObject:tag];
        [tag_nameArr addObject:tag_name];
    }
    
    NSString *ftag = [ftagArr componentsJoinedByString:@","];
    NSString *tag = [tagArr componentsJoinedByString:@","];
    NSString *tag_name = [tag_nameArr componentsJoinedByString:@","];
    
    user.ud_ftag = ftag;
    user.ud_tag = tag;
    user.ud_tag_name = tag_name;
    
    YDWeakSelf(self);
    [YDLoadingHUD showLoading];
    [[YDUserDefault defaultUser] uploadUser:user success:^{
        
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(interestsControllerDidChanged:ftag:tag:tag_name:)]) {
            [weakself.delegate interestsControllerDidChanged:weakself ftag:ftag tag:tag tag_name:tag_name];
        }
        weakself.checkInterests = [weakself.allSelectedInterests mutableCopy];
        weakself.navigationItem.rightBarButtonItem.enabled = NO;
        [weakself.navigationController popViewControllerAnimated:YES];
        
    } failure:^{
        [YDMBPTool showText:@"修改兴趣失败"];
    }];
}

#pragma mark  - YDInterestsCellDelegate
- (void)interestsCell:(YDInterestsCell *)cell selectedBtn:(UIButton *)btn selectedItem:(YDInterest *)item{
    if ([cell.model.selectedInterests containsObject:item]) {
        [cell.model.selectedInterests removeObject:item];
        [self.allSelectedInterests removeObject:item];
    }else{
        if (self.allSelectedInterests.count >= 5) {
            [YDMBPTool showText:@"已选择五个兴趣点"];
            return;
        }
        [cell.model.selectedInterests addObject:item];
        [self.allSelectedInterests addObject:item];
    }
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = cell.model.color;
    }else{
        btn.backgroundColor = [UIColor whiteColor];
    }
    
    NSMutableSet *set1 = [NSMutableSet setWithArray:self.allSelectedInterests];
    NSMutableSet *set2 = [NSMutableSet setWithArray:self.checkInterests];
    [set1 intersectSet:set2];
    if (set1.count == self.allSelectedInterests.count && set1.count == self.checkInterests.count) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data? self.data.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDInterestsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDInterestsCell"];
    YDInterestModel *model = [self.data objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDInterestModel *model = [self.data objectAtIndex:indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[YDInterestsCell class] contentViewWidth:SCREEN_WIDTH];
}

#pragma mark - Getters
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 109)];
        UILabel *label = [YDUIKit labelWithTextColor:YDBaseColor text:@"你对什么感兴趣？" fontSize:18 textAlignment:NSTextAlignmentCenter];
        label.frame = CGRectMake(0, 23, SCREEN_WIDTH, 25);
        
        UILabel *content = [YDUIKit labelWithTextColor:[UIColor grayTextColor] text:@"添加兴趣标签，可以让更多志同道合的人找到你哟（最多选择五项）" fontSize:12 textAlignment:NSTextAlignmentCenter];
        content.numberOfLines = 2;
        content.frame = CGRectMake((SCREEN_WIDTH-274)/2, 57, 274, 40);
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 108, SCREEN_WIDTH-30, 1)];
        lineView.backgroundColor = [UIColor colorWithString:@"#B6C5DC"];
        
        [_headerView sd_addSubviews:@[label,content,lineView]];
    }
    return _headerView;
}

@end

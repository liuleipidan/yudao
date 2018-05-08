//
//  YDSearchViewController.m
//  YuDao
//
//  Created by 汪杰 on 16/10/14.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDSearchViewController.h"
#import "YDSearchController.h"


@interface YDSearchViewController ()<UISearchBarDelegate,YDSearchControllerCustomDelegagte>

@property (nonatomic, strong) YDSearchController *searchController;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UILabel *label;


@end

@implementation YDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"搜索"];
    
    //适配UISearchController的动画效果
    self.definesPresentationContext = YES;
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    
    [self.view yd_addSubviews:@[
                                self.introduceLabel,
                                self.label,
                                self.searchController.searchBar]];
    
    [self y_addMasonry];
}

#pragma mark - Events

#pragma mark Private Methods
- (void)y_addMasonry{
    
    [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view).offset(14);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(21);
    }];
    
}

#pragma mark - YDSearchControllerCustomDelegagte
- (void)searchControllerWillPresent:(YDSearchController *)controller{
    [UIView animateWithDuration:0.25 animations:^{
        [self.introduceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(84);
        }];
        [self.view layoutIfNeeded];
    }];
}
- (void)searchControllerWillDismiss:(YDSearchController *)controller{
    [UIView animateWithDuration:0.25 animations:^{
        [self.introduceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.view).offset(64);
        }];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //限制第一个字符为%
    if (searchBar.text.length == 0 && [text isEqualToString:@"%"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Getters
- (UILabel *)introduceLabel{
    if (!_introduceLabel) {
        _introduceLabel = [YDUIKit labelWithTextColor:YDBaseColor text:@"您可以搜索用户昵称" fontSize:kFontSize(14) textAlignment:0];
    }
    return _introduceLabel;
}

- (YDSearchController *)searchController{
    if (!_searchController) {
        _searchController = [[YDSearchController alloc] initWithSearchResultsController:self.searchResultVC];
        _searchController.searchResultsUpdater = self.searchResultVC;
        _searchController.searchBar.delegate = self;
        _searchController.customDelegate = self;
    }
    return _searchController;
}

- (YDSearchResultsTableViewController *)searchResultVC{
    if (!_searchResultVC) {
        _searchResultVC = [YDSearchResultsTableViewController new];
    }
    return _searchResultVC;
}

- (UILabel *)label{
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont font_14];
        _label.text = @"他们都在搜:";
    }
    return _label;
}

@end

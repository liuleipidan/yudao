//
//  YDDynamicLabelController.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDynamicLabelController.h"
#import "YDDynamicLabelController+Delegate.h"

@interface YDDynamicLabelController ()


@end

@implementation YDDynamicLabelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"添加标签"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(lc_rightButtonItemAction:)];
    rightItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self registerCells];
    
    _viewModel = [[YDLabelViewModel alloc] init];
    
    [self lc_requestDynamicHotLabels];
}

//完成按钮
- (void)lc_rightButtonItemAction:(UIBarButtonItem *)sender{
    if (self.DLCDidSelectedBlock) {
        self.DLCDidSelectedBlock(self.textField.text);
    }
    [self.viewModel insertUserDynamicLabel:self.textField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

//获取热门标签
- (void)lc_requestDynamicHotLabels{
    [YDNetworking GET:kDynamicHotLabelsURL parameters:nil success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            NSArray *labels = [data objectForKey:@"tags"];
            if (labels) {
                [self.viewModel setHotArr:[NSMutableArray arrayWithArray:labels]];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Getter
- (YDLimitTextField *)textField{
    if (_textField == nil) {
        _textField = [[YDLimitTextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-30, 44) limit:5];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"最多五个字";
        _textField.font = [UIFont font_16];
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        YDWeakSelf(self);
        [_textField setTextDidChangeBlock:^(NSString *text) {
            weakself.navigationItem.rightBarButtonItem.enabled = text.length > 0;
        }];
    }
    return _textField;
}

- (YDTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDTableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor searchBarBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableView.tableHeaderView = ({
            UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
            tableHeaderView.backgroundColor = [UIColor searchBarBackgroundColor];
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
            bgView.backgroundColor = [UIColor whiteColor];
            [tableHeaderView addSubview:bgView];
            [tableHeaderView addSubview:self.textField];
            tableHeaderView;
        });
        
        [_tableView registerClass:[YDContactHeaderView class] forHeaderFooterViewReuseIdentifier:@"YDContactHeaderView"];
    }
    return _tableView;
}

@end

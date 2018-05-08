//
//  YDAuthenticateTableView.m
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAuthenticateTableView.h"

@interface YDAuthenticateTableView()

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) UIButton *uploadButton;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation YDAuthenticateTableView

- (instancetype)initWithFrame:(CGRect)frame data:(NSMutableArray *)data{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = kHeight(250.f);
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self registerClass:[YDAuthenticateCell class] forCellReuseIdentifier:@"YDAuthenticateCell"];
        
        _data = data;
        
        [self setTableFooterView:self.bottomView];
        
    }
    return self;
}
//点击提交按钮
- (void)at_uploadBtnAction:(UIButton *)button{
    if (self.touchedUploadBtn) {
        self.touchedUploadBtn(button);
    }
}

- (void)setAuthStatus:(YDAuthenticateStatus)authStatus{
    _authStatus = authStatus;
    
    self.uploadButton.hidden = _authStatus == YDAuthenticateStatusSuccess|| _authStatus == YDAuthenticateStatusAuthing;
    [self.uploadButton setTitle:authStatus == YDAuthenticateStatusFail ? @"重新提交" : @"提交" forState:0];
}

#pragma mark - YDAuthenticateCellDelegate
- (void)authenticateCell:(YDAuthenticateCell *)cell clickedPopViewButton:(UIButton *)sender{
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(authenticateTableView:ClickPopPromptViewType:)]) {
        [self.customDelegate authenticateTableView:self ClickPopPromptViewType:cell.model.imageType];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDAuthenticateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDAuthenticateCell"];
    YDAuthenticateModel *model = _data[indexPath.row];
    cell.model = model;
    [cell setDelegate:self];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.didSelectBlock && !self.uploadButton.hidden) {
        self.didSelectBlock(indexPath.row,_data[indexPath.row]);
    }
}

#pragma mark - Getter
- (UIButton *)uploadButton{
    if (_uploadButton == nil) {
        _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadButton.backgroundColor = [UIColor baseColor];
        _uploadButton.layer.cornerRadius = 8.0f;
        [_uploadButton setTitle:@"提交" forState:0];
        [_uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_uploadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_uploadButton addTarget:self action:@selector(at_uploadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadButton;
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [UIView new];
        UILabel * promptLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14]];
        promptLabel.text = @"*上传的证件资料仅作为认证使用，《遇道》承诺绝不用于其他用途，请放心上传";
        promptLabel.numberOfLines = 0;
        CGFloat height = [promptLabel.text yd_stringHeightBySize:CGSizeMake(SCREEN_WIDTH-40, CGFLOAT_MAX) font:[UIFont font_14]];
        [_bottomView addSubview:promptLabel];
        [_bottomView addSubview:self.uploadButton];
        
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView).offset(18);
            make.right.equalTo(self.bottomView).offset(-18);
            make.top.equalTo(self.bottomView).offset(5);
            make.height.mas_equalTo(height);
        }];
        
        [self.uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bottomView);
            make.width.mas_equalTo(kWidth(309));
            make.height.mas_equalTo(kHeight(44));
            make.bottom.equalTo(self.bottomView).offset(-20);
        }];
        
        UIView *separatorView = [UIView new];
        separatorView.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:separatorView];
        [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_bottomView);
            make.height.mas_equalTo(20);
        }];
        
        _bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5+height+10+kHeight(44)+20);
    }
    return _bottomView;
}

@end

//
//  LIkedListCell.m
//  YuDao
//
//  Created by 汪杰 on 16/9/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDLikedListCell.h"


@implementation YDLikedListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self y_layoutSubviews];
    }
    return self;
}

- (void)setDataType:(YDLikedPeopleType)dataType{
    _dataType = dataType;
    
}

//MARK:Publick Method
- (void)setModel:(YDLikePersonModel *)model{
    _model = model;
    
    [_headerImageV sd_setImageWithURL:[NSURL URLWithString:model.ud_face] placeholderImage:[UIImage imageNamed:kDefaultAvatarPath]];
    
    _nameLabel.text = model.ub_nickname;
}

//MARK:Private Method
- (void)y_layoutSubviews{
    [self.contentView sd_addSubviews:@[self.headerImageV,self.nameLabel,self.addButton]];
    
    _headerImageV.frame = CGRectMake(10, (52-36)/2, 36, 36);
    _headerImageV.layer.cornerRadius = 18.0f;
    _headerImageV.layer.masksToBounds = YES;
    
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageV.frame)+14, (52-22)/2, 200, 22);
    
    _addButton.frame = CGRectMake(SCREEN_WIDTH-32-23, (52-32)/2, 32, 32);
    
    _lineView = [UIView new];
    _lineView.backgroundColor = YDSeperatorColor;
    [self.contentView addSubview:_lineView];
    
    _lineView.sd_layout
    .leftEqualToView(_nameLabel)
    .rightSpaceToView(self.contentView,15)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
    
}

- (void)addButtonAction:(UIButton *)sender{
    NSString *title = nil;
    
    NSString *url = nil;
    NSDictionary *parameters = nil;
    if (self.dataType == 2) {
        title = @"礼物已发送!";
        url = kSendGiftURL;
        parameters = @{@"access_token":YDAccess_token};
    }else{
        title = @"好友请求已发送，等待对方回复!";
        url = kAddFriendURL;
        parameters = @{@"access_token":YDAccess_token,
                       @"f_ub_id":self.model.ub_id};
    }
    
    [YDNetworking getUrl:url parameters:parameters progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        YDLog(@"添加好友或赠送礼物%@",[responseObject mj_JSONObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:title
                                                   delegate:nil
                                          cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
    
#pragma clang diagnostic pop
    
}


- (UIImageView *)headerImageV{
    if (!_headerImageV) {
        _headerImageV = [[UIImageView alloc] init];
    }
    return _headerImageV;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:16];
    }
    return _nameLabel;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end

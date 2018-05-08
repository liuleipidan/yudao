//
//  YDRankingListCollectionCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDRankingListCollectionCell.h"

@interface YDRankingListCollectionCell()

@property (nonatomic, strong) UIImageView *rankImgV;

@property (nonatomic, strong) UILabel *rankLabel;

@property (nonatomic, strong) UIImageView *avatarImgV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *dataLabel;

@end

@implementation YDRankingListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView yd_addSubviews:@[self.avatarImgV,self.rankImgV,self.rankLabel,self.nameLabel,self.dataLabel]];
        [self y_addMasonry];
    }
    return self;
}

- (void)setDataType:(YDRankingListDataType )dataType
              model:(YDListModel *)model
            ranking:(NSUInteger )ranking{
    ranking += 1;
    _rankImgV.image = [UIImage imageNamed:[YDListModel rankingImageByRank:ranking]];
    _rankLabel.text = [NSString stringWithFormat:@"%lu",ranking];
    [_avatarImgV yd_setImageWithString:model.ud_face placeholaderImageString:[model.ud_sex isEqual:@1] ? kDefaultAvatarPathMale : kDefaultAvatarPath showIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleGray];
    _nameLabel.text = model.ub_nickname;
    NSString *dataString = nil;
    switch (dataType) {
        case YDRankingListDataTypeMileage:
        {
            dataString = [NSString stringWithFormat:@"里程 %.1fKM",model.oti_mileage?model.oti_mileage.floatValue:0.f];
            break;}
        case YDRankingListDataTypeSpeed:
        {
            dataString = [NSString stringWithFormat:@"时速 %ldKM/H",model.oti_speed?model.oti_speed.integerValue:0];
            break;}
        case YDRankingListDataTypeOilwear:
        {
            dataString = [NSString stringWithFormat:@"油耗 %.1fL",model.oti_oilwear?model.oti_oilwear.floatValue:0.f];
            break;}
        case YDRankingListDataTypeStop:
        {
            dataString = [NSString stringWithFormat:@"滞留 %ld分钟",model.oti_stranded?model.oti_stranded.integerValue:0];
            break;}
        case YDRankingListDataTypeScore:
        {
            dataString = [NSString stringWithFormat:@"%@ 积分",YDNoNilNumber(model.ud_credit)];
            break;}
        case YDRankingListDataTypeLike:
        {
            dataString = [NSString stringWithFormat:@"%@ 人喜欢",YDNoNilNumber(model.enjoynum)];
            break;}
        default:
            dataString = model.ud_constellation;
            break;
    }
    _dataLabel.text = dataString;
}

- (void)y_addMasonry{
    [_avatarImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.width.equalTo(self.avatarImgV.mas_height);
    }];
    
    [_rankImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(7);
        make.size.mas_equalTo(CGSizeMake(18, 24));
    }];
    
    [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rankImgV).insets(UIEdgeInsetsMake(0, 0, 6, 0));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.avatarImgV.mas_bottom).offset(7);
        make.height.mas_equalTo(14);
    }];
    
    [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(12);
    }];
}

#pragma mark - Getter
- (UIImageView *)rankImgV{
    if (!_rankImgV) {
        _rankImgV = [[UIImageView alloc] init];
    }
    return _rankImgV;
}

- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont pingFangSC_MediumFont:16] textAlignment:NSTextAlignmentCenter];
    }
    return _rankLabel;
}

- (UIImageView *)avatarImgV{
    if (!_avatarImgV) {
        _avatarImgV = [[UIImageView alloc] init];
        _avatarImgV.backgroundColor = [UIColor whiteColor];
        _avatarImgV.layer.cornerRadius = 8.0f;
        _avatarImgV.clipsToBounds = YES;
    }
    return _avatarImgV;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:14] textAlignment:0 backgroundColor:[UIColor whiteColor]];
        
    }
    return _nameLabel;
}

- (UILabel *)dataLabel{
    if (!_dataLabel) {
        _dataLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_12] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    }
    return _dataLabel;
}


@end

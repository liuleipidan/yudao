//
//  YDSingleVisitorCell.m
//  YuDao
//
//  Created by 汪杰 on 17/1/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSingleVisitorCell.h"

@implementation YDSingleVisitorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(17);
            make.width.mas_lessThanOrEqualTo(150);
        }];
        
    }
    return self;
}


- (void)setVisitorType:(YDVisitorType)visitorType{
    _visitorType = visitorType;
    /*
    NSString *imageString = nil;
    if (_visitorType == YDVisitorTypeForMe) {
        imageString = @"mine_likePerson_gift";
    }else{
        imageString = @"mine_contacts_newfriend";
    }
    [self.addButton setImage:[UIImage imageNamed:imageString] imageHL:[UIImage imageNamed:imageString]];
     */
}


//访客信息
- (void)setVisitorModel:(YDVisitorsModel *)visitorModel{
    _visitorModel = visitorModel;
    
    [self.avatarImageView yd_setImageWithString:_visitorModel.ud_face placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:1];
    
    self.usernameLabel.text = _visitorModel.ub_nickname;
    
    _timeLabel.text = visitorModel.timeInfo;
}


- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [YDUIKit labelTextColor:[UIColor grayTextColor] fontSize:12 textAlignment:NSTextAlignmentRight];
    }
    return _timeLabel;
}

@end

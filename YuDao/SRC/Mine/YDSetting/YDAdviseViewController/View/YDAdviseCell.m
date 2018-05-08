//
//  YDAdviseCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDAdviseCell.h"
#import "YDAdviseAnswerView.h"

@interface YDAdviseCell()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIView *answerView;


@end

@implementation YDAdviseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor grayBackgoundColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self ac_initSubviews];
        [self ac_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setItem:(YDAdvise *)item{
    if (_item && [_item.fb_id isEqual:item.fb_id]) {
        return;
    }
    
    [_avatarImageView yd_setImageWithString:[YDUserDefault defaultUser].user.ud_face placeholaderImageString:kDefaultAvatarPath];
    
    _nameLabel.text = [YDUserDefault defaultUser].user.ub_nickname;
    
    NSDate *date = [NSDate dateFromTimeStamp:item.time];
    _timeLabel.text = [date formatYMD];
    
    _contentLabel.text = item.content;
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(item.contentHeight);
    }];
    
    [_answerView removeAllSubViews];
    __block CGFloat answerViewHeight = 0;
    __block NSMutableArray *subViews = [NSMutableArray array];
    [item.answers enumerateObjectsUsingBlock:^(YDAdviseAnswer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        answerViewHeight += obj.allHeight;
        YDAdviseAnswerView *answerView = [YDAdviseAnswerView new];
        [answerView setItem:obj];
        [subViews addObject:answerView];
        [_answerView addSubview:answerView];
        if (idx == 0) {
            [answerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_answerView);
            }];
        }
        else{
            YDAdviseAnswerView *lastAnswerView = [subViews objectAtIndex:idx-1];
            [answerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAnswerView.mas_bottom);
            }];
        }
        
        [answerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(obj.allHeight);
        }];
    }];
    [_answerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(answerViewHeight);
    }];
    
    [subViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_answerView);
    }];
    
}

#pragma mark - Private Methods
- (void)ac_initSubviews{
    _avatarImageView = [UIImageView new];
    _avatarImageView.layer.cornerRadius = 20.0f;
    _avatarImageView.clipsToBounds = YES;
    
    _nameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    
    _timeLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12]];
    
    _contentLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    _contentLabel.numberOfLines = 3;
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor lineColor1];
    
    _answerView = [UIView new];
    _avatarImageView.backgroundColor = [UIColor redColor];
    
    [self.contentView yd_addSubviews:@[_avatarImageView,_nameLabel,_timeLabel,_contentLabel,_bottomLine,_answerView]];
}

- (void)ac_addMasonry{
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView).offset(15);
        make.width.height.mas_equalTo(40);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_top);
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarImageView.mas_bottom);
        make.left.equalTo(_nameLabel.mas_left);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_avatarImageView.mas_bottom).offset(7);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(_contentLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    [_answerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomLine.mas_left);
        make.right.equalTo(_bottomLine.mas_right);
        make.top.equalTo(_bottomLine.mas_bottom);
    }];
    
}

#pragma mark - Getter
//- (NSMutableArray<YDAdviseAnswerView *> *)answerViews{
//    if (_answerViews == nil) {
//
//    }
//    return _answerViews;
//}

@end

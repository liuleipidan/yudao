//
//  YDMomentCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMomentCell.h"

@interface YDMomentCell()

@end

@implementation YDMomentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self mc_setupSubviews];
        [self mc_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setMoment:(YDMoment *)moment{
    
    _moment = moment;
    
    [_headerView setMomentUserInfo:moment];
    
    [_textView setMomentFrame:moment.frame];
    
    [_textView setText:moment.attrContent location:moment.d_address];
    
    [_bottomView setLeftButtonCount:moment.taplikenum centerBtnCount:moment.commentnum likeState:moment.state];
    
}

#pragma mark - YDMomentHeaderViewDelegate
- (void)momentHedaerViewClickUserAvatar:(YDMoment *)moment{
    if (self.delegate && [self.delegate respondsToSelector:@selector(momentHedaerViewClickUserAvatar:)]) {
        [self.delegate momentHedaerViewClickUserAvatar:self.moment];
    }
}

- (void)momentHedaerViewClickRightButton:(UIButton *)btn moment:(YDMoment *)moment{
    if (self.delegate && [self.delegate respondsToSelector:@selector(momentHedaerViewClickRightButton:moment:)]) {
        [self.delegate momentHedaerViewClickRightButton:btn moment:self.moment];
    }
}

#pragma mark - YDMomentBottomViewDelegate

- (void)mc_setupSubviews{
    _headerView = [[YDMomentHeaderView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.delegate = self;
    
    _textView = [[YDMomentTextView alloc] init];
    
    YDWeakSelf(self);
    _bottomView = [[YDMomentBottomView alloc] initWithLeftBtnAction:^{
        NSLog(@"赞");
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(momentBottomViewClickLeftButton:moment:)]) {
            [weakself.delegate momentBottomViewClickLeftButton:weakself.bottomView.leftBtn moment:weakself.moment];
        }
    } centerBtnAction:^{
        NSLog(@"评论");
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(momentBottomViewClickCenterButton:moment:)]) {
            [weakself.delegate momentBottomViewClickCenterButton:weakself.bottomView.centerBtn moment:weakself.moment];
        }
    } rightBtnAction:^{
        NSLog(@"分享");
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(momentBottomViewClickRightButton:moment:)]) {
            [weakself.delegate momentBottomViewClickRightButton:weakself.bottomView.rightBtn moment:weakself.moment];
        }
    }];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView yd_addSubviews:@[_headerView,_textView,_bottomView]];
}

- (void)mc_addMasonry{
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        //make.top.equalTo(_imagesView.mas_bottom).offset(9);
        make.bottom.equalTo(_bottomView.mas_top).offset(-11);
        make.height.mas_equalTo(0);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(56);
    }];
    
}

@end

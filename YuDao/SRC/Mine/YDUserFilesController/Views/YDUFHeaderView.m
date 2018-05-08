//
//  YDUFHeaderView.m
//  YuDao
//
//  Created by 汪杰 on 16/12/29.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUFHeaderView.h"

@implementation YDUFHeaderView

- (id)init{
    if (self = [super init]) {
        
        [self y_layoutSubviews];
    }
    return self;
}

#pragma mark - Public Methods - 刷新数据
- (void)updateDataWith:(NSString *)headerUrl name:(NSString *)name start:(NSString *)start gender:(NSInteger )gender level:(NSString *)level likeNum:(NSNumber *)likeNum score:(NSNumber *)score backgroudImageUrl:(NSString *)backgroudImageUrl{
    [self.headerImageV sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:gender == 1 ? kDefaultAvatarPathMale : kDefaultAvatarPath]];
    self.nameLabel.text = name;
    self.startLabel.text = start;
    
    [_levelLabel setLabelAttributeWithContent:level footString:@"  等级"];
    [_likeLabel setLabelAttributeWithContent:[NSString stringWithFormat:@"%@",likeNum?likeNum:@"0"] footString:@"  喜欢"];
    [self.scoreLabel setLabelAttributeWithContent:[NSString stringWithFormat:@"%@",score?score:@"0"] footString:@"  积分"];
    
    [self.backImageV yd_setImageWithString:backgroudImageUrl showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    if (gender == 1) {self.genderImageV.image = [UIImage imageNamed:@"userFiles_man"];}
    if (gender == 2) {self.genderImageV.image = [UIImage imageNamed:@"userFiles_woman"];}
}

- (void)setLabelAttributeText:(UILabel *)label content:(NSString *)content footString:(NSString *)footString{
    NSString *originStr = [content stringByAppendingString:footString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:originStr];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(originStr.length-2, 2)];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(originStr.length-4, 2)];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, originStr.length-4)];
    label.attributedText = attributeString;
}

- (void)y_layoutSubviews{
    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [self sd_addSubviews:@[self.backImageV,self.headerImageV,self.genderImageV,self.scrollImage,self.nameLabel,self.startLabel,self.levelLabel,self.likeLabel,self.scoreLabel]];
    
    //float y = 1.0f/3.0f * SCREEN_WIDTH;
    CGFloat bgImageVHeight = SCREEN_WIDTH * 2.0f / 3.0f;
    _backImageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, bgImageVHeight);
    
    [_backImageV addSubview:self.overView];
    _overView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _headerImageV.frame = CGRectMake(24, bgImageVHeight-kWidth(94)/2.0, kWidth(94), kWidth(94));
    _headerImageV.layer.cornerRadius = kWidth(94)/2.0;
    
    
    _genderImageV.frame = CGRectMake(CGRectGetMaxX(_headerImageV.frame)-24, CGRectGetMaxY(_headerImageV.frame)-24, 20, 20);
    _scrollImage.frame = CGRectMake((SCREEN_WIDTH-30)/2, bgImageVHeight-17, 30, 10);
    
    _startLabel.sd_layout
    .bottomEqualToView(_headerImageV)
    .leftSpaceToView(_headerImageV,22)
    .heightIs(17)
    .widthIs(60);
    
    _nameLabel.sd_layout
    .leftEqualToView(_startLabel)
    .bottomSpaceToView(_startLabel,kHeight(5))
    .rightEqualToView(_backImageV)
    .heightIs(20);
    
    UIView *line = [UIView new];
    UIView *leftLine = [UIView new];
    UIView *rightLine = [UIView new];
    [@[line,leftLine,rightLine] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = obj;
        view.backgroundColor = YDSeperatorColor;
        [self addSubview:view];
    }];
    line.sd_layout
    .topSpaceToView(_headerImageV,15)
    .leftSpaceToView(self,14)
    .rightSpaceToView(self,14)
    .heightIs(1);
    leftLine.sd_layout
    .leftSpaceToView(self,SCREEN_WIDTH/3-0.5)
    .topSpaceToView(line,12)
    .heightIs(22)
    .widthIs(1);
    rightLine.sd_layout
    .topEqualToView(leftLine)
    .rightSpaceToView(self,SCREEN_WIDTH/3+0.5)
    .heightIs(22)
    .widthIs(1);
    
    self.levelLabel.sd_layout
    .leftSpaceToView(self,0)
    .rightSpaceToView(leftLine,0)
    .centerYEqualToView(leftLine)
    .heightIs(21);
    
    self.likeLabel.sd_layout
    .leftSpaceToView(leftLine,0)
    .rightSpaceToView(rightLine,0)
    .centerYEqualToView(leftLine)
    .heightIs(21);
    
    self.scoreLabel.sd_layout
    .leftSpaceToView(rightLine,0)
    .rightSpaceToView(self,0)
    .centerYEqualToView(leftLine)
    .heightIs(21);
    
    UIView *bottomline = [UIView new];
    bottomline.backgroundColor = [UIColor colorWithString:@"#EBEBEB"];
    [self addSubview:bottomline];
    bottomline.sd_layout
    .topSpaceToView(line, 49)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(10);
    
    whiteView.sd_layout
    .topSpaceToView(_backImageV,0)
    .bottomSpaceToView(bottomline,0)
    .leftEqualToView(self)
    .rightEqualToView(self);
    
    //[self setupAutoHeightWithBottomView:bottomline bottomMargin:0];
}


#pragma mark - Events
- (void)panScrollImage:(UIGestureRecognizer *)swipe{
    YDLog(@"swipeScrollImage");
}

- (void)tapHeaderImageViewAction:(UITapGestureRecognizer *)tap{
    if (self.subDelegate  && [self.subDelegate respondsToSelector:@selector(UFHeaderView:didSelectedHeaderImageView:)]) {
        [self.subDelegate UFHeaderView:self didSelectedHeaderImageView:(UIImageView *)tap.view];
    }
}

- (UIView *)overView{
    if (!_overView) {
        _overView = [[UIView alloc] init];
        _overView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    }
    return _overView;
}
- (UIImageView *)backImageV{
    if (!_backImageV) {
        _backImageV = [[UIImageView alloc] init];
        _backImageV.contentMode = UIViewContentModeScaleAspectFill;
        _backImageV.clipsToBounds = YES;
        //_backImageV.backgroundColor = [UIColor colorWithString:@"#FF2B3552"];
    }
    return _backImageV;
}

- (UIImageView *)headerImageV{
    if (!_headerImageV) {
        _headerImageV = [[UIImageView alloc] init];
        _headerImageV.backgroundColor = [UIColor whiteColor];
        _headerImageV.layer.borderColor = [UIColor whiteColor].CGColor;
        _headerImageV.layer.borderWidth = 1.f;
        _headerImageV.layer.masksToBounds = YES;
        _headerImageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderImageViewAction:)];
        [_headerImageV addGestureRecognizer:tap];
    }
    return _headerImageV;
}

- (UIImageView *)genderImageV{
    if (!_genderImageV) {
        _genderImageV = [[UIImageView alloc] init];
    }
    return _genderImageV;
}
- (UIImageView *)scrollImage{
    if (!_scrollImage) {
        _scrollImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userFiles_bottomPush"]];
        // 移动手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panScrollImage:)];
        
        [_scrollImage addGestureRecognizer:panGestureRecognizer];
    }
    return _scrollImage;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:16];
        
    }
    return _nameLabel;
}

- (UILabel *)startLabel{
    if (!_startLabel) {
        _startLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:12];
        
    }
    return _startLabel;
}

- (UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:20 textAlignment:NSTextAlignmentCenter];
    }
    return _levelLabel;
}
- (UILabel *)likeLabel{
    if (!_likeLabel) {
        _likeLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:20 textAlignment:NSTextAlignmentCenter];
    }
    return _likeLabel;
}
- (UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:20 textAlignment:NSTextAlignmentCenter];
    }
    return _scoreLabel;
}
@end

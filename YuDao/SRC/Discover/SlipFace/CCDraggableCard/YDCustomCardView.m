//
//  CustomCardView.m
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 China-SQP. All rights reserved.
//

#import "YDCustomCardView.h"

@interface YDCustomCardView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView     *view;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *genderImageV;

@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *starLabel;
@property (nonatomic, strong) UILabel *placeLabel;

@property (nonatomic, strong) UIView *interestView;

@end

@implementation YDCustomCardView

- (instancetype)init {
    if (self = [super init]) {
        [self loadComponent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadComponent];
    }
    return self;
}

- (void)loadComponent {
    self.imageView = [[UIImageView alloc] init];
    self.view = [[UIView alloc] init];
    self.nameLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:16];
    self.genderImageV = [[UIImageView alloc] init];
    self.ageLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:12];
    self.starLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:12];
    self.placeLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:12];
    self.interestView = [[UIView alloc] init];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView.layer setMasksToBounds:YES];
    
    [self addSubview:self.imageView];
    [self.view sd_addSubviews:@[self.nameLabel,self.genderImageV,self.ageLabel,self.starLabel,self.interestView,self.placeLabel]];
    [self addSubview:self.view];
    
    self.backgroundColor = [UIColor colorWithRed:0.951 green:0.951 blue:0.951 alpha:1.00];
}

- (void)cc_layoutSubviews {
    self.imageView.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 90);
    self.view.frame = CGRectMake(0, self.frame.size.height - 90, self.frame.size.width, 90);
    _nameLabel.sd_layout
    .topSpaceToView(_view,10)
    .leftSpaceToView(_view,20)
    .heightIs(21);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _genderImageV.sd_layout
    .centerYEqualToView(_nameLabel)
    .leftSpaceToView(_nameLabel,7)
    .heightIs(16)
    .widthIs(16);
    
    _ageLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel,7)
    .heightIs(17);
    [_ageLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:@"#B6C5DC"];
    [_view addSubview:lineView];
    lineView.sd_layout
    .centerYEqualToView(_ageLabel)
    .leftSpaceToView(_ageLabel,5)
    .heightIs(10)
    .widthIs(1);
    
    _starLabel.sd_layout
    .centerYEqualToView(_ageLabel)
    .leftSpaceToView(lineView,5)
    .heightIs(17);
    [_starLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = [UIColor colorWithString:@"#B6C5DC"];
    [_view addSubview:lineView1];
    lineView1.sd_layout
    .centerYEqualToView(_ageLabel)
    .leftSpaceToView(_starLabel,5)
    .heightIs(10)
    .widthIs(1);
    
    _placeLabel.sd_layout
    .centerYEqualToView(_ageLabel)
    .leftSpaceToView(lineView1,5)
    .heightIs(17)
    .widthIs(100);
    
    _interestView.sd_layout
    .topSpaceToView(_ageLabel,0)
    .bottomEqualToView(_view)
    .leftEqualToView(_ageLabel)
    .rightSpaceToView(_view,10);
}

- (void)installData:(NSDictionary *)element {
    self.imageView.image  = [UIImage imageNamed:element[@"image"]];
    //self.titleLabel.text = element[@"title"];
}

- (void)setModel:(YDSlipFaceModel *)model{
    _model = model;
    
    [_imageView yd_setImageWithString:model.ud_face placeholaderImageString:[model.ud_sex isEqual:@1] ? kDefaultAvatarPathMale : kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
    
    _nameLabel.text = model.ub_nickname;
    
    NSString *genderString = nil;
    genderString = model.ud_sex.integerValue == 1 ? @"userFiles_man": @"userFiles_woman";
    _genderImageV.image = [UIImage imageNamed:genderString];
    
    //年龄为nil或0，显示保密
    if (model.ud_age == nil || [model.ud_age isEqual:@0]) {
        _ageLabel.text = @"保密";
    }
    else{
        _ageLabel.text = [NSString stringWithFormat:@"%@岁",model.ud_age];
    }
    
    _starLabel.text = model.ud_constellation;
    
    NSString *distancString = @"离你很近哟";
    if (model.distance.floatValue > 100 && model.distance.floatValue <= 200) {
        distancString = [NSString stringWithFormat:@"%dm以内",200];
    }
    else if (model.distance.floatValue > 200 && model.distance.floatValue <= 500) {
        distancString = [NSString stringWithFormat:@"%dm以内",500];
    }
    else if (model.distance.floatValue > 500 && model.distance.floatValue <= 1000){
        distancString = [NSString stringWithFormat:@"%dkm以内",1];
    }
    else if (model.distance.floatValue > 1000){
        distancString = [NSString stringWithFormat:@"<%ldkm",(NSInteger)(model.distance.floatValue/1000)];
    }
    
    _placeLabel.text = distancString;
    
    __block NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:model.interestArray.count];
    [model.interestArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [YDUIKit labelWithTextColor:[UIColor colorWithString:@"#9B9B9B"] text:obj fontSize:12 textAlignment:NSTextAlignmentLeft];
        [_interestView addSubview:label];
        [tempArray addObject:label];
        if (idx == 0) {
            label.sd_layout
            .centerYEqualToView(_interestView)
            .leftEqualToView(_interestView)
            .heightIs(21);
            [label setSingleLineAutoResizeWithMaxWidth:100];
        }else{
            UIView *view = [tempArray objectAtIndex:idx-1];
            label.sd_layout
            .centerYEqualToView(_interestView)
            .leftSpaceToView(view,7)
            .heightIs(21);
            [label setSingleLineAutoResizeWithMaxWidth:100];
        }
    }];
}

@end

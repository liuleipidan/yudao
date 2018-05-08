//
//  YDRecueDetailController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDRescueDetailController.h"
#import "YDMapView.h"
#import "YDRescueBottomTool.h"
#import "YDPointAnnotation.h"
#import "YDUserAnnotationView.h"
#import "YDMapTool.h"
#import "YDUserLocation.h"

@interface YDRescueDetailController ()<BMKMapViewDelegate,YDRescueBottomToolDelegate>

@property (nonatomic, strong) YDRescueBottomTool *tool;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *topImgV;

@property (nonatomic, strong) UIImageView *avatarImgV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *gradeLabel;

@property (nonatomic, strong) UILabel *detailsLabel;

@property (nonatomic, strong) UIImageView *locImgV;

@property (nonatomic, strong) UILabel *locLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) YDMapView *mapView;

@end

@implementation YDRescueDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self rdc_initUI];
    
    [self reloadData];
}

- (void)reloadData{
    if (_data) {
        [_avatarImgV yd_setImageWithString:_data.avatarURL placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
        _nameLabel.text = _data.name;
        _detailsLabel.text = _data.details;
        _locLabel.text = _data.address;
        if (_data.distance) {
            _locLabel.text = [NSString stringWithFormat:@"%@,%@",_data.address,_data.distance];
        }
        
        YDPointAnnotation *annotation = [YDPointAnnotation pointAnnotationWith:_data.coor title:_data.name];
        [_mapView addAnnotation:annotation];
        [_mapView setCenterCoordinate:_data.coor];
    }
}

#pragma mark - YDRescueBottomToolDelegate
- (void)rescueBottomTool:(YDRescueBottomTool *)tool selectedBtn:(UIButton *)btn{
    NSUInteger index = btn.tag - 1000;
    switch (index) {
        case 0:
        {
            
            break;}
        case 1:
        {
            [YDMapTool showNavigationPresentViewController:self startCoor:[YDUserLocation sharedLocation].userLocation.location.coordinate endCoor:_data.coor isWalk:_data.isWalk];
            break;}
        case 2:
        {
            
            break;}
            
        default:
            break;
    }
}

#pragma mark - BMKMapViewDelegate
/**
 *返回标注视图
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation.title isEqualToString:_data.name]) {
        YDUserAnnotationView *userAn = [[YDUserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userAnnotation"];
        //userAn.centerOffset = CGPointMake(0, -28);
        userAn.canShowCallout = NO;
        [userAn setAvatarUrl:_data.avatarURL];
        return userAn;
    }
    return nil;
}

- (void)rdc_initUI{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _tool = [YDRescueBottomTool new];
    _tool.delegate = self;
    [self.view yd_addSubviews:@[_tool,_scrollView]];
    
    [_tool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.tool.mas_top).offset(0);
    }];
    _containerView = [[UIView alloc] init];
    [_scrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    _topImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"first_launchImage_2"]];
    _avatarImgV = [UIImageView new];
    _avatarImgV.layer.cornerRadius = 30.0f;
    _avatarImgV.layer.masksToBounds = YES;
    _nameLabel = [YDUIKit labelWithTextColor:YDBaseColor text:@"也罢" fontSize:16 textAlignment:NSTextAlignmentLeft];
    _gradeLabel = [YDUIKit labelWithTextColor:[UIColor grayTextColor] text:@"LV5 | 认证用户" fontSize:12 textAlignment:NSTextAlignmentLeft];
    [_containerView yd_addSubviews:@[_topImgV,_avatarImgV,_nameLabel,_gradeLabel]];
    
    [_topImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView);
        make.height.equalTo(self.topImgV.mas_width).multipliedBy(0.57);
    }];
    [_avatarImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(10);
        make.top.equalTo(self.topImgV.mas_bottom).offset(11);
        make.width.height.mas_equalTo(60);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgV.mas_right).offset(16);
        make.top.equalTo(self.avatarImgV.mas_top).offset(9);
        make.right.equalTo(self.containerView).offset(-10);
        make.height.mas_equalTo(22);
    }];
    [_gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImgV.mas_bottom).offset(-5);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.nameLabel);
        make.height.mas_equalTo(17);
    }];
    UIView *line = [UIView new];
    line.backgroundColor = YDColorString(@"#C7C7CC");
    line.alpha = 0.3;
    [_containerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(10);
        make.right.equalTo(self.containerView).offset(-10);
        make.top.equalTo(self.avatarImgV.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    _detailsLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:14 textAlignment:NSTextAlignmentLeft];
    _detailsLabel.text = @"爆胎了！不会换胎求救援！爆胎了！不会换胎求救援！爆胎了！不会换胎求救援！爆胎了！不会换胎求救援！爆胎了！不会换胎求救援！爆胎了！不会换胎求救援！爆胎了！不会换胎求救援！爆胎了！不会换胎求救援！爆胎了！不会换胎求救援！";
    _detailsLabel.numberOfLines = 0;
    _timeLabel = [YDUIKit labelTextColor:[UIColor grayTextColor] fontSize:10 textAlignment:NSTextAlignmentRight];
    _timeLabel.text = @"刚刚";
    _locImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardriving_location"]];
    _locLabel = [YDUIKit labelTextColor:[UIColor grayTextColor] fontSize:12];
    
    _mapView = [YDMapView mapViewWithDelegate:self];
    _mapView.layer.cornerRadius = 8;
    _mapView.layer.masksToBounds = YES;
    _mapView.zoomLevel = 18;
    [_containerView yd_addSubviews:@[_detailsLabel,_timeLabel,_locImgV,_locLabel,_mapView]];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(14);
        make.right.equalTo(self.containerView).offset(-10);
        make.height.mas_equalTo(14);
        make.width.mas_lessThanOrEqualTo(50);
    }];
    
    [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(10);
        make.left.equalTo(self.containerView).offset(10);
        make.right.equalTo(self.timeLabel.mas_left).offset(-5);
        make.height.mas_lessThanOrEqualTo(200);
    }];
    
    [_locImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(10);
        make.top.equalTo(self.detailsLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(17);
    }];
    [_locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.locImgV);
        make.left.equalTo(self.locImgV.mas_right).offset(6);
        make.height.mas_equalTo(17);
        make.right.equalTo(self.containerView).offset(-10);
    }];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locImgV.mas_bottom).offset(10);
        make.left.equalTo(self.containerView).offset(10);
        make.right.equalTo(self.containerView).offset(-10);
        make.height.equalTo(self.mapView.mas_width).multipliedBy(0.5);
        make.bottom.equalTo(self.containerView).offset(-14);
    }];
    
}

@end

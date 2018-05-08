//
//  YDCarIllegalityController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/18.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarIllegalityController.h"
#import "YDCarIllegalityHeaderView.h"
#import "YDCarIllegalityController+Delegate.h"
#import "YDNoCarIllealityView.h"

#define kIllegalDataURL [kOriginalURL stringByAppendingString:@"wzquery"]

@interface YDCarIllegalityController ()

@property (nonatomic, strong) YDCarIllegalityHeaderView *headerView;

@property (nonatomic, strong) YDTableView *tableView;

@property (nonatomic, strong) YDNoCarIllealityView *noIllegalityView;

@property (nonatomic, strong) UIButton *returnButton;

@end

@implementation YDCarIllegalityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view yd_addSubviews:@[self.headerView,self.returnButton,self.tableView,self.noIllegalityView]];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(224);
    }];
    
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.top.equalTo(self.view).offset(30);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.noIllegalityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(80);
        make.size.mas_equalTo(CGSizeMake(180, 90));
    }];
    
    YDCarDetailModel *car = [[YDCarHelper sharedHelper] getOneCarWithCarid:self.ug_id];
    
    NSString *plateNumber = @"未填写";
    if (car.ug_plate.length > 1) {
        NSString *subString1 = [car.ug_plate substringWithRange:NSMakeRange(0, 1)];
        NSString *subString2 = [car.ug_plate substringWithRange:NSMakeRange(1, car.ug_plate.length-1)];
        plateNumber = [NSString stringWithFormat:@"%@ %@",subString1,subString2];
    }
    [self.headerView setPlateNumbaer:[NSString stringWithFormat:@"%@%@",YDNoNilString(car.ug_plate_title),plateNumber] carSeries:car.ug_series_name];
    
    [self requestCarIllegality];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Events
- (void)cic_returnButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestCarIllegality{
    [YDLoadingHUD showLoadingInView:self.view];
    NSDictionary *param = @{
                            @"access_token":YDAccess_token,
                            @"ug_id":YDNoNilNumber(self.ug_id)
                            };
    [YDNetworking GET:kIllegalDataURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        self.data = [YDIllegalModel mj_objectArrayWithKeyValuesArray:data];
        if (self.data.count == 0) {
            self.noIllegalityView.hidden = NO;
            self.tableView.hidden = YES;
        }
        else{
            self.noIllegalityView.hidden = YES;
            self.tableView.hidden = NO;
            __block NSInteger allPrice = 0;
            __block NSInteger allScore = 0;
            [self.data enumerateObjectsUsingBlock:^(YDIllegalModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                allPrice += obj.price.integerValue;
                allScore += obj.score.integerValue;
            }];
            [self.headerView setFines:[NSString stringWithFormat:@"%ld",allPrice] score:[NSString stringWithFormat:@"%ld",allScore]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        self.noIllegalityView.hidden = NO;
        self.tableView.hidden = YES;
    }];
}


#pragma mark - Getter
- (YDCarIllegalityHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[YDCarIllegalityHeaderView alloc] init];
    }
    return _headerView;
}

- (YDTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDTableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[YDCarIllegalityCell class] forCellReuseIdentifier:@"YDCarIllegalityCell"];
    }
    return _tableView;
}

- (YDNoCarIllealityView *)noIllegalityView{
    if (_noIllegalityView == nil) {
        _noIllegalityView = [[YDNoCarIllealityView alloc] initWithFrame:CGRectZero];
        _noIllegalityView.hidden = YES;
    }
    return _noIllegalityView;
}

- (UIButton *)returnButton{
    if (_returnButton == nil) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnButton setImage:@"navigation_back_image" imageHL:@"navigation_back_image"];
        [_returnButton addTarget:self action:@selector(cic_returnButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnButton;
}


@end

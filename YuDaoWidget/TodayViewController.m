//
//  TodayViewController.m
//  YuDaoWidget
//
//  Created by 汪杰 on 17/3/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TodayCollectionCell.h"


@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) BOOL hadLogin;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self init_UI];
    
}

- (void)init_UI{
    CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
    //CGFloat kHeight = [UIScreen mainScreen].bounds.size.height;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((kWidth-30)/3, 100);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView.collectionViewLayout = layout;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"TodayCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TodayCollectionCell"];
    
    _promptLabel.hidden = YES;
    _promptLabel.userInteractionEnabled = YES;
    [_promptLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tdv_tapPromptLabelAction:)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
- (void)tdv_tapPromptLabelAction:(UIGestureRecognizer *)tap{
    [self openURLContainingAppWithIndex:-1];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TodayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TodayCollectionCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.subTitleLabel.text = self.data[indexPath.row];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self openURLContainingAppWithIndex:indexPath.row];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    NSLog(@"widgetPerformUpdateWithCompletionHandler");
    [self readDataFromUserDefaults];
    [self.collectionView reloadData];
    completionHandler(NCUpdateResultNewData);
}

- (void)openURLContainingAppWithIndex:(NSInteger )index{
    //通过extensionContext借助host app调起app
    /*
        组建URL。
        scheme：来源为YuDaoWidget
        host：功能表示，目前为行车信息（carInformation)
        query:具体功能的索引（0->历程，1->百公里油耗,2->车辆评分）
     */
    NSString *schemeString = [NSString stringWithFormat:@"YuDaoWidget://carInformation?%ld",(long)index];
    [self.extensionContext openURL:[NSURL URLWithString:schemeString] completionHandler:^(BOOL success) {
        
    }];
}

- (void)readDataFromUserDefaults{
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ve-link.YuDaoApp"];
    _hadLogin = [shared boolForKey:@"kHadLogin"];
    NSNumber *boundtype = [shared valueForKey:@"boundtype"];
    NSString *oilWear = [shared valueForKey:@"oilWear"];
    NSString *mileage = [shared valueForKey:@"mileage"];
    NSString *test = [shared valueForKey:@"test"];
    _data = @[  [NSString stringWithFormat:@"%@",mileage?mileage:@"0KM"],
                  [NSString stringWithFormat:@"%@",oilWear?oilWear:@"0L"],
                  [NSString stringWithFormat:@"%@",test?test:@"0"]];
    if (_hadLogin) {
        if ([boundtype isEqual:@1]) {
            _collectionView.hidden = NO;
            _promptLabel.hidden = YES;
        }
        else{
            _promptLabel.text = @"未绑定VE-BOX";
            _promptLabel.hidden = NO;
            _collectionView.hidden = YES;
        }
    }
    else{
        _promptLabel.text = @"未登录";
        _promptLabel.hidden = NO;
        _collectionView.hidden = YES;
    }
    
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"里程",@"百公里油耗",@"评分"];
    }
    return _titles;
}

- (NSArray *)data{
    if (!_data) {
        _data = @[@"0KM",@"0L",@"0"];
    }
    return _data;
}


@end

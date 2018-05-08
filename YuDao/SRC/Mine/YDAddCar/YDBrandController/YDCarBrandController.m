//
//  YDCarBrandController.m
//  YuDao
//
//  Created by 汪杰 on 16/11/9.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDCarBrandController.h"
#import "YDCarSeriesViewController.h"
#import "YDDBCarBrandStore.h"
#import "YDContactHeaderView.h"
#import "YDPopularCarBrandView.h"

#define kBrandURL [kOriginalURL stringByAppendingString:@"vbrand"]

@interface YDCarBrandController ()<YDPopularCarBrandViewDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *indexArray;

@property (nonatomic, strong) YDPopularCarBrandView *headerView;

@end

@implementation YDCarBrandController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"选择品牌"];
    
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView registerClass:[YDContactHeaderView class] forHeaderFooterViewReuseIdentifier:@"YDContactHeaderView"];
    
    //优先去数据库内容
    YDDBCarBrandStore *store = [YDDBCarBrandStore manager];
    NSArray *dataSouce = [store carBrands];
    if (dataSouce.count < kCarBrandDataCount) {
        YDLog(@"车辆品牌数量不足180条");
        [self requestCarBrandData];
    }
    else{
        self.indexArray = [YDCarBrand indexArrayFromDataSource:[store carBrands]];
        self.data = [YDCarBrand groupedArrayFormDataSource:[store carBrands]];
        [self.tableView reloadData];
    }
}

#pragma mark - Private Methods
- (void)requestCarBrandData{
    [YDLoadingHUD showLoadingInView:self.view];
    [YDNetworking GET:kBrandURL parameters:nil success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            NSArray *brands = [YDCarBrand mj_objectArrayWithKeyValuesArray:data];
            YDDBCarBrandStore *store = [YDDBCarBrandStore manager];
            if ([store insertCarBrands:brands]) {
                YDLog(@"DB:插入所有车辆品牌成功");
                self.indexArray = [YDCarBrand indexArrayFromDataSource:[store carBrands]];
                self.data = [YDCarBrand groupedArrayFormDataSource:[store carBrands]];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

//创建热门品牌数据
- (NSArray *)createPopularCarBrandData{
    YDCarBrand *brand0 = YDCreateCarBrandModel(@10, @"宝马", @"B", @"", @"brand_icon_bmw");
    YDCarBrand *brand1 = YDCreateCarBrandModel(@19, @"奥迪", @"A", @"", @"brand_icon_aodi");
    YDCarBrand *brand2 = YDCreateCarBrandModel(@30, @"捷豹", @"J", @"", @"brand_icon_jb");
    YDCarBrand *brand3 = YDCreateCarBrandModel(@35, @"路虎", @"L", @"", @"brand_icon_lh");
    YDCarBrand *brand4 = YDCreateCarBrandModel(@26, @"保时捷", @"B", @"", @"brand_icon_bsj");
    YDCarBrand *brand5 = YDCreateCarBrandModel(@59, @"英菲尼迪", @"Y", @"", @"brand_icon_yfld");
    YDCarBrand *brand6 = YDCreateCarBrandModel(@1, @"大众", @"D", @"", @"brand_icon_shdz");
    YDCarBrand *brand7 = YDCreateCarBrandModel(@9, @"本田", @"B", @"", @"brand_icon_bt");
    YDCarBrand *brand8 = YDCreateCarBrandModel(@24, @"别克", @"B", @"", @"brand_icon_bk");
    YDCarBrand *brand9 = YDCreateCarBrandModel(@57, @"雪佛兰", @"X", @"", @"brand_icon_xfl");
    return @[brand0,brand1,brand2,brand3,brand4,brand5,brand6,brand7,brand8,brand9];
}

#pragma mark - YDPopularCarBrandViewDelegate - 点击热门品牌
- (void)popularCarBrandView:(YDPopularCarBrandView *)view didSelectedItem:(YDCarBrand *)item{
    YDCarSeriesViewController *carSerVC = [YDCarSeriesViewController new];
    [carSerVC setBrand:item];
    
    [self.navigationController pushViewController:carSerVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data ? self.data.count: 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? [[self.data objectAtIndex:section] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *carBrandCellId = @"carBrandCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carBrandCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:carBrandCellId];
        cell.textLabel.textColor = [UIColor blackTextColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    YDCarBrand *model = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = model.vb_name;
    return cell;
}

////右侧索引标题数据源
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return self.indexArray;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YDContactHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YDContactHeaderView"];
    [view setTitle:[self.indexArray objectAtIndex:section]];
    return view;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDCarBrand *model = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    
    YDCarSeriesViewController *carSerVC = [YDCarSeriesViewController new];
    [carSerVC setBrand:model];
    
    [self.navigationController pushViewController:carSerVC animated:YES];
}

#pragma mark - Getter
- (YDPopularCarBrandView *)headerView{
    if (_headerView == nil) {
        _headerView = [[YDPopularCarBrandView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 172)];
        [_headerView setData:[self createPopularCarBrandData]];
        _headerView.delegate = self;
    }
    return _headerView;
}

@end

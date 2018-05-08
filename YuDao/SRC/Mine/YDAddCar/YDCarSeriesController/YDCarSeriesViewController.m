//
//  YDCarSeriesViewController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarSeriesViewController.h"
#import "YDContactHeaderView.h"
#import "YDAddCarController.h"

#define kCarSeriesURL [kOriginalURL stringByAppendingString:@"vseries"]

@interface YDCarSeriesViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *indexArray;

@end

@implementation YDCarSeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"选择车系"];
    
    [self.tableView registerClass:[YDContactHeaderView class] forHeaderFooterViewReuseIdentifier:@"YDContactHeaderView"];
    
    [self requestCarSeriesData];
}

- (void)requestCarSeriesData{
    [YDLoadingHUD showLoadingInView:self.view];
    NSDictionary *para = @{@"vaid":YDNoNilNumber(self.brand.vb_id)};
    [YDNetworking GET:kCarSeriesURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        NSArray *dataSource = [YDCarSeries mj_objectArrayWithKeyValuesArray:data];
        if (dataSource.count == 0) {
            [UIAlertController YD_OK_AlertController:self title:@"你选择的品牌暂无对应车系" clickBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else{
            NSArray *tempArr = [YDCarBrand sortedArrayFormDataSource:dataSource];
            self.indexArray = [YDCarBrand indexArrayFromDataSource:tempArr];
            self.data = [YDCarBrand groupedArrayFormDataSource:tempArr];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data ? self.data.count: 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data ? [[self.data objectAtIndex:section] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *carSeriesCellId = @"carSeriesCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carSeriesCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:carSeriesCellId];
        cell.textLabel.textColor = [UIColor blackTextColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    YDCarSeries *model = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = model.vs_name;
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
    YDCarSeries *model = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    YDAddCarController *addCarVC = [YDAddCarController new];
    YDCarDetailModel *carDetail = [YDCarDetailModel new];
    carDetail.vb_id = self.brand.vb_id;
    carDetail.vs_id = model.vs_id;
    carDetail.ug_brand_name = self.brand.vb_name;
    carDetail.ug_series_name = model.vs_name;
    
    addCarVC.carInfo = carDetail;
    [self.navigationController pushViewController:addCarVC animated:YES];
}

@end

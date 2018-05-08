//
//  YDTestOtherDataCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestOtherDataCell.h"
#import "YDTestOtherParamView.h"

@interface YDTestOtherDataCell()

@property (nonatomic, strong) YDTestOtherParamView *voltageView;

@property (nonatomic, strong) YDTestOtherParamView *coolanttempView;

@property (nonatomic, strong) YDTestOtherParamView *mileageView;

@end

@implementation YDTestOtherDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.bgImageView setImage:YDImage(@"test_other_bg")];
        
        self.titleLabel.text = @"其他参数";
        self.titleLabel.textColor = [UIColor whiteColor];
        
        [self.contentView yd_addSubviews:@[self.voltageView,self.coolanttempView,self.mileageView]];
        
        [_voltageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(86, 108));
        }];
        
        [_coolanttempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.voltageView);
            make.size.mas_equalTo(CGSizeMake(86, 108));
        }];
        
        [_mileageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-30);
            make.centerY.equalTo(self.voltageView);
            make.size.mas_equalTo(CGSizeMake(86, 108));
        }];
    }
    return self;
}

- (void)setModel:(YDTestsModel *)model{
    [super setModel:model];
    
    //三个月里程
    NSString *mileageText = [NSString stringWithFormat:@"%ld",model.mileage.integerValue];
    [_mileageView setData:mileageText status:@"公里"];
    
    /*电压和水温
     VE-BOX关闭时，显示设备已关闭
     VE-BOX开启时，显示对应数据
     */
    if ([model.isopen isEqual:@1]) {
        CGFloat voltage = model.voltage.floatValue;
        CGFloat coolanttemp = model.coolanttemp.floatValue;
        [_voltageView setData:[NSString stringWithFormat:@"%.2fV",voltage] status:@"正常"];
        [_coolanttempView setData:[NSString stringWithFormat:@"%ld℃",(NSInteger)coolanttemp] status:@"正常"];
    }
    else{
        [_voltageView setData:@"设备" status:@"已关闭"];
        [_coolanttempView setData:@"设备" status:@"已关闭"];
    }
    
}

#pragma mark - Getters
- (YDTestOtherParamView *)voltageView{
    if (_voltageView == nil) {
        _voltageView = [[YDTestOtherParamView alloc] initWithFrame:CGRectZero title:@"蓄电池电压"];
    }
    return _voltageView;
}

- (YDTestOtherParamView *)coolanttempView{
    if (_coolanttempView == nil) {
        _coolanttempView = [[YDTestOtherParamView alloc] initWithFrame:CGRectZero title:@"冷却液温度"];
    }
    return _coolanttempView;
}

- (YDTestOtherParamView *)mileageView{
    if (_mileageView == nil) {
        _mileageView = [[YDTestOtherParamView alloc] initWithFrame:CGRectZero title:@"三个月里程"];
    }
    return _mileageView;
}

@end

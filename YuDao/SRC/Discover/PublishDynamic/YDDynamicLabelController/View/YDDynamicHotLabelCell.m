//
//  YDDynamicHotLabelCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/3.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDynamicHotLabelCell.h"
#import "YDDynamicLabelButton.h"

@interface YDDynamicHotLabelCell()

@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation YDDynamicHotLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.promptLabel];
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
            make.height.mas_equalTo(21);
            make.width.mas_lessThanOrEqualTo(300);
        }];
    }
    return self;
}

- (void)setLabels:(NSMutableArray *)labels{
    _labels = labels;
    if (labels.count == 0) {
        _promptLabel.hidden = NO;
        _promptLabel.text = @"暂无热门标签";
        return;
    }
    _promptLabel.hidden = YES;
    [self.contentView removeAllSubViews];
    [labels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        NSString *title = [dic objectForKey:@"title"];
        NSValue *frameValue = [dic objectForKey:@"frame"];
        YDDynamicLabelButton *btn = [[YDDynamicLabelButton alloc] initWithFrame:frameValue.CGRectValue];
        [btn addTarget:self action:@selector(hl_labelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setText:title];
        [self.contentView addSubview:btn];
    }];
    
}

- (void)hl_labelButtonAction:(YDDynamicLabelButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(dynamicHotLabelCell:didSelctedLabel:)]) {
        [_delegate dynamicHotLabelCell:self didSelctedLabel:btn.text];
    }
}

#pragma mark - Getters
- (UILabel *)promptLabel{
    if (_promptLabel == nil) {
        _promptLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14]];
        _promptLabel.text = @"加载中...";
    }
    return _promptLabel;
}

@end

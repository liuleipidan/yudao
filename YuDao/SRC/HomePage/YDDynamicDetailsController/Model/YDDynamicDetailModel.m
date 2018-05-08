//
//  YDDynamicDetailModel.m
//  YuDao
//
//  Created by 汪杰 on 16/11/24.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDynamicDetailModel.h"

//用于计算动态详情的文本高度
static UILabel *dynamicSizeLabel;

@implementation YDDynamicDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"taplike":@"YDTapLikeModel",
             @"commentdynamic":@"YDDynamicCommentModel"
             };
}

- (id)init{
    if (self = [super init]) {
        dynamicSizeLabel = [[UILabel alloc] init];
        [dynamicSizeLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
        [dynamicSizeLabel setNumberOfLines:0];
    }
    return self;
}

#pragma mark - Getters
- (CGFloat)contentHeight{
    if (_contentHeight == 0) {
        if (self.d_details.length == 0) {
            _contentHeight = 34;
        }
        else{
            [dynamicSizeLabel setAttributedText:self.contentAttr];
            
            _contentHeight = [dynamicSizeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX)].height + 14;
        }
    }
    return _contentHeight;
}

- (NSMutableAttributedString *)contentAttr{
    if (_contentAttr == nil) {
        _contentAttr = [[NSMutableAttributedString alloc] initWithString:YDNoNilString(self.d_details)];
        if (self.d_details.length > 0) {
            NSAttributedString *attrString = [self.d_details toMessageString];
            _contentAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attrString];
            //内容的字体属性，font = 14 lineSpacing = 10
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            [style setLineSpacing:8];
            [style setLineBreakMode:NSLineBreakByCharWrapping];
            [style setAlignment:NSTextAlignmentLeft];
            [style setFirstLineHeadIndent:self.labelWidth + 20];
            NSDictionary *contentAttributes = @{
                                   NSFontAttributeName:[UIFont font_14],
                                   NSParagraphStyleAttributeName:style
                                   };
            [_contentAttr addAttributes:contentAttributes range:NSMakeRange(0, _contentAttr.length)];
        }
    }
    return _contentAttr;
}

- (CGFloat)labelWidth{
    if (_labelWidth == 0) {
        if (self.d_label.length == 0) {
            _labelWidth = 40;
        }
        else{
            CGFloat width = [self.d_label yd_stringWidthBySize:CGSizeMake(CGFLOAT_MAX, 20) font:[UIFont font_12]];
            _labelWidth = width > 40 ? width : 40;
        }
    }
    return _labelWidth;
}

- (CGFloat)videoHeight{
    if (_videoHeight == 0) {
        _videoHeight = 10 + (SCREEN_WIDTH - 20) * 0.563;
    }
    return _videoHeight;
}

- (NSArray<NSDictionary *> *)imagesDicArray{
    if (_imagesDicArray == nil) {
        if (self.d_image.count == 0) {
            NSLog(@"图片数据出错");
            _imagesDicArray = @[];
        }
        else{
            __block NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:self.d_image.count];
            __block CGFloat allHeight = 0;
            CGFloat space = 5;
            [self.d_image enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *components = [obj componentsSeparatedByString:@","];
                if (components.count < 3) {
                    NSLog(@"图片数据出错");
                }
                else{
                    CGFloat x = 10;
                    CGFloat y;
                    NSString *url = components.firstObject;
                    NSString *widthStr = [components objectAtIndex:1];
                    NSString *heightStr = components.lastObject;
                    CGFloat width = SCREEN_WIDTH-20;
                    CGFloat height = heightStr.floatValue * width / widthStr.floatValue;
                    
                    if (idx == 0) {
                        y = space;
                    }
                    else{
                        y = allHeight + (idx + 1) * space;
                    }
                    allHeight += height;
                    NSDictionary *dic = @{
                                          @"url":url,
                                          @"x":@(x),
                                          @"y":@(y),
                                          @"width":@(width),
                                          @"height":@(height)
                                          };
                    [tempArr addObject:dic];
                }
            }];
            
            allHeight += (space * self.d_image.count);
            
            _imagesHeight = allHeight;
            _imagesDicArray = [NSArray arrayWithArray:tempArr];
        }
    }
    return _imagesDicArray;
}

- (CGFloat)locationHeight{
    if ([_d_hide isEqual:@1]
        || [_d_address isEqualToString:@"不显示位置"]
        || _d_address.length == 0) {
        return 0;
    }
    return 34.f;
}

- (CGFloat)likerHeight{
    if (self.taplike.count == 0) {
        return 10;
    }
    return 76.f;
}

@end

/**
 *  点击喜欢的模型
 */
@implementation YDTapLikeModel

- (NSString *)showTime{
    if (_showTime == nil) {
        _showTime = [NSDate timeInfoWithDate:self.tl_timeint];
    }
    return _showTime;
}

@end


/**
 *  动态评论模型
 */
@implementation YDDynamicCommentModel

- (NSAttributedString *)detailsAttr{
    if (_detailsAttr == nil) {
        _detailsAttr = [self.cd_details toMessageString];
    }
    return _detailsAttr;
}

- (CGFloat)height{
    if (_height == 0) {
        _height = 41;
        if (self.cd_details.length == 0) {
            _height += 17.0f;
        }
        else{
            [dynamicSizeLabel setAttributedText:self.detailsAttr];
            _height += [dynamicSizeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-10-40-5-10, CGFLOAT_MAX)].height;
        }
    }
    return _height;
}

- (NSString *)timeInfo{
    if (_timeInfo == nil) {
        _timeInfo = [NSDate timeInfoWithDate:self.cd_dateInt];
    }
    return _timeInfo;
}

@end

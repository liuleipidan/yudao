//
//  YDMoment.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMoment.h"

//属性字符串参数
static NSDictionary *attributeDic;
static UILabel *momentTextLabel = nil;

@interface YDMoment()


@end

@implementation YDMoment

- (instancetype)init{
    if (self = [super init]) {
        if (attributeDic == nil) {
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paraStyle.alignment = NSTextAlignmentLeft;
            //paraStyle.minimumLineHeight = 22.7f;
            //设置行间距
            paraStyle.lineSpacing = UILABEL_LINE_SPACE;
            paraStyle.hyphenationFactor = 1.0;
            paraStyle.firstLineHeadIndent = 0.0;
            paraStyle.paragraphSpacingBefore = 0.0;
            paraStyle.headIndent = 0;
            paraStyle.tailIndent = 0;
            //设置字间距 NSKernAttributeName:@1.5f
            attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle};
        }
        
        if (momentTextLabel == nil) {
            momentTextLabel = [[UILabel alloc] init];
            [momentTextLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
            [momentTextLabel setNumberOfLines:2];
        }
        
    }
    return self;
}

#pragma mark - Getter
- (NSArray *)imagesURL{
    if (_imagesURL == nil) {
        NSMutableArray *imagesURL = [NSMutableArray arrayWithCapacity:self.d_image.count];
        for (NSString *imageInfo in self.d_image) {
            NSArray *tempArr = [imageInfo componentsSeparatedByString:@","];
            if (tempArr.count > 0) {
                [imagesURL addObject:tempArr.firstObject];
            }
        }
        _imagesURL = [NSArray arrayWithArray:imagesURL];
    }
    return _imagesURL;
}

- (NSString *)showTime{
    if (_showTime == nil) {
        _showTime = [NSDate timeInfoWithDate:self.d_issuetimeInt];
    }
    return _showTime;
}

- (NSMutableAttributedString *)attrContent{
    if (_attrContent == nil) {
        NSString *tempStr = self.d_details.length > 0 ? self.d_details : @"";
        _attrContent = [[NSMutableAttributedString alloc] initWithAttributedString:[tempStr toMessageString]];
        [_attrContent addAttributes:attributeDic range:NSMakeRange(0, _attrContent.length)];
    }
    return _attrContent;
}

- (YDMomentFrame *)frame{
    if (_frame == nil) {
        _frame = [[YDMomentFrame alloc] init];
        
        _frame.cellHeight = [self heightMomentDefault];
        _frame.heightText = [self heightText];
        _frame.locationHeight = [self locationHeight];
        if (_frame.heightText == 0 || _frame.locationHeight == 0) {
            _frame.textAndLocationHeight = _frame.heightText + _frame.locationHeight;
        }else{
            _frame.textAndLocationHeight = _frame.heightText + _frame.locationHeight + 5;
        }
        _frame.cellHeight += _frame.textAndLocationHeight == 0 ? : _frame.textAndLocationHeight + SPACE_MOMENT_ZONE;
    }
    return _frame;
}

/**
 正文高度
 */
- (CGFloat)heightText{
    if (self.d_details.length > 0) {
        CGSize size = CGSizeMake(SCREEN_WIDTH - 20, CGFLOAT_MAX);
        [momentTextLabel setAttributedText:self.attrContent];
        
        CGFloat height = [momentTextLabel sizeThatFits:size].height;
        //CGFloat height = [self.d_details boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size.height;
        //浮点数会导致cell顶部多一条线
        return height;
    }
    return 0.0f;
}

/**
 位置高度
 */
- (CGFloat)locationHeight{
    if (self.d_hide && [self.d_hide isEqual:@1]) {
        return 0.0f;
    }
    return 18.0f;
}

- (CGFloat)heightMomentDefault{
    //图片
    if ([self.d_type isEqual:@1]) {
        return HEIGHT_MOMENT_HEADER_DEFAULT + HEIGHT_MOMENT_IMAGES_DEFAULT + HEIGHT_MOMENT_BOTTOM_DEFAULT + 0.5;
    }
    //视频
    return HEIGHT_MOMENT_HEADER_DEFAULT + HEIGHT_MOMENT_VIDEO_DEFAULT + HEIGHT_MOMENT_BOTTOM_DEFAULT + 0.5;
}

@end

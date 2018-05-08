//
//  YDDynamicModel.m
//  YuDao
//
//  Created by 汪杰 on 16/11/11.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDynamicModel.h"

@implementation YDDynamicModel


#pragma mark - Getters
- (NSString *)imageUrl{
    if (_imageUrl == nil) {
        NSArray *imageData = [self.d_image componentsSeparatedByString:@","];
        if (imageData.count < 3) {
            _imageUrl = @"";
        }
        else{
            _imageUrl = imageData.firstObject;
        }
    }
    return _imageUrl;
}

- (CGFloat )width{
    NSArray *imageData = [self.d_image componentsSeparatedByString:@","];
    if (imageData.count < 3) {
        return 0;
    }
    NSString *width = [imageData objectAtIndex:1];
    return [width floatValue];
}

- (CGFloat )height{
    NSArray *imageData = [self.d_image componentsSeparatedByString:@","];
    if (imageData.count < 3) {
        return 0;
    }
    NSString *height = [imageData lastObject];
    return [height floatValue];
}


- (CGFloat )cellHeight{
    if (_cellHeight == 0) {
        if (self.d_details.length == 0) {
            _cellHeight = 10+(SCREEN_WIDTH-20)*0.56 + 7+21 + 6+17 + 6;
        }
        else{
            _cellHeight = 10+(SCREEN_WIDTH-20)*0.56 + 7+21 + 6+21 + 6+17 + 6;
        }
        if ([self.d_hide isEqual:@1]) {
            _cellHeight -= (6+17);
        }
    }
    return _cellHeight;
}

@end

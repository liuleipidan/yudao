//
//  YDPublishDynamicModel.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPublishDynamicModel.h"

@implementation YDPublishDynamicModel

- (id)init{
    if (self = [super init]) {
        _text = @"";
        _address = @"";
        _label = @"";
        
        _images = [NSMutableArray array];
        _assets = [NSMutableArray array];
        
        _imagesColSpace = 10.f;
        _imagesRowSpace = 10.f;
    }
    return self;
}


- (CGFloat)imagesHeight{
    NSUInteger rowNumber = 1;
    if (self.images.count >= 3 && self.images.count < 6) {
        rowNumber = 2;
    }
    else if (self.images.count >= 6){
        rowNumber = 3;
    }
    return rowNumber * kPDImagesRowHeight + _imagesRowSpace * (rowNumber - 1);
}

- (CGFloat)imagesWidth{
    if (self.images.count >= 2) {
        return kPDImagesRowHeight * 3 + _imagesColSpace * 2;
    }
    return kPDImagesRowHeight * (self.images.count + 1) + _imagesColSpace * self.images.count;
}

- (CGFloat)cellHeight{
    return 120 + self.imagesHeight + 20 + 10;
}

- (BOOL)isVideo{
    return self.videoLocalURL ? YES : NO;
}

@end

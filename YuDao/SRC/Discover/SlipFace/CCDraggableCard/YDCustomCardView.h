//
//  CustomCardView.h
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 China-SQP. All rights reserved.
//

#import "CCDraggableCardView.h"
#import "YDSlipFaceModel.h"

@interface YDCustomCardView : CCDraggableCardView

@property (nonatomic, strong) YDSlipFaceModel *model;

- (void)installData:(NSDictionary *)element;

@end

//
//  YDDynamicMessageCell.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/30.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTableViewSingleLineCell.h"
#import "YDDynamicMessage.h"

@interface YDDynamicMessageCell : YDTableViewSingleLineCell

@property (nonatomic, strong) YDDynamicMessage *message;

@end

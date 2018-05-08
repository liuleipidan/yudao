//
//  YDInterestModel.m
//  YuDao
//
//  Created by 汪杰 on 16/11/10.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDInterestModel.h"

@implementation YDInterestModel

- (id)init{
    if (self = [super init]) {
        self.interests = [NSMutableArray array];
        self.selectedInterests = [NSMutableArray array];
    }
    return self;
}

- (void)setP_model:(YDInterest *)p_model{
    _p_model = p_model;
    if ([self.p_model.t_name isEqualToString:@"生活"]) {
        self.color = [UIColor colorWithString:@"#6F95EC"];
        self.iconPath = @"mine_interest_1";
    }else if ([self.p_model.t_name isEqualToString:@"体育"]){
        self.color = [UIColor colorWithString:@"#FFC058"];
        self.iconPath = @"mine_interest_2";
    }else if ([self.p_model.t_name isEqualToString:@"休闲"]){
        self.color = [UIColor colorWithString:@"#6DD1B0"];
        self.iconPath = @"mine_interest_3";
    }
}


@end

@implementation YDInterest



@end

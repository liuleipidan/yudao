//
//  YDMomentBottomView.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDMomentBottomView : UIView

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *centerBtn;

@property (nonatomic, strong) UIButton *rightBtn;

- (instancetype)initWithLeftBtnAction:(void (^)(void))leftBtnBlock
                      centerBtnAction:(void (^)(void))centerBtnBlock
                       rightBtnAction:(void (^)(void))rightBtnBlock;

- (void)setLeftButtonCount:(NSNumber *)leftCount centerBtnCount:(NSNumber *)centerCount likeState:(NSNumber *)state;

@end

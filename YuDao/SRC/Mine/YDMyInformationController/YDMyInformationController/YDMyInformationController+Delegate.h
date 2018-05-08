//
//  YDMyInformationController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/18.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMyInformationController.h"

@interface YDMyInformationController (Delegate)<UITableViewDataSource,UITableViewDelegate,YDInterestsControllerDelegate,YDMyTextFieldCellDelegate>

- (void)mic_registerCells;

@end

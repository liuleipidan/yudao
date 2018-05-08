//
//  YDPublishDynamicCellDelegate.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#ifndef YDPublishDynamicCellDelegate_h
#define YDPublishDynamicCellDelegate_h

@protocol YDPublishDynamicCellDelegate <NSObject>

@optional

- (BOOL)cellTextViewShouldBeginEditing:(UITextView *)textView;

- (void)clickedAdd;

- (void)clickedDelete:(NSInteger)index;

- (void)clickedImage:(NSInteger)index;

- (void)clickedVideo:(NSURL *)videoURL;

@end

#endif /* YDPublishDynamicCellDelegate_h */

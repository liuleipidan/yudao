//
//  SystemActionSheet.h
//  ActionSheetExtension
//
//  Created by yixiang on 15/7/6.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol systemActionSheetDelegate <NSObject>

@optional
- (void)systemActionSheetDidTouchedIndex:(NSInteger )index;

@end

@interface YDSystemActionSheet : UIView

@property (nonatomic, weak) id<systemActionSheetDelegate> systemDelegate;

@property (nonatomic, copy) void (^clickBlock)(NSInteger index);

-(id) initViewWithTitle: (NSString *) phone title : (NSString *) title clickedBlock:(void (^)(NSInteger index))clickedBlock;

-(id) initViewWithMultiTitles:(NSArray *) array title :(NSString *)title clickedBlock:(void (^)(NSInteger index))clickedBlock;

-(id) initViewWithTitle: (NSString *) phone title : (NSString *) title;

-(id) initViewWithMultiTitles:(NSArray *) array title :(NSString *)title;

-(void) show;

@end

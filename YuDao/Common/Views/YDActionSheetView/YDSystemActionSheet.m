//
//  SystemActionSheet.m
//  ActionSheetExtension
//
//  Created by yixiang on 15/7/6.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "YDSystemActionSheet.h"

@interface YDSystemActionSheet()<UIActionSheetDelegate>

@property (nonatomic , strong) UIActionSheet *actionSheet;

@end

@implementation YDSystemActionSheet
-(id) initViewWithTitle: (NSString *) phone title : (NSString *) title clickedBlock:(void (^)(NSInteger index))clickedBlock{
    if (self = [self init]) {
        _actionSheet.title = title;
        [_actionSheet addButtonWithTitle:phone];
        _clickBlock = clickedBlock;
    }
    return self;
}

-(id) initViewWithMultiTitles:(NSArray *) array title :(NSString *)title clickedBlock:(void (^)(NSInteger index))clickedBlock{
    if (self = [self init]) {
        _actionSheet.title = title;
        _clickBlock = clickedBlock;
        for (NSString *phone in array) {
            [_actionSheet addButtonWithTitle:phone];
        }
    }
    return self;
}
-(id) initViewWithTitle: (NSString *) phone title : (NSString *) title{
    if (self = [self init]) {
        _actionSheet.title = title;
        [_actionSheet addButtonWithTitle:phone];
    }
    return self;
}

-(id) initViewWithMultiTitles:(NSArray *) array title :(NSString *)title{
    
    if (self = [super init]) {
        _actionSheet.title = title;
        for (NSString *phone in array) {
            [_actionSheet addButtonWithTitle:phone];
        }
    }
    return self;
}

-(id)init{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if (self = [super initWithFrame:bounds]) {
        self.backgroundColor = [UIColor clearColor];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
#pragma clang diagnostic pop
        
        _actionSheet.cancelButtonIndex = [_actionSheet addButtonWithTitle:@"取消"];
    }
    return self;
}

-(void) show{
    [_actionSheet showInView : self];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self close];
    }else{
        if (self.clickBlock) {
            self.clickBlock(buttonIndex);
            [self close];
            return;
        }
        if (self.systemDelegate && [self.systemDelegate respondsToSelector:@selector(systemActionSheetDidTouchedIndex:)]) {
            [self.systemDelegate systemActionSheetDidTouchedIndex:buttonIndex];
            [self close];
        }
        
    }
}



- (void)onPhoneButtonClick:(NSString *)phone {
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", phone];
    BOOL result = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    if (!result) {
        [self close];
        YDLog(@"亲，您的设备不支持拨打电话功能");
    } else {
        [self close];
    }
}

-(void) close{
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    [self removeFromSuperview];
}

@end

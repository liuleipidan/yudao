//
//  YDPopupController.h
//  YuDao
//
//  Created by 汪杰 on 16/9/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YDPopupControllerDelegate;
@class YDPopupTheme, YDPopupButton;

@interface YDPopupController : NSObject

@property (nonatomic, strong) YDPopupTheme *_Nonnull theme;
@property (nonatomic, weak) id <YDPopupControllerDelegate> _Nullable delegate;

- (nonnull instancetype) init __attribute__((unavailable("You cannot initialize through init - please use initWithContents:")));
- (nonnull instancetype)initWithContents:(nonnull NSArray<UIView *> *)contents NS_DESIGNATED_INITIALIZER;

- (void)presentPopupControllerAnimated:(BOOL)flag;
- (void)dismissPopupControllerAnimated:(BOOL)flag;

@end

@protocol YDPopupControllerDelegate <NSObject>

@optional
- (void)popupControllerWillPresent:(nonnull YDPopupController *)controller;

- (void)popupControllerDidPresent:(nonnull YDPopupController *)controller;

- (void)popupControllerWillDismiss:(nonnull YDPopupController *)controller;

//点击控制器上的Button或者调用dismissPopupControllerAnimated,isTapBackgroud = YES
//其他的isTapBackgroud = NO
- (void)popupControllerDidDismiss:(nonnull YDPopupController *)controller isTapBackgroud:(BOOL)isTapBackgroud;


@end

typedef void(^SelectionHandler) (YDPopupButton *_Nonnull button);

@interface YDPopupButton : UIButton

@property (nonatomic, copy) SelectionHandler _Nullable selectionHandler;

@end

// YDPopupStyle: Controls how the popup looks once presented
typedef NS_ENUM(NSUInteger, YDPopupStyle) {
    YDPopupStyleActionSheet = 0, // Displays the popup similar to an action sheet from the bottom.
    YDPopupStyleCentered, // Displays the popup in the center of the screen.
    YDPopupStyleFullscreen // Displays the popup similar to a fullscreen viewcontroller.
};

// YDPopupPresentationStyle: Controls how the popup is presented
typedef NS_ENUM(NSInteger, YDPopupPresentationStyle) {
    YDPopupPresentationStyleFadeIn = 0,
    YDPopupPresentationStyleSlideInFromTop,
    YDPopupPresentationStyleSlideInFromBottom,
    YDPopupPresentationStyleSlideInFromLeft,
    YDPopupPresentationStyleSlideInFromRight
};

// YDPopupMaskType
typedef NS_ENUM(NSInteger, YDPopupMaskType) {
    YDPopupMaskTypeClear,
    YDPopupMaskTypeDimmed,
    YDPopupMaskTypeCustom
};

NS_ASSUME_NONNULL_BEGIN
@interface YDPopupTheme : NSObject

@property (nonatomic, strong) UIColor *backgroundColor; // Background color of the popup content view (Default white)
@property (nonatomic, strong) UIColor *customMaskColor; // Custom color for YDPopupMaskTypeCustom
@property (nonatomic, assign) CGFloat cornerRadius; // Corner radius of the popup content view (Default 4.0)
@property (nonatomic, assign) UIEdgeInsets popupContentInsets; // Inset of labels, images and buttons on the popup content view (Default 0.0 on all sides)
@property (nonatomic, assign) YDPopupStyle popupStyle; // How the popup looks once presented (Default actionSheet)
@property (nonatomic, assign) YDPopupPresentationStyle presentationStyle; // How the popup is presented (Defauly slide in from bottom. NOTE: Only applicable to YDPopupStyleCentered)
@property (nonatomic, assign) YDPopupMaskType maskType; // Backgound mask of the popup (Default dimmed)
@property (nonatomic, assign) BOOL dismissesOppositeDirection; // If presented from a direction, should it dismiss in the opposite? (Defaults to NO. i.e. Goes back the way it came in)
@property (nonatomic, assign) BOOL shouldDismissOnBackgroundTouch; // Popup should dismiss on tapping on background mask (Default yes)
@property (nonatomic, assign) BOOL movesAboveKeyboard; // Popup should move up when the keyboard appears (Default yes)
@property (nonatomic, assign) CGFloat blurEffectAlpha; // Alpha of the background blur effect (Default 0.0)
@property (nonatomic, assign) CGFloat contentVerticalPadding; // Spacing between each vertical element (Default 0.0)
@property (nonatomic, assign) CGFloat maxPopupWidth; // Maxiumum width that the popup should be (Default 300)
@property (nonatomic, assign) CGFloat animationDuration; // Duration of presentation animations (Default 0.3s)

// Factory method to help build a default theme
+ (YDPopupTheme *)defaultTheme;

@end
NS_ASSUME_NONNULL_END

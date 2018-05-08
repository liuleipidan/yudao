//
//  LLTabBar.m
//  LLRiseTabBarDemo
//
//  Created by Meilbn on 10/18/15.
//  Copyright © 2015 meilbn. All rights reserved.
//

#import "LLTabBar.h"

@interface LLTabBar ()

@property (strong, nonatomic) NSMutableArray *tabBarItems;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation LLTabBar

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self config];
	}
	
	return self;
}

#pragma mark - Private Method

- (void)config {
	self.backgroundColor = [UIColor whiteColor];
//	UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, SCREEN_WIDTH, 5)];
//	topLine.image = [UIImage imageNamed:@"tapbar_top_line"];
//	[self addSubview:topLine];
    UIImageView *bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_tabbar_backgroundIcon"]];
    [self addSubview:bgImgV];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(-15);
    }];
}

- (void)setSelectedIndex:(NSInteger)index {
    
	for (LLTabBarItem *item in self.tabBarItems) {
		if (item.tag == index) {
			item.selected = YES;
		} else {
			item.selected = NO;
		}
	}
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarDidSelectedNormalButton:)] && _selectedIndex != index) {
        _selectedIndex = index;
        [self.delegate tabBarDidSelectedNormalButton:index];
    }
}

#pragma mark - Touch Event

- (void)itemSelected:(LLTabBarItem *)sender {
	if (sender.tabBarItemType != LLTabBarItemRise) {
		[self setSelectedIndex:sender.tag];
	} else {
		if (self.delegate) {
			if ([self.delegate respondsToSelector:@selector(tabBarDidSelectedRiseButton)]) {
				[self.delegate tabBarDidSelectedRiseButton];
			}
		}
	}
}

#pragma mark - Setter

- (void)setTabBarItemAttributes:(NSArray<NSDictionary *> *)tabBarItemAttributes {
	_tabBarItemAttributes = tabBarItemAttributes.copy;
    
    NSAssert(_tabBarItemAttributes.count > 2, @"TabBar item count must greet than two.");
    
    CGFloat normalItemWidth = (SCREEN_WIDTH * 3 / 4) / (_tabBarItemAttributes.count - 1);
    CGFloat tabBarHeight = CGRectGetHeight(self.frame);
    CGFloat publishItemWidth = (SCREEN_WIDTH / 4);
    
	NSInteger itemTag = 0;
    BOOL passedRiseItem = NO;
    
    _tabBarItems = [NSMutableArray arrayWithCapacity:_tabBarItemAttributes.count];
    
	for (id item in _tabBarItemAttributes) {
		if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *itemDict = (NSDictionary *)item;
            
            LLTabBarItemType type = [itemDict[kLLTabBarItemAttributeType] integerValue];
            
            CGRect frame = CGRectMake(itemTag * normalItemWidth + (passedRiseItem ? publishItemWidth : 0), 0, type == LLTabBarItemRise ? publishItemWidth : normalItemWidth, tabBarHeight);
            
            LLTabBarItem *tabBarItem = [self tabBarItemWithFrame:frame
                                                         title:itemDict[kLLTabBarItemAttributeTitle]
                                               normalImageName:itemDict[kLLTabBarItemAttributeNormalImageName]
                                             selectedImageName:itemDict[kLLTabBarItemAttributeSelectedImageName] tabBarItemType:type];
			if (itemTag == 0) {
				tabBarItem.selected = YES;
			}
            
			[tabBarItem addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            if (tabBarItem.tabBarItemType != LLTabBarItemRise) {
                tabBarItem.tag = itemTag;
                itemTag++;
            } else {
                passedRiseItem = YES;
            }
            
            [_tabBarItems addObject:tabBarItem];
			[self addSubview:tabBarItem];
            if (tabBarItem.tabBarItemType == LLTabBarItemRise) {
//                [tabBarItem mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.equalTo(self);
//                    make.top.equalTo(self).offset(-3);
//                    make.width.mas_equalTo(publishItemWidth);
//                    make.height.mas_equalTo(tabBarHeight);
//                }];
            }
		}
	}
}

- (LLTabBarItem *)tabBarItemWithFrame:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tabBarItemType:(LLTabBarItemType)tabBarItemType {
    LLTabBarItem *item = [[LLTabBarItem alloc] initWithFrame:frame];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateSelected];
    item.titleLabel.font = [UIFont systemFontOfSize:10];
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    [item setTitleColor:YDColorString(@"#9B9B9B") forState:UIControlStateNormal];
    [item setTitleColor:YDBaseColor forState:UIControlStateSelected];
    item.tabBarItemType = tabBarItemType;
    
    return item;
}

@end

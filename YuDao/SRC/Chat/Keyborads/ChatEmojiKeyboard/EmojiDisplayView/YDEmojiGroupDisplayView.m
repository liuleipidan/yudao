//
//  YDEmojiGroupDisplayView.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDEmojiGroupDisplayView.h"
#import "YDEmojiGroupDisplayView+CollectionView.h"

@implementation YDEmojiGroupDisplayView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self egm_registerCells];
    }
    return self;
}

- (void)setData:(NSMutableArray *)data
{
    if (data && _data && [_data isEqualToArray:data]) {
        return;
    }
    _data = data;
    
    self.height = HEIGHT_CHAT_KEYBOARD - 57;
    self.width = SCREEN_WIDTH;
    
    NSMutableArray *displayData = [[NSMutableArray alloc] init];
    for (NSInteger emojiGroupIndex = 0; emojiGroupIndex < data.count; emojiGroupIndex++) {
        YDEmojiGroup *group = data[emojiGroupIndex];
        if (group.count > 0) {      // 已下载的表情包
            NSInteger cellWidth, cellHeight;
            CGFloat spaceX, spaceYTop, spaceYBottom;
            cellWidth = ((self.width - 20) / group.colNumber);
            spaceX = (self.width - cellWidth * group.colNumber) / 2.0;
            cellHeight = (self.height - 15) / group.rowNumber;
            spaceYTop = 10;
            spaceYBottom = (self.height - cellHeight * group.rowNumber) - spaceYTop;
            for (NSInteger pageIndex = 0; pageIndex < group.pageNumber; pageIndex++) {
                //group pageIndex group.pageItemCount
                YDEmojiGroupDisplayModel *model = [[YDEmojiGroupDisplayModel alloc] initWithEmojiGroup:group pageNumber:pageIndex count:group.pageItemCount];
                YDEmoji *emoji = [[YDEmoji alloc] init];
                emoji.emojiID = @"-1";
                emoji.emojiName = @"emoji_delete";
                emoji.emojiPath = @"emoji_delete";
                [model addEmoji:emoji];
                model.pageItemCount ++;
                
                model.emojiGroupIndex = emojiGroupIndex;
                model.pageIndex = pageIndex;
                model.cellSize = CGSizeMake(cellWidth, cellHeight);
                model.sectionInsets = UIEdgeInsetsMake(spaceYTop, spaceX, spaceYBottom, spaceX);
                [displayData addObject:model];
            }
        }
    }
    self.displayData = displayData;
    [self.collectionView reloadData];
    if (self.displayData.count > 0 && self.delegate && [self.delegate respondsToSelector:@selector(emojiGroupDisplayView:didScrollToPageIndex:forGroupIndex:)]) {
        YDEmojiGroupDisplayModel *group = self.displayData[0];
        [self.collectionView setContentOffset:CGPointZero];
        [self.delegate emojiGroupDisplayView:self didScrollToPageIndex:0 forGroupIndex:group.emojiGroupIndex];
    }
}

- (void)scrollToEmojiGroupAtIndex:(NSInteger)index
{
    if (index > self.data.count) {
        return;
    }
    _curPageIndex = index;
    NSInteger page = 0;
    for (int i = 0; i < index; i ++) {
        YDEmojiGroup *group = self.data[i];
        page += group.pageNumber;
    }
    [self.collectionView setContentOffset:CGPointMake(page * self.collectionView.width, 0)];
    if (self.displayData.count > page) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiGroupDisplayView:didScrollToPageIndex:forGroupIndex:)]) {
            YDEmojiGroupDisplayModel *group = self.displayData[page];
            [self.delegate emojiGroupDisplayView:self didScrollToPageIndex:0 forGroupIndex:group.emojiGroupIndex];
        }
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView setPagingEnabled:YES];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
        
    }
    return _collectionView;
}

@end

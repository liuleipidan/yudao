//
//  YDChatMessageDisplayView.m
//  YuDao
//
//  Created by 汪杰 on 17/3/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatMessageDisplayView.h"
#import "YDChatMessageDisplayView+Delegate.h"

#define     PAGE_MESSAGE_COUNT      10

@interface YDChatMessageDisplayView ()

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;

/// 用户决定新消息是否显示时间
@property (nonatomic, strong) NSDate *curDate;

@end

@implementation YDChatMessageDisplayView
@synthesize tableView = _tableView;
@synthesize data = _data;

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = YDColorString(@"#F5F5F5");
        [self addSubview:self.tableView];
        [self registerCellClassForTableView:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchTableView)];
        [self.tableView addGestureRecognizer:tap];
        
        [self.tableView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"bounds"];
#ifdef DEBUG_MEMERY
    NSLog(@"dealloc MessageDisplayView");
#endif
}


#pragma mark - # Public Methods
- (void)resetMessageView
{
    [self.data removeAllObjects];
    [self.tableView reloadData];
    self.curDate = [NSDate date];
    if (!self.disablePullToRefresh) {
        [self.tableView setMj_header:self.refreshHeader];
    }
    YDWeakSelf(self);
    [self y_tryToRefreshMoreRecord:^(NSInteger count, BOOL hasMore) {
        
        if (!hasMore) {
            weakself.tableView.mj_header = nil;
        }
        if (count > 0) {
            [weakself.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView scrollToBottomWithAnimation:NO];
            });
        }
    }];
}

- (void)addMessage:(YDChatMessage *)message{
    [self.data addObject:message];
    [self.tableView reloadData];
}

- (void)updateMessageSendStatus:(NSString *)msgId
                     sendStatus:(YDMessageSendState)status{
    NSLog(@"status = %ld",status);
    [self.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YDChatMessage *message = obj;
        if ([message.msgId isEqualToString:msgId]) {
            message.sendState = status;
            NSLog(@"找到需要修改发送状态的消息了");
            *stop = YES;
        }
    }];
    [self.tableView reloadData];
    [self.tableView yd_scrollToFoot:NO];
}

/**
 *  删除消息
 */
- (void)deleteMessage:(YDChatMessage *)message{
    [self deleteMessage:message withAnimation:YES];
}
- (void)deleteMessage:(YDChatMessage *)message withAnimation:(BOOL)animation{
    if (message == nil) {
        return;
    }
    __block NSInteger row = -1;
    [self.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YDChatMessage *dataMessage = obj;
        if ([dataMessage.msgId isEqualToString:message.msgId]) {
            row = idx;
            *stop = YES;
        }
    }];
    if (row == -1) {    return;}
    if (row == self.data.count-1 && self.data.count != 1) {
        YDChatMessage *lastMessage = [self.data objectAtIndex:row-1];
        lastMessage.readState = YDMessageReaded;
        [[YDChatHelper sharedInstance] addConversationByMessage:lastMessage];
    }
    [self.data removeObjectAtIndex:row];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:animation ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

/**
 *  更新消息状态
 */
- (void)updateMessage:(YDChatMessage *)message{
    NSArray *visibleCells = [self.tableView visibleCells];
    for (id cell in visibleCells) {
        if ([cell isKindOfClass:[YDChatBaseCell class]]) {
            if ([[(YDChatBaseCell *)cell message].msgId isEqualToString:message.msgId]) {
                [cell updateMessage:message];
                return;
            }
        }
    }
}

- (void)setData:(NSMutableArray *)data
{
    _data = data;
    [self.tableView reloadData];
}

- (void)reloadData
{
    [self.tableView reloadData];
    //[self.tableView scrollToBottomWithAnimation:YES];
}

- (void)scrollToBottomWithAnimation:(BOOL)animation
{
    [self.tableView yd_scrollToBottomWithAnimation:animation];
}

- (void)setDisablePullToRefresh:(BOOL)disablePullToRefresh{
    if (disablePullToRefresh) {
        self.tableView.mj_header = nil;
    }else{
        self.tableView.mj_header = self.refreshHeader;
    }
}

#pragma mark - Private Methods
- (void)y_tryToRefreshMoreRecord:(void (^)(NSInteger count,BOOL hasMore))completion{
    YDWeakSelf(self);
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:getRecordsFromDate:count:completed:)]) {
        [self.delegate chatMessageDisplayView:self getRecordsFromDate:self.curDate count:PAGE_MESSAGE_COUNT completed:^(NSDate *date, NSArray *array, BOOL hasMore) {
            if (array.count > 0) {
                weakself.curDate = [array[0] date];
                [weakself.data insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                completion(array.count, hasMore);
            }
            else {
                completion(0, hasMore);
            }
        }];
    }
}

#pragma mark - # Event Response
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.tableView && [keyPath isEqualToString:@"bounds"]) {  // tableView变小时，消息贴底
        CGRect oldBounds, newBounds;
        [change[@"old"] getValue:&oldBounds];
        [change[@"new"] getValue:&newBounds];
        CGFloat t = oldBounds.size.height - newBounds.size.height;
        if (t > 0 && fabs(self.tableView.contentOffset.y + t + newBounds.size.height - self.tableView.contentSize.height) < 1.0) {
            NSLog(@"scrollToBottom%s",__func__);
            [self scrollToBottomWithAnimation:NO];
        }
    }
}

- (void)didTouchTableView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayViewDidTouched:)]) {
        [self.delegate chatMessageDisplayViewDidTouched:self];
    }
}

#pragma mark - # Getter
- (YDTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDTableView alloc] init];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
    }
    return _tableView;
}

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (MJRefreshNormalHeader *)refreshHeader{
    if (!_refreshHeader) {
        YDWeakSelf(self);
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self y_tryToRefreshMoreRecord:^(NSInteger count, BOOL hasMore) {
                [weakself.tableView.mj_header endRefreshing];
                if (!hasMore) {
                    weakself.tableView.mj_header = nil;
                }
                if (count > 0) {
                    [weakself.tableView reloadData];
                    [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }];
        }];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        _refreshHeader.stateLabel.hidden = YES;
        _refreshHeader.arrowView.image = YDImage(@"load_bottom_arrow");
    }
    return _refreshHeader;
}


@end

//
//  YDPhotoBrowerController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPhotoBrowerController.h"
#import "YDPhotoBrowerController+Delegate.h"

@interface YDPhotoBrowerController ()

@property (nonatomic, assign) NSUInteger initImageCount;

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation YDPhotoBrowerController
- (instancetype)initWithData:(NSArray *)data{
    if (self = [super init]) {
        _data = [NSMutableArray arrayWithArray:data];
        _initImageCount = _data.count;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pbc_initUI];
    
}

- (void)pbc_initUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[YDPhotoBrowserCell class] forCellWithReuseIdentifier:@"YDPhotoBrowserCell"];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:(CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT*15/16, SCREEN_WIDTH/3, SCREEN_HEIGHT/16))];
    [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    _pageControl.currentPage = 0;
    if (_data.count == 1) {
        _pageControl.hidden = YES;
    }else{
        _pageControl.numberOfPages = _data.count;
    }
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_deleteBtn setImage:@"photoBrowser_delete" imageHL:@"photoBrowser_delete"];
    [_deleteBtn setTitle:@"删除" forState:0];
    [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view yd_addSubviews:@[_collectionView,_pageControl,_deleteBtn]];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(21);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(27);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
    }];
    
    
}

- (void)deleteBtnAction:(UIButton *)btn{
    [UIAlertController YD_alertController:self title:nil subTitle:@"确认删除这张照片吗？" items:@[@"确认"] style:UIAlertControllerStyleActionSheet clickBlock:^(NSInteger index) {
        if (index == 1) {
            [_data removeObjectAtIndex:_pageControl.currentPage];
            if (_data.count == 0) {
                if (self.needRefreshBlock) {
                    self.needRefreshBlock(_data);
                }
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }else{
                [_collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:_pageControl.currentPage inSection:0]]];
                if (_data.count == 1) {
                    _pageControl.hidden = YES;
                }else{
                    _pageControl.numberOfPages = _data.count;
                    _pageControl.currentPage = _collectionView.contentOffset.x/SCREEN_WIDTH;
                }
            }
        }
    }];
}

- (void)pageControlAction:(UIPageControl *)pageControl{
    [_collectionView setContentOffset:CGPointMake(pageControl.currentPage*SCREEN_WIDTH, 0) animated:YES];
}


@end

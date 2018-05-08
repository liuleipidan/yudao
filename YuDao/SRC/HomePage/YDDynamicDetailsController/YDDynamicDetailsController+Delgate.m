//
//  YDDynamicDetailsController+Delgate.m
//  YuDao
//
//  Created by 汪杰 on 16/12/20.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDynamicDetailsController+Delgate.h"
#import "YDImageController.h"
#import "YDDynamicLikerViewController.h"
#import "WWVideoPlayerViewController.h"
#import "WWAVPlayerView.h"

@implementation YDDynamicDetailsController (Delgate)
//注册单元格
- (void)registeCellClass{
    
    //标签和内容
    [self.tableView registerClass:[YDDDLabelContentCell class] forCellReuseIdentifier:@"YDDDLabelContentCell"];
    //图片
    [self.tableView registerClass:[YDDDImagesCell class] forCellReuseIdentifier:@"YDDDImagesCell"];
    
    //视频
    [self.tableView registerClass:[YDDDVideoCell class] forCellReuseIdentifier:@"YDDDVideoCell"];
    
    //定位
    [self.tableView registerClass:[YDDDLocationCell class] forCellReuseIdentifier:@"YDDDLocationCell"];
    
    //喜欢的人
    [self.tableView registerClass:[YDDDLikerCell class] forCellReuseIdentifier:@"YDDDLikerCell"] ;
    
    //评论
    [self.tableView registerClass:[YDDDCommentCell class] forCellReuseIdentifier:@"YDDDCommentCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
    
}

#pragma mark - YDDynamicDetailsBottomViewDelegate
- (void)dynamicDetailsBottomView:(YDDynamicDetailsBottomView *)view didSelectedBtn:(UIButton *)btn{
    NSInteger index = btn.tag - 1000;
    switch (index) {
        case 0://点击喜欢按钮
        {
            if (!YDHadLogin) {
                [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
                    [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
                }];
                return;
            }
            NSMutableArray<YDTapLikeModel *> *likePeople = self.dyModel.taplike;
            if (!btn.selected) {
                YDTapLikeModel *model = [YDTapLikeModel new];
                model.d_id = _viewModel.dy_id;
                model.ub_id = [YDUserDefault defaultUser].user.ub_id;
                model.ub_nickname = [YDUserDefault defaultUser].user.ub_nickname;
                model.ud_face = [YDUserDefault defaultUser].user.ud_face;
                [likePeople addObject:model];
            }
            else{
                [likePeople enumerateObjectsUsingBlock:^(YDTapLikeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.ub_id isEqual:[YDUserDefault defaultUser].user.ub_id]) {
                        [likePeople removeObjectAtIndex:idx];
                        *stop = YES;
                    }
                }];
            }
            
            NSString *title = likePeople.count == 0 ? @"点赞" : [NSString stringWithFormat:@"点赞·%ld",likePeople.count];
            [btn setTitle:title forState:0];
            
            [self.tableView reloadData];
            btn.selected = !btn.selected;
            
            //通知代理刷新喜欢数量
            if (self.delegate && [self.delegate respondsToSelector:@selector(moment:likeCountChanged:isLike:)]) {
                [self.delegate moment:self.viewModel.moment likeCountChanged:likePeople.count isLike:btn.selected];
            }
            NSDictionary *para = @{
                                   @"d_id":_viewModel.dy_id,
                                   @"access_token":YDAccess_token,
                                   @"tl_type":@1
                                   };
            [YDNetworking POST:kAddLikedynamicURL parameters:para success:nil failure:nil];
            break;}
        case 1:
        {
            if (!YDHadLogin) {
                [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
                    [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
                }];
                return;
            }
            if (_comtentTo) {
                _comtentTo = nil;
            }
            [self.commentView setPlaceholderText:@"评论"];
            [self.commentView show];
            
            break;}
        case 2:
        {
#pragma mark - 动态分享 - 动态详情
            __block NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:self.dyModel.d_image.count];
            [self.dyModel.d_image enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *url = [(NSString *)obj componentsSeparatedByString:@","];
                [imageUrls addObject:url.firstObject];
            }];
            NSString *title = nil;
            NSString *content = nil;
            if (YDHadLogin) {
                title = [NSString stringWithFormat:@"%@发布了新的动态：%@",self.dyModel.ub_nickname,self.dyModel.d_label];
                content = self.dyModel.d_details.length == 0 ? @"分享 @遇道" : self.dyModel.d_details;
            }else{
                title = [NSString stringWithFormat:@"分享一条来自遇道的新动态 #%@#",self.dyModel.d_label];
                content = [NSString stringWithFormat:@"分享自%@的动态，一起来看~",self.dyModel.ub_nickname];
            }
            NSString *shareUrl = [NSString stringWithFormat:@"http://%@/app-share/dynamic.html?did=%@",kHtmlEnvironmentalKey,self.dyModel.d_id];
            AWActionSheet *sheet = [AWActionSheet actionSheetWithTouchItemBlock:^(YDClickSharePlatformType index) {
                [YDShareManager shareToPlatform:index
                                          title:title
                                        content:content
                                            url:shareUrl
                                     thumbImage:imageUrls.firstObject
                                          image:imageUrls
                                   musicFileURL:nil
                                        extInfo:nil
                                       fileData:nil
                                   emoticonData:nil
                                       latitude:0.0
                                      longitude:0.0
                                       objectID:nil];
            }];
            [sheet show];
            break;}
            
        default:
            break;
    }
}

#pragma mark - YDDDLikerCellDelegate
//点击喜欢的人的头像
- (void)DDlikerCell:(YDDDLikerCell *)cell didSelectedArrowBtn:(UIButton *)arrowBtn{
    YDDynamicLikerViewController *dylikerVC = [[YDDynamicLikerViewController alloc] init];
    dylikerVC.data = [[self.dyModel.taplike reverseObjectEnumerator] allObjects];
    [self.navigationController pushViewController:dylikerVC animated:YES];
}
//查看所有喜欢的人
- (void)DDlikerCell:(YDDDLikerCell *)cell didClicedAvatarWithIndex:(NSInteger)index{
    YDTapLikeModel *model = [cell.likePeople objectAtIndex:index];
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:model.ub_id];
    viewM.userName = model.ub_nickname;
    viewM.userHeaderUrl = model.ud_face;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    [self.navigationController pushViewController:userVC animated:YES];
}


#pragma mark - YDDDCommentCellDelegate
//MARK:点击评论者的头像
- (void)commentCell:(YDDDCommentCell *)cell didSelectedAvatar:(UIImageView *)avatar{
    
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:cell.model.ub_id];
    viewM.userName = cell.model.ub_nickname;
    viewM.userHeaderUrl = cell.model.ud_face;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    [self.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - YDDDImagesCellDelegate - 点击图片
- (void)dynamicImagesCell:(YDDDImagesCell *)cell selectedImageIndex:(NSUInteger)index{
    if (!_browerPhotos) {
        _browerPhotos = [NSMutableArray array];
    }
    [_browerPhotos removeAllObjects];
    [self.dyModel.imagesDicArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = [obj valueForKey:@"url"];
        [_browerPhotos addObject:YDURL(url)];
    }];
    //_cellImageViews = cell.imageViews;
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:_browerPhotos.count datasource:self];
    [browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" deleteButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
}

#pragma mark - YDDDVideoCellDelegate
- (void)dynamicVideoCellDidClickedVideo:(YDDDVideoCell *)cell{
    YDDynamicDetailModel *dynamic =  self.viewModel.dyDetailModel;
    if ([dynamic.d_type isEqual:@2]) {
        CGRect rect = [cell.thumbnailImageView.superview convertRect:cell.thumbnailImageView.frame toView:nil];
        [[WWAVPlayerView sharedPlayerView] fullScreenPlay:YDURL(dynamic.d_video) placeholderImage:nil rect:rect];
    }
}

#pragma mark - YDDynamicCommentViewDelegate
- (void)dynamicCommentView:(YDDynamicCommentView *)view didClickedSendWithText:(NSString *)text{
    if (text.length > 0) {
        if (!YDHadLogin) {
            [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        }else{
            NSDictionary *parameterDic = nil;
            if (_comtentTo) {
                NSString *newContent = [NSString stringWithFormat:@"回复%@:%@",_comtentTo.ub_nickname,text];
                parameterDic = @{@"cd_details":newContent,
                                 @"access_token":YDAccess_token,
                                 @"d_id":_viewModel.dy_id,
                                 @"cd_pid":_comtentTo.cd_id,
                                 @"f_ub_id":_comtentTo.ub_id
                                 };
                _comtentTo = nil;
            }
            else{
                parameterDic = @{@"cd_details":text,
                                 @"access_token":YDAccess_token,
                                 @"d_id":_viewModel.dy_id,
                                 @"cd_pid":@0};
            }
            
            YDWeakSelf(self);
            [YDNetworking POST:kAddcommentdynamicURL parameters:parameterDic success:^(NSNumber *code, NSString *status, id data) {
                
                YDDynamicCommentModel *comModel = [YDDynamicCommentModel mj_objectWithKeyValues:data];
                comModel.ub_nickname = [YDUserDefault defaultUser].user.ub_nickname;
                comModel.ud_face = [YDUserDefault defaultUser].user.ud_face;
                
                if ([code isEqual:@200] && comModel.cd_details) {
                    [weakself.dyModel.commentdynamic addObject:comModel];
                    [weakself.tableView reloadData];
                    [weakself.tableView yd_scrollToFoot:YES];
                    NSString *title = weakself.dyModel.commentdynamic.count == 0 ? @"评论":[NSString stringWithFormat:@"评论·%ld",weakself.dyModel.commentdynamic.count];
                    //评论
                    [self.bottomView.centerBtn setTitle:title forState:0];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(moment:commentCountChanged:)]) {
                        [self.delegate moment:self.viewModel.moment commentCountChanged:weakself.dyModel.commentdynamic.count];
                    }
                    [YDMBPTool  showText:@"评论成功"];
                }
                else{
                    NSLog(@"code = %@,status = %@",code,status);
                    [YDMBPTool  showText:@"评论失败"];
                }
                
            } failure:^(NSError *error) {
                YDLog(@"commentdynamic_error = %@",error);
                [YDMBPTool  showText:@"评论失败"];
            }];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //标签和内容Cell
    if (indexPath.row == 0) {
        YDDDLabelContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDDDLabelContentCell"];
        [cell setItem:self.dyModel];
        return cell;
    }
    //图片或视频Cell
    else if (indexPath.row == 1) {
        
        if ([self.dyModel.d_type isEqual:@1]) {
            YDDDImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDDDImagesCell"];
            [cell setItem:self.dyModel];
            [cell setDelegate:self];
            #pragma mark - 添加 3Dtouch
            if ([self respondsToSelector:@selector(traitCollection)]) {
                if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
                    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                        [self registerForPreviewingWithDelegate:self sourceView:cell];
                    }
                }
            }
            return cell;
        }
        else if ([self.dyModel.d_type isEqual:@2]){
            YDDDVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDDDVideoCell"];
            [cell setItem:self.dyModel];
            [cell setDelegate:self];
            return cell;
        }
        return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
    }
    else if (indexPath.row == 2) {
        YDDDLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDDDLocationCell"];
        [cell setLocationText:self.dyModel.d_address];
        return cell;
    }
    else if (indexPath.row == 3){
        YDDDLikerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDDDLikerCell"];
        [cell setLikePeople:self.dyModel.taplike];
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.row > 3){
        YDDDCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDDDCommentCell"];
        YDDynamicCommentModel *comment = self.dyModel.commentdynamic[indexPath.row-4];
        [cell setModel:comment];
        cell.delegate = self;
        return cell;
    }
    
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.dyModel.contentHeight;
        
    }
    else if (indexPath.row == 1){
        if ([self.dyModel.d_type isEqual:@1]) {
            return self.dyModel.imagesHeight;
        }
        else if ([self.dyModel.d_type isEqual:@2]){
            return self.dyModel.videoHeight;
        }
        return 0;
    }
    else if (indexPath.row == 2){
        return self.dyModel.locationHeight;
    }
    else if (indexPath.row == 3){
        return self.dyModel.likerHeight;
    }
    else{
        YDDynamicCommentModel *comment = self.dyModel.commentdynamic[indexPath.row-4];
        return comment.height;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 3) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        YDDynamicCommentModel *comment = self.dyModel.commentdynamic[indexPath.row-4];
        //点击自己的评论,弹出删除按钮
        if ([comment.ub_id isEqual:[YDUserDefault defaultUser].user.ub_id]) {
            [LPActionSheet showActionSheetWithTitle:@"删除此评论？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
                if (index == -1) {
                    NSDictionary *param = @{
                                            @"cd_id":YDNoNilNumber(comment.cd_id),
                                            @"access_token":YDAccess_token};
                    [YDNetworking POST:kDeleteCommentURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
                        if ([code isEqual:@200]) {
                            [self.dyModel.commentdynamic removeObject:comment];
                            NSString *title = self.dyModel.commentdynamic.count == 0 ? @"评论" : [NSString stringWithFormat:@"评论·%ld",self.dyModel.commentdynamic.count];
                            //评论
                            [self.bottomView.centerBtn setTitle:title forState:0];
                            [self.tableView reloadData];
                            if (self.delegate && [self.delegate respondsToSelector:@selector(moment:commentCountChanged:)]) {
                                [self.delegate moment:self.viewModel.moment commentCountChanged:self.dyModel.commentdynamic.count];
                            }
                        }
                        else{
                            [YDMBPTool showErrorImageWithMessage:@"删除评论失败" hideBlock:nil];
                        }
                    } failure:^(NSError *error) {
                        [YDMBPTool showErrorImageWithMessage:@"删除评论失败" hideBlock:nil];
                    }];
                }
            }];
        }
        else{
            _comtentTo = comment;
            NSString *headerStr = [NSString stringWithFormat:@"回复%@:",comment.ub_nickname];
            [self.commentView setPlaceholderText:headerStr];
            [self.commentView show];
        }
    }
}

#pragma mark  - XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return _browerPhotos[index];
}
//- (UIImageView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index{
//    return _cellImageViews[index];
//}

#pragma mark - XLPhotoBrowserDelegate
- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex{
    NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
    if (actionSheetindex == 0) {//保存图片
        [browser saveCurrentShowImage];
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
//MARK:3Dtouch 代理(抓取所点击的图片，并初始化用于展示图片的ViewController)
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    __block NSString *imageUrl = nil;
    [self.dyModel.imagesDicArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat y = [[obj valueForKey:@"y"] floatValue];
        CGFloat height = [[obj valueForKey:@"height"] floatValue];
        if (location.y >= y && location.y <= (y + height)) {
            imageUrl = [obj valueForKey:@"url"];
            *stop = YES;
        }
    }];
    
    YDImageController *imageVC = [YDImageController new];
    UIImage *cacheImage =  [[SDImageCache sharedImageCache] imageFromCacheForKey:imageUrl];
    if (cacheImage) {
        imageVC.imageV.image = cacheImage;
        
        CGFloat height = cacheImage.size.height/cacheImage.size.width * previewingContext.sourceView.width;
        //previewingContext.sourceRect = cell.frame;
        imageVC.preferredContentSize = CGSizeMake(previewingContext.sourceView.width, height);
    }
   
    
    return imageVC;
}
//MARK:3dTouch 继续用力点击 ——> 跳入ImageViewController
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self presentViewController:viewControllerToCommit animated:NO completion:nil];
    
}

@end

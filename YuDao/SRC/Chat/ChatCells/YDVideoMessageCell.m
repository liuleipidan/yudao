//
//  YDVideoMessageCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/5.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDVideoMessageCell.h"
#import "YDMessageImageView.h"

@interface YDVideoMessageCell()

@property (nonatomic, strong) YDMessageImageView *msgImageView;

@property (nonatomic, strong) UIImageView *playIcon;

@end

@implementation YDVideoMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView insertSubview:self.msgImageView belowSubview:self.indicatorView];
        
        [self.contentView insertSubview:self.playIcon aboveSubview:self.msgImageView];
        
        [self.playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.msgImageView);
            make.width.height.mas_equalTo(52);
        }];
        
        [self.indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    }
    return self;
}

- (void)setMessage:(YDVideoChatMessage *)message{
    [self.msgImageView setAlpha:1.0];
    YDMessageOwnerType lastOwenType = self.message ? self.message.ownerType : -1;
    [super setMessage:message];
    
    if (message.thumbnailImagePath && message.thumbnailImagePath.length > 0 && message.ownerType == YDMessageOwnerTypeSelf) {
        NSString *imagePath = [NSFileManager pathUserChatImage:message.thumbnailImagePath];
//        NSLog(@"thumbnailImagePath = %@",imagePath);
//        NSData *data = [NSData dataWithContentsOfFile:imagePath];
//        UIImage *image = [UIImage imageWithData:data];
//        NSLog(@"thumbnailImage = %@",image);
//        [self.msgImageView setImage:image];
        [self.msgImageView setImagePath:imagePath];
    }else{
        [self.msgImageView setImageUrl:message.thumbnailImageURL];
    }
    
    if (lastOwenType != message.ownerType) {
        if (message.ownerType == YDMessageOwnerTypeSelf) {
            [self.msgImageView setBackgroundImage:[UIImage imageNamed:@"chat_message_self"]];
            [self.msgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.messageBackgroundView);
                make.right.mas_equalTo(self.messageBackgroundView);
            }];
        }
        else if (message.ownerType == YDMessageOwnerTypeFriend) {
            [self.msgImageView setBackgroundImage:[UIImage imageNamed:@"chat_message_other"]];
            [self.msgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.messageBackgroundView);
                make.left.mas_equalTo(self.messageBackgroundView);
            }];
        }
    }
    [self.msgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(message.messageFrame.contentSize);
    }];
    //添加发送进度加载
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.msgImageView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.failBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.msgImageView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

#pragma mark - Event Response
- (void)setLongpressStatus:(BOOL)selected{
    if (selected) {
        [self.msgImageView setAlpha:0.7];
    }else{
        [self.msgImageView setAlpha:1];
    }
}
- (void)tapMessageView:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellTapView:message:)]) {
        [self.delegate messageCellTapView:tap.view message:self.message];
    }
}

- (void)longPressMsgBGView{
    [self setLongpressStatus:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellLongPress:rect:)]) {
        CGRect rect = self.msgImageView.frame;
        rect.size.height -= 10;     // 背景图片底部空白区域
        [self.delegate messageCellLongPress:self.message rect:rect];
    }
}

- (void)doubleTabpMsgBGView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDoubleClick:)]) {
        [self.delegate messageCellDoubleClick:self.message];
    }
}

#pragma mark - Getter
- (YDMessageImageView *)msgImageView
{
    if (_msgImageView == nil) {
        _msgImageView = [[YDMessageImageView alloc] init];
        [_msgImageView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessageView:)];
        [_msgImageView addGestureRecognizer:tapGR];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMsgBGView)];
        [_msgImageView addGestureRecognizer:longPressGR];
        
        UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTabpMsgBGView)];
        [doubleTapGR setNumberOfTapsRequired:2];
        [_msgImageView addGestureRecognizer:doubleTapGR];
    }
    return _msgImageView;
}

- (UIImageView *)playIcon{
    if (_playIcon == nil) {
        _playIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_icon_play"]];
    }
    return _playIcon;
}

@end

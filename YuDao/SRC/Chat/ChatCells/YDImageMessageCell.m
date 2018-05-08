//
//  YDImageMessageCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDImageMessageCell.h"
#import "YDMessageImageView.h"

@interface YDImageMessageCell()

@property (nonatomic, strong) YDMessageImageView *msgImageView;

@end

@implementation YDImageMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView insertSubview:self.msgImageView belowSubview:self.indicatorView];
        [self.indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    }
    return self;
}

- (void)setMessage:(YDImageChatMessage *)message{
    [self.msgImageView setAlpha:1.0];
    YDMessageOwnerType lastOwenType = self.message ? self.message.ownerType : -1;
    [super setMessage:message];
    
    if (message.imagePath && message.imagePath.length > 0 && message.ownerType == YDMessageOwnerTypeSelf) {
        NSString *imagePath = [NSFileManager pathUserChatImage:message.imagePath];
        [self.msgImageView setImagePath:imagePath];
    }else{
        [self.msgImageView setImageUrl:message.imageURL];
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

@end

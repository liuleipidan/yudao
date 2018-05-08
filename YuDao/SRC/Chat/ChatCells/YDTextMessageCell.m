//
//  YDTextMessageCell.m
//  YuDao
//
//  Created by 汪杰 on 17/2/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTextMessageCell.h"

@interface YDTextMessageCell()

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation YDTextMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.messageLabel];
        [self.indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    return self;
}

- (void)setMessage:(YDTextChatMeesage *)message{
    YDMessageOwnerType lastOwnType = self.message ? self.message.ownerType: -1;
    [super setMessage:message];
    //[self.messageLabel setText:message.text];
    [self.messageLabel setAttributedText:message.attrText];
    [self.messageLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.messageBackgroundView setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    if (lastOwnType != message.ownerType) {
        UIImage *image = [self resizebleImage:message.ownerType];
        [self.messageBackgroundView setImage:image];
        [self.messageBackgroundView setHighlightedImage:image];
        if (message.ownerType == YDMessageOwnerTypeSelf) {
            self.messageLabel.textColor = [UIColor whiteColor];
            [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.messageBackgroundView).mas_offset(-MSG_SPACE_RIGHT);
                make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP);
            }];
            [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.messageLabel).mas_offset(-MSG_SPACE_LEFT);
                make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM);
            }];
            //添加发送进度加载
            [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.messageBackgroundView);
                make.right.equalTo(self.messageBackgroundView.mas_left).offset(-5);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            [self.failBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.messageBackgroundView);
                make.right.equalTo(self.messageBackgroundView.mas_left).offset(-5);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
        }
        else if (message.ownerType == YDMessageOwnerTypeFriend){
            self.messageLabel.textColor = YDColorString(@"#2A2A2A");
            [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_LEFT);
                make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP);
            }];
            [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_RIGHT);
                make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM);
            }];
        }
    }
    
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        //单行宽度 +3 用于适配有些纯英文显示不全
        make.width.mas_equalTo(message.messageFrame.contentSize.height < 26 ? message.messageFrame.contentSize.width + 3 : message.messageFrame.contentSize.width);
        //固定单行高度
        make.height.mas_equalTo(message.messageFrame.contentSize.height < 26 ? 21: message.messageFrame.contentSize.height);
    }];
    //重置单行背景与内容的间距
    if (message.messageFrame.contentSize.height < 26) {
        [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM-5);
        }];
        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP-5);
        }];
    }
}

#pragma mark - Getter -
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:15]];
        _messageLabel.backgroundColor = [UIColor clearColor];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _messageLabel.lineBreakMode = UILineBreakModeCharacterWrap;
#pragma clang diagnostic pop
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

@end

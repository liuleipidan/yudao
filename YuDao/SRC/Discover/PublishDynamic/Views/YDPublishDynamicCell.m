//
//  YDPublishDynamicCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPublishDynamicCell.h"
#import "YDPublishDynamicImagesView.h"

@interface YDPublishDynamicCell()<YDPublishDynamicCellDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) YDPublishDynamicImagesView *imagesView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation YDPublishDynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView yd_addSubviews:@[self.textView,self.placeholderLabel,self.imagesView,self.lineView]];
        
        [self pbc_addMasonry];
        
        [YDNotificationCenter addObserver:self selector:@selector(pbc_textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
    }
    return self;
}

- (void)dealloc{
    [YDNotificationCenter removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setItem:(YDPublishDynamicModel *)item{
    _item = item;
    
    [_imagesView setItem:item];
    
    [_imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(item.imagesHeight);
        make.width.mas_equalTo(item.imagesWidth);
    }];
}

- (void)deleteLastCharacter
{
    if([self textView:self.textView shouldChangeTextInRange:NSMakeRange(self.textView.text.length - 1, 1) replacementText:@""]){
        [self.textView deleteBackward];
    }
}

#pragma mark - YDPublishDynamicCellDelegate
- (void)clickedAdd{
    if (_delegate && [_delegate respondsToSelector:@selector(clickedAdd)]) {
        [_delegate clickedAdd];
    }
}

- (void)clickedDelete:(NSInteger)index{
    if (_delegate && [_delegate respondsToSelector:@selector(clickedDelete:)]) {
        [_delegate clickedDelete:index];
    }
}

- (void)clickedImage:(NSInteger)index{
    if (_delegate && [_delegate respondsToSelector:@selector(clickedImage:)]) {
        [_delegate clickedImage:index];
    }
}

- (void)clickedVideo:(NSURL *)videoURL{
    if (_delegate && [_delegate respondsToSelector:@selector(clickedVideo:)]) {
        [_delegate clickedVideo:self.item.videoLocalURL];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTextViewShouldBeginEditing:)]) {
        return [_delegate cellTextViewShouldBeginEditing:textView];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 0 && [text isEqualToString:@""]) {       // delete
        if ([textView.text characterAtIndex:range.location] == ']') {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            while (location != 0) {
                location --;
                length ++ ;
                char c = [textView.text characterAtIndex:location];
                if (c == '[') {
                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
                    return NO;
                }
                else if (c == ']') {
                    return YES;
                }
            }
        }
    }
    
    return YES;
}

#pragma mark - Private Methods
- (void)pbc_textViewTextDidChange:(NSNotification *)noti{
    UITextView *textView = noti.object;
    _item.text = textView.text;
    self.placeholderLabel.hidden = _item.text.length > 0 ? YES : NO;
}

- (void)pbc_addMasonry{
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(100);
    }];
    
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_top);
        make.left.equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(36);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [_imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(_textView.mas_bottom).offset(10);
        make.height.mas_equalTo(0);
        make.width.mas_equalTo(0);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
}

#pragma mark - Getters
- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.font = [UIFont font_16];
        _textView.textColor = [UIColor blackTextColor];
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeholderLabel{
    if (_placeholderLabel == nil) {
        _placeholderLabel = [UILabel labelByTextColor:[UIColor grayTextColor1] font:[UIFont font_16]];
        _placeholderLabel.text = @"你想说的话......";
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor grayBackgoundColor];
    }
    return _placeholderLabel;
}

- (YDPublishDynamicImagesView *)imagesView{
    if (_imagesView == nil) {
        _imagesView = [[YDPublishDynamicImagesView alloc] initWithFrame:CGRectZero];
        _imagesView.delegate = self;
    }
    return _imagesView;
}

@end

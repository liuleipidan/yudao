//
//  YDImageChatMessage.m
//  YuDao
//
//  Created by 汪杰 on 17/1/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDImageChatMessage.h"

@implementation YDImageChatMessage
@synthesize imagePath = _imagePath;
@synthesize imageURL = _imageURL;

- (id)init{
    if (self = [super init]) {
        [self setMessageType:YDMessageTypeImage];
    }
    return self;
}

#pragma mark -
- (NSString *)imagePath
{
    if (_imagePath == nil) {
        _imagePath = [self.content objectForKey:@"path"];
    }
    return _imagePath;
}
- (void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
    [self.content setObject:imagePath forKey:@"path"];
}

- (NSString *)imageURL
{
    if (_imageURL == nil) {
        _imageURL = [self.content objectForKey:@"url"];
    }
    return _imageURL;
}
- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    [self.content setObject:imageURL forKey:@"url"];
}

- (CGSize)imageSize
{
    CGFloat width = [[self.content objectForKey:@"width"] doubleValue];
    CGFloat height = [[self.content objectForKey:@"height"] doubleValue];
    return CGSizeMake(width > 0? width : 200, height > 0? height : 200 );
}
- (void)setImageSize:(CGSize)imageSize
{
    [self.content setObject:[NSNumber numberWithDouble:imageSize.width] forKey:@"width"];
    [self.content setObject:[NSNumber numberWithDouble:imageSize.height] forKey:@"height"];
}

- (YDMessageFrame *)messageFrame{
    if (!_messageFrame) {
        _messageFrame = [[YDMessageFrame alloc]init];
        _messageFrame.height = 12 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0);
        CGSize imageSize = self.imageSize;
        if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
            _messageFrame.contentSize = CGSizeMake(100, 100);
        }
        else if (imageSize.width > imageSize.height) {
            CGFloat height = MAX_MESSAGE_IMAGE_WIDTH * imageSize.height / imageSize.width;
            height = height < MIN_MESSAGE_IMAGE_WIDTH ? MIN_MESSAGE_IMAGE_WIDTH : height;
            _messageFrame.contentSize = CGSizeMake(MAX_MESSAGE_IMAGE_WIDTH, height);
        }
        else {
            CGFloat width = MAX_MESSAGE_IMAGE_WIDTH * imageSize.width / imageSize.height;
            width = width < MIN_MESSAGE_IMAGE_WIDTH ? MIN_MESSAGE_IMAGE_WIDTH : width;
            _messageFrame.contentSize = CGSizeMake(width, MAX_MESSAGE_IMAGE_WIDTH);
        }
        
        _messageFrame.height += _messageFrame.contentSize.height;
        
    }
    return _messageFrame;
}

- (NSString *)conversationContent
{
    return @"[图片]";
}

- (NSString *)messageCopy
{
    return [self.content mj_JSONString];
}

@end

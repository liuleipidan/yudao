//
//  YDVideoChatMessage.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/5.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDVideoChatMessage.h"

@implementation YDVideoChatMessage
@synthesize videoPath = _videoPath;
@synthesize videoURL = _videoURL;
@synthesize thumbnailImagePath = _thumbnailImagePath;
@synthesize thumbnailImageURL = _thumbnailImageURL;

- (id)init{
    if (self = [super init]) {
        [self setMessageType:YDMessageTypeVideo];
    }
    return self;
}

#pragma mark - Setters & Getters
- (NSString *)videoPath{
    if (_videoPath == nil) {
        _videoPath = [self.content objectForKey:@"videoPath"];
    }
    return _videoPath;
}

- (void)setVideoPath:(NSString *)videoPath{
    _videoPath = videoPath;
    [self.content setObject:videoPath forKey:@"videoPath"];
}

- (NSString *)videoURL{
    if (_videoURL == nil) {
        _videoURL = [self.content objectForKey:@"videoURL"];
    }
    return _videoURL;
}

- (void)setVideoURL:(NSString *)videoURL{
    _videoURL = videoURL;
    [self.content setObject:videoURL forKey:@"videoURL"];
}

- (NSString *)thumbnailImagePath{
    if (_thumbnailImagePath == nil) {
        _thumbnailImagePath = [self.content objectForKey:@"imagePath"];
    }
    return _thumbnailImagePath;
}

- (void)setThumbnailImagePath:(NSString *)thumbnailImagePath{
    _thumbnailImagePath = thumbnailImagePath;
    [self.content setObject:thumbnailImagePath forKey:@"imagePath"];
}

- (NSString *)thumbnailImageURL{
    if (_thumbnailImageURL == nil) {
        _thumbnailImageURL = [self.content objectForKey:@"imageURL"];
    }
    return _thumbnailImageURL;
}

- (void)setThumbnailImageURL:(NSString *)thumbnailImageURL{
    _thumbnailImageURL = thumbnailImageURL;
    [self.content setObject:thumbnailImageURL forKey:@"imageURL"];
}

- (CGSize)thumbnailImageSize{
    CGFloat width = [[self.content objectForKey:@"imageWidth"] doubleValue];
    CGFloat height = [[self.content objectForKey:@"imageHeight"] doubleValue];
    return CGSizeMake(width > 0? width : 200, height > 0? height : 200 );
}

- (void)setThumbnailImageSize:(CGSize)thumbnailImageSize{
    [self.content setObject:[NSNumber numberWithDouble:thumbnailImageSize.width] forKey:@"imageWidth"];
    [self.content setObject:[NSNumber numberWithDouble:thumbnailImageSize.height] forKey:@"imageHeight"];
}

- (YDMessageFrame *)messageFrame{
    if (!_messageFrame) {
        _messageFrame = [[YDMessageFrame alloc]init];
        _messageFrame.height = 12 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0);
        CGSize imageSize = self.thumbnailImageSize;
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
    return @"[视频]";
}

- (NSString *)messageCopy
{
    return [self.content mj_JSONString];
}

@end

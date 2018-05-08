//
//  pinyin.h
//  YuDao
//
//  Created by 汪杰 on 16/9/28.
//  Copyright © 2016年 汪杰. All rights reserved.
//

/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *hanyu = @"中国共产党万岁！";
 * for (int i = 0; i < [hanyu length]; i++)
 * {
 *     printf("%c", pinyinFirstLetter([hanyu characterAtIndex:i]));
 * }
 *
 */

char pinyinFirstLetter(unsigned short hanzi);
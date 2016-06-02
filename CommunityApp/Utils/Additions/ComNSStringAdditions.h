//
//  SXNSStringAdditions.h
//  TPO
//
//  Created by SunX on 14-5-9.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ComNSStringAdditions)

//当前string的md5
- (NSString *)comMD5;

//string json 解码
- (id)comJsonDecode;

//unsign integer
- (NSUInteger)comUnsignedIntegerValue;

//获取指定宽度情况下，字符串value的高度fontSize 字体的大小 andWidth 限制字符串显示区域的宽度
- (CGFloat)heightWithFont:(UIFont*)font width:(float)width;

@end

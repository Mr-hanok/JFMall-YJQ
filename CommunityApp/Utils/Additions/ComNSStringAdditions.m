//
//  SXNSStringAdditions.m
//  TPO
//
//  Created by SunX on 14-5-9.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import "ComNSStringAdditions.h"
#import <commoncrypto/CommonDigest.h>

@implementation NSString (ComNSStringAdditions)

- (NSString *)comMD5
{
    const char *str = [self UTF8String];
    unsigned char res[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str,(CC_LONG)strlen(str), res);
    NSMutableString *m = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [m appendFormat:@"%02x",res[i]];
    }
    return m;
}

- (id)comJsonDecode {
    if(![self isKindOfClass:[NSString class]]) return nil;
    NSData *data =  [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error=nil;
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers error:&error];
}

- (NSUInteger)comUnsignedIntegerValue{
    if(![self isKindOfClass:[NSString class]]) return 0;
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    return [[formatter numberFromString:self] unsignedIntegerValue];
}

- (CGFloat)heightWithFont:(UIFont*)font width:(float)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize sizeToFit = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading
                                        attributes:attributes context:nil].size;
    
    return sizeToFit.height;
}

@end

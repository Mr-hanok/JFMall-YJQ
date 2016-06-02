//
//  TDDUIImageAdditions.m
//  TDDManager
//
//  Created by SunX on 15/7/15.
//  Copyright (c) 2015年 SunX. All rights reserved.
//

#import "ComUIImageAdditions.h"

@implementation UIImage (ComUIImageAdditions)

- (UIImage *)gaussianBlur:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    const size_t width = CGImageGetWidth(img)-2;
    const size_t height = CGImageGetHeight(img)-2;
    const size_t rowBytes = CGImageGetBytesPerRow(img);
    
    vImage_Buffer inBuffer = {(void*)CFDataGetBytePtr(inBitmapData) , height, width, rowBytes};
    
    void *pixelBuffer = malloc(rowBytes * height);
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    vImage_Buffer outBuffer = {pixelBuffer , height, width, rowBytes};
    
    vImage_Buffer outBuffer2 = {pixelBuffer , height, width, rowBytes};
    
    vImage_Error error;
    vImageBoxConvolve_ARGB8888(&inBuffer,&outBuffer2,NULL,0,0,boxSize,boxSize,NULL,kvImageEdgeExtend);
    vImageBoxConvolve_ARGB8888(&outBuffer2,&inBuffer,NULL,0,0,boxSize,boxSize,NULL,kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer,&outBuffer,NULL,0,0,boxSize,boxSize,NULL,kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"vImage_Error 错误代码 %ld", error);
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             bitmapInfo);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (BOOL)writeImageToFilePath:(NSString*)filePath
          compressionQuality:(CGFloat)compressionQuality
{
    NSData *imageData = nil;
    NSString *ext = [filePath pathExtension];
    if ([ext isEqualToString:@"png"])
        imageData = UIImagePNGRepresentation(self);
    else
    {
        imageData = UIImageJPEGRepresentation(self, compressionQuality);
    }
    if ([imageData length] <= 0) {
        return NO;
    }
    [imageData writeToFile:filePath atomically:YES];
    return YES;
}

- (UIImage*)toJPGImageWithCompressionQuality:(CGFloat)compressionQuality {
    NSData *imageData = UIImageJPEGRepresentation(self, compressionQuality);
    return  [UIImage imageWithData:imageData];
}

@end

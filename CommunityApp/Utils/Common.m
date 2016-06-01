//
//  Common.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "Common.h"
#import "DDXMLElementAdditions.h"

//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>
#import "AFNetworkReachabilityManager.h"

@implementation Common
+(void)weiXinLoginOrIphoneLogin
{
    //已安装微信进入微信登陆
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
    {
        PersonalWeinXinLoginViewController*vc=[[PersonalWeinXinLoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        //        nav.navigationBarHidden = YES;
        ((AppDelegate *)([UIApplication sharedApplication]).delegate).window.rootViewController = nav;
    }
    else{//没有安装微信进入手机登陆
        PersonalCenterViewController*vc=[[PersonalCenterViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        //        nav.navigationBarHidden = YES;
        ((AppDelegate *)([UIApplication sharedApplication]).delegate).window.rootViewController = nav;
    }
    //

}
+(BOOL)wifiSwitchValue
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_WIFI_SWITCH];
}

//搜索记录
+(BOOL)insertSearchText:(NSString *)text
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_SEARCH_TEXT];
    NSMutableArray *searchArray = [[NSMutableArray alloc] initWithArray:array];
    
    if (![searchArray containsObject:text])
    {
        [searchArray addObject:text];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:searchArray forKey:KEY_SEARCH_TEXT];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray *)getSearchText
{
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_SEARCH_TEXT];
    return [[array reverseObjectEnumerator] allObjects];
}

+(BOOL)clearSearchHistory
{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:KEY_SEARCH_TEXT];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)CheckString:(NSString *)string
{
    if (string.length == 0)
    {
        return @"";
    }
    else
    {
        return string;
    }
}

/**
 根据网络状态显示不同提示信息
 AFNetworkReachabilityStatusUnknown          = -1,  // 未知
 AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
 AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
 AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
 */
#pragma -mark 12-23判断网络是否连接
+(BOOL)checkNetworkStatus
{
    NSNumber *status = [[LoginConfig Instance] getNetStatus];
    return status.intValue == AFNetworkReachabilityStatusReachableViaWWAN || status.intValue == AFNetworkReachabilityStatusReachableViaWiFi;
}

+ (void)showBottomToast:(NSString *)message
{
    [[AppToast shareInstance] showToastWith:message position:ToastPositionBottom];
}

+ (void)showCenterToast:(NSString *)message
{
    [[AppToast shareInstance] showToastWith:message position:ToastPositionCenter];
}

+ (void)showNoticeAlertView:(NSString *)message
{
    [self showNoticeAlertView:@"温馨提示" message:message];
}

+ (void)showNoticeAlertView:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (CGFloat)labelDemandHeightWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size
{
    CGRect bounds = CGRectZero;
    CGFloat height = 0.0;
    if (IOS7) {
        bounds = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] context:nil];
    }
    else{
        CGSize demandSize = [text sizeWithFont:font constrainedToSize:size];
        bounds = CGRectMake(0, 0, demandSize.width, demandSize.height);
    }
    return height = bounds.size.height;
    
}

+ (CGFloat)labelDemandWidthWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size
{
    CGRect bounds = CGRectZero;
    CGFloat width = 0.0;
    if (IOS7) {
        bounds = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] context:nil];
    }
    else{
        CGSize demandSize = [text sizeWithFont:font constrainedToSize:size];
        bounds = CGRectMake(0, 0, demandSize.width, demandSize.height);
    }
    return width = bounds.size.width;
}

+ (CGRect)labelDemandRectWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size
{
    CGRect bounds = CGRectZero;
    
    if (IOS7) {
        bounds = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    }
    else{
        CGSize demandSize = [text sizeWithFont:font constrainedToSize:size];
        bounds = CGRectMake(0, 0, demandSize.width, demandSize.height);
    }
    return bounds;
}


+ (NSString *)navigationItemTitle:(NSString *)text
{
    NSString *string = @"";
    CGFloat width = [Common labelDemandWidthWithText:text font:[UIFont systemFontOfSize:20.0] size:CGSizeMake(Screen_Width*2, 44.0)];
    int num = 0;
    if (width > Screen_Width*0.8) {
        num = Screen_Width*0.85*text.length/width;
        NSString *titleText = [text substringToIndex:num-3];
        string = [titleText stringByAppendingString:@"..."];
    }
    else{
        string = text;
    }
    
    return string;
}

+ (NSString *)showText:(NSString *)text maxWidth:(CGFloat)maxWidth
{
    NSString *string = @"";
    CGFloat width = [Common labelDemandWidthWithText:text font:[UIFont systemFontOfSize:20.0] size:CGSizeMake(Screen_Width*2, 44.0)];
    int num = 0;
    if (width > maxWidth) {
        num = maxWidth*text.length/width;
        NSString *titleText = [text substringToIndex:num-3];
        string = [titleText stringByAppendingString:@"..."];
    }
    else{
        string = text;
    }
    
    return string;
}

+ (CGFloat)labelTextWidth:(UILabel *)label
{
    if (label.text.length != 0)
    {
        CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, label.frame.size.height) lineBreakMode:label.lineBreakMode];
        return size.width + 1;
    }
    
    return 1;
}

//设置Autolayout中的边距辅助方法
+ (void)updateLayout:(UIView *)view where:(NSLayoutAttribute)attribute constant:(CGFloat)constant
{
    if (attribute == NSLayoutAttributeLeading
        || attribute == NSLayoutAttributeTop
        || attribute == NSLayoutAttributeBottom
        || attribute == NSLayoutAttributeLeft
        || attribute == NSLayoutAttributeRight)
    {
        for (NSLayoutConstraint *constraint in view.superview.constraints)
        {
            if (constraint.firstItem == view)
            {
                if (constraint.firstAttribute == attribute)
                {
                    [constraint setConstant:constant];
                }
            }
        }
    }
    else
    {
        for (NSLayoutConstraint *constraint in view.constraints)
        {
            if (constraint.firstItem == view)
            {
                if (constraint.firstAttribute == attribute)
                {
                    [constraint setConstant:constant];
                }
            }
        }
    }
}

+(void)setEdge:(UIView *)view attr:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    [self setEdge:view.superview view:view attr:attr constant:constant];
}

+(void)setEdge:(UIView *)superview view:(UIView *)view attr:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (attr == NSLayoutAttributeHeight || attr == NSLayoutAttributeWidth)
    {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant]];
    }
    else
    {
        [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr multiplier:1.0 constant:constant]];
    }
}

/* 设置圆角边框 */
+(void)setRoundBorder:(UIView *)view borderWidth:(CGFloat)width cornerRadius:(CGFloat)radius borderColor:(UIColor *)color{
    CALayer *layer = view.layer;
    layer.borderWidth = width;
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
    layer.borderColor = color.CGColor;
}

/* 判断字符串是否为空－公共函数 */
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        return YES;
    }
    
    return NO;
}

/* 判断输入的字符串是否是电话号码－公共函数 */
+ (BOOL)checkPhoneNumInput:(NSString *)_text
{
    return [self validateNumber:_text] && (_text.longLongValue > 9999999999 && _text.longLongValue <= 19999999999);
}

/* 判断输入的字符串是否为email格式*/
+ (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL result = [emailTest evaluateWithObject:candidate];
    return result;
}

/* 判断输入的字符串是否为数字格式*/
+ (BOOL)validateNumber:(NSString *)number
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    
    while (i < number.length)
    {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0)
        {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

//图片URL转码
+ (NSString *)setCorrectURL:(NSString *)url
{
    if ([url isKindOfClass:[NSString class]] && url.length != 0)
    {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",ImageServer_Address, url];
//        NSString *urlString = [[url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return urlString;
    }
    
    return @"";
}

//图片URL转码 共通
+ (NSString *)setCorrectURLByServer:(NSString *)server andImgUrl:(NSString *)url
{
    if ([url isKindOfClass:[NSString class]] && url.length != 0)
    {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",server, url];
        //        NSString *urlString = [[url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return urlString;
    }
    
    return @"";
}


+ (NSString *)encryptWithText:(NSString *)sText theKey:(NSString *)aKey
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
    plainTextBufferSize = [encryptData length];
    vplainText = (const void *)[encryptData bytes];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [aKey UTF8String];
    
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,//  加密/解密
                                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                                       vkey,//密钥    加密和解密的密钥必须一致
                                       aKey.length,//   DES 密钥的大小（kCCKeySizeDES=8）
                                       vkey,//  可选的初始矢量
                                       vplainText,// 数据的存储单元
                                       plainTextBufferSize,// 数据的大小
                                       (void *)bufferPtr,// 用于返回数据
                                       bufferPtrSize,
                                       &movedBytes);
    //NSLog(@"%d",ccStatus);
    NSString *result = nil;
    if (ccStatus == kCCSuccess)
    {
        result = [self parseByte2HexString:bufferPtr length:movedBytes];
    }
    return result;
}

//用于将byte转换成16进制数据
+(NSString *) parseByte2HexString:(Byte *) bytes length:(int) length
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    if(bytes)
    {
        for(int i = 0;i<length;i++)
        {
            if (bytes [i] == '\0')
            {
                continue;
            }
            
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
        }
    }
    //NSLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}

+ (NSString *)MD5With:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSString *result32 = [NSString stringWithFormat:
                          @"%02X%02X%02X%02X%02X%02X%02X%02X"
                          "%02X%02X%02X%02X%02X%02X%02X%02X",
                          result[0],result[1],result[2],result[3],
                          result[4],result[5],result[6],result[7],
                          result[8],result[9],result[10],result[11],
                          result[12],result[13],result[14],result[15]];
    
    return result32;
}

+ (UIImage *)fitSmallImage:(UIImage *)image
{
    if (nil == image)
    {
        return nil;
    }
    
    NSData *data;
    
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    
    NSInteger imgsize = 0;
    
    if (data.length / 1000.0 >= data.length / 1000+0.5)
    {
        imgsize = data.length / 1000 + 1;
        //        NSLog(@"原图大小：%d KB",imgsize);
    }
    else
    {
        imgsize = data.length / 1000;
        //        NSLog(@"原图大小：%d KB",imgsize);
    }
    
    if (data.length / 1000000.0 >= 1.0 || imgsize > 200)
    {
        CGSize size = [self fitsize:image.size];
        UIGraphicsBeginImageContext(size);
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        [image drawInRect:rect];
        
        UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *ndata;
        if (UIImagePNGRepresentation(image) == nil)
        {
            ndata = UIImageJPEGRepresentation(newing, 1.0);
        }
        else
        {
            ndata = UIImagePNGRepresentation(newing);
        }
        
        //        NSLog(@"等比缩放后图片大小：%f KB",ndata.length / 1000.0);
        return newing;
    }
    else
    {
        return image;
    }
}

+ (CGSize)fitsize:(CGSize)thisSize
{
    if(thisSize.width == 0 && thisSize.height ==0)
    {
        return CGSizeMake(0, 0);
    }
    
    CGFloat wscale = thisSize.width/240.0;
    CGFloat hscale = thisSize.height/240.0;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    
    return newSize;
}

+(UIImage *)compressionImage:(UIImage *)image
{
    UIImage *temp = [Common fitImageSizeWith:image];
    return [UIImage imageWithData:UIImageJPEGRepresentation(temp, 0.0001)];
    //    return [UIImage imageWithData:UIImageJPEGRepresentation(temp, [Common getImageScaling:temp])];
}

//压缩图片长宽
+(UIImage *)fitImageSizeWith:(UIImage *)img
{
    int h = img.size.height;
    int w = img.size.width;
    
    float destWith = 0.0;
    float destHeight = 0.0;
    
    if ((h < 800 && w < 600) || (h < 600 && w < 800))
    {
        return img;
    }
    
    if (w>h)
    {
        destWith = (float)600;
        destHeight = 600 * h / w;
    }
    else
    {
        destHeight = (float)800;
        destWith = 800 * w / h;
    }
    
    CGSize itemSize = CGSizeMake(destWith, destHeight);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 0, destWith + 1, destHeight);
    [img drawInRect:imageRect];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImg;
}

+(CGFloat)getImageScaling:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataLength = data.length / 1024.0;
    CGFloat scaling = 0.0;
    
    if (dataLength >= 1024)
    {
        scaling = 0.00001;
    }
    else if (dataLength >= 512.0 && dataLength < 1024)
    {
        scaling = 0.0001;
    }
    else if (dataLength >= 100.0 && dataLength < 512.0)
    {
        scaling = 0.001;
    }
    else if (dataLength >= 30.0 && dataLength < 100.0)
    {
        scaling = 0.01;
    }
    else
    {
        scaling = 1.0;
    }
    
    return scaling;
}

// 获取UUID
+ (NSString*) getUUIDString
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}


#pragma mark - 等比缩放
//指定宽度按比例缩放
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}


// 指定缩放目标宽度，获取缩放目标高度
+(CGFloat)getTargetHeightForScaleImage:(UIImage *)sourceImage withTargetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
    }
    
    return scaledHeight;
}

// 为指定字符串数组添加标签
+(void)insertLabelForStrings:(NSArray *)strings toView:(UIView *)view andMaxWidth:(CGFloat)maxWidth andLabelHeight:(CGFloat)labelHeight andLabelMargin:(CGFloat)labelMargin andAddtionalWidth:(CGFloat)additionalWidth andFont:(UIFont *)font andBorderColor:(CGColorRef)borderColor andTextColor:(UIColor *)textColor
{
    NSArray *subviews = [view subviews];
    for (UIView *subView in subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat usedWidth = 0.0;                    // 已用宽度
    CGFloat posY = (view.bounds.size.height - labelHeight)/2.0; // 标签Y坐标
    
    for (int i=0; i<strings.count; i++) {
        NSString *str = [strings objectAtIndex:i];
        CGFloat width = [Common labelDemandWidthWithText:str font:font size:CGSizeMake(maxWidth, labelHeight)];
        
        if ((usedWidth+width+additionalWidth) > maxWidth) {
            break;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(usedWidth, posY, width+additionalWidth, labelHeight)];
        [label setText:str];
        label.font = font;
        label.textColor = textColor;
        label.layer.borderColor = borderColor;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = 5.0;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        usedWidth += width+additionalWidth+labelMargin;
    }
}


// 为指定字符串数组添加标签
+(void)insertLabelForStrings:(NSArray *)strings toView:(UIView *)view andViewHeight:(CGFloat)viewHight andMaxWidth:(CGFloat)maxWidth andLabelHeight:(CGFloat)labelHeight andLabelMargin:(CGFloat)labelMargin andAddtionalWidth:(CGFloat)additionalWidth andFont:(UIFont *)font andBorderColor:(CGColorRef)borderColor andTextColor:(UIColor *)textColor
{
    NSArray *subviews = [view subviews];
    for (UIView *subView in subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat usedWidth = 0.0;                    // 已用宽度
    CGFloat posY = (viewHight - labelHeight)/2.0; // 标签Y坐标
    
    for (int i=0; i<strings.count; i++) {
        NSString *str = [strings objectAtIndex:i];
        CGFloat width = [Common labelDemandWidthWithText:str font:font size:CGSizeMake(maxWidth, labelHeight)];
        
        if ((usedWidth+width+additionalWidth) > maxWidth) {
            break;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(usedWidth, posY, width+additionalWidth, labelHeight)];
        [label setText:str];
        label.font = font;
        label.textColor = textColor;
        label.layer.borderColor = borderColor;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = 2.0;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        usedWidth += width+additionalWidth+labelMargin;
    }
}


// 为指定字符串数组添加按钮
+(NSArray *)insertButtonForStrings:(NSArray *)strings toView:(UIView *)view andViewHeight:(CGFloat)viewHight andMaxWidth:(CGFloat)maxWidth andButtonHeight:(CGFloat)btnHeight andButtonMargin:(CGFloat)btnMargin andAddtionalWidth:(CGFloat)additionalWidth andFont:(UIFont *)font andBorderColor:(CGColorRef)borderColor andTextColor:(UIColor *)textColor
{
    NSArray *subviews = [view subviews];
    for (UIView *subView in subviews) {
        [subView removeFromSuperview];
    }
    
    NSMutableArray *btnArray = [[NSMutableArray alloc] init];
    
    CGFloat usedWidth = 0.0;                    // 已用宽度
    CGFloat posY = (viewHight - btnHeight)/2.0; // 标签Y坐标
    
    for (int i=0; i<strings.count; i++) {
        NSString *str = [strings objectAtIndex:i];
        CGFloat width = [Common labelDemandWidthWithText:str font:font size:CGSizeMake(maxWidth, btnHeight)];
        
//        why？？？？？
//        if ((usedWidth+width+additionalWidth) > maxWidth) {
//            break;
//        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(usedWidth, posY, width+additionalWidth, btnHeight);
        [button.titleLabel setFont:font];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:textColor forState:UIControlStateNormal];
        button.layer.borderColor = borderColor;
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 2.0;
        button.tag = i;
        [view addSubview:button];
        [btnArray addObject:button];
        usedWidth += width+additionalWidth+btnMargin;
    }
    
    return btnArray;
}


#pragma mark - 创建主订单号
+(NSString *)createMainOrderNo
{
    NSString    *mOrderNo = @"M";
    LoginConfig *loginConfig = [LoginConfig Instance];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyMMddHHmmss";
    NSString *strNow = [formatter stringFromDate:now];
    mOrderNo = [mOrderNo stringByAppendingString:strNow];
    
    if ([loginConfig userLogged]) {
        mOrderNo = [mOrderNo stringByAppendingString:[loginConfig userID]];
    }
    
    NSInteger randomVal = random()%10000;
    mOrderNo = [mOrderNo stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)randomVal]];
    
    return mOrderNo;
}


#pragma mark - 创建子订单号
+(NSString *)createSubOrderNoWithSubNo:(NSInteger)subNo
{
    NSString    *sOrderNo = @"S";
    LoginConfig *loginConfig = [LoginConfig Instance];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyMMddHHmmss";
    NSString *strNow = [formatter stringFromDate:now];
    sOrderNo = [sOrderNo stringByAppendingString:strNow];
    
    if ([loginConfig userLogged]) {
        sOrderNo = [sOrderNo stringByAppendingString:[loginConfig userID]];
    }
    
    sOrderNo = [sOrderNo stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)subNo]];
    
    return sOrderNo;
}

#pragma mark - 创建物业账单订单号
+(NSString *)createPropertyBillOrderNo
{
    NSString    *sOrderNo = @"G";
    LoginConfig *loginConfig = [LoginConfig Instance];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyMMddHHmmss";
    NSString *strNow = [formatter stringFromDate:now];
    sOrderNo = [sOrderNo stringByAppendingString:strNow];
    
    if ([loginConfig userLogged]) {
        sOrderNo = [sOrderNo stringByAppendingString:[loginConfig userID]];
    }
    
    sOrderNo = [sOrderNo stringByAppendingString:@"1"];
    
    return sOrderNo;
}


+ (NSString *)vaildString:(NSString *)string
{
    return string.length == 0 ? @"" : string;
}

/* 获取本地图片存储路径 */
+(NSString *)getImageSavePath
{
    //获取存放的照片
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"PhotoFile"];
    return imageDocPath;
}

+ (NSMutableArray *)getArrayFromXML:(NSString *)xmlString
{
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    NSArray *nodes = [xmlDoc nodesForXPath:@"//xml" error:nil];
    
    NSMutableArray* resultArray= [[NSMutableArray alloc]init];
    for (DDXMLElement *user in nodes)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString* createTime = [[user elementForName:@"CreateTime"] stringValue] ;
        if(createTime) {
            [dic setObject:createTime forKey:@"CreateTime"];
        }
        NSString* type = [[user elementForName:@"MsgType"] stringValue];
        if(type) {
            [dic setObject:type forKey:@"MsgType"];
        }
        if([type isEqualToString:@"news"]) {
            NSString* ArticleCount = [[user elementForName:@"ArticleCount"] stringValue];
            if(ArticleCount) {
                [dic setObject:ArticleCount forKey:@"ArticleCount"];
            }
            DDXMLElement* Articles = [user elementForName:@"Articles"];
            NSArray* itemes = [Articles elementsForName:@"item"];
            NSMutableArray* itemsArray = [[NSMutableArray alloc]init];
            for (DDXMLElement *items in itemes) {
                NSMutableDictionary* newsItem = [[NSMutableDictionary alloc]init];
                NSString* Title = [[items elementForName:@"Title"] stringValue];
                if (Title) {
                    [newsItem setObject:Title forKey:@"Title"];
                }
                NSString* Description = [[items elementForName:@"Description"] stringValue];
                if(Description) {
                    [newsItem setObject:Description forKey:@"Description"];
                }
                NSString* PicUrl = [[items elementForName:@"PicUrl"] stringValue];
                if(PicUrl) {
                    [newsItem setObject:PicUrl forKey:@"PicUrl"];
                }
                NSString* Url = [[items elementForName:@"Url"] stringValue];
                if (Url) {
                    [newsItem setObject:Url forKey:@"Url"];
                }
                [itemsArray addObject:newsItem];
            }
            [dic setObject:itemsArray forKey:@"Content"];
        }
        else {
            NSString* Content = [[user elementForName:@"Content"] stringValue];
            if(Content) {
                [dic setObject:Content forKey:@"Content"];
            }
        }
        [resultArray addObject:dic];
    }
    return resultArray;
}

+ (NSArray *)getArrayFromJson:(NSString *)jsonStr
{
    NSError *error = nil;
    NSArray *array = nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    return array;
}

@end

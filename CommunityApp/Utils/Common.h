//
//  Common.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "PersonalWeinXinLoginViewController.h"
#import "PersonalCenterViewController.h"
@interface Common : NSObject

+(void)weiXinLoginOrIphoneLogin;
//判断Wifi模式是否开启
+(BOOL)wifiSwitchValue;

+(NSString *)CheckString:(NSString *)string;

//检查网络是否可用
+(BOOL)checkNetworkStatus;

//Toast
+ (void)showCenterToast:(NSString *)message;
+ (void)showBottomToast:(NSString *)message;

//Alert
+ (void)showNoticeAlertView:(NSString *)message;
+ (void)showNoticeAlertView:(NSString *)title message:(NSString *)message;

//搜索记录
+(BOOL)insertSearchText:(NSString *)text;
+(NSArray *)getSearchText;
+(BOOL)clearSearchHistory;

/**
 * 获取appDelegate
 * @return appDelegate
 */
+ (AppDelegate *)appDelegate;

/**
 * 计算label显示某段文字需要的高度
 * @param text 目标文字
 * @param font label的字体
 * @param size label的最大尺寸
 */
+ (CGFloat)labelDemandHeightWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size;

/**
 * 计算label显示某段文字需要的宽度
 * @param text 目标文字
 * @param font label的字体
 * @param size label的最大尺寸
 */
+ (CGFloat)labelDemandWidthWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size;

/**
 * 计算label显示某段文字需要的Rect
 * @param text 目标文字
 * @param font label的字体
 * @param size label的最大尺寸
 */
+ (CGRect)labelDemandRectWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size;

/**
 * 根据文字长度计算navigationItem需要显示的文字，即显示文字最大的宽度为屏幕宽度*0.9，超出的文字显示...
 * @param text 目标text
 * @result 返回NSString类型数据，即最大宽度下显示的文字
 */
+ (NSString *)navigationItemTitle:(NSString *)text;

/**
 * 根据文字长度计算需要显示的文字，即显示文字最大的宽度,超出的文字显示...
 * @param text 目标text
 * @result 返回NSString类型数据，即最大宽度下显示的文字
 */
+ (NSString *)showText:(NSString *)text maxWidth:(CGFloat)maxWidth;

//获取Label文字宽度
+ (CGFloat)labelTextWidth:(UILabel *)label;

//设置Autolayout中的边距辅助方法
+ (void)updateLayout:(UIView *)view where:(NSLayoutAttribute)attribute constant:(CGFloat)constant;
+ (void)setEdge:(UIView *)view attr:(NSLayoutAttribute)attr constant:(CGFloat)constant;
+ (void)setEdge:(UIView*)superview view:(UIView*)view attr:(NSLayoutAttribute)attr constant:(CGFloat)constant;

//设置圆角边框
+(void)setRoundBorder:(UIView *)view borderWidth:(CGFloat)width cornerRadius:(CGFloat)radius borderColor:(UIColor *)color;

/* 判断字符串是否为空－公共函数 */
+ (BOOL)isBlankString:(NSString *)string;

/* 判断输入的字符串是否是电话号码－公共函数 */
+ (BOOL)checkPhoneNumInput:(NSString *)_text;

/* 判断输入的字符串是否为email格式*/
+ (BOOL)validateEmail:(NSString *)candidate;

/* 判断输入的字符串是否为数字格式*/
+ (BOOL)validateNumber:(NSString*)number;

//图片URL转码
+ (NSString *)setCorrectURL:(NSString *)url;

//图片URL转码 共通
+ (NSString *)setCorrectURLByServer:(NSString *)server andImgUrl:(NSString *)url;

/**
 *将text用DES加密
 *返回加密结果（16进制）
 */
+ (NSString *)encryptWithText:(NSString *)sText theKey:(NSString *)aKey;

/**
 *  iOS自带的MD5加密算法
 */
+ (NSString *)MD5With:(NSString *)str;

/**
 *  图片等比例压缩
 * @param image 需要压缩的图片
 * @return 返回压缩后的图片
 */
+(UIImage *)fitSmallImage:(UIImage *)image;

//晒单图片压缩
+(CGFloat)getImageScaling:(UIImage *)image;
+(UIImage *)fitImageSizeWith:(UIImage *)img;
+(UIImage *)compressionImage:(UIImage *)image;

/**
 * 获取UUID
 */
+ (NSString*)getUUIDString;


/* 
 * 指定宽度按比例缩放
 */
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;


/*
 * 指定缩放目标宽度，获取缩放目标高度
 */
+(CGFloat)getTargetHeightForScaleImage:(UIImage *)sourceImage withTargetWidth:(CGFloat)defineWidth;


/**
 * 为指定字符串数组添加标签
 * strings: 字符串数组
 * view: 插入的父视图
 * maxWidth: 总计可插入最大宽度
 * labelHeight: 插入标签高度
 * labelMargin: 标签之间的Margin
 * additionalWidth: 标签文字和边框之间的空白宽度
 * font: 标签的字体
 * borderColor: 标签的边框颜色
 * textColor: 文字颜色
 */
+(void)insertLabelForStrings:(NSArray *)strings toView:(UIView *)view andMaxWidth:(CGFloat)maxWidth andLabelHeight:(CGFloat)labelHeight andLabelMargin:(CGFloat)labelMargin andAddtionalWidth:(CGFloat)additionalWidth andFont:(UIFont *)font andBorderColor:(CGColorRef)borderColor andTextColor:(UIColor *)textColor;


/**
 * 为指定字符串数组添加标签
 * strings: 字符串数组
 * view: 插入的父视图
 * viewHight: 父视图高度
 * maxWidth: 总计可插入最大宽度
 * labelHeight: 插入标签高度
 * labelMargin: 标签之间的Margin
 * additionalWidth: 标签文字和边框之间的空白宽度
 * font: 标签的字体
 * borderColor: 标签的边框颜色
 * textColor: 文字颜色
 */
+(void)insertLabelForStrings:(NSArray *)strings toView:(UIView *)view andViewHeight:(CGFloat)viewHight andMaxWidth:(CGFloat)maxWidth andLabelHeight:(CGFloat)labelHeight andLabelMargin:(CGFloat)labelMargin andAddtionalWidth:(CGFloat)additionalWidth andFont:(UIFont *)font andBorderColor:(CGColorRef)borderColor andTextColor:(UIColor *)textColor;


/**
 * 为指定字符串数组添加按钮
 * strings: 字符串数组
 * view: 插入的父视图
 * viewHight: 父视图高度
 * maxWidth: 总计可插入最大宽度
 * labelHeight: 插入标签高度
 * labelMargin: 标签之间的Margin
 * additionalWidth: 标签文字和边框之间的空白宽度
 * font: 标签的字体
 * borderColor: 标签的边框颜色
 * textColor: 文字颜色
 */
+(NSArray *)insertButtonForStrings:(NSArray *)strings toView:(UIView *)view andViewHeight:(CGFloat)viewHight andMaxWidth:(CGFloat)maxWidth andButtonHeight:(CGFloat)btnHeight andButtonMargin:(CGFloat)btnMargin andAddtionalWidth:(CGFloat)additionalWidth andFont:(UIFont *)font andBorderColor:(CGColorRef)borderColor andTextColor:(UIColor *)textColor;


/**
 * 创建主订单号
 */
+(NSString *)createMainOrderNo;


/**
 * 创建子订单号
 * subNo:自增序号
 */
+(NSString *)createSubOrderNoWithSubNo:(NSInteger)subNo;


/**
 * 创建物业账单订单号
 */
+(NSString *)createPropertyBillOrderNo;

/**
 *  验证字符串有效性，字符串为空，返回空字符串，否则返回原字符串
 *
 *  @param string 输入的字符串
 *
 *  @return 处理后的字符串
 */
+ (NSString *)vaildString:(NSString *)string;

/* 获取本地图片存储路径 */
+(NSString *)getImageSavePath;


+ (NSMutableArray *)getArrayFromXML:(NSString *)xmlString;

+ (NSArray *)getArrayFromJson:(NSString *)jsonStr;

@end

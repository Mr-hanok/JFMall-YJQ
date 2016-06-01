//
//  ColorValues.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#ifndef CommunityApp_ColorValues_h
#define CommunityApp_ColorValues_h


#pragma mark - 颜色方法区
//RGB颜色方法
#define COLOR_RGB(r,g,b)    [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:1.0]
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:(a)]

#define UIColorFromRGB(rgbValue)    ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])
#define UIColorFromRGBA(rgbValue,a)    ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)])


#pragma mark - 共通 颜色定义区域
//全局App背景色
#define Color_Comm_AppBackground            COLOR_RGB(243,243,243)

//TabBarItem选中的文字颜色
#define Color_Comm_TabBarItemSel            COLOR_RGB(245, 164, 37)

//吃喝玩乐-标签边框颜色
#define Color_Comm_LabelBorder              COLOR_RGB(220, 220, 220).CGColor


#pragma mark - 首页 颜色定义区域
// 各Section左侧 条形框背景色
#define Color_Home_SectionHeaderRedBg       COLOR_RGB(221, 60, 120)
#define Color_Home_SectionHeaderPurpleBg    COLOR_RGB(171, 60, 221)
#define Color_Home_SectionHeaderBlueBg      COLOR_RGB(60, 179, 221)
// 便民服务背景色
#define Color_Home_ConvenienceBrownBg       COLOR_RGB(229, 123, 47)
#define Color_Home_ConvenienceYellowBg      COLOR_RGB(227, 180, 68)
#define Color_Home_ConvenienceBlueBg        COLOR_RGB(90, 157, 220)


#pragma mark - 购物车 颜色定义区域


#pragma mark - 消息 颜色定义区域


#pragma mark - 我 颜色定义区域

#pragma mark - 联系电话 颜色定义区域
#define Color_Userful_Tel_Color            COLOR_RGB(249, 156, 63)
#define Color_Button_Layer_Border          COLOR_RGB(235, 114, 25)

#pragma mark - 优惠券颜色
#define Color_Coupon_Border                 COLOR_RGB(225, 225, 225) //边框颜色
#define Color_Coupon_Label_Border           COLOR_RGB(238, 174, 118) //标签边框颜色
#define Color_Button_Selected               COLOR_RGB(246, 131, 29) //按钮被选中颜色
#define Color_Coupon_Type_Cash              COLOR_RGB(232, 108, 108) //现金券
#define Color_Coupon_Type_Discount          COLOR_RGB(116, 174, 203) //折扣券
#define Color_Coupon_Type_Full              COLOR_RGB(153, 139, 197) //满减券
#define Color_Coupon_Type_Gift              COLOR_RGB(122, 190, 139) //买赠券
#define Color_Coupon_Type_Benifit           COLOR_RGB(56, 183, 250) //福利券

// 常用颜色值
#define Color_White_RGB                     COLOR_RGB(255, 255, 255)    // 白色
#define Color_Pink_Red_RGB                  COLOR_RGB(221, 48, 118)     // 粉红色
#define Color_Orange_RGB                    COLOR_RGB(246, 131, 29)     // 橘黄色
#define Color_Gray_RGB                      COLOR_RGB(210, 210, 210)    // 浅灰色
#define Color_Dark_Gray_RGB                 COLOR_RGB(48, 48, 48)       // 深灰色
#define Color_Blue_RGB                      COLOR_RGB(44, 152, 237)     // 蓝色
#define Color_Green_RGB                     COLOR_RGB(98, 205, 1)       // 绿色
#define Color_Yellow_RGB                    COLOR_RGB(255, 209, 9)      // 黄色
#endif

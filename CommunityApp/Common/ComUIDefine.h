//
//  ComUIDefine.h
//  CommonApp
//
//  Created by lipeng on 16/3/8.
//  Copyright © 2016年 common. All rights reserved.
//

//-----------------------------------  设备的宽高  ------------------------------------
#define APP_SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

//-----------------------------------  颜色  ------------------------------------
// e.g. HEXCOLOR(0xCECECE);
#define HEXCOLOR(rgbValue)  [ComColorManager colorWithHex:rgbValue alpha:1.f]

// e.g. HEXCOLORA(0xCECECE, 0.8);
#define HEXCOLORA(rgbValue,a) [ComColorManager colorWithHex:rgbValue alpha:a]

//-----------------------------------  旋转角度  ------------------------------------
#define DegreesToRadians(degrees)             degrees*M_PI/180
#define RadiansToDegrees(radians)             radians*180/M_PI


//------------------------------------ 字体和颜色公共颜色配置 ----------------------------------------
#define TEXT_DEFAULT_COLOR_BLACK        HEXCOLOR(0x3f444d)
#define TEXT_DEFAULT_COLOR_GRAY         HEXCOLOR(0x999999)
#define TEXT_DEFAULT_COLOR_LIGHT        HEXCOLOR(0x6592e1)
#define LINE_COLOR                      HEXCOLOR(0xd9d9d9)
#define TEXT_DEFAULT_FONT               [UIFont systemFontOfSize:14]




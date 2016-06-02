//
//  Rects.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#ifndef CommunityApp_Rects_h
#define CommunityApp_Rects_h


#pragma mark - 共通 视图元素坐标尺寸定义区域
// 导航栏左侧按钮视图默认显示位置及大小
#define Rect_Comm_NavBarLeftItem        CGRectMake(0, 0, 44, 44)

// 导航栏右侧按钮视图默认显示位置及大小
#define Rect_Comm_NavBarRightItem       CGRectMake((Screen_Width-60), 7, 60, 30)



#pragma mark - 首页 视图元素坐标尺寸定义区域
// 首页导航栏右侧按钮视图显示位置及大小
#define Rect_Home_NavBarRightItem       CGRectMake((Screen_Width-36), 10, 16, 24)



#pragma mark - 物业缴费 视图元素坐标尺寸定义区域
// 物业缴费导航栏右侧按钮显示位置及大小
#define Rect_PropBill_NavBarRightItem   CGRectMake((Screen_Width-40), 12, 26, 26)


#pragma mark -商城商品 视图元素坐标尺寸定义区域
// 商品列表导航栏右侧按钮显示位置及大小
#define Rect_WaresList_NavBarRightItem  CGRectMake(Screen_Width-75, 7, 60, 30)

// 限时抢列表导航栏右侧按钮显示位置及大小
#define Rect_LimitBuy_NavBarRightItem  CGRectMake(Screen_Width-40, 7, 30, 30)

//物业通知列表导航栏右侧按钮显示位置及大小===2016.02.23
#define Rect_CommunityMessage_NavBarRightItem  CGRectMake(Screen_Width-110, 7, 100, 30)

#endif

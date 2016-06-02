//
//  JFBaseViewController.h
//  CommunityApp
//
//  Created by yuntai on 16/4/11.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApiLoginRequest;
@interface JFBaseViewController : UIViewController
@property (nonatomic, strong) ApiLoginRequest *apiLogin;

@property (nonatomic, assign) BOOL keyboardIsVisible;
@property (nonatomic, assign) CGFloat   keyboardHeight;
@property (strong,nonatomic) UIToolbar* toolBar;
/* 设置导航栏左侧按钮为返回键头
 */
- (void)setNavBarLeftItemAsBackArrow;
- (void)navBarRightItemClick;
/* 设置导航栏右侧按钮Title和背景图片 (设置导航栏方案1)
 * @parameter:title 右侧按钮视图显示的文字 (本方法适合点击前后文字不发生变化)
 * @parameter:norName 右侧按钮视图背景图片--点击前
 * @parameter:preName 右侧按钮视图背景图片--点击时
 */
- (void)setNavBarRightItemTitle:(NSString *)title andNorBgImgName:(NSString *)norName andPreBgImgName:(NSString *)preName;
- (void)setNavBarItemLeftView:(UIView *)view;
- (void)setNavBarItemRightView:(UIView *)view;

#pragma mark -push
- (void)pushWithVCClass:(Class)vcClass properties:(NSDictionary*)properties;
- (void)pushWithVCClassName:(NSString*)className properties:(NSDictionary*)properties;

@end

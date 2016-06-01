//
//  BaseViewController.h
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "ShopCartModel.h"
#import "DBOperation.h"

@interface BaseViewController : UIViewController

@property (nonatomic, copy) NSString    *strNavBarBgImg;    //导航栏背景图片

@property (nonatomic, assign) BOOL keyboardIsVisible;
@property (nonatomic, assign) CGFloat   keyboardHeight;

@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, assign) BOOL hudHidden;

@property (strong,nonatomic) UIToolbar* toolBar;


- (void)pushWithVCClass:(Class)vcClass properties:(NSDictionary*)properties;
- (void)pushWithVCClassName:(NSString*)className properties:(NSDictionary*)properties;


#pragma mark - 导航栏设定关联
/* 设置导航栏左侧按钮Title和背景图片 (设置导航栏方案1)
 * @parameter:title 左侧按钮视图显示的文字 (本方法适合点击前后文字不发生变化)
 * @parameter:norName 左侧按钮视图背景图片--点击前
 * @parameter:preName 左侧按钮视图背景图片--点击时
 */
- (void)setNavBarLeftItemTitle:(NSString *)title andNorBgImgName:(NSString *)norName andPreBgImgName:(NSString *)preName;

/* 设置导航栏右侧按钮Title和背景图片 (设置导航栏方案1)
 * @parameter:title 右侧按钮视图显示的文字 (本方法适合点击前后文字不发生变化)
 * @parameter:norName 右侧按钮视图背景图片--点击前
 * @parameter:preName 右侧按钮视图背景图片--点击时
 */
- (void)setNavBarRightItemTitle:(NSString *)title andNorBgImgName:(NSString *)norName andPreBgImgName:(NSString *)preName;

/* 设置导航栏左侧按钮Title和背景图片和Frame (设置导航栏方案1)
 * @parameter:title 左侧按钮视图显示的文字 (本方法适合点击前后文字不发生变化)
 * @parameter:norName 左侧按钮视图背景图片--点击前
 * @parameter:preName 左侧按钮视图背景图片--点击时
 * @parameter:frame   左侧按钮视图的位置和尺寸
 */
- (void)setNavBarLeftItemTitle:(NSString *)title andNorBgImgName:(NSString *)norName andPreBgImgName:(NSString *)preName andFrame:(CGRect)frame;

/* 设置导航栏右侧按钮Title和背景图片和Frame (设置导航栏方案1)
 * @parameter:title 右侧按钮视图显示的文字 (本方法适合点击前后文字不发生变化)
 * @parameter:norName 右侧按钮视图背景图片--点击前
 * @parameter:preName 右侧按钮视图背景图片--点击时
 * @parameter:frame   右侧按钮视图的位置和尺寸
 */
- (void)setNavBarRightItemTitle:(NSString *)title andNorBgImgName:(NSString *)norName andPreBgImgName:(NSString *)preName andFrame:(CGRect)frame;



/* 设置导航栏按钮视图 (设置导航栏方案2)
 * @parameter:leftView  左侧按钮视图
 * @parameter:rightView 右侧按钮视图
 */
- (void)setNavBarItemLeftView:(UIView *)leftView andRightView:(UIView *)rightView;

/* 设置左侧按钮视图 (设置导航栏方案2)
 * @parameter:leftView  左侧按钮视图
 */
- (void)setNavBarItemLeftView:(UIView *)view;

/* 设置右侧按钮视图 (设置导航栏方案2)
 * @parameter:leftView  右侧按钮视图
 */
- (void)setNavBarItemRightView:(UIView *)view;


/* 设置导航栏背景图片
 * @parameter:name  导航栏背景图片名称
 */
- (void)setNavBarBgImgName:(NSString *)name;

/* 设置左右按钮视图的Frame
 * @parameter:leftFrame   左侧按钮视图的frame
 * @parameter:rightFrame  右侧按钮视图的frame
 */
- (void)setNavBarFrameForLeftItem:(CGRect)leftFrame andRightItem:(CGRect)rightFrame;

/* 设置导航栏左侧按钮为返回键头
 */
- (void)setNavBarLeftItemAsBackArrow;

/* 设置导航栏右侧按钮For一个只有Icon的按钮
 * @parameter:norImg  未点击图片
 * @parameter:preImg  点击后图片
 */
- (void)setNavBarItemRightViewForNorImg:(NSString *)norImg andPreImg:(NSString *)preImg;

/* 设置导航栏左侧按钮For一个只有Icon的按钮
 * @parameter:norImg  未点击图片
 * @parameter:preImg  点击后图片
 */
- (void)setNavBarItemLeftViewForNorImg:(NSString *)norImg andPreImg:(NSString *)preImg;

/* 左侧按钮视图点击事件处理函数，如需定制，请在自己的ViewController内重写该方法
 */
- (void)navBarLeftItemClick;


/* 右侧按钮视图点击事件处理函数，如需定制，请在自己的ViewController内重写该方法
 */
- (void)navBarRightItemClick;


#pragma mark -
#pragma mark HUD
- (void)showHUDWithMessage:(NSString *)msg;
- (void)hideHUD;

#pragma mark -
#pragma mark Http
-(void)getArrayFromServer:(NSString *)url
                     path:(NSString *)path
               parameters:(NSDictionary *)parameters
            xmlParentNode:(NSString *)parentNode
                  success:(void (^)(NSMutableArray *result))success
                  failure:(void (^)(NSError *error))failure;


-(void)getArrayFromServer:(NSString *)url
                     path:(NSString *)path
                  method:(NSString *)method
               parameters:(NSDictionary *)parameters
            xmlParentNode:(NSString *)parentNode
                  success:(void (^)(NSMutableArray *result))success
                  failure:(void (^)(NSError *error))failure;
#pragma -mark xml解析多层
-(void)getArrayFromServer1:(NSString *)url path1:(NSString *)path method1:(NSString *)method parameters1:(NSDictionary *)parameters xmlParentNode1:(NSString *)parentNode
                  success1:(void (^)(NSMutableArray *result))success failure1:(void (^)(NSError *error))failure;


-(void)getStringFromServer:(NSString *)url
                      path:(NSString *)path
                parameters:(NSDictionary *)parameters
                   success:(void (^)(NSString *result))success
                   failure:(void (^)(NSError *error))failure;

-(void)getStringFromServer:(NSString *)url
                      path:(NSString *)path
                   method:(NSString *)method
                parameters:(NSDictionary *)parameters
                   success:(void (^)(NSString *result))success
                   failure:(void (^)(NSError *error))failure;


-(void)getArrayFromSMSServer:(NSString *)url path:(NSString *)path method:(NSString *)method parameters:(NSDictionary *)parameters xmlParentNode:(NSString *)parentNode
                       success:(void (^)(NSMutableArray *result))success failure:(void (^)(NSError *error))failure;
- (void)uploadImageWithUrl:(NSString *)url path:(NSString*)path fileid:(NSString*)UUID
                     image:(UIImage *)image
                   success:(void (^)(NSString *result))success
                   failure:(void (^)(NSError *error))failure;
-(void)uploadImgPathToServer:(NSString*)url path:(NSString*)path recordId:(NSString*)recordId fileId:(NSString*)fileId
                     success:(void (^)(NSString *result)) success
                     failure:(void (^)(NSError *error))failure;
#pragma mark--xml
-(NSMutableArray *)getArrayFromXML:(NSString *)xmlString byParentNode:(NSString *)parentNode;
-(void)getOrignStringFromServer:(NSString *)url path:(NSString *)path method:(NSString *)method parameters:(NSDictionary *)parameters success:(void (^)(NSString *result))success failure:(void (^)(NSError *error))failure;

-(NSString*)codeResultMessage:(NSString* )errorcode;


-(void)requestFromServer:(NSString *)url path:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *error))failure;

#pragma mark - 键盘显示、隐藏事件处理函数
/* 键盘显示
 */
- (void)keyboardDidShow:(NSNotification *)notification;

/* 键盘隐藏
 */
- (void)keyboardDidHide;


/* 同步购物车商品到服务器 */
- (void)updateCartInfoToServerSuccess:(void (^)(NSString *result))success failure:(void (^)(NSError *error))failure;

/* 同/Users/zhangyanqing/Desktop/CommunityApp/CommunityApp/ViewControllers/ServiceOrderWebViewController.h步购物车数据到服务器(删除商品) */
- (void)deleteCartInfoToServerByShopCartModel:(ShopCartModel *)model;

/* 从服务器上更新购物车信息到本地 */
- (void)downLoadCartInfoFromServerForException;

/* 判断是否去登录 */
- (BOOL)isGoToLogin;

/* 判断是否去绑定 */
- (BOOL)isGoToBindPhone;



@end

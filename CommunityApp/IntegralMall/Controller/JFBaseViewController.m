//
//  JFBaseViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/4/11.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFBaseViewController.h"
//友盟统计
#import "MobClick.h"
#import "ApiLoginRequest.h"

@interface JFBaseViewController ()<APIRequestDelegate>
@property (nonatomic, copy) NSString    *strNavBarBgImg;    //导航栏背景图片

//导航栏背景图、文字
@property (nonatomic, copy) NSString    *strNavBarLeftItemNorBgImg;     //左侧Item背景图(normal)
@property (nonatomic, copy) NSString    *strNavBarLeftItemPreBgImg;     //左侧Item背景图(press)
@property (nonatomic, copy) NSString    *strNavBarRightItemNorBgImg;    //右侧Item背景图(normal)
@property (nonatomic, copy) NSString    *strNavBarRightItemPreBgImg;    //右侧Item背景图(press)
@property (nonatomic, copy) NSString    *strNavBarLeftItemNorTitle;     //左侧ItemTitle(normal)
@property (nonatomic, copy) NSString    *strNavBarLeftItemPreTitle;     //左侧ItemTitle(press)
@property (nonatomic, copy) NSString    *strNavBarRightItemNorTitle;    //右侧ItemTitle(normal)
@property (nonatomic, copy) NSString    *strNavBarRightItemPreTitle;    //右侧ItemTitle(press)

//设置导航栏左右按钮视图用
@property (nonatomic, retain) UIView    *viewNavBarLeftItem;        //左侧按钮视图
@property (nonatomic, retain) UIView    *viewNavBarRightItem;       //右侧按钮视图
@property (nonatomic, assign) CGRect    rectNavBarLeftItem;         //左侧按钮frame
@property (nonatomic, assign) CGRect    rectNavBarRightItem;        //右侧按钮frame

@property (nonatomic, strong) UIView*   keyboardAccessoryView;        //隐藏按钮

@end

@implementation JFBaseViewController

- (void)pushWithVCClass:(Class)vcClass properties:(NSDictionary*)properties {
    id obj = [vcClass new];
    if(properties)
        [obj yy_modelSetWithDictionary:properties];
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)pushWithVCClassName:(NSString*)className properties:(NSDictionary*)properties {
    id obj = [NSClassFromString(className) new];
    if(properties)
        [obj yy_modelSetWithDictionary:properties];
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_Comm_AppBackground;   //设置App默认背景色
    
    self.strNavBarBgImg = Img_Comm_NavNormalBgImg;           //设置导航栏默认背景色
    
    self.rectNavBarLeftItem = Rect_Comm_NavBarLeftItem;     //设置导航栏左侧按钮视图默认显示区域
    
    self.rectNavBarRightItem = Rect_Comm_NavBarRightItem;   //设置导航栏右侧按钮视图默认显示区域
    self.hidesBottomBarWhenPushed = YES;    // Push的时候隐藏TabBar
    
//    [Common appDelegate].baseViewDelegate= self;
    
    [self initAccesoryView];
}


-(void) initAccesoryView
{
    _keyboardAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
    [_keyboardAccessoryView setBackgroundColor:COLOR_RGB(243, 243, 243)];
    [self.view addSubview:_keyboardAccessoryView];
    _keyboardAccessoryView.hidden = TRUE;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(Screen_Width-60, 0, 60, 44)];
    [_keyboardAccessoryView addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"MsgKeyboardPreImg"] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:@"MsgKeyboardNorImg"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(keyboardDidHide) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)toLogin
{
    [self isGoToLogin];
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(keyboardDidHide)];
        _toolBar.items = @[space,done];
    }
    return _toolBar;
}
// 画面将要显示的时候加载当前视图的导航栏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //友盟统计：页面开始
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    [self showNavigationBar];
    self.tabBarController.tabBar.hidden = YES;
    if (self.tabBarController.tabBar.hidden) {
        CGRect frame = self.tabBarController.tabBar.frame;
        self.tabBarController.tabBar.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
    }
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification  addObserver:self selector:@selector(keyboardDidShow:)  name:UIKeyboardDidShowNotification  object:nil];
    [notification addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
}

// 画面将要消失的时候移除当前视图导航栏的左右按钮
- (void)viewWillDisappear:(BOOL)animated
{
    
    
    [super viewWillDisappear:animated];
    //友盟统计：页面结束
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
    
    [self.viewNavBarLeftItem removeFromSuperview];
    [self.viewNavBarRightItem removeFromSuperview];
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [notification removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[Common appDelegate] setUserAccountLoginAtOtherPlaceBlock:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    
    [[Common appDelegate] setUserAccountLoginAtOtherPlaceBlock:^(BOOL isLogin) {
        if (isLogin) {
            [Common weiXinLoginOrIphoneLogin];
        }else {
            return ;
            //            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}
#pragma mark - 键盘显示、隐藏通知事件处理函数

- (void)keyboardDidShow:(NSNotification *)notification
{
    self.keyboardIsVisible = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    self.keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [_keyboardAccessoryView setFrame:CGRectMake(0, Screen_Height-self.keyboardHeight-44-60, Screen_Width, 44)];
    //IQKeyboardManager添加后隐藏系统键盘
    _keyboardAccessoryView.hidden = TRUE;
    self.keyboardHeight += 44;
    [self.view bringSubviewToFront:_keyboardAccessoryView];
    //
}

- (void)keyboardDidHide
{
    self.keyboardIsVisible = NO;
    self.keyboardHeight = 0;
    _keyboardAccessoryView.hidden = TRUE;
    [[[UIApplication sharedApplication] keyWindow]endEditing:TRUE];
    [self.view sendSubviewToBack:_keyboardAccessoryView];
}


// 设置导航栏title颜色
- (void)setNavigationTextColor:(UIColor *)color
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:20.0],NSFontAttributeName, nil]];
    }
    else
    {
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,UITextAttributeTextColor,[UIFont boldSystemFontOfSize:20.0],UITextAttributeFont, nil]];
    }
}

// 导航栏显示函数
- (void)showNavigationBar
{
    // 设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:self.strNavBarBgImg] forBarMetrics:UIBarMetricsDefault];
    if ([self.strNavBarBgImg isEqualToString:Img_Comm_NavBackground]) {
        [self setNavigationTextColor:[UIColor whiteColor]];     //设置导航栏文字颜色
    }else{
        [self setNavigationTextColor:COLOR_RGB(85, 85, 85)];     //设置导航栏文字颜色
    }
    
    // 隐藏系统返回按钮
    self.navigationItem.hidesBackButton = TRUE;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    
    // 添加导航栏左侧按钮
    [self setNavBarLeftItemView];
    
    // 添加导航栏右侧按钮
    [self setNavBarRightItemView];
    
    
}

// 设置导航栏左侧按钮式样
- (void)setNavBarLeftItemView
{
    if (self.viewNavBarLeftItem == nil) {
        self.viewNavBarLeftItem = [[UIView alloc] initWithFrame:self.rectNavBarLeftItem];
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, self.rectNavBarLeftItem.size.width, self.rectNavBarLeftItem.size.height);
        [leftBtn setTitle:self.strNavBarLeftItemNorTitle forState:UIControlStateNormal];
        [leftBtn setTitle:self.strNavBarLeftItemPreTitle forState:UIControlStateHighlighted];
        if (self.strNavBarLeftItemNorBgImg != nil && self.strNavBarLeftItemPreBgImg != nil) {
            [leftBtn setBackgroundImage:[UIImage imageNamed:self.strNavBarLeftItemNorBgImg] forState:UIControlStateNormal];
            [leftBtn setBackgroundImage:[UIImage imageNamed:self.strNavBarLeftItemPreBgImg] forState:UIControlStateHighlighted];
        }
        [leftBtn addTarget:self action:@selector(navBarLeftItemClick) forControlEvents:UIControlEventTouchUpInside];
        [self.viewNavBarLeftItem addSubview:leftBtn];
    }
    [self.navigationController.navigationBar addSubview:self.viewNavBarLeftItem];
}

// 设置导航栏右侧按钮式样
- (void)setNavBarRightItemView
{
    if (self.viewNavBarRightItem == nil) {
        self.viewNavBarRightItem = [[UIView alloc] initWithFrame:self.rectNavBarRightItem];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, self.rectNavBarRightItem.size.width, self.rectNavBarRightItem.size.height);
        [rightBtn setTitle:self.strNavBarRightItemNorTitle forState:UIControlStateNormal];
        [rightBtn setTitle:self.strNavBarRightItemPreTitle forState:UIControlStateHighlighted];
        if (self.strNavBarRightItemNorBgImg != nil && self.strNavBarRightItemPreBgImg != nil) {
            [rightBtn setBackgroundImage:[UIImage imageNamed:self.strNavBarRightItemNorBgImg] forState:UIControlStateNormal];
            [rightBtn setBackgroundImage:[UIImage imageNamed:self.strNavBarRightItemPreBgImg] forState:UIControlStateHighlighted];
        }
        if (self.strNavBarRightItemNorBgImg == nil && self.strNavBarRightItemPreBgImg == nil) {
            [rightBtn setTitleColor:COLOR_RGB(87, 87, 87) forState:UIControlStateNormal];
        }
        [rightBtn addTarget:self action:@selector(navBarRightItemClick) forControlEvents:UIControlEventTouchUpInside];
        [self.viewNavBarRightItem addSubview:rightBtn];
    }
    [self.navigationController.navigationBar addSubview:self.viewNavBarRightItem];
}

#pragma mark - 子类设置导航栏调用方法
#pragma mark - 设置导航栏按钮方案1
/* 设置导航栏左侧按钮Title和背景图片 (设置导航栏方案1)
 * @parameter:title 左侧按钮视图显示的文字 (本方法适合点击前后文字不发生变化)
 * @parameter:norName 左侧按钮视图背景图片--点击前
 * @parameter:preName 左侧按钮视图背景图片--点击时
 */
- (void)setNavBarLeftItemTitle:(NSString *)title andNorBgImgName:(NSString *)norName andPreBgImgName:(NSString *)preName
{
    self.strNavBarLeftItemNorTitle = title;
    self.strNavBarLeftItemPreTitle = title;
    
    self.strNavBarLeftItemNorBgImg = norName;
    self.strNavBarLeftItemPreBgImg = preName;
}


/* 设置导航栏右侧按钮Title和背景图片 (设置导航栏方案1)
 * @parameter:title 右侧按钮视图显示的文字 (本方法适合点击前后文字不发生变化)
 * @parameter:norName 右侧按钮视图背景图片--点击前
 * @parameter:preName 右侧按钮视图背景图片--点击时
 */
- (void)setNavBarRightItemTitle:(NSString *)title andNorBgImgName:(NSString *)norName andPreBgImgName:(NSString *)preName
{
    self.strNavBarRightItemNorTitle = title;
    self.strNavBarRightItemPreTitle = title;
    
    self.strNavBarRightItemNorBgImg = norName;
    self.strNavBarRightItemPreBgImg = preName;
}


/* 设置导航栏左侧按钮Title和背景图片和Frame (设置导航栏方案1)
 * @parameter:title 左侧按钮视图显示的文字 (本方法适合点击前后文字不发生变化)
 * @parameter:norName 左侧按钮视图背景图片--点击前
 * @parameter:preName 左侧按钮视图背景图片--点击时
 * @parameter:frame   左侧按钮视图的位置和尺寸
 */
- (void)setNavBarLeftItemTitle:(NSString *)title andNorBgImgName:(NSString *)norName andPreBgImgName:(NSString *)preName andFrame:(CGRect)frame
{
    self.strNavBarLeftItemNorTitle = title;
    self.strNavBarLeftItemPreTitle = title;
    
    self.strNavBarLeftItemNorBgImg = norName;
    self.strNavBarLeftItemPreBgImg = preName;
    
    self.rectNavBarLeftItem = frame;
}


/* 设置导航栏右侧按钮Title和背景图片和Frame (设置导航栏方案1)
 * @parameter:title 右侧按钮视图显示的文字 (本方法适合点击前后文字不发生变化)
 * @parameter:norName 右侧按钮视图背景图片--点击前
 * @parameter:preName 右侧按钮视图背景图片--点击时
 * @parameter:frame   右侧按钮视图的位置和尺寸
 */
- (void)setNavBarRightItemTitle:(NSString *)title andNorBgImgName:(NSString *)norName andPreBgImgName:(NSString *)preName andFrame:(CGRect)frame
{
    self.strNavBarRightItemNorTitle = title;
    self.strNavBarRightItemPreTitle = title;
    
    self.strNavBarRightItemNorBgImg = norName;
    self.strNavBarRightItemPreBgImg = preName;
    
    self.rectNavBarRightItem = frame;
}


#pragma mark - 设置导航栏按钮方案2
/* 设置导航栏按钮视图 (设置导航栏方案2)
 * @parameter:leftView  左侧按钮视图
 * @parameter:rightView 右侧按钮视图
 */
- (void)setNavBarItemLeftView:(UIView *)leftView andRightView:(UIView *)rightView
{
    [self setNavBarItemLeftView:leftView];
    [self setNavBarItemRightView:rightView];
}


/* 设置左侧按钮视图 (设置导航栏方案2)
 * @parameter:leftView  左侧按钮视图
 */
- (void)setNavBarItemLeftView:(UIView *)view
{
    if (self.viewNavBarLeftItem != nil) {
        for (UIView *subview in self.viewNavBarLeftItem.subviews) {
            [subview removeFromSuperview];
        }
    }
    self.viewNavBarLeftItem = view;
}


/* 设置右侧按钮视图 (设置导航栏方案2)
 * @parameter:leftView  右侧按钮视图
 */
- (void)setNavBarItemRightView:(UIView *)view
{
    if (self.viewNavBarRightItem != nil) {
        for (UIView *subview in self.viewNavBarRightItem.subviews) {
            [subview removeFromSuperview];
        }
    }
    self.viewNavBarRightItem = view;
}


/* 设置导航栏背景图片
 * @parameter:name  导航栏背景图片名称
 */
- (void)setNavBarBgImgName:(NSString *)name
{
    self.strNavBarBgImg = name;
}


/* 设置左右按钮视图的Frame
 * @parameter:leftFrame   左侧按钮视图的frame
 * @parameter:rightFrame  右侧按钮视图的frame
 */
- (void)setNavBarFrameForLeftItem:(CGRect)leftFrame andRightItem:(CGRect)rightFrame
{
    self.rectNavBarLeftItem = leftFrame;
    self.rectNavBarRightItem = rightFrame;
}


/* 设置导航栏左侧按钮为返回键头
 */
- (void)setNavBarLeftItemAsBackArrow
{
    UIView  *leftItem = [[UIView alloc] init];
    leftItem.frame = Rect_Comm_NavBarLeftItem;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:Img_Comm_NavBackNor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:Img_Comm_NavBackPre] forState:UIControlStateHighlighted];
    backBtn.frame = Rect_Comm_NavBarLeftItem;
    [backBtn addTarget:self action:@selector(navBarLeftItemBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftItem addSubview:backBtn];
    
    [self setNavBarItemLeftView:leftItem];
}

/* 设置导航栏右侧按钮For一个只有Icon的按钮
 */
- (void)setNavBarItemRightViewForNorImg:(NSString *)norImg andPreImg:(NSString *)preImg
{
    UIView  *rightItem = [[UIView alloc] init];
    rightItem.frame = CGRectMake((Screen_Width-60), 0, 60, 44);
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:preImg] forState:UIControlStateHighlighted];
    rightBtn.frame = CGRectMake(0, 0, 60, 44);
    [rightBtn addTarget:self action:@selector(navBarRightItemClick) forControlEvents:UIControlEventTouchUpInside];
    [rightItem addSubview:rightBtn];
    
    [self setNavBarItemRightView:rightItem];
}

/* 设置导航栏左侧按钮For一个只有Icon的按钮
 */
- (void)setNavBarItemLeftViewForNorImg:(NSString *)norImg andPreImg:(NSString *)preImg
{
    UIView  *leftItem = [[UIView alloc] init];
    leftItem.frame = CGRectMake(5, 0, 40, 44);
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:preImg] forState:UIControlStateHighlighted];
    leftBtn.frame = CGRectMake(0, 0, 40, 44);
    [leftBtn addTarget:self action:@selector(navBarLeftItemClick) forControlEvents:UIControlEventTouchUpInside];
    [leftItem addSubview:leftBtn];
    
    [self setNavBarItemLeftView:leftItem];
}



#pragma mark - 导航栏按钮点击事件处理函数
// 导航栏返回按钮点击事件处理函数
- (void)navBarLeftItemBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 左侧按钮视图点击事件处理函数，如需定制，请在自己的ViewController内重写该方法
- (void)navBarLeftItemClick
{
    if ([self.strNavBarLeftItemNorBgImg isEqualToString:Img_Comm_NavBackNor]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

// 右侧按钮视图点击事件处理函数，如需定制，请在自己的ViewController内重写该方法
- (void)navBarRightItemClick
{
    // nothing
}

#pragma mark - 判断是否去登录
- (BOOL)isGoToLogin
{
    BOOL isLogged = [[LoginConfig Instance] userLogged];
    
    if(!isLogged)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您还没有登录" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"登录", nil];
        alert.tag = 1;
        [alert show];
    }
    return isLogged;
}

#pragma mark - 判断是否去绑定
- (BOOL)isGoToBindPhone
{
    BOOL isRst = YES;
    
    NSString *telno = [[LoginConfig Instance] getBindPhone];
    if (telno == nil || telno.length <= 0) {
        isRst = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您还没有绑定手机号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
        alert.tag = 2;
        [alert show];
    }
    return isRst;
}



#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            //安装微信选择微信登陆，否则选择手机登陆
            [Common weiXinLoginOrIphoneLogin];
        }
    }else if (alertView.tag == 2) {
//        if (buttonIndex == 1) {
//            PersonalCenterBindTelViewController *vc = [[PersonalCenterBindTelViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    }
    
}


@end

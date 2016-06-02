//
//  MainViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "ShoppingCartViewController.h"
#import "CustomerServiceCenterViewController.h"
#import "PersonalCenterViewController.h"

#import "HouseKeepViewController.h"
#import "DoorToDoorServiceViewController.h"
//🍎
#import "Interface.h"
#import "LoginConfig.h"
#import "WebViewController.h"

#import "OpenDoorViewController.h"

#import "BaseViewController.h"

@interface MainViewController ()

@property (nonatomic, retain) NSArray *barItemSelImgNameArray;  //TabBarItem 选中效果imageName数组
@property(nonatomic,strong)BaseViewController*baseVC;
@property(nonatomic,strong)NSArray*authenArray;
@end

@implementation MainViewController
-(BaseViewController *)baseVC
{
    if (_baseVC==nil) {
        _baseVC=[[BaseViewController alloc]init];
    }
    return _baseVC;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化TabBar图片名称数组
    self.barItemSelImgNameArray = @[Img_Comm_TabBarHomeSel, Img_Comm_TabBarHouseKeepPre,Img_Comm_TabBarOpenDoorPre, Img_Comm_TabBarDoorToDoorPre, Img_Comm_TabBarMeSel];

    //装载TabBar资源
    [self loadTabBarViewControllers];

    UIView *tabBarBg = [[UIView alloc] init];
    tabBarBg.frame = CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
    [tabBarBg setBackgroundColor:[UIColor whiteColor]];
    self.tabBar.opaque = YES;
    [self.tabBar insertSubview:tabBarBg atIndex:0];

    //设置TabBarController的代理
    self.delegate = self;

    self.hidesBottomBarWhenPushed = NO;    // Push的时候隐藏TabBar
    //判断用户是否有认证地址
    [self addressAuthen];
}
//判断用户是否有认证地址
-(void)addressAuthen
{
    if([[LoginConfig Instance] userLogged]== FALSE)
        return;
    NSString *userId = [[LoginConfig Instance]userID];
    // 请求服务器获取数据
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:   userId,@"userId",nil];
    NSUserDefaults*defaultsAuthen=[NSUserDefaults standardUserDefaults];
    [self.baseVC getArrayFromServer:ServiceInfo_Url path:@"getBuildLocation" method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result)
     {
         NSMutableArray*array=[[NSMutableArray alloc]init];
         if (result.count==0) {
             [defaultsAuthen setObject:@"" forKey:@"authenStatus"];
         }
        for (NSDictionary *dicResult in result)
        {
            [array addObject:dicResult[@"authen"]];
        }
         self.authenArray =[NSArray arrayWithArray:array];
     }
        failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
    for (NSString*str in self.authenArray) {
        if ([str isEqualToString:@"1"]) {
            [defaultsAuthen setObject:@"YES" forKey:@"authenStatus"];
            break;
        }
        else{
            [defaultsAuthen setObject:@"NO" forKey:@"authenStatus"];
        }
    }
}
#pragma mark - TabBarController Delegate实现
// 选择前
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

// 选择后
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}

#pragma mark - TabBar Delegate实现
// 选择后
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
}


#pragma mark -内部方法
// 装载TabBar资源
- (void)loadTabBarViewControllers
{
    //首页
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:Str_Comm_Home image:[UIImage imageNamed:Img_Comm_TabBarHomeNor] tag:0];
    
    //管家
    HouseKeepViewController *houseKeepVC = [[HouseKeepViewController alloc] init];
    houseKeepVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:Str_Comm_HouseKeep image:[UIImage imageNamed:Img_Comm_TabBarHouseKeepNor] tag:1];

#pragma mark-开门
    //开门
    OpenDoorViewController *openDoorVC = [[OpenDoorViewController alloc] init];
    openDoorVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:Str_Comm_OpenDoor image:[UIImage imageNamed:Img_Comm_TabBarOpenDoorNor] tag:2];
    
#pragma mark-到家
    //到家
        DoorToDoorServiceViewController *doorToDoorVC = [[DoorToDoorServiceViewController alloc] init];
        doorToDoorVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:Str_Comm_DoorToDoor image:[UIImage imageNamed:Img_Comm_TabBarDoorToDoorNor] tag:3];
/*
    //🍎到家服务
   WebViewController *vc = [[WebViewController alloc] init];
    [doorToDoorVC addChildViewController:vc];
//    vc.tabBarController.tabBar.hidden = NO;
    vc.navTitle = @"服务";//导航栏title
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:Str_Comm_DoorToDoor image:[UIImage imageNamed:Img_Comm_TabBarDoorToDoorNor] tag:3];
//解析数据
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.projectId = [userDefault objectForKey:KEY_PROJECTID];
   // YjqLog(@"----%@",self.projectId);
    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    //YjqLog(@"---%@",userid);
   vc.url = [NSString stringWithFormat:@"http://wx.bjyijiequ.com/wechat/serviceIndex/index.do?memberId=%@&commId=%@&type=1",userid,self.projectId];
//   // vc.tabBarItem.title = @"服务";
*/
    //我--个人中心
    PersonalCenterViewController *meVC = [[PersonalCenterViewController alloc] init];
    meVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:Str_Comm_Me image:[UIImage imageNamed:Img_Comm_TabBarMeNor] tag:4];

    //各TabBarItem选中效果
    [self setTabBarItemSelectedEffect:homeVC.tabBarItem];
    [self setTabBarItemSelectedEffect:houseKeepVC.tabBarItem];
    [self setTabBarItemSelectedEffect:openDoorVC.tabBarItem];
    [self setTabBarItemSelectedEffect:doorToDoorVC.tabBarItem];///旧到家
    //[self setTabBarItemSelectedEffect:vc.tabBarItem];//新服务到家
    [self setTabBarItemSelectedEffect:meVC.tabBarItem];

    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UINavigationController *houseKeepNC = [[UINavigationController alloc] initWithRootViewController:houseKeepVC];
    UINavigationController *openDoorNC = [[UINavigationController alloc] initWithRootViewController:openDoorVC];
    UINavigationController *doorToDoorNC = [[UINavigationController alloc] initWithRootViewController:doorToDoorVC];///就到家
    //UINavigationController *doorToDoorNC = [[UINavigationController alloc] initWithRootViewController:vc];//新服务到家
    UINavigationController *meNC = [[UINavigationController alloc] initWithRootViewController:meVC];

    //装载TabBarController的视图控制器
    NSArray *vcs = @[homeNC, houseKeepNC, openDoorNC, doorToDoorNC , meNC];
    [self setViewControllers:vcs animated:YES];
    [self setCustomizableViewControllers:vcs];

    //设置默认选中项
    [self setSelectedIndex:0];
}

// 设置TabBarItem选中效果
- (void)setTabBarItemSelectedEffect:(UITabBarItem *)item
{
    //文字选中效果
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Color_Comm_TabBarItemSel,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    //图片选中效果
    item.selectedImage = [[UIImage imageNamed:[self.barItemSelImgNameArray objectAtIndex:item.tag]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark -内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

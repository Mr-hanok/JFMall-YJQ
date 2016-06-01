//
//  AppDelegate.m
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginConfig.h"
#import "SelectNeighborhoodViewController.h"
#import "GYZChooseCityController.h"////////////
#import <AlipaySDK/AlipaySDK.h>
#import "NSDataEx.h"
#import "GuideViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UserAgent.h"
#import "NetworkHelper.h"//友盟统计
#import "MobClick.h"
//友盟消息推送
#import "UMessage.h"

//物业通知 消息
#import "MessageViewController.h"
#import "MessageDetailViewController.h"
//高德地图定位
#import <CoreLocation/CoreLocation.h>

//微信登陆页面
#import "PersonalWeinXinLoginViewController.h"

//腾讯崩溃捕获信息
#import <Bugly/CrashReporter.h>

#import "UMSocialData.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"

//第三方平台的SDK头文件，根据需要的平台导入。
//以下分别对应微信
#import "WXApi.h"
//以下是腾讯QQ和QQ空间
//定位
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的
//app store 版本监测
#import <AFNetworking.h>

//11-20qq占时屏蔽
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//友盟推送设置
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface AppDelegate ()<WXApiDelegate,BMKLocationServiceDelegate,UIAlertViewDelegate>
{
    BMKLocationService* _locService;
    NSString *longitude ;
    NSString *latitude;
    NSString *locationCity;
    NSString *messageMsgidStr;

}
@property (nonatomic, retain) UITabBarController *tabBarVC;
@property (nonatomic, retain) UIAlertView *alert;
@end

@implementation AppDelegate
@synthesize db;
@synthesize chatDelegate;
@synthesize messageDelegate;

//
#pragma -mark BMKLocationServiceDelegate定位

//- (void)upDateVersion
//{
//    //检测app store 版本
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    [manager POST:@"http://itunes.apple.com/lookup?id=1048321627" parameters:nil success:^(NSURLSessionTask * _Nonnull operation, id  _Nonnull responseObject) {
//        NSArray *array = responseObject[@"results"];
//        //获取app store上应用的最新版本号
//        NSDictionary *dict = [array lastObject];
//        NSString *appVersion =dict[@"version"];
//        NSLog(@"当前版本为：%@", dict[@"version"]);
//        // 获取 本机 软件版本号
//        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//        if (![currentVersion isEqualToString:appVersion]) {
//
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"更新提示" message:@"App Store有新版本哦～" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
//
////            YjqLog(@"取消：%d",alertView.cancelButtonIndex);//0
////            YjqLog(@"更新：%d",alertView.firstOtherButtonIndex);//1
//            [alertView show];
//            
//        }
//        else
//        {
//            [Common showBottomToast:@"当前已为最新版本"];
//        }
//    } failure:^(NSURLSessionTask * _Nullable operation, NSError * _Nonnull error) {
//        [Common showBottomToast:@"请求失败！" ];
//    }];
//}

- (void)initializePlat
{
//    [self upDateVersion];
    //定位
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];

    [UMSocialData setAppKey:kUMengAppKey];
    [UMSocialWechatHandler setWXAppId:kWXAppID appSecret:kWXAppSecret url:nil];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//        [self.locationManager stopUpdatingLocation];

    //获取经纬度
    longitude =[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *array, NSError *error)
     {

          if (array.count >0)
          {
             CLPlacemark *placemark = [array objectAtIndex:0];

             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
              //存入
              NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

              if (![locationCity isEqualToString:city]) {
                  locationCity = city;
                  //获取城市
                  [userDefaults setObject:locationCity forKey:@"locationCity"];
                  [userDefaults synchronize];//立即
              }
              locationCity = city;
              [userDefaults setObject:longitude forKey:@"lon"];
              [userDefaults setObject:latitude forKey:@"lat"];
              [userDefaults synchronize];

            }
          else if (error == nil && [array count] == 0)
          {
              NSLog(@"No results were returned.");
          }
          else if (error != nil)
          {
              NSLog(@"An error occurred = %@", error);
          }

     }];

}
#pragma mark - 如果使用SSO（可以简单理解成客户端授权），以下方法是必要的
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    NSRange foundWxPay=[[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://pay", kWXAppID] options:NSCaseInsensitiveSearch];
    if (foundWxPay.length>0) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return [UMSocialSnsService handleOpenURL:url];
}
#pragma mark-是否支付成功
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                if (self.wxPayOKtoDo) {
                    self.wxPayOKtoDo(TRUE);
                }
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                if (self.wxPayOKtoDo) {
                    self.wxPayOKtoDo(FALSE);
                }
                break;
        }
    }
}
#pragma mark-支付处理
//iOS 4.2+
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSRange foundObj=[sourceApplication rangeOfString:@"com.alipay." options:NSCaseInsensitiveSearch];
    if(foundObj.length>0) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    NSRange foundWxAuth=[[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://oauth", kWXAppID] options:NSCaseInsensitiveSearch];
    if (foundWxAuth.length>0) {
        return [UMSocialSnsService handleOpenURL:url];
    }
    NSRange foundWxPay=[[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://pay", kWXAppID] options:NSCaseInsensitiveSearch];
    if (foundWxPay.length>0) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return TRUE;
}
#pragma mark-第三方友盟统计，百度统计，百度地图－－1-－
//如果应用程序已经完全退出那么此时会调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 开启网络状态监测
    [NetworkHelper startNetMonitoring];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    //腾讯崩溃信息捕获
     [[CrashReporter sharedInstance] installWithAppId:@"900014411"];
    
    
    
    
    // 开启UMessage的Log，然后寻找deviceToken的字段
    [UMessage setLogEnabled:YES];
    //友盟消息推送
    [UMessage startWithAppkey:kUMengAppKey launchOptions:launchOptions];
#pragma mark-设置推送消息为特定的用户
    //获取当前用户ID
    NSString *userid = [[LoginConfig Instance]userID];
    NSLog(@"userid===========%@",userid);
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:@"projectId"];
    //用户登录调用
    [UMessage addAlias:userid type:projectId response:nil];
    
    NSLog(@"projectId++++========%@",projectId);
    // [UMessage addAlias:@"projectId" type:projectId response:nil];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
    
    
    // bugly
    [[CrashReporter sharedInstance] installWithAppId:@"900014411"];
    
    //友盟统计
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
#ifdef DEBUG
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
#endif
    [MobClick setEncryptEnabled:YES];   // 日志加密
    [MobClick startWithAppkey:kUMengAppKey reportPolicy:BATCH channelId:nil];
    
    //version 标识
    //友盟SDK为了兼容Xcode3的工程，默认取的是Build号，如果需要取Xcode4及以上版本的Version，可以使用下面的方法；
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
        
    BOOL isok = [WXApi registerApp:kWXAppID];
    if (isok) {
        NSLog(@"注册微信成功");
    }else{
        NSLog(@"注册微信失败");
    }
    
    //2. 初始化社交平台
    //2.1 代码初始化社交平台的方法
    [self initializePlat];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _userArray = [[NSMutableArray alloc] init];
    
    //初始化本地数据库连接
    if (![self initializeDb])
    {
        NSLog (@"couldn't init db");
    }
    [db close];
    
//    //百度地图
//    _mapManager = [[BMKMapManager alloc]init];
//    BOOL ret = [_mapManager start:BaiduMap_Key  generalDelegate:self];
//    if (ret) {
//        NSLog(@"百度地图启动OK");
//    }else{
//        NSLog(@"百度地图启动失败");
//    }
    
    [self loadRootVC];
    
    [self.window makeKeyAndVisible];
    
    // 第一种情况，由push message启动，直接跳转到message页面
    if (launchOptions) {
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            //获取自定义参数
            messageMsgidStr = [userInfo objectForKey:@"push_chat_msgid"];//消息ID
            YjqLog(@"友盟ID1：%@",messageMsgidStr);
            [self goMessageViewController];
        }
    }

    return YES;
}
#pragma mark-友盟推送消息设置
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    [UMessage setLogEnabled:YES];
    [UMessage setAutoAlert:NO];//设置是否允许SDK当应用在前台运行收到Push时弹出Alert框（默认开启）
    //获取设备的 DeviceToken
    YjqLog(@"DeviceToken===================%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    YjqLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}
#pragma mark-接受到系统通知跳到指定的页面（物业通知）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //获取自定义参数
    messageMsgidStr = [userInfo objectForKey:@"push_chat_msgid"];
    YjqLog(@"友盟ID：%@",messageMsgidStr);

    if (application.applicationState == UIApplicationStateActive) {
//        //第二种情况-app 是打开状态（包括未登录）
        if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
//            NSString *message = [NSString stringWithFormat:@"新消息：%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
//            [Common showBottomToast:message];
        }
    } else {
        //第三种情况－app在后台运行
        [self goMessageViewController];
    }

    [UMessage didReceiveRemoteNotification:userInfo];

    
}
#pragma -mark 11-22  已安装微信进入微信登陆,没有安装微信进入手机登陆
-(void)weiXinOrIphoneLoginApp
{
    //已安装微信进入微信登陆
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
    {
        PersonalWeinXinLoginViewController*vc=[[PersonalWeinXinLoginViewController alloc]init];
        UINavigationController*nvc=[[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController=nvc;
    }
    else{//没有安装微信进入手机登陆
        PersonalCenterViewController*vc=[[PersonalCenterViewController alloc]init];
        UINavigationController*nvc=[[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController=nvc;
    }

}

#pragma mark-推送消息点击进入
-(void)goMessageViewController{
    if ([self.window.rootViewController isMemberOfClass:[MainViewController class]]) {
        MainViewController *mainVC = (MainViewController *)self.window.rootViewController;
        [mainVC setSelectedIndex:0];
        UINavigationController *nav = (UINavigationController *)mainVC.selectedViewController;
        MessageDetailViewController *vc = [[MessageDetailViewController alloc] init];
        if ([messageMsgidStr isEqualToString:NULL]) {
            vc.messageMsgid = @"";
        }
        vc.messageMsgid =messageMsgidStr;
        [nav pushViewController:vc animated:NO];

    }
}

- (void)dealloc
{
    // 关闭网络状态监测
    [NetworkHelper stopNetMonitoring];
}

#pragma mark-判断是否选择小区，登陆方式
-(void)loadSWRevealViewController{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *value = [userDefault objectForKey:KEY_PROJECTID];
    if (!value)//未经选择小区
    {
        BOOL isLogged = [[LoginConfig Instance] userLogged];
#pragma -mark 11-22微信登陆  手机登陆
        if(!isLogged) {//用户未登录进入登陆，再加载选择小区页
            [self weiXinOrIphoneLoginApp];
            return;
        }
//        SelectNeighborhoodViewController *vc = [[SelectNeighborhoodViewController alloc] init];
        GYZChooseCityController *vc = [[GYZChooseCityController alloc] init];
        vc.isRootVC = TRUE;
        vc.isSaveData = TRUE;
        if (![locationCity isEqual:@""] && locationCity != nil) {
//            vc.longitudeStr = longitude;
//            vc.latitudeStr = latitude;
//            vc.locationCityStr = locationCity;
        }
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nvc;
        longitude = @"";
        latitude = @"";
        locationCity = @"";

    }
    else//已选择小区
    {
#pragma -mark 11-15 登陆判断修改
        BOOL isLogged = [[LoginConfig Instance] userLogged];
        if(!isLogged) {//用户未登录进入登陆，再加载选择小区页
            [self weiXinOrIphoneLoginApp];
            return;
        }
        else
        {
            //装载根视图
            MainViewController *mainVC = [[MainViewController alloc] init];
            

            self.window.rootViewController = mainVC;
            UserModel* user = [[LoginConfig Instance] getUserInfo];
            if(user.isLogin)
            {
                [_userArray addObject:user];
                _isWillLogin = YES;
            }
#pragma -mark ios 修改web view的ua（已选择小区）
            [UserAgent UserAgentMenthd];
        }
    }
}
#pragma mark-判断该手机是否已安装，手机首次安装加载引导页，不是首次使用加载主页
-(void)loadRootVC
{
    //读取沙盒数据
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *isFirst = [userDefault objectForKey:@"is_first"];//是否第一次装机
    // NSString *value = [userDefault objectForKey:KEY_PROJECTID];
    if (isFirst == nil || [isFirst isEqualToString:@"false"]==FALSE) {//手机未安装
        GuideViewController* vc = [[GuideViewController alloc]init];//3张引导页
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nvc;
    }
    else //不是第一次装机
    {
        [self loadSWRevealViewController];

    }
    
}

#pragma mark - database init
- (BOOL)initializeDb
{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"CommunityApp.db"];
    NSLog(@"db path:%@",dbPath);
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"CommunityApp.db"的文件,sqlite会自动创建"CommunityApp.db"
    db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return FALSE;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //#pragma mark-用户退出的时候调用
    //    //获取当前用户ID
    //    NSString *userid = [[LoginConfig Instance]userID];
    //    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    //    NSString *projectId = [userDefault objectForKey:@"projectId"];
    //    //用户退出的时候调用
    //    [UMessage removeAlias:@"userid" type:userid response:nil];
    //    [UMessage removeAlias:@"projectId" type:projectId response:nil];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
    {
        [application setKeepAliveTimeout:600 handler:^{
            
            NSLog(@"KeepAliveHandler");
            
            // Do other keep alive stuff here.
        }];
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//- (NSManagedObjectContext *)managedObjectContext_roster
//{
//    return [xmppRosterStorage mainThreadManagedObjectContext];
//}
//
//- (NSManagedObjectContext *)managedObjectContext_capabilities
//{
//    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
//}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0) {
//        return;
//    }
//    else if (buttonIndex == 1)
//    {
//        //       1.进入appstore中指定的应用
//        NSString *str = [NSString stringWithFormat:
//                         @"itms://itunes.apple.com/gb/app/yi-dong-cai-bian/id1048321627?mt=8"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//
//    }

    [Common weiXinLoginOrIphoneLogin];
//    BOOL isLogin = YES;
//    if (self.userAccountLoginAtOtherPlaceBlock) {
//        self.userAccountLoginAtOtherPlaceBlock(isLogin);
//    }
}

#pragma mark--- toLogin
-(void)toLogin
{
    
    if ([self.baseViewDelegate respondsToSelector:@selector(toLogin)]) {
        [self.baseViewDelegate toLogin];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
//{
//
//    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
//                                                             xmppStream:xmppStream
//                                                   managedObjectContext:[self managedObjectContext_roster]];
//
//    NSString *displayName = [user displayName];
//    NSString *jidStrBare = [presence fromStr];
//    NSString *body = nil;
//
//    if (![displayName isEqualToString:jidStrBare])
//    {
//        body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
//    }
//    else
//    {
//        body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
//    }
//
//
//    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
//                                                            message:body
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Not implemented"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }
//    else
//    {
//        // We are not active, so use a local notification instead
//        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        localNotification.alertAction = @"Not implemented";
//        localNotification.alertBody = body;
//
//        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//    }
//
//}

// 获取当前ViewController
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] firstObject];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
    
    
    //    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    //    UIViewController *topVC = appRootVC;
    //    while (topVC.presentedViewController) {
    //        topVC = topVC.presentedViewController;
    //    }
    //    return topVC;
}


//#pragma mark - XMPP更换我的头像
//- (void)updateMyAvatar:(UIImage *)image
//{
//    NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns:
//                              @"vcard-temp"];
//    NSXMLElement *photoXML = [NSXMLElement elementWithName:@"PHOTO"];
//    NSXMLElement *typeXML = [NSXMLElement elementWithName:@"TYPE"
//                                              stringValue:@"image/jpeg"];
//    NSData *dataFromImage = UIImageJPEGRepresentation(image, 0.7f);
//    NSXMLElement *binvalXML = [NSXMLElement elementWithName:@"BINVAL"
//                                                stringValue:[dataFromImage base64Encoding]];
//    [photoXML addChild:typeXML];
//    [photoXML addChild:binvalXML];
//    [vCardXML addChild:photoXML];
//    XMPPvCardTemp *myvCardTemp = [xmppvCardTempModule myvCardTemp];
//
//    if (myvCardTemp) {
//        [myvCardTemp setPhoto:dataFromImage];
//        [xmppvCardTempModule updateMyvCardTemp:myvCardTemp];
//    }
//    else{
//        XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement
//                                       :vCardXML];
//        [xmppvCardTempModule updateMyvCardTemp:newvCardTemp];
//    }
//}
//
//#pragma mark - XMPP显示我的头像
//- (UIImage *)showMyAvatar
//{
//    XMPPJID *userJID = [xmppStream myJID];
//        XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:userJID
//                                                             xmppStream:xmppStream
//                                                   managedObjectContext:[self managedObjectContext_roster]];
//    if (user.photo) {
//        return user.photo;
//    }else {
//        NSData *photoData = [xmppvCardAvatarModule photoDataForJID:userJID];
//        UIImage *image = [[UIImage alloc] initWithData:photoData];
//        return image;
//    }
//}


@end

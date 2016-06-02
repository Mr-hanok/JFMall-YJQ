//
//  OpenDoorViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "OpenDoorViewController.h"
//🍎下
#import "GattManager.h"//蓝牙类
#import <CoreBluetooth/CoreBluetooth.h>
#import "iZHC_MoProtocol.h"//解析key
#import "RoadData.h"
#import "RoadAddressManageViewController.h"
//🍎业主
#import "LoginConfig.h"
#import "Interface.h"

//base64+md5
#import "base64.h"
#import "Common.h"
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#define pageSize (10)


#import <AFNetworking.h>
#import <MJRefresh.h>
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
//开门动画设计头文件
#import "OpenDoorAnimation.h"
//开门设置
#import "OpenDoorSettingViewController.h"
//开门自定义alertview
#import "FKAlertView.h"
#import "UIImage+animatedGIF.h"

@interface OpenDoorViewController ()<GattBLEDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate/*,UIGestureRecognizerDelegate*//*,CBPeripheralManagerDelegate*/>{

    BOOL bluetooth;
    NSMutableArray *bleNameArray;//蓝牙数组
    NSMutableArray *FIDArray;//fid数组
    iZHC_MoProtocol *moPro;//解析key
     NSString *codeNumber;

    //🍎////////
    NSMutableArray *_dataArray;

    NSString *authStatus;
    NSDictionary *dict;
    NSString *projectName;
    NSMutableArray *_projectNameArr;
    NSString *datestr;//开始开门时间
    CGRect rect;
    FKAlertView *alertView;
    NSTimer *timerSearch;
    NSInteger timerCount;
}

@property (strong,nonatomic) UIImageView *loadimageView;

@property (strong,nonatomic) RoadData* roadData;
@property(nonatomic,strong)UIWindow*openAnimationWindow;
@property(strong,nonatomic) GattManager *gattManager;
@property (nonatomic, assign) BOOL isWillClick;
//🍎上
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openDoorImageWidthConstratint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openDoorImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openDoorImageViewToTopConstraint;
@property (strong, nonatomic)  UIImageView *openDoorImg1;
@property (strong, nonatomic)  UIImageView *openDoorImg2;
@property (strong, nonatomic)  UIImageView *openDoorImg3;
@property (strong, nonatomic)  UIImageView *openDoorImg4;
@property (strong, nonatomic)  UIImageView *openDoorHandImg;
@property(nonatomic,strong)UIImageView*flameAnimation;


//@property (nonatomic,strong)CBCentralManager *centralManager;//本机蓝牙类
@end

@implementation OpenDoorViewController
#pragma mark - 重载方法区
//1初始化数据
- (void)viewDidLoad {
    [super viewDidLoad];


    //自定义alertview位置大小
     rect = CGRectMake(self.view.frame.size.width/6, self.view.frame.size.height/10, CGRectGetWidth(self.view.frame) * 0.8, CGRectGetHeight(self.view.frame) * 0.4);

    _dataArray = [[NSMutableArray alloc] init];
    _projectNameArr = [[NSMutableArray alloc] init];
    //初始化导航栏信息
    self.title = Str_Comm_OpenDoor;
    self.hidesBottomBarWhenPushed = NO;
    [self becomeFirstResponder];

    //设置按钮的处理
    [self setNavBarRightItemTitle:@"设置" andNorBgImgName:nil andPreBgImgName:nil];
    UIBarButtonItem*buttonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarRightItemClick)];
    self.navigationItem.rightBarButtonItem=buttonItem;
    
//    //本机蓝牙代理方法
//    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    //创建BLE搜索对象

#if TARGET_IPHONE_SIMULATOR
#else
    self.gattManager = [[GattManager alloc] init];
#endif
    self.gattManager.delegate = self;

 [self prepareUI];
    
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    

}
- (void)requestAuthenData
{
//    [self.roadDataArray removeAllObjects];
    if([[LoginConfig Instance] userLogged]== FALSE)
        return;
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    // 请求服务器获取数据
    NSString *userId = user.userId;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:   userId,@"userId",nil];
    NSUserDefaults*defaultsAuthen=[NSUserDefaults standardUserDefaults];
    [self getArrayFromServer:ServiceInfo_Url path:@"getBuildLocation" method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result)
     {
         NSMutableArray*array=[[NSMutableArray alloc]init];
         //没有数据的时候认证状态保存为空
         if (result.count==0) {
             //认证状态保存到本地
             [defaultsAuthen setObject:@"" forKey:@"authenStatus"];
         }
         for (NSDictionary *dicResult in result)
         {
             RoadData *roadData = [[RoadData alloc] initWithDictionary:dicResult];
             //所有的认证状态添加到数据
             [array addObject:dicResult[@"authen"]];
             [self.roadDataArray addObject:roadData];
         }
         
         //所有的认证状态保存到数组
         self.authenStatusarray=[NSArray arrayWithArray:array];
         //消除认证状态的冗余并且封装新字典
         NSMutableDictionary *autnenDict = [[NSMutableDictionary alloc] init];
         for (NSString*str in self.authenStatusarray) {
             if ([str isEqualToString:Str_One]) {//已认证
                 if(![autnenDict objectForKey:Str_One]){
                     [autnenDict setObject:Str_One forKey:Str_One];
                 }
                 //存在 有认证的地址，认证状态保存到本地
                 
             }else if ([str isEqualToString:Str_Two]){//待认证
                 if(![autnenDict objectForKey:Str_Two]){
                     [autnenDict setObject:Str_Two forKey:Str_Two];
                 }
             }else if ([str isEqualToString:Str_Three]){///3 以拒绝
                 if(![autnenDict objectForKey:Str_Three]){
                     [autnenDict setObject:Str_Three forKey:Str_Three];
                 }
             }else{
                 if(![autnenDict objectForKey:Str_Fore]){
                     [autnenDict setObject:Str_Fore forKey:Str_Fore];
                 }
             }
         }
         //根据认证优先级，储存认证状态
         if ([autnenDict objectForKey:Str_One]) {//1 已认证
             [defaultsAuthen setObject:@"YES" forKey:@"authenStatus"];
             //存在 有认证的地址，认证状态保存到本地
             
         }
         if ([autnenDict objectForKey:Str_Two]){//2 待认证
             if(![autnenDict objectForKey:Str_One]){
                 [defaultsAuthen setObject:@"MID" forKey:@"authenStatus"];
             }
         }
         if ([autnenDict objectForKey:Str_Three]){///3 以拒绝
             if(![autnenDict objectForKey:Str_One] && ![autnenDict objectForKey:Str_Two]){
                 [defaultsAuthen setObject:@"NO" forKey:@"authenStatus"];
             }
         }
         if ([autnenDict objectForKey:Str_Fore]){///4 异常
             if(![autnenDict objectForKey:Str_One] && ![autnenDict objectForKey:Str_Two] && ![autnenDict objectForKey:Str_Three]){
                 [defaultsAuthen setObject:@"CANCLE" forKey:@"authenStatus"];
             }
         }
         [defaultsAuthen synchronize];
         [self clickDoorMethod];
     }
      failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}
-(void)prepareUI
{
    self.openDoorImg1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-64)];
    self.openDoorImg1.image=[UIImage imageNamed:@"image1.jpg"];//OpenDoorImg
    [self.view addSubview:self.openDoorImg1];
  
    

    UIView *toumingview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    toumingview.backgroundColor = [UIColor clearColor];
    toumingview.alpha = 1;
    [self.view addSubview:toumingview];

//    self.openDoorHandImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width/2, self.view.frame.size.height/2)];
//    self.openDoorHandImg.image=[UIImage imageNamed:@"hand.png"];
//    self.openDoorHandImg.userInteractionEnabled=YES;
//    [toumingview addSubview:self.openDoorHandImg];
#pragma mark-点击开门
    //点击开门（一个手指头）
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.delegate=self;
    //设置当前需要点击的次数
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    //设置当前需要触发事件的手指数量
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [toumingview addGestureRecognizer:singleTapGestureRecognizer];


#pragma mark-下拉开门
    UISwipeGestureRecognizer * swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeGesture.delegate=self;
    //设置轻滑的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [toumingview addGestureRecognizer:swipeGesture];
}

#pragma -mark CBPeripheralManagerDelegate本机蓝牙代理方法
//- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
//{
//    bluetooth = NO;
//    switch (peripheral.state) {
//        case CBPeripheralManagerStatePoweredOn:
//        {
//            bluetooth = YES;
//            YjqLog(@"蓝牙打开");
//        }
//            break;
//
//        default:
//        {
//            YjqLog(@"蓝牙未打开");
//        }
//            break;
//    }
//}
//设置按钮事件
- (void)navBarRightItemClick
{
    OpenDoorSettingViewController*openDoorSettingVC=[[OpenDoorSettingViewController alloc]init];
    [self.navigationController pushViewController:openDoorSettingVC animated:YES];

}
- (void)openDoor
{

    //上传设备信息
    UIDevice *device = [UIDevice currentDevice];
//     NSString *name = device.name;       //获取设备所有者的名称
    NSString *model = device.model;      //获取设备的类别@"iPhone"
    NSString *type = device.localizedModel; //获取本地化版本@"iPhone"
//     NSString *systemName = device.systemName;   //获取当前运行的系统@"iOS"
    NSString *systemVersion = device.systemVersion;//获取当前系统的版9.1
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];//每次删除app都会发生变化序列号
    YjqLog(@"********%@",identifierForVendor);
    NSString *rst = [NSString stringWithFormat:@"%@#@#%@#@#%@#@#%@",model,type,systemVersion,identifierForVendor];
    //因为有汉字要utf8编码
    NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    YjqLog(@"****%@",rstt);

    //🍎AFNetWorking解析数据
    AFHTTPSessionManager  *_manager
    =[AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    YjqLog(@"userid:%@",userid);

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"ownerId",VersionNumber,@"version",rstt,@"rst", nil];//dic是向服务器上传的参数
    YjqLog(@"dic:%@",dic);//输入
    [_manager POST:OwnerApprove_Url parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {


        //解析数据
        dict=[NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers error:nil];
        YjqLog(@"********************dict:%@********************",dict);
        /*
         * 接口请求成功---开门
         */
        if ([dict[@"code"] isEqualToString:@"IOD00000"]) {

           // YjqLog(@"dict:%@",dict);
            NSDictionary *bodyDict = dict[@"body"];
            authStatus = bodyDict[@"authStatus"];//认证状态
            YjqLog(@"authStatus:%@",authStatus);
            NSArray *projectsArray = bodyDict[@"projects"];
            // NSLog(@"projects:%@",projectsArray);
            for (NSDictionary *dict1 in projectsArray) {

                projectName = dict1[@"projectName"];
                [_projectNameArr addObject:projectName];//认证项目名数组
                NSArray *keysArray = dict1[@"keys"];
                for (NSDictionary *dict2 in keysArray) {
                    NSString *keyStr = [dict2 objectForKey:@"key"];

                    [_dataArray addObject:keyStr];

                }
            }
            YjqLog(@"%@",_projectNameArr);
        }
        /**
         * 版本号错误
         */
        else if ([dict[@"code"] isEqualToString:@"IODB0002"])
        {
            YjqLog(@"用户没有认证");
        }
        else
        {
            YjqLog(@"其他错误");
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        YjqLog(@"%@", error.localizedDescription);
    }];

}


//4🍎上
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [timerSearch invalidate];//使搜索无效
//    timerSearch = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [alertView removeFromSuperview];//移除自定义alertview
}
//2🍎下
#pragma mark - 重载viewWillAppear
-(void)viewWillAppear:(BOOL)animated {
    //开门
    [self openDoor];
    //新
    _isWillClick = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BLEmonitor:) name:@"BLENotification" object:nil];
    
    //注册定时器
    timerCount = 0;
    timerSearch = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(searchOpenDoor) userInfo:nil repeats:YES];
    [timerSearch setFireDate:[NSDate distantFuture]];

    CGFloat fImageHeight = 0;
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.frame = CGRectMake(0, Screen_Height-BottomBar_Height, Screen_Width, BottomBar_Height);
    // 偏移量占总屏幕宽度百分比 22 / 320
    fImageHeight = (Screen_Width - 78) - ( 22.0 / 320.0 ) * Screen_Width;
    self.openDoorImageWidthConstratint.constant = fImageHeight;
    self.openDoorImageViewHeightConstraint.constant = fImageHeight;

    //设置图片垂直居中
    self.openDoorImageViewToTopConstraint.constant = (Screen_Height - (Navigation_Bar_Height + fImageHeight + 60 + 100)) / 2.0;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark-瑶瑶，点击，下拉调用此方法可执行开门效果
//瑶瑶，点击，下拉调用此方法可执行开门效果
-(void)openDoorMethod{
    [self requestAuthenData];
}
-(void)clickDoorMethod
{
    if(!_isWillClick){
        return;
    }
    _isWillClick =NO;

    //获取当前时间
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);

    

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    
    datestr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",year,month,day,hour,minute,second];
#pragma -mark 12-23 网络连接判断
//    BOOL netWorking = [Common checkNetworkStatus];
//    if (netWorking) {

    //上传设备信息
    UIDevice *device = [UIDevice currentDevice];
    //     NSString *name = device.name;       //获取设备所有者的名称
    NSString *model = device.model;      //获取设备的类别@"iPhone"
    NSString *type = device.localizedModel; //获取本地化版本@"iPhone"
    //     NSString *systemName = device.systemName;   //获取当前运行的系统@"iOS"
    NSString *systemVersion = device.systemVersion;//获取当前系统的版9.1
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];//每次删除app都会发生变化序列号
    YjqLog(@"********%@",identifierForVendor);
    NSString *rst = [NSString stringWithFormat:@"%@#@#%@#@#%@#@#%@",model,type,systemVersion,identifierForVendor];
    //因为有汉字要utf8编码
    NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    YjqLog(@"****%@",rstt);

    //🍎AFNetWorking解析数据
    AFHTTPSessionManager  *_manager
    =[AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    YjqLog(@"userid:%@",userid);

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"ownerId",VersionNumber,@"version",rstt,@"rst", nil];//dic是向服务器上传的参数
    YjqLog(@"dic:%@",dic);//输入
    [_manager POST:OwnerApprove_Url parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {


        //解析数据
        dict=[NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers error:nil];
        /**
         * 接口请求成功 且为认证状态
         **/
        //  &&且  ||与
        YjqLog(@"+++++++%@++++++",dict);
        if ([dict[@"code"] isEqualToString:@"IOD00000"] ){
            if ([authStatus isEqualToString:@"1"]) {
                //触发定时器
                [timerSearch setFireDate:[NSDate distantPast]];
//                    _isWillClick = YES;


#if TARGET_IPHONE_SIMULATOR
#else
                moPro = [[iZHC_MoProtocol alloc] init];//初始化key数组
#endif
                NSMutableArray *arrr = [[NSMutableArray alloc] init];
                for (int i = 0;i<_dataArray.count;i++) {
                    NSString *sttr = _dataArray[i];
                    NSDictionary *dicc = @{@"encryptStr": sttr};
                    //array为从服务器获取到的数据
                    [arrr addObject:dicc];
                    //这是解key的操作，bleNameArray为解析出的蓝牙名数组，FIDArray为解析出的fid数组
                    
                }
                [moPro decodeKey:arrr];//解key

            }
            //新
            [self searchOpenDoor];
        }
        /*
         用户未认证
         */
        else if ([dict[@"code"] isEqualToString:@"IODB0002"])//
        {

            self.openDoorImg3=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
            self.openDoorImg3.image=[UIImage imageNamed:@"image3.jpg"];//OpenDoorImg
            [self.view addSubview:self.openDoorImg3];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3
 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.openDoorImg3 removeFromSuperview];
                _isWillClick = YES;

            });

//            //声音设置
//            [self soundSetting];
            NSUserDefaults*defaultsAuthen=[NSUserDefaults standardUserDefaults];
             YjqLog(@"%@",defaultsAuthen);
            NSString*authenStatutring=[defaultsAuthen objectForKey:@"authenStatus"];

            if ([authenStatutring isEqualToString:@""] || [authenStatutring isEqualToString:@"NO"] || [authenStatutring isEqualToString:@"CANCLE"]) {

                self.key = @"";
                datestr = @"";
                self.resultStr = @"false";
                self.resultReason = @"未认证";
                [self openDoorResult];//上传开门数据

                alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"认证" message:@"先认证才可以开门哦!"  cancel:@"取消" other:@"认证"];
//                timerCount = 0;
//                [timerSearch setFireDate:[NSDate distantFuture]];
                alertView.quxiaoBlock = ^void() {

                    [self.openDoorImg3 removeFromSuperview];
                    _isWillClick = YES;
                };
                alertView.lookBaojiaBlock = ^void() {
                    //未认证，去认证
                    RoadAddressManageViewController* next = [[RoadAddressManageViewController alloc]init];
                    next.isAddressSel = addressSel_Auth;
                    next.showType = ShowDataTypeAuth;
                    [self.navigationController pushViewController:next animated:YES];

                };

                self.loadimageView.hidden = YES;
                [self.view addSubview:alertView];



            }
            if ([authenStatutring isEqualToString:@"MID"]) {

                self.key = @"";
                datestr = @"";
                self.resultStr = @"false";
                self.resultReason = @"认证中";
                [self openDoorResult];//上传开门数据

                alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"认证中" message:@"物业人员会尽快为您认证，请等待通知哦"  cancel:@"好" other:@""];
//                timerCount = 0;
//                [timerSearch setFireDate:[NSDate distantFuture]];
                alertView.quxiaoBlock = ^void() {

                    [self.openDoorImg3 removeFromSuperview];
                    _isWillClick = YES;
                };
                self.loadimageView.hidden = YES;
                [self.view addSubview:alertView];
                [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];


            }

        }
        
        /*
         其他情况
         */
        else  if ([dict[@"code"] isEqualToString:@"IOD0020"])//
            
        {
            self.key = @"";
            datestr = @"";
            self.resultStr = @"false";
            self.resultReason = @"开门失败";
            [self openDoorResult];//上传开门数据

            self.openDoorImg4=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
            self.openDoorImg4.image=[UIImage imageNamed:@"image4.jpg"];//OpenDoorImg
            [self.view addSubview:self.openDoorImg4];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.openDoorImg4 removeFromSuperview];
                _isWillClick = YES;
            });
            [Common showBottomToast:@"已认证的社区暂无开门服务哦"];
//            timerCount = 0;
//            [timerSearch setFireDate:[NSDate distantFuture]];

//            FKAlertView *alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"无连接" message:@"未检测到有效设备"  cancel:@"好" other:@""];
//
//            alertView.quxiaoBlock = ^void() {
//                _isWillClick = YES;
//
//            };
//
//            [self.view addSubview:alertView];
//            [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];


        }
        else
        {
            self.key = @"";
            datestr = @"";
            self.resultStr = @"false";
            self.resultReason = @"开门失败";
            [self openDoorResult];//上传开门数据

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.openDoorImg4 removeFromSuperview];
                _isWillClick = YES;
            });
            [Common showBottomToast:@"门禁较远或升级，请靠前或刷卡"];
//            timerCount = 0;
//            [timerSearch setFireDate:[NSDate distantFuture]];
//            _isWillClick = YES;

        }


    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        _isWillClick = YES;
        YjqLog(@"%@", error.localizedDescription);
    }];
//    }
//    else
//    {
//        [Common showBottomToast:Str_Comm_RequestTimeout];
//        return;
//
//    }
}
#pragma mark-点击开门
- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer
{
    [MobClick event:@"opendoor_button"];
    
    [self openDoorMethod];
}
#pragma mark-下拉开门
-(void)swipeGestureAction:(UISwipeGestureRecognizer *)swipeGesture
{
//    [UIView animateWithDuration:0.5 animations:^{
//        CGPoint center = self.openDoorHandImg.center;
//        if (swipeGesture.direction==UISwipeGestureRecognizerDirectionDown) {
//            center.y+=150;
//        }
//        self.openDoorHandImg.center = center;
//    } completion:^(BOOL finished) {
//        CGPoint center = self.openDoorHandImg.center;
//        center.y-=150;
//        self.openDoorHandImg.center = center;
//    }];
//    [self openDoorMethod];
}

//摇一摇开门
#pragma mark-开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [MobClick event:@"opendoor_opendoor_shake"];
    
    [self openDoorMethod];
}
#pragma mark - 摇一摇部分代码
- (BOOL)canBecomeFirstResponder {
    return YES;
}
#pragma mark-声音设置
-(void)soundSetting
{
    //获取音效，震动开关设置的状态
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *soundEffectSwitch = [userDefault objectForKey:@"soundEffectSwitch"];
    NSString *shakeSwitch = [userDefault objectForKey:@"shakeSwitch"];
    //根据不同的开关设置音效或震动
    if ([soundEffectSwitch isEqualToString:@"YES"]) {//音效开关打开状态
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"4514.wav" withExtension:nil];
        SystemSoundID soundID=0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        AudioServicesPlayAlertSound(soundID);
    }
    if ([shakeSwitch isEqualToString:@"YES"]) {//震动开关打开状态
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if ([soundEffectSwitch isEqualToString:@"YES"]&&[shakeSwitch isEqualToString:@"YES"]) {//音效和震动同时开启
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"4514.wav" withExtension:nil];
        SystemSoundID soundID=0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        AudioServicesPlayAlertSound(soundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    

}
#pragma mark-alertView代理方法
//提示框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //🍎
    if (buttonIndex == 0)
    {
        return;
    }
    else
    {
        if (![[LoginConfig Instance] userLogged]) {
            //未登录，跳转登陆界面
            [Common weiXinLoginOrIphoneLogin];
        }
        else
        {
            //未认证，去认证
            RoadAddressManageViewController* next = [[RoadAddressManageViewController alloc]init];
            next.isAddressSel = addressSel_Auth;
            next.showType = ShowDataTypeAuth;
            [self.navigationController pushViewController:next animated:YES];
        }
    }
}



//🍎上
#pragma mark - 隔一定时间后如果还没得到回应就重新搜索
//3搜索设备
-(void)searchOpenDoor
{
    timerCount++;
    if (timerCount > 4) {
        [self hideHUD];
        self.openDoorImg4=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
        self.openDoorImg4.image=[UIImage imageNamed:@"image4.jpg"];//OpenDoorImg
        [self.view addSubview:self.openDoorImg4];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.openDoorImg4 removeFromSuperview];
            _isWillClick = YES;
        });
        
        [Common showBottomToast:@"搜索设备超时,开门失败!"];
        self.loadimageView.hidden = YES;
        
        self.key = @"";
        datestr = @"";
        self.resultStr = @"false";
        self.resultReason = @"开门失败";
        [self openDoorResult];//上传开门数据
        
        [timerSearch setFireDate:[NSDate distantFuture]];
        timerCount = 0;
        
    }else{
        //给蓝牙类的蓝牙数组和Fid数组赋值
        self.gattManager.gattUserInfoArray = moPro.bleNameArray;
        self.gattManager.gattUserFIDArray = moPro.FIDArray;
        self.gattManager.gattUserKeyArray = moPro.keyArray;
        [self.gattManager setUp];//实例化中心角色
        [self.gattManager setFlagDefault];
        //        [self.gattManager stopScan];
        
        [self.gattManager scan:2];//整形参数为搜索次数，代表周边蓝牙设备的数目，当搜索次数到达此整数还未搜索到目标设备则返回未搜索到设备。
        
        NSLog(@"%d",self.UseTime);//1
    }
    
}

//新
#pragma mark - iZHC_MoProtocolDelegate
-(void)getKeyCheckAnswer:(int)result resultString:(NSString *)key{
    switch (result) {
        case 2:
        {
            NSLog(@"key:%@ \n快要过期，请从服务器获取有效的key",key);
        }
            break;
        case 3:
        {
            NSLog(@"key:%@ \n已经过期，请从服务器获取有效的key",key);
        }
            break;

        default:
            break;
    }
}
//#pragma mark -创建开门成功的动画图片
//-(void)creatOpendoorAnimation
//{
//    _flameAnimation = [[UIImageView alloc] initWithFrame:self.view.frame];
//    _flameAnimation.animationImages = [NSArray arrayWithObjects:
//                                      [UIImage imageNamed:@"open1.jpg"],
//                                      [UIImage imageNamed:@"open2.jpg"],
//                                      [UIImage imageNamed:@"open3.jpg"],
//                                      [UIImage imageNamed:@"open4.jpg"],
//                                      [UIImage imageNamed:@"open5.jpg"],
//                                      [UIImage imageNamed:@"open6.jpg"],nil];
//    _flameAnimation.animationDuration = 2.0;
//    _flameAnimation.animationRepeatCount = 1;
//    [_flameAnimation startAnimating];
//    [self.view addSubview:_flameAnimation];
//}

#pragma mark - GattBLE Delegate
-(void)getBleSearchAnswer:(int)result resultString:(NSString *)str26
{
    timerCount = 0;
    [timerSearch setFireDate:[NSDate distantFuture]];
    switch (result) {
        case 0:
        {

            YjqLog(@"开门成功");
#pragma mark-开门动画
            //添加声音
            [self soundSetting];

            [Common showBottomToast:@"欢迎回家"];
            
            self.openDoorImg2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
            self.openDoorImg2.image=[UIImage imageNamed:@"image2.jpg"];//OpenDoorImg
            [self.view addSubview:self.openDoorImg2];
            _isWillClick = NO;


////            self.openAnimationWindow.hidden=NO;
////            self.openAnimationWindow=[OpenDoorAnimation showOpenDoorAnimation:[NSString stringWithFormat:@"%d",self.UseTime]andSuccessOrFail:0];
//            [self creatOpendoorAnimation];
//                           //延迟动画开门的时间之后消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                YjqLog(@"开门成功");
                [self.openDoorImg2 removeFromSuperview];
                _isWillClick = YES;
            });

//            FKAlertView *alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"" message:@"开门成功"  cancel:@"好" other:@""];
//            alertView.quxiaoBlock = ^void() {
//                _isWillClick = YES;
//                [self.openDoorImg2 removeFromSuperview];
//            };

            self.loadimageView.hidden = YES;
//            [self.view addSubview:alertView];

            self.resultStr = @"true";
            self.resultReason = @"开门成功";
            self.key = [self.gattManager getOpenKey];
            [self openDoorResult];//上传开门数据

            break;
        }
        case 1:
        {
            NSLog(@"蓝牙未打开222");
            self.key = @"";
            datestr = @"";
            self.resultStr = @"fault";
            self.resultReason = @"未打开蓝牙";
            [self openDoorResult];//上传开门数据

            _isWillClick = YES;
            break;
        }

        default:
            _isWillClick = YES;
            break;
    }

    if(self.gattManager)
        [self.gattManager setFlagDefault];
}


- (UIImageView *)loadimageView {
    if (!_loadimageView) {
        _loadimageView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-Screen_Width/1.5)/2,Screen_Height/7,Screen_Width/1.5 ,Screen_Height/8)];
        NSString * filePath = [[NSBundle mainBundle]pathForResource:@"openDoorLoad" ofType:@"gif"];
        NSURL * fileUrl = [NSURL fileURLWithPath:filePath];//这个方法用来进行本地地下的转换
        NSData * data = [[NSData alloc]initWithContentsOfURL:fileUrl];
        UIImage * image = [UIImage animatedImageWithAnimatedGIFData:data];
        _loadimageView.backgroundColor = UIColorFromRGB(0x404040);
        _loadimageView.alpha = 0.5;
        _loadimageView.image = image;
        _loadimageView.hidden = NO;
        [self.view addSubview:_loadimageView];
        _isWillClick = NO;
    }
    return _loadimageView;
}

-(void)BLEmonitor:(NSNotification *)notification{
    timerCount = 0;
    [timerSearch setFireDate:[NSDate distantFuture]];
    self.loadimageView.hidden = NO;
    
    NSNumber *result = [notification object];
    NSLog(@"result = %@",result);//个数
    switch ([result intValue]) {
        case 2:
        {
            NSLog(@"未搜索到设备");

            self.openDoorImg4=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
            self.openDoorImg4.image=[UIImage imageNamed:@"image4.jpg"];//OpenDoorImg
            [self.view addSubview:self.openDoorImg4];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.openDoorImg4 removeFromSuperview];
                _isWillClick = YES;
            });

            [Common showBottomToast:@"门禁较远或升级，请靠前或刷卡"];

//            FKAlertView *alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"无连接" message:@"未检测到有效设备，请靠近门禁哦"  cancel:@"好" other:@""];
//            alertView.quxiaoBlock = ^void() {
//                _isWillClick = YES;
//                [self.openDoorImg4 removeFromSuperview];
//
//            };
            self.loadimageView.hidden = YES;
//            _isWillClick = YES;
//            [self.view addSubview:alertView];
//            [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];

            self.key = @"";
            datestr = @"";
            self.resultStr = @"false";
            self.resultReason = @"未搜索到设备";
            [self openDoorResult];//上传开门数据


            break;
        }
        case 3:
        {
            NSLog(@"正在连接设备");
            self.loadimageView.hidden = YES;
            break;
        }
        case 4:
        {
            NSLog(@"连接成功");
            self.loadimageView.hidden = YES;
            break;
        }
//        case 5:
//        {
//            NSLog(@"连接超时");
//        }
        case 6:
        {
            NSLog(@"连接失败");
            self.loadimageView.hidden = YES;
        }
        case 7:
        {
            NSLog(@"未找到服务或特性");

            self.key = @"";
            datestr = @"";
            self.resultStr = @"false";
            self.resultReason = @"开门失败";
            [self openDoorResult];//上传开门数据

            self.openDoorImg4=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
            self.openDoorImg4.image=[UIImage imageNamed:@"image4.jpg"];//OpenDoorImg
            [self.view addSubview:self.openDoorImg4];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.openDoorImg4 removeFromSuperview];
                _isWillClick = YES;
            });


            alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"开门失败" message:@"门禁设备暂时出现故障，请尝试其他途径哦"  cancel:@"好" other:@""];
            alertView.quxiaoBlock = ^void() {
                _isWillClick = YES;
            };
            self.loadimageView.hidden = YES;
            [self.view addSubview:alertView];
            [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];

            break;
        }
        default:
            _isWillClick = YES;
            self.loadimageView.hidden = YES;
            break;
    }

//    self.UseTime = 230;

}
//🍎
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        //[alert release];
    }
}
//开门结果
- (void)openDoorResult
{

    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    //上传设备信息
    UIDevice *device = [UIDevice currentDevice];
    // NSString *name = device.name;       //获取设备所有者的名称
    NSString *model = device.model;      //获取设备的类别
    NSString *type = device.localizedModel; //获取本地化版本
    // NSString *systemName = device.systemName;   //获取当前运行的系统
    NSString *systemVersion = device.systemVersion;//获取当前系统的版
    //NSString *uuid = device.identifierForVendor;//获取设备uuid
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *rst = [NSString stringWithFormat:@"%@#@#%@#@#%@#@#%@",model,type,systemVersion,identifierForVendor];
    //因为有汉字要utf8编码
    NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


    //1.本地保存文件
    //获得本应用程序的沙盒目录
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[array objectAtIndex:0];
    YjqLog(@"path:%@",path);
    NSDictionary *writedict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"ownerId",@"3",@"useTime",self.key,@"key",datestr,@"openTime",self.resultStr,@"result",self.resultReason,@"resultReason",nil];
    YjqLog(@"开门结果%@",writedict);

//    NSString *sandBoxPathFile=[NSString stringWithFormat:@"%@/OpenDoorLog.plist",path];
//
//    //向本应用程序的沙盒目录的Documents文件夹下写入abc.plist
//    [writedict writeToFile:sandBoxPathFile atomically:YES];
//
//    //2.读文件
//    NSDictionary *readDict=[[NSDictionary alloc]initWithContentsOfFile:sandBoxPathFile];
//YjqLog(@"readdict:%@",readDict);

    //3.将字典转换为－nsdata
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:writedict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *string= [NSString stringWithFormat:@"\r\n%@",[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]];
YjqLog(@"string:%@",string);
    /*
     //NSString *string= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     //NSString *string2 = [[NSString alloc] initWithFormat:@"\r\n%@",string];//🍎\r\n给字符串加空行
     */
    //string转nsdata
    NSData* nsData = [string dataUsingEncoding:NSUTF8StringEncoding];
    //4.base64编码
    NSString *encodingStr = [nsData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *encodingStr1 = [encodingStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];//🍎\r\n去掉里边的空行
    NSData *baseData = [encodingStr1 dataUsingEncoding:NSUTF8StringEncoding];
YjqLog(@"baseData = %@",baseData);
    //5.md5校验
    NSString *result = [Common MD5With:encodingStr1];
    result = [result lowercaseString];
YjqLog(@"result:%@",result);

    //🍎AFNetWorking解析数据
    // url编码
    NSString * urlStr = [OpenResult_Url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString * aaa = [NSString stringWithFormat:urlStr,result,rstt];
YjqLog(@"aaa:%@",aaa);

    // 构造request
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aaa] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:baseData];

    // 构造Session
    NSURLSessionConfiguration * sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"api-key"       : @"API_KEY",
                                                   @"Content-Type"  : @"application/json"
                                                   };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            // 网络获取返回字符串
            NSString * receiveStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        YjqLog(@"===== %@",receiveStr);
        } else {
            
        }
    }];
    [task resume];
    
}
//🍎下

@end

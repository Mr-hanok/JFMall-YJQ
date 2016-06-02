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

@interface OpenDoorViewController ()<GattBLEDelegate,UIAlertViewDelegate/*,UIGestureRecognizerDelegate*/>{
    
    //开门属性
    
    NSTimer *timerSearch;
    
    NSMutableArray *bleNameArray;//蓝牙数组
    
    NSMutableArray *FIDArray;//fid数组
    
    iZHC_MoProtocol *moPro;//解析key
    
    int timerCount;
    
    NSString *codeNumber;
    
    
    
    //🍎////////
    
    NSMutableArray *_dataArray;
    
    
    
    //BOOL    authStatus;
    
    NSString *authStatus;
    
    NSDictionary *dict;
    
    NSString *projectName;
    
    NSMutableArray *_projectNameArr;
    
    NSString *datestr;//开始开门时间
    
}



@property (strong,nonatomic) RoadData* roadData;

@property(nonatomic,strong)UIWindow*openAnimationWindow;

@property(strong,nonatomic) GattManager *gattManager;

//🍎上

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openDoorImageWidthConstratint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openDoorImageViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openDoorImageViewToTopConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *openDoorImg;

@property(nonatomic,strong)  IBOutlet UITableView*tableView;

@property(nonatomic,assign)NSInteger pageNum;

@end



@implementation OpenDoorViewController

#pragma mark - 重载方法区

//1初始化数据

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _projectNameArr = [[NSMutableArray alloc] init];
    
    //初始化导航栏信息
    
    self.title = Str_Comm_OpenDoor;
    
    self.hidesBottomBarWhenPushed = NO;
    
    [self becomeFirstResponder];
    
#pragma -mark 开门
    
    // [self openDoor];//开门认证
    
    //点击开门（一个手指头）
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    
    [self.openDoorImg addGestureRecognizer:singleTapGestureRecognizer];
    
    //下拉开门
    
    _pageNum = 1;
    
    // 顶部下拉刷出更多
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        
        [self openDoorMethod];
        
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.header = header;
    
    
    
    //设置按钮的处理
    
    [self setNavBarRightItemTitle:@"设置" andNorBgImgName:nil andPreBgImgName:nil];
    
    UIBarButtonItem*buttonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarRightItemClick)];
    
    self.navigationItem.rightBarButtonItem=buttonItem;
    
    
    
}

//设置按钮事件

- (void)navBarRightItemClick

{
    
    OpenDoorSettingViewController*openDoorSettingVC=[[OpenDoorSettingViewController alloc]init];
    
    [self.navigationController pushViewController:openDoorSettingVC animated:YES];
    
    
    
}

- (void)openDoor

{
    
    //创建BLE搜索对象
    
    
    
#if TARGET_IPHONE_SIMULATOR
    
#else
    
    self.gattManager = [[GattManager alloc] init];
    
#endif
    
    self.gattManager.delegate = self;
    
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
    
    AFHTTPRequestOperationManager  *_manager
    
    =[AFHTTPRequestOperationManager manager];
    
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    
    YjqLog(@"userid:%@",userid);
    
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"ownerId",VersionNumber,@"version",rstt,@"rst", nil];//dic是向服务器上传的参数
    
    YjqLog(@"dic:%@",dic);//输入
    
    [_manager POST:OwnerApprove_Url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        YjqLog(@"%@", error.localizedDescription);
        
    }];
    
    
    
}





//4🍎上

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [timerSearch invalidate];//使搜索无效
    
    timerSearch = nil;
    
}

//2🍎下

#pragma mark - 重载viewWillAppear

-(void)viewWillAppear:(BOOL)animated {
    
    [self openDoor];//开门认证
    
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
    
    
    
    //🍎上
    
    timerCount = 0;
    
    timerSearch = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(searchOpenDoor) userInfo:nil repeats:YES];
    
    [timerSearch setFireDate:[NSDate distantFuture]];
    
    //🍎下
    
}





- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    
    
}

#pragma mark-瑶瑶，点击，下拉调用此方法可执行开门效果

//瑶瑶，点击，下拉调用此方法可执行开门效果

-(void)openDoorMethod

{
    
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
    
    //🍎若已经登陆
    
    if([[LoginConfig Instance] userLogged])
        
    {
        
        /**
         
         * 接口请求成功 且为认证状态
         
         **/
        
        //  &&且  ||与
        
        YjqLog(@"+++++++%@++++++",dict);
        
        if ([dict[@"code"] isEqualToString:@"IOD00000"] ){
            
            if ([authStatus isEqualToString:@"1"]) {
                
                
                
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
                
                [timerSearch setFireDate:[NSDate distantPast]];
                
                [self.tableView.header endRefreshing];
                
            }
            
            /*
             
             用户没权限  [@"您认证的%@项目，无法打开此门",projectName ]
             
             bleName = LLING65264
             
             */
            
            
            
        }
        
        /*
         
         用户未认证
         
         */
        
        else if ([dict[@"code"] isEqualToString:@"IODB0002"])//
            
        {
            
            //声音设置
            
            [self soundSetting];
            
            NSUserDefaults*defaultsAuthen=[NSUserDefaults standardUserDefaults];
            
            NSString*authenStatutring=[defaultsAuthen objectForKey:@"authenStatus"];
            
            if ([authenStatutring isEqualToString:@""]) {
                
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"认证" message:@"只有认证用户才能使用摇一摇功能哦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往认证", nil];
                
                [alert show];
                
                [self.tableView.header endRefreshing];
                
                
                
            }
            
            if ([authenStatutring isEqualToString:@"NO"]) {
                
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"认证中" message:@"物业人员会尽快为您认证，请等待通知哦" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                
                [alert show];
                
                [self.tableView.header endRefreshing];
                
                
                
            }
            
            
            
        }
        
        
        
        /*
         
         接口请求失败导致的开门失败
         
         */
        
        else
            
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您认证的社区还没有开通摇一摇开门功能" delegate:self  cancelButtonTitle:@"3S" otherButtonTitles:nil];
            
            [alert show];
            
            [self.tableView.header endRefreshing];
            
            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
            
        }
        
        
        
    }
    
    else
        
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录哦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"用户登录", nil];
        
        [alert show];
        
        [self.tableView.header endRefreshing];
        
    }
    
}

//点击开门

- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer

{
    
    [self openDoorMethod];
    
}

//摇一摇开门

#pragma mark-开始摇动

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    
    
    [self openDoorMethod];
    
}

#pragma mark - 摇一摇部分代码

- (BOOL)canBecomeFirstResponder {
    
    return YES;
    
}

#pragma -mark 12-12摇一摇添加手机震动功能

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    //声音设置
    
    [self soundSetting];
    
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
    
#pragma -mark 调用等待加载。。。
    
    self.HUD.hidden = NO;
    
    if (!self.hudHidden)
        
    {
        
        [self.HUD show:YES];
        
        [self.view bringSubviewToFront:self.HUD];
        
    }
    
    
    
    timerCount++;
    
    YjqLog(@"timerCount = %d",timerCount);
    
    if (timerCount > 3) {
        
        YjqLog(@"开门失败");
        
        self.HUD.hidden = YES;
        
        
        
        self.openAnimationWindow.hidden=NO;
        
        self.openAnimationWindow=[OpenDoorAnimation showOpenDoorAnimation:[NSString stringWithFormat:@"%d",self.UseTime]andSuccessOrFail:1];
        
        //延迟动画开门的时间之后消失
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.UseTime* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            YjqLog(@"开门失败!请重新摇一摇");
            
            self.openAnimationWindow.hidden=YES;
            
        });
        
        self.resultStr = @"开门失败,连接超时";
        
        self.resultReason = @"连接超时";
        
        //🍎
        
        
        
        [timerSearch setFireDate:[NSDate distantFuture]];
        
        timerCount = 0;
        
        
        
    }else{
        
        //给蓝牙类的蓝牙数组和Fid数组赋值
        
        self.gattManager.gattUserInfoArray = moPro.bleNameArray;
        
        self.gattManager.gattUserFIDArray = moPro.FIDArray;
        
        self.gattManager.gattUserKeyArray = moPro.keyArray;
        
        [self.gattManager setUp];//实例化中心角色
        
        [self.gattManager setFlagDefault];
        
        [self.gattManager scan];
        
        
        
        
        
    }
    
    self.UseTime = timerCount;//开门过程用时
    
    YjqLog(@"%d",self.UseTime);//1
    
    
    
}



//四种开门结果

#pragma mark - GattBLE Delegate

-(void)getBleSearchAnswer:(int)result resultString:(NSString *)str26



{
    
#pragma -mark 调用等待加载。。。
    
    self.HUD.hidden = NO;
    
    if (!self.hudHidden)
        
    {
        
        [self.HUD show:YES];
        
        [self.view bringSubviewToFront:self.HUD];
        
    }
    
    
    
    timerCount = 0;
    
    [timerSearch setFireDate:[NSDate distantFuture]];
    
    switch (result) {
            
            
            
        case 0:
            
        {
            
            self.HUD.hidden = YES;
            
            YjqLog(@"开门成功");
            
#pragma mark-开门动画
            
            self.openAnimationWindow.hidden=NO;
            
            self.openAnimationWindow=[OpenDoorAnimation showOpenDoorAnimation:[NSString stringWithFormat:@"%d",self.UseTime]andSuccessOrFail:0];
            
            //延迟动画开门的时间之后消失
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.UseTime* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                YjqLog(@"开门成功");
                
                self.openAnimationWindow.hidden=YES;
                
            });
            
            self.resultStr = @"开门成功";
            
            self.resultReason = @"开门成功";
            
            break;
            
        }
            
        case 2:
            
        {
            
            //            self.HUD.hidden = YES;
            
            //            if (moPro.bleNameArray == nil) {
            
            //                self.openAnimationWindow.hidden=NO;
            
            //                self.openAnimationWindow=[OpenDoorAnimation showOpenDoorAnimation:[NSString stringWithFormat:@"%d",self.UseTime]andSuccessOrFail:1];
            
            //                //延迟动画开门的时间之后消失
            
            //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.UseTime* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //                    YjqLog(@"开门失败!请重新摇一摇");
            
            //                    self.openAnimationWindow.hidden=YES;
            
            //                });
            
            //                self.resultStr = @"开门失败";
            
            //                self.resultReason = @"no reason";
            
            //            }
            
            //            else
            
            //            {
            
#pragma -mark 11-22添加无权限提示
            
            NSString *mutbalestr = [_projectNameArr componentsJoinedByString:@"项目,"];//将可变数组中元素已‘项目,’隔开，连成字符串
            
            YjqLog(@"mutbalestr:%@",mutbalestr);
            
            NSString *message = [NSString stringWithFormat:@"您认证的%@无法打开此门1",mutbalestr];
            
            YjqLog(@"message:%@",message);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil  cancelButtonTitle:@"3S" otherButtonTitles:nil];
            
            [alert show];
            
            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];//3m后消失
            
            self.resultStr = @"开门失败,无权限";
            
            self.resultReason = @"无权限";
            
            
            
            //            }
            
            
            
            break;
            
        }
            
        case 3://开门失败，无权限
            
        {
            
            self.HUD.hidden = YES;
            
            YjqLog(@"开门失败,命令错误");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开门失败,命令错误" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            
            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
            
            [alert show];
            
            self.resultStr = @"开门失败,命令错误";
            
            self.resultReason = @"命令错误";
            
            break;
            
        }
            
        case 9://系统提示
            
        {
            
            self.HUD.hidden = YES;
            
            YjqLog(@"请检测蓝牙正常再重试");
            
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请打开蓝牙功能才能开门哦!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            
            //            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
            
            //            [alert show];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检测蓝牙正常再重试" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            
            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
            
            self.resultStr = @"开门失败,请检测蓝牙正常再重试";
            
            self.resultReason = @"请检测蓝牙正常再重试";
            
            break;
            
        }
            
        default:
            
        {
            
            self.HUD.hidden = YES;
            
            /*
             
             if (moPro.bleNameArray == nil) {
             
             self.openAnimationWindow.hidden=NO;
             
             self.openAnimationWindow=[OpenDoorAnimation showOpenDoorAnimation:[NSString stringWithFormat:@"%d",self.UseTime]andSuccessOrFail:1];
             
             //延迟动画开门的时间之后消失
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.UseTime* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             
             YjqLog(@"开门失败!请重新摇一摇");
             
             self.openAnimationWindow.hidden=YES;
             
             });
             
             self.resultStr = @"开门失败";
             
             self.resultReason = @"no reason";
             
             }
             
             else
             
             {
             
             #pragma -mark 11-22添加无权限提示
             
             NSString *mutbalestr = [_projectNameArr componentsJoinedByString:@"项目,"];//将可变数组中元素已‘项目,’隔开，连成字符串
             
             YjqLog(@"mutbalestr:%@",mutbalestr);
             
             NSString *message = [NSString stringWithFormat:@"您认证的%@无法打开此门2",mutbalestr];
             
             YjqLog(@"message:%@",message);
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil  cancelButtonTitle:@"3S" otherButtonTitles:nil];
             
             [alert show];
             
             [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];//3m后消失
             
             self.resultStr = @"开门失败,无权限";
             
             self.resultReason = @"无权限";
             
             
             
             }
             
             */
            
            YjqLog(@"连接失败,请靠近门重试");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败,请靠近点哦！" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            
            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
            
            self.resultStr = @"连接失败,请靠近门重试";
            
            self.resultReason = @"距离门太远";
            
            [alert show];
            
        }
            
    }
    
    
    
    if(self.gattManager)
        
        [self.gattManager setFlagDefault];
    
    
    
    self.UseTime = timerCount;
    
    //🍎获取key
    
    [self.gattManager getOpenKey];
    
    self.key = [NSString stringWithFormat:@"%@",[self.gattManager getOpenKey]];
    
    //YjqLog(@"key:%@",self.key);
    
    
    
    [self openDoorResult];//上传开门数据
    
    
    
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
    
    //因为有汉子要utf8编码
    
    NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    
    //1.本地保存文件
    
    //获得本应用程序的沙盒目录
    
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path=[array objectAtIndex:0];
    
    YjqLog(@"path:%@",path);
    
    NSDictionary *writedict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"ownerId",@"3",@"useTime",self.key,@"key",datestr,@"openTime",self.resultStr,@"result",self.resultReason,@"resultReason",rstt,@"rst",nil];
    
    
    
    NSString *sandBoxPathFile=[NSString stringWithFormat:@"%@/OpenDoorLog.plist",path];
    
    //向本应用程序的沙盒目录的Documents文件夹下写入abc.plist
    
    [writedict writeToFile:sandBoxPathFile atomically:YES];
    
    
    
    //2.读文件
    
    NSDictionary *readDict=[[NSDictionary alloc]initWithContentsOfFile:sandBoxPathFile];
    
    YjqLog(@"readdict:%@",readDict);
    
    
    
    //3.将字典转换为－nsdata
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:readDict options:NSJSONWritingPrettyPrinted error:&parseError];
    
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
    
    NSString * aaa = [NSString stringWithFormat:urlStr,result];
    
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


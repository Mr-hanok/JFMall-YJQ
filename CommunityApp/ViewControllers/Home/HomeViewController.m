//
//  HomeViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "DoorToDoorServiceViewController.h"
#import "HomeViewController.h"
#import "BlankCollectionViewCell.h"
#import "CommunityServiceCollectionViewCell.h"
#import "CommunityMessageCollectionViewCell.H"//2016.02.22
#import "ConvenienceServiceCollectionViewCell.h"
#import "ConvenienceDefaultCollectionViewCell.h"
#import "StoreCollectionViewCell.h"
#import "GroupBuyCollectionViewCell.h"
#import "FirstHeaderView.h"
#import "FirstFooterView.h"
#import "CommonFooterView.h"
#import "CommonHeaderView.h"
#import "StoreListViewController.h"
#import "MoreServicesViewController.h"
#import "SurroundBusinessViewController.h"
#import "BusinessDetailViewController.h"
#import "PropertyBillViewController.h"
#import "PropertyBillWebViewController.h"//新物业缴费
#import "CategorySelectedViewController.h"
#import "UserfulTelNoListViewController.h"
#import "WaresListViewController.h"
#import "WaresDetailViewController.h"
#import "QuestionnaireSurveyViewController.h"
#import "NearShopViewController.h"
#import "DetailServiceViewController.h"
#import "UserfulTelNoListViewController.h"
#import "SelectNeighborhoodViewController.h"
#import "GYZChooseCityController.h"/////////////定位选择小区
#import "ServiceList.h"
#import "WaresList.h"
#import "CartBottomBar.h"
#import "DBOperation.h"
#import "VisitorPassportViewController.h"
#import "HousesServicesHouseAgencyViewController.h"
#import "BuildingsServicesBuildingShowViewController.h"
#import "MJRefresh.h"
//限时抢
#import "LimitBuyViewController.h"
#import "LoginConfig.h"
#import "GrouponListViewController.h"
#import "AdImgSlideInfo.h"
#import "BenefitPeopleCollectionViewCell.h"
#import "EasyLiveCollectionViewCell.h"
#import "MessageViewController.h"
#import "MessageDetailViewController.h"//消息内容
#import "GoodsListViewController.h"
#import "FleaMarketListViewController.h"
#import "GrouponDetailViewController.h"
#import "WebViewController.h"
//我加🍎
#import "BaseViewController.h"
#import "Common.h"
//代码控制约束
#import <Masonry/Masonry.h>
//店铺商品列表
#import "GoodsForSaleViewController.h"

//🍎下
#import "GattManager.h"//蓝牙类
#import <CoreBluetooth/CoreBluetooth.h>
#import "iZHC_MoProtocol.h"//解析key
#import "RoadData.h"
#import "RoadAddressManageViewController.h"
//🍎业主
#import "LoginConfig.h"
#import "Interface.h"
//projectID
#import "ShopCartModel.h"
#import "AppDelegate.h"

//base64+md5
#import "base64.h"
#import "Common.h"
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
//手机震动
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#define pageSize (10)

#import <AFNetworking.h>
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
//开门动画设计头文件
#import "OpenDoorAnimation.h"
#import "SurveyAndVoteViewController.h"

//导航栏右侧消息提醒（解XML）
#import "GDataXMLNode.h"

//访客通行－－添加新访客页
#import "NewVieitorViewController.h"
#import "FKAlertView.h"

//物业通知＝＝＝2016.02.22
#import "MessageModel.h"

#pragma mark - 宏定义区
// Cell Nib文件名定义
#define CommunityServiceCollectionCellNibName       @"CommunityServiceCollectionViewCell"
#define CommunityMessageCollectionViewCellNibName   @"CommunityMessageCollectionViewCell" //物业通知 2016.02.22
#define BlankCollectionViewCellNibName              @"BlankCollectionViewCell"
#define BenefitPeopleCollectionViewCellNibName      @"BenefitPeopleCollectionViewCell"
#define EasyLiveCollectionViewCellNibName           @"EasyLiveCollectionViewCell"


// CollectionReusableView
#define FirstHeaderViewNibName          @"FirstHeaderView"
#define FirstFooterViewNibName          @"FirstFooterView"
#define CommonHeaderViewNibName         @"CommonHeaderView"
#define CommonFooterViewNibName         @"CommonFooterView"

#define UserDefaultKeyUpdateTip         @"UserDefaultKeyUpdateTip"
#define UpdateAlertTagNeed              110
#define UpdateAlertTagNoNeed            111

#pragma mark - 枚举类型定义区
// CollectionView SectionID定义
typedef enum E_SectionID
{
    E_Section_CommunityService,     // 首页轮播图Section
    E_Section_CommunityMessage,     // 物业通知Section＝＝＝＝2016.02.22
    E_Section_CommunityService1,    //物业服务Section
    E_Section_BenefitPeopleArea,    // 惠民专区Section
    E_Section_EasyLive,             // 吃喝玩乐Section
    E_Section_End
}eSectionID;


#pragma mark - 接口属性定义区
@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, SelectNeighborhoodDelegate,GattBLEDelegate,UIAlertViewDelegate>
{
    //  物业通知
    NSMutableArray *dataSourceArray;
    NSMutableArray *titleDatas;
    NSMutableArray *typeDatas;
    NSMutableArray *typeArray;
    NSMutableArray *titleArray;



    UIView *giveTokenview;//发劵弹出view
    UIImageView *imageview;//发劵弹出对话框

    AppDelegate *myDelegate;
    //开门属性
    //新
    NSString *codeNumber;
    NSMutableArray *bleNameArray;//蓝牙数组
    NSMutableArray *FIDArray;//fid数组
    iZHC_MoProtocol *moPro;//解析key

    //🍎////////
    NSMutableArray *_dataArray;

    NSString *authStatus;
    NSDictionary *dict;
    NSString *projectName;
    NSMutableArray *_projectNameArr;

    NSDictionary *YorNdict;
    NSDictionary *giveTokendict;
    NSDictionary *bodyDict;
    NSString *sellerIdsStr;
    NSString *sellerNamesStr;
    NSString *datestr;//开始开门时间
    NSString *endOpenDoorStr;//结束时间

    GDataXMLDocument *_gdXML;
    NSString * messageCountStr;

    NSArray *startArr;
    NSArray *endArr;
    CGRect rect;
    FKAlertView *alertView;


}
@property (nonatomic ,strong)CommunityMessageCollectionViewCell *cell;
@property (nonatomic, strong) NSTimer *timer;
@property (strong,nonatomic) RoadData* roadData;
@property(nonatomic,strong)UIWindow*openAnimationWindow;
@property(strong,nonatomic) GattManager *gattManager;
@property (nonatomic, assign) BOOL isWillClick;
//🍎上

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (retain, nonatomic) IBOutlet UIView*           navRightView;
@property (retain, nonatomic) IBOutlet UIButton*         navRightNumView;

// 广告图片数据数组
@property (nonatomic, retain) NSMutableArray    *adImgArray;
@property (nonatomic, retain) NSMutableArray    *slideInfoArray;


// 物业服务数据数组
@property (nonatomic, retain) NSArray           *communityServiceItemArray;

//物业通知数据数组＝＝＝2016.02.22
@property(nonatomic,strong)NSMutableArray*dataSourceArray;//消息列表存储数据的数组
@property (nonatomic,strong)NSMutableArray      *datas;
@property (nonatomic, retain) NSMutableArray    *typeArray;//消息类型：系统，物业
@property (nonatomic, retain) NSMutableArray    *titleArray;//消息title

// 吃喝玩乐商家数据数组
@property (nonatomic, retain) NSMutableArray    *easyLiveDataArray;

// 首页动态替换内容数据数组
@property (nonatomic, retain) NSMutableArray    *replaceContentArray;
@property (nonatomic, retain) AdImgSlideInfo    *grouponReplaceContent;
@property (nonatomic, retain) AdImgSlideInfo    *limitBuyReplaceContent;
@property (nonatomic, retain) NSMutableArray    *houseKeepReplaceArray;
@property (nonatomic, retain) NSMutableArray    *doorToDoorReplaceArray;

@property (retain, nonatomic) CartBottomBar     *carBar;        //购物车Bar(编辑/完成)状态不同，内容不同


@end

@implementation HomeViewController

#pragma mark - 视图装载
- (void)viewDidLoad {
    [super viewDidLoad];


    dataSourceArray = [[NSMutableArray alloc] init];
    titleDatas = [[NSMutableArray alloc] init];
    typeDatas = [[NSMutableArray alloc] init];
    typeArray = [[NSMutableArray alloc] init];
    titleArray = [[NSMutableArray alloc] init];


    //自定义alertview位置大小
    rect = CGRectMake(self.view.frame.size.width/6, self.view.frame.size.height/10, CGRectGetWidth(self.view.frame) * 0.8, CGRectGetHeight(self.view.frame) * 0.4);

#pragma -mark 11-15

    startArr = [[NSMutableArray alloc] init];
    endArr = [[NSMutableArray alloc] init];

    _dataArray = [[NSMutableArray alloc] init];
    _projectNameArr = [[NSMutableArray alloc] init];

    // 初始化导航栏
    self.title = Str_Comm_Home;
    self.projectName = Str_Comm_Home;
    self.strNavBarBgImg = Img_Comm_NavBackground;

    //设置导航栏默认背景色
    //    self.navRightView.userInteractionEnabled=NO;
    self.navRightView.frame = Rect_LimitBuy_NavBarRightItem;
    [self setNavBarItemRightView:self.navRightView];
#ifdef APP_DEBUG
    [self setNavBarItemRightViewForNorImg:Img_Home_NavMailNor andPreImg:Img_Home_NavMailPre];
#endif
    [self setNavBarItemLeftViewForNorImg:Img_Home_NavLogo andPreImg:Img_Home_NavLogo];

    // 初始化基本数据
    [self initBasicDataInfo];

    // 注册CollectionView的CellNib
    [self registNibForCollectionVew];

    _collectionViewHeight.constant = Screen_Height - BottomBar_Height - Navigation_Bar_Height;

    self.hidesBottomBarWhenPushed = NO;    // Push的时候隐藏TabBar

    self.carBar = [CartBottomBar instanceCartBottomBar];
    //    self.carBar.totalCount = 6;

    // 添加下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getSlideListDataFromService];             // 获取广告图片
        [self getMessageListDataFromService];           //获取物业通知列表＝＝＝2016.02.22
        [self getEasyLiveDataFromServer];               // 获取吃喝玩乐数据
        [self getReplaceContentFromServer];             // 获取替换内容数据
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;

    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.projectId = [userDefault objectForKey:KEY_PROJECTID];

    self.projectName = [userDefault objectForKey:KEY_PROJECTNAME];

    [self getSlideListDataFromService];             // 获取广告图片
    [self getMessageListDataFromService];           //获取物业通知列表＝＝＝2016.02.22
    [self getEasyLiveDataFromServer];               // 获取吃喝玩乐数据
    [self getReplaceContentFromServer];             // 获取替换内容数据
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageCountUnread) name:MSG_RECIVENEWMESSAGE_NOTICE object:nil];

    //创建BLE搜索对象

#if TARGET_IPHONE_SIMULATOR
#else
    self.gattManager = [[GattManager alloc] init];
#endif
    self.gattManager.delegate = self;


    /*
     11月12日app装机送代金劵暂时屏蔽
     */
    
    
    [self checkVersion];

 }

- (void)checkVersion {
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    if (localVersion.length <= 0) {
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    [self getArrayFromServer:VersionInfo_Url path:VersionInfo_Path method:@"GET" parameters:@{@"flag":@"9"} xmlParentNode:@"list" success:^(NSMutableArray *result) {
        if (result && result.count > 0) {
            NSDictionary *dic = result[0];
            NSString *description = dic[@"description"];
            // xml解析时会把\n转为\\n
            description = [description stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            
            NSString *isUpdate = dic[@"isUpdate"];
            NSString *version = dic[@"version"];
            if (version.length > 0) {
                if ([localVersion compare:version] == NSOrderedAscending) {
                    // 提示升级
                    [weakSelf showUpdateAlert:description isNeedUpdate:[isUpdate isEqualToString:@"1"]];
                }
            }
        }
    } failure:nil];
}

- (void)showUpdateAlert:(NSString *)message isNeedUpdate:(BOOL)isNeedUpdate {
    // 提示升级
    UIAlertView *alert = [UIAlertView alloc];
    if (isNeedUpdate) {
        // 强制升级
        alert.tag = UpdateAlertTagNeed;
        alert = [alert initWithTitle:@"发现新版本，需要立即更新！" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        // 可选升级
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDate *lastDate = [userDefaults objectForKey:UserDefaultKeyUpdateTip];
        if (lastDate) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                                       fromDate:lastDate
                                                         toDate:[NSDate date]
                                                        options:0];
            if ([components day] <= 0) {
                return;
            }
        }
        
        alert.tag = UpdateAlertTagNoNeed;
        alert = [alert initWithTitle:@"发现新版本，是否需要更新？" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

- (void)gotoAppstore {
    NSString *str = [NSString stringWithFormat:@"itms://itunes.apple.com/cn/app/yi-jie-qu/id1048321627?mt=8"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//开门
- (void)openDoor
{
    //    //创建BLE搜索对象
    //
    //#if TARGET_IPHONE_SIMULATOR
    //#else
    //    self.gattManager = [[GattManager alloc] init];
    //#endif
    //    self.gattManager.delegate = self;
    ////新
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BLEmonitor:) name:@"BLENotification" object:nil];

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

#pragma -mark 11月12日app装机送代金劵暂时屏蔽
//判断是否发劵
- (void)GivetokenYESorNO
{
    AFHTTPSessionManager  *_manager
    =[AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];

    /*
     获取用户ID
     */
    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    NSLog(@"userid:%@",userid);
    /*
     // *获取用户当前所在小区的项目ID
     // */
    //    ShopCartModel *projectmodel = [[DBOperation Instance] selectLatestDataFromCart];
    //    NSLog(@"projectID:%@",projectmodel.projectId);
    /*
     上传设备信息
     */
    UIDevice *device = [UIDevice currentDevice];
    // NSString *name = device.name;       //获取设备所有者的名称
    NSString *model = device.model;      //获取设备的类别
    NSString *type = device.localizedModel; //获取本地化版本
    // NSString *systemName = device.systemName;   //获取当前运行的系统
    NSString *systemVersion = device.systemVersion;//获取当前系统的版
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *rst = [NSString stringWithFormat:@"%@#@#%@#@#%@#@#%@",model,type,systemVersion,identifierForVendor];
    //因为有汉子要utf8编码
    NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"ownerId",self.projectId,@"projectId",@"40",@"appType",VersionNumber,@"version",rstt,@"rst", nil];//dic是向服务器上传的参数
    NSLog(@"dic:%@",dic);

    [_manager POST:GivetokenYESorNO_URL parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {


        //解析数据
        YorNdict=[NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"YorNdict:%@",YorNdict);
        /**
         * 接口请求成功---Success("成功", 0, "操作成功"),
         */
        NSString *codeStr = [NSString stringWithFormat:@"%@",YorNdict[@"code"]];
        NSLog(@"codeStr:%@",codeStr);
        YjqLog(@"description:%@",YorNdict[@"description"]);
        YjqLog(@"title:%@",YorNdict[@"title"]);
        if ([codeStr isEqualToString:@"0"]) {

            NSLog(@"dict:%@",YorNdict);
            /**
             *CanSendCoupon("可以发券", 10, "用户<%s>经验证可以执行发券"),
             */
            NSString *subcodeStr = [NSString stringWithFormat:@"%@",YorNdict[@"subCode"]];
            NSLog(@"subcodeStr:%@",subcodeStr);
            if ([subcodeStr isEqualToString:@"10"]) {
                NSLog(@"可以发卷");
                //发放现金劵－－－调用]发劵方法
                [self giveToken];

            }

            else if ([YorNdict[@"subcode"] isEqualToString:@"100"])
            {

            }
            else if ([YorNdict[@"subcode"] isEqualToString:@"110"])
            {

            }
            else if ([YorNdict[@"subcode"] isEqualToString:@"120"])
            {

            }
            else if ([YorNdict[@"subcode"] isEqualToString:@"130"])
            {

            }
            else if ([YorNdict[@"subcode"] isEqualToString:@"140"])
            {

            }
            else if ([YorNdict[@"subcode"] isEqualToString:@"1000"])
            {

            }
            else if ([YorNdict[@"subcode"] isEqualToString:@"1100"])
            {

            }
            else if ([YorNdict[@"subcode"] isEqualToString:@"1110"])
            {

            }

            else if ([YorNdict[@"subcode"] isEqualToString:@"1200"])
            {

            }

            else if ([YorNdict[@"subcode"] isEqualToString:@"1210"])
            {

            }

            else if ([YorNdict[@"subcode"] isEqualToString:@"1220"])
            {

            }

            else if ([YorNdict[@"subcode"] isEqualToString:@"1230"])
            {

            }

        }
        /**
         * Failure("失败", 100, "操作失败"),
         */
        else if ([codeStr isEqualToString:@"100"])
        {
            NSLog(@"操作失败");
        }
        /**
         * Unknown("未知错误", 200, "未知错误:%s")
         */
        else if ([codeStr isEqualToString:@"200"])
        {
            NSLog(@"未知错误");
        }


    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];

}
//发放现金劵
- (void)giveToken
{
    AFHTTPSessionManager  *_manager
    =[AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];

    /*
     获取用户ID
     */
    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    NSLog(@"userid:%@",userid);
    /*
     *获取用户当前所在小区的项目ID
     */
    /*
     上传设备信息
     */
    UIDevice *device = [UIDevice currentDevice];
    // NSString *name = device.name;       //获取设备所有者的名称
    NSString *model = device.model;      //获取设备的类别
    NSString *type = device.localizedModel; //获取本地化版本
    // NSString *systemName = device.systemName;   //获取当前运行的系统
    NSString *systemVersion = device.systemVersion;//获取当前系统的版
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *rst = [NSString stringWithFormat:@"%@#@#%@#@#%@#@#%@",model,type,systemVersion,identifierForVendor];
    //因为有汉子要utf8编码
    NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:  userid,@"ownerId",self.projectId,@"projectId",@"40",@"appType",VersionNumber,@"version",rstt,@"rst", nil];//dic是向服务器上传的参数
    NSLog(@"dic:%@",dic);


    [_manager POST:Givetoken_URL parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {


        //解析数据
        giveTokendict=[NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"YorNdict:%@",giveTokendict);
        /**
         * 接口请求成功---是否发劵Success("成功", 0, "操作成功"),
         */
        NSString *codeStr = [NSString stringWithFormat:@"%@",giveTokendict[@"code"]];
        NSLog(@"codeStr:%@",codeStr);
        bodyDict = giveTokendict[@"body"];
        if (![bodyDict isEqual:nil]) {
            sellerNamesStr = bodyDict[@"actionSellerFullname"];
        }
        else
        {
            sellerNamesStr = @"";
        }
        if ([codeStr isEqualToString:@"0"]) {

            NSLog(@"dict:%@",giveTokendict);
            /**
             *Success("发券成功", 0, "用户首次登录APP，已成功发放现金券"),
             */
            NSString *subcodeStr = [NSString stringWithFormat:@"%@",giveTokendict[@"subCode"]];
            NSLog(@"subcodeStr:%@",subcodeStr);
            if ([subcodeStr isEqualToString:@"0"]) {
                //发放现金劵成功弹出发放成功画面
//                NSLog(@"发放代金劵成功");

                [self giveTokenviewUI];
                //
            }

        }
        /**
         * Failure("失败", 100, "操作失败"),
         */
        else if ([dict[@"code"] isEqualToString:@"100"])
        {
            NSLog(@"操作失败");
        }
        /**
         * Unknown("未知错误", 200, "未知错误:%s")
         */
        else if ([dict[@"code"] isEqualToString:@"200"])
        {
            NSLog(@"未知错误");
        }


    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];

}
//弹出送代金劵界面
- (void)giveTokenviewUI
{
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];


    giveTokenview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,myDelegate.window.frame.size.width, myDelegate.window.frame.size.height)];
    giveTokenview.backgroundColor = [UIColor grayColor];
    giveTokenview.backgroundColor = [UIColor colorWithRed:246/255 green:246/2255 blue:246/255 alpha:0.4];


    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(myDelegate.window.frame.size.width/2-150, self.view.frame.size.height/2-150, 300, 300)];
    imageview.userInteractionEnabled = YES;//交互
    imageview.alpha = 1;
    imageview.image = [UIImage imageNamed:@"cashcoupona_bg.png"];
    [giveTokenview addSubview:imageview];

    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageview.frame.size.width-32, 1, 24, 24)];
    [cancelBtn setImage:[UIImage imageNamed:@"cashcoupona_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:cancelBtn];

    UIButton *useBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageview.frame.size.width/2-45, imageview.frame.size.height-28, 90, 25)];
    [useBtn setImage:[UIImage imageNamed:@"cashcoupona_user"] forState:UIControlStateNormal];
    [useBtn addTarget:self action:@selector(useBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:useBtn];

    [myDelegate.window addSubview:giveTokenview];
    _isWillClick = NO;
}
- (void)closeBtn:(UIButton *)closebtn
{
    _isWillClick = YES;
    giveTokenview.hidden = YES;
}
- (void)useBtn:(UIButton *)usebtn
{
    _isWillClick = YES;
    giveTokenview.hidden = YES;
//进入对应店铺
    GoodsForSaleViewController *vc = [[GoodsForSaleViewController alloc] init];
    vc.sellerName = sellerNamesStr;
//    vc.sellerId = sellerIdsStr;
    vc.moduleType = @"7";
    [self.navigationController pushViewController:vc animated:YES];





}
//🍎上
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];//关闭通知
    [alertView removeFromSuperview];
}
//🍎下

// 重载viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [self GivetokenYESorNO];//判断是否发放代金劵
    [self getMessageListDataFromService];
    [self openDoor];
    //新
    _isWillClick = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BLEmonitor:) name:@"BLENotification" object:nil];//打开通知

    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.frame = CGRectMake(0, Screen_Height-BottomBar_Height, Screen_Width, BottomBar_Height);


    self.strNavBarBgImg = Img_Comm_NavBackground;           //设置导航栏默认背景色

    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSString *projectName = [userDefault objectForKey:KEY_PROJECTNAME];
    if (![self.projectId isEqualToString:projectId]) {
        self.projectId = projectId;
        self.projectName = projectName;

        [self getSlideListDataFromService];        // 获取广告图片
        [self getEasyLiveDataFromServer];          // 获取吃喝玩乐数据
        [self getReplaceContentFromServer];        // 获取替换内容数据
        [self downLoadCartInfoFromServer];         // 更新购物车
    }

    // 自定义UI TitleView
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 0, Screen_Width-100, 44);
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [titleBtn setTitle:self.projectName forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"WhiteDownArrowImg"] forState:UIControlStateNormal];
    CGFloat width = [Common labelDemandWidthWithText:self.projectName font:[UIFont boldSystemFontOfSize:20.0] size:CGSizeMake(Screen_Width-100, 20.0)];
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (Screen_Width-100+width)/2+2, 0, 0)];
    //我改
    //设置省略号在后边
    [titleBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    //[titleBtn.titleLabel setFrame:CGRectMake(0, 0, Screen_Width-200, 40)];
    //设置titlelable的frame对其没影响
    [titleBtn addTarget:self action:@selector(selectProject) forControlEvents:UIControlEventTouchUpInside];
    //我改
    UIView *navview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-100, 44)];
    [navview addSubview:titleBtn];

    self.navigationItem.titleView = navview;
    // self.navigationItem.titleView = titleBtn;

    //首页导航栏右边‘物业通知’小信封和红点（有物业通知时）
//    [self updateMessageCountUnread];
#pragma -mark 11-13注释掉管家的消息推送

    //        UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
    //        if (self.carBar.totalCount > 0) {
    //            tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)self.carBar.totalCount];
    //        }
    //        else {
    //            tabBarItem.badgeValue = nil;
    //        }

    //🍎旧上
    //    timerCount = 0;
    //
    //    timerSearch = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(searchOpenDoor) userInfo:nil repeats:YES];
    //    [timerSearch setFireDate:[NSDate distantFuture]];
    //    //🍎下
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    NSNotification *notification = [NSNotification notificationWithName:ClearTimerNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma -mark 12-05首页导航栏右边‘物业通知’小信封和红点（有物业通知时）
//- (void)updateMessageCountUnread
//{
//    //    //12-05 通过解析XML 获取消息个数
//    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key];//用户ID
//    NSString *urlStr = [NSString stringWithFormat:@"%@rest/goodsModuleInfo/messageCount?projectId=%@&userId=%@&toModule=1",Service_Address,self.projectId,userId];
//    YjqLog(@"++++%@",urlStr);
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
//    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];
//    NSArray *array = [document nodesForXPath:@"/list" error:nil];
//    for (GDataXMLElement *list in array)
//    {
//        for (int i=0; i<array.count; i++) {
//            GDataXMLElement *messageCount = [list elementsForName:@"messageCount"][0];
//            messageCountStr= [messageCount stringValue];
//            YjqLog(@"%@",messageCountStr);
//        }
//    }
//    if (messageCountStr == nil || messageCountStr == NULL || [messageCountStr intValue]<=0) {
//        [self.navRightNumView setHidden:YES];//不显示
//        YjqLog(@"不显示");
//    } else {
//        [self.navRightNumView setTitle:@"" forState:UIControlStateNormal];//不显示数字
//        [self.navRightNumView setHidden:NO];//显示红点,
//        YjqLog(@"显示红点");
//    }
//}

#pragma mark - 从服务器上更新购物车信息到本地
- (void)downLoadCartInfoFromServer
{
    //    return;
    NSString *userId = [[LoginConfig Instance] userID];

    //初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[userId] forKeys:@[@"userId"]];

    [self getArrayFromServer:ShopCartSync_Url path:ShopCartSyncDownLoad_Path method:@"GET" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result0) {
        [[DBOperation Instance] deleteCartAllData];
        for (NSDictionary *dic in result0) {
            ShopCartModel *model = [[ShopCartModel alloc] initWithDictionary:dic];
            [[DBOperation Instance] syncWaresDataFromServer:model];
        }
        self.carBar.totalCount = [[DBOperation Instance] getTotalWaresAndServicesCountInCart];
    } failure:^(NSError *error) {
        NSLog(@"更新购物车失败");
    }];
}



#pragma mark - CollectionDataSource代理
// 设计该CollectionView的Section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger num = 4;//2016.02.22加1

    // 吃喝玩乐
    if (self.easyLiveDataArray.count > 0) {
        num++;
    }

    return num;
}

// 设计每个section的Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger   itemNums = 0;

    switch (section) {
            // 物业服务
        case E_Section_CommunityService:
//            itemNums = self.communityServiceItemArray.count;
            itemNums = 0;
            break;
            // 物业通知====2016.02.22
        case E_Section_CommunityMessage:
            itemNums = 1;
            break;
            //物业服务
        case E_Section_CommunityService1:
            itemNums = self.communityServiceItemArray.count;
            break;
            // 惠民专区
        case E_Section_BenefitPeopleArea:
            itemNums = 1;
            break;
            // 吃喝玩乐
        case E_Section_EasyLive:
        {
            itemNums = self.easyLiveDataArray.count;
        }
            break;
        default:
            break;
    }

    return itemNums;
}


// 加载CollectionViewCell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            // 物业服务
        case E_Section_CommunityService:
        {
//            CommunityServiceCollectionViewCell *cell = (CommunityServiceCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CommunityServiceCollectionCellNibName forIndexPath:indexPath];
//
//            [cell loadCellData: [self.communityServiceItemArray objectAtIndex:indexPath.row]];
//            return cell;
        }
            break;
                //物业通知＝＝＝2016.02.22
        case E_Section_CommunityMessage:
        {
            //放scrollview
            CommunityMessageCollectionViewCell *cell = [[CommunityMessageCollectionViewCell alloc]init];

            cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"CommunityMessageCollectionViewCell"
                                                             forIndexPath:indexPath];
             [self HeaderSetionData:cell];
            self.cell = cell;
            return cell;
        }
            break;
            // 物业服务
        case E_Section_CommunityService1:
        {
            CommunityServiceCollectionViewCell *cell = (CommunityServiceCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CommunityServiceCollectionCellNibName forIndexPath:indexPath];

            [cell loadCellData: [self.communityServiceItemArray objectAtIndex:indexPath.row]];

            return cell;
        }
            break;
            // 惠民专区
        case E_Section_BenefitPeopleArea:
        {
            BenefitPeopleCollectionViewCell *cell = (BenefitPeopleCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:BenefitPeopleCollectionViewCellNibName forIndexPath:indexPath];
            if (self.easyLiveDataArray.count > 0) {
                [cell.bottomLine setHidden:YES];
            }else {
                [cell.bottomLine setHidden:NO];
            }

            [cell loadCellDataForGroupon:_grouponReplaceContent andLimitBuy:_limitBuyReplaceContent];

            [cell setSelectFunctionAreaBlock:^(NSInteger tag) {
                switch (tag) {
                        // 惠民专区
                    case BTN_TAG_BENEFIT:
                    {
                        GoodsListViewController *vc = [[GoodsListViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        // 团购
                    case BTN_TAG_GROUPBUY:
                    {
                        NSLog(@"123");
                        //                        if (_grouponReplaceContent && _grouponReplaceContent.url) {
                        //                            WebViewController *vc = [[WebViewController alloc] init];
                        //                            vc.url = [NSString stringWithFormat:@"http://%@",_grouponReplaceContent.url];
                        //                            vc.navTitle = Str_Comm_WebPage;
                        //                            [self.navigationController pushViewController:vc animated:YES];
                        //                        }else {
                        //                            GrouponListViewController *vc = [[GrouponListViewController alloc] init];
                        //                            [self.navigationController pushViewController:vc
                        //                                                                 animated:YES];
                        //                        }

                        //我改
                        //                        WebViewController *vc = [[WebViewController alloc] init];
                        //                        // 网页视图
                        //                        //UIWebView *webView = [[UIWebView alloc] init];
                        //                        vc.navTitle = @"e袋洗";
                        //                        [self.navigationController pushViewController:vc animated:YES];
                        //                        vc.url = [NSString stringWithFormat:@"http://wx.rongchain.com/mobile.php?m=wap&act=homepage&do=index&mark=77a5a3a1-5764-11e5-ade6-f80f41fd4734&ref_code=d4997a3902fbc413800ca3770668e74b"];

#pragma -mark 11-15首页亿想不到的生活上线临时修改
                        WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
                        vc.waresId = @"213";
                        vc.efromType = E_FromViewType_WareList;
                        [self.navigationController pushViewController:vc animated:YES];

                    }
                        break;
                        // 跳蚤市场－－>合作伙伴
                    case BTN_TAG_FLEAMARKET:
                    {
                        FleaMarketListViewController *vc = [[FleaMarketListViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];

                        //                        //我改
                        //                        WebViewController *vc = [[WebViewController alloc] init];
                        //                        vc.navTitle = @"合作伙伴";
                        //                        [self.navigationController pushViewController:vc animated:YES];
                        //                        vc.url = [NSString stringWithFormat:@"http://mp.weixin.qq.com/s?__biz=MzA3Nzc1NTY4Mg==&mid=209086095&idx=1&sn=8371d8cc1851bcdd7ec49a114bdff831#wechat_redirect"];


                    }
                        break;
                        // 限时抢
                    case BTN_TAG_LIMITBUY:
                    {
                        //                        //正式环境
                        //                                                if (_limitBuyReplaceContent && _limitBuyReplaceContent.url) {
                        //                                                    WebViewController *vc = [[WebViewController alloc] init];
                        //                                                    vc.url = [NSString stringWithFormat:@"http://%@",_limitBuyReplaceContent.url];
                        //                                                    vc.navTitle = Str_Comm_WebPage;
                        //                                                    [self.navigationController pushViewController:vc animated:YES];
                        //                                                }else {
                        //                        //生产环境
                        LimitBuyViewController *vc = [[LimitBuyViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                        //                                                }


                        //改
                        //                        WebViewController *vc = [[WebViewController alloc] init];
                        //                        vc.navTitle = @"亿客征集令";
                        //                        [self.navigationController pushViewController:vc animated:YES];
                        //                        vc.url = [NSString stringWithFormat:@"http://www.rabbitpre.com/m/27QInjVB?sui=A0jwlKRy#from=share"];
                    }
                        break;
                    default:
                        break;
                }
            }];
            return cell;
        }
            break;
            // 吃喝玩乐
        case E_Section_EasyLive:
        {
            EasyLiveCollectionViewCell *cell = (EasyLiveCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:EasyLiveCollectionViewCellNibName forIndexPath:indexPath];
            if (indexPath.row == self.easyLiveDataArray.count-1) {
                [cell loadCellData:[self.easyLiveDataArray objectAtIndex:indexPath.row] hideSplitLine:YES];
            }else {
                [cell loadCellData:[self.easyLiveDataArray objectAtIndex:indexPath.row] hideSplitLine:NO];
            }
            return cell;
        }
            break;
        default:
            break;
    }

    return nil;
}
#pragma -mark 物业通知scrollview UI设置
- (void)HeaderSetionData:(CommunityMessageCollectionViewCell *)cell
{
    [self setScrollView:cell.scrollview];

    if (titleDatas.count >1) {
        // 定时器
        [self addTimer];
    }
    else {
        [self removeTimer];
    }

}
- (void)addTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
}
- (void)nextPage {
   [self.cell.scrollview setContentOffset:CGPointMake(0,self.cell.scrollview.contentOffset.y + (self.cell.frame.size.height)) animated:YES];
}
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setScrollView:(UIScrollView *)scrollView {

    [scrollView updateConstraints];
    scrollView.tag = 100;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = NO;
//    scrollView.backgroundColor = [UIColor blueColor];
    // 水平滚动

    scrollView.contentOffset = CGPointMake(0, 40);
    scrollView.showsVerticalScrollIndicator = NO;
    
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if ( titleDatas.count >1) {
        scrollView.contentSize = CGSizeMake(Screen_Width-117, 40*(titleDatas.count+2));
        //第一
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.frame.size.height)];
        [scrollView addSubview:view1];

        UIImageView *butLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,45, 40)];
//        butLine.image = [UIImage imageNamed:@"newsTypeImg"];
        [view1 addSubview:butLine];

        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
        typeLabel.textColor = [UIColor orangeColor];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.font = [UIFont boldSystemFontOfSize:16];
        typeLabel.text = [NSString stringWithFormat:@"%@",typeDatas[0]];
        [view1 addSubview:typeLabel];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, view1.frame.size.width-butLine.frame.size.width-3, 40)];
        titleLabel.textColor = [UIColor colorWithRed:83/225.0 green:83/225.0 blue:83/225.0 alpha:1];
        titleLabel.font = [UIFont fontWithName:@"Menlo" size:16];
        titleLabel.text = [NSString stringWithFormat:@"%@",titleDatas[0]];
        [view1 addSubview:titleLabel];

        for (int i = 0; i< titleDatas.count; i++) {
            UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, (i+1)*40, scrollView.frame.size.width, scrollView.frame.size.height)];
            [scrollView addSubview:view2];

            UIImageView *butLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,45, 40)];
//            butLine.image = [UIImage imageNamed:@"newsTypeImg"];
            [view2 addSubview:butLine];

            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
            typeLabel.textColor = [UIColor orangeColor];
            typeLabel.textAlignment = NSTextAlignmentCenter;
            typeLabel.font = [UIFont boldSystemFontOfSize:16];
            typeLabel.text = [NSString stringWithFormat:@"%@",typeDatas[i]];
            [butLine addSubview:typeLabel];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, view2.frame.size.width-butLine.frame.size.width-3, 40)];
            titleLabel.textColor = [UIColor colorWithRed:83/225.0 green:83/225.0 blue:83/225.0 alpha:1];
             titleLabel.font = [UIFont fontWithName:@"Menlo" size:16];
            titleLabel.text = [NSString stringWithFormat:@"%@",titleDatas[i]];
            [view2 addSubview:titleLabel];
        }

        //最后
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, (titleDatas.count+1)*40, scrollView.frame.size.width, scrollView.frame.size.height)];
        [scrollView addSubview:view3];
        UIImageView *butLine3 = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0,45, 40)];
//        butLine3.image = [UIImage imageNamed:@"newsTypeImg"];
        [view3 addSubview:butLine3];

        UILabel *typeLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
        typeLabel.textColor = [UIColor orangeColor];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.font = [UIFont boldSystemFontOfSize:16];
        typeLabel3.text = [NSString stringWithFormat:@"%@",typeDatas[0]];
        [butLine3 addSubview:typeLabel3];

        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, view3.frame.size.width-butLine.frame.size.width-3, 40)];
        titleLabel.textColor = [UIColor colorWithRed:83/225.0 green:83/225.0 blue:83/225.0 alpha:1];
        titleLabel.font = [UIFont fontWithName:@"Menlo" size:16];
        titleLabel3.text = [NSString stringWithFormat:@"%@",titleDatas[0]];
         [view3 addSubview:titleLabel];
    }
    else if (titleDatas.count == 1)
    {

        scrollView.contentSize = CGSizeMake(Screen_Width-117, 40);
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, scrollView.frame.size.width, scrollView.frame.size.height)];
        [scrollView addSubview:view2];
        UIImageView *butLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,45, 40)];
//        butLine.image = [UIImage imageNamed:@"newsTypeImg"];
        [view2 addSubview:butLine];

        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
        typeLabel.textColor = [UIColor orangeColor];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.font = [UIFont boldSystemFontOfSize:16];
        typeLabel.text = [NSString stringWithFormat:@"%@",typeDatas[0]];
        [butLine addSubview:typeLabel];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, view2.frame.size.width-butLine.frame.size.width-3, 40)];
        titleLabel.textColor = [UIColor colorWithRed:83/225.0 green:83/225.0 blue:83/225.0 alpha:1];
        titleLabel.font = [UIFont fontWithName:@"Menlo" size:16];
        titleLabel.text = [NSString stringWithFormat:@"%@",titleDatas[0]];
        [view2 addSubview:titleLabel];
    }
    else
    {
        scrollView.contentSize = CGSizeMake(Screen_Width-117, 40);
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, scrollView.frame.size.width, scrollView.frame.size.height)];
        UILabel *noLabel = [[UILabel alloc] initWithFrame: CGRectMake(2, 0, view2.frame.size.width-4, 40)];
        noLabel.textColor = [UIColor colorWithRed:83/225.0 green:83/225.0 blue:83/225.0 alpha:1];
        noLabel.font = [UIFont fontWithName:@"Menlo" size:16];
        noLabel.text = @"暂时没有新的物业通知哦～";
        [view2 addSubview:noLabel];
        [scrollView addSubview:view2];
    }


    scrollView.pagingEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 100) {
        if ((int)scrollView.contentOffset.y%40 == 0) {
            if (scrollView.contentOffset.y == 0) {
                scrollView.contentOffset = CGPointMake(0,titleDatas.count*40);
            } else if (scrollView.contentOffset.y == (titleDatas.count+1)*40) {
                scrollView.contentOffset = CGPointMake(0, 40);
            }
            else{}
        }
        else{}

    }
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self removeTimer];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self addTimer];
//}

#pragma mark - CollectionView代理
// CollectionView元素选择事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            // 物业服务
        case E_Section_CommunityService:
            [MobClick event:@"PropertyPayment_homepage_icon"];
            [self communityServiceItemClickHandler:indexPath.row];
            break;
            // 物业通知===2016.02.22
        case E_Section_CommunityMessage:
        {
            [self toMessage];
        }
            break;
            // 物业服务
        case E_Section_CommunityService1:
            [MobClick event:@"PropertyPayment_homepage_icon"];
            [self communityServiceItemClickHandler:indexPath.row];
            break;

            // 惠民专区
        case E_Section_BenefitPeopleArea:
            break;
            // 吃喝玩乐
        case E_Section_EasyLive:
        {
            BusinessDetailViewController *vc = [[BusinessDetailViewController alloc] init];
            SurroundBusinessModel *detail = [self.easyLiveDataArray objectAtIndex:indexPath.row];
            vc.businessModel = detail;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 0;
    CGFloat height = 0;

    switch (indexPath.section) {
            // 物业服务
        case E_Section_CommunityService:
        {
            width = Screen_Width/4.0 - 1;
            height = width * 7 / 6.0;
        }
            break;
            // 物业通知===2016.02.22
        case E_Section_CommunityMessage:
        {
            width = Screen_Width;
            height = 40;
        }
            break;
            // 物业服务
        case E_Section_CommunityService1:
        {
            width = Screen_Width/4.0 -1;
            height = width * 7 / 6.0;
        }
            break;
            // 惠民专区
        case E_Section_BenefitPeopleArea:
        {
            width = Screen_Width;
            height = width*(5.0/9.0) + 20;
        }
            break;
            // 吃喝玩乐
        case E_Section_EasyLive:
        {
            width = Screen_Width;
            height = 128.0;
        }
            break;
        default:
            break;
    }

    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}

// 设置Sectionheader大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeMake(0, 0);
    switch (section) {
            // 物业服务
        case E_Section_CommunityService:
            itemSize = CGSizeMake(Screen_Width, (Screen_Width * 2.0 / 5.0));
            break;
            // 物业通知 ==== 2016.02.22
        case E_Section_CommunityMessage:
            itemSize = CGSizeMake(Screen_Width, 0);
            break;
            // 物业服务
        case E_Section_CommunityService1:
            itemSize = CGSizeMake(Screen_Width, 0);//(Screen_Width * 2.0 / 5.0)
            break;

            // 惠民专区
        case E_Section_BenefitPeopleArea:
            itemSize = CGSizeMake(Screen_Width, 0);
            break;
        case E_Section_EasyLive:
            itemSize = CGSizeMake(Screen_Width, 45);
            break;
        default:
            break;
    }

    return itemSize;
}

// 设置SectionFooter大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeMake(0, 0);
    switch (section) {
            // 物业服务
        case E_Section_CommunityService:
            itemSize = CGSizeMake(Screen_Width, 1);
            break;
            // 物业通知===2016.02.22
        case E_Section_CommunityMessage:
            itemSize = CGSizeMake(Screen_Width, 1);
            break;
            // 物业服务
        case E_Section_CommunityService1:
            itemSize = CGSizeMake(Screen_Width, 1);
            break;
            // 惠民专区
        case E_Section_BenefitPeopleArea:
            itemSize = CGSizeMake(Screen_Width, 2);
            break;
            // 吃喝玩乐
        case E_Section_EasyLive:
            itemSize = CGSizeMake(Screen_Width, 5);
            break;
        default:
            break;
    }

    return itemSize;
}


#pragma mark-轮播图设置
// 设置Header和FooterView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == E_Section_CommunityService) {//物业服务
            FirstHeaderView *view = (FirstHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FirstHeaderViewNibName forIndexPath:indexPath];
            [view setDefaultImgName:@"AdSlideDefaultImg"];
            [view loadHeaderData:self.adImgArray];// 广告图片数据数组
            [view setAdImgClickBlock:^(NSUInteger index) {

                AdImgSlideInfo *slideInfo = [self.slideInfoArray objectAtIndex:index];
                switch ([slideInfo.relatetype integerValue]) {
                    case 3: // 限时抢
                    {
                        LimitBuyViewController*vc=[[LimitBuyViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 7: // 普通商品
                    {
                        WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
                        vc.waresId = slideInfo.gmId;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;

                    case 4: // 团购
                    {
                        GrouponDetailViewController *vc = [[GrouponDetailViewController alloc] init];
                        vc.grouponId = slideInfo.gmId;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;

                    case 8: // 物业通知
                    {
                        MessageDetailViewController *vc = [[MessageDetailViewController alloc] init];
                        vc.messageMsgid = slideInfo.gmId;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;

                    case 9: // 外部链接
                    {
                        //🍎我加
                        //未登录跳转到登陆页面
                        if(![[LoginConfig Instance] userLogged])
                        {
                            //我加
                            //BaseViewController *vc = nil;
                            PersonalCenterViewController * loginVC = (PersonalCenterViewController *) [[PersonalCenterViewController alloc]init];
                            //loginVC.backVC = self;
                            //vc = loginVC;
                            [self.navigationController pushViewController:loginVC animated:YES];
                        }
                        else
                        {
#pragma mark-报名 ，投票
                            //获取当前用户ID
                            NSString *userid = [[LoginConfig Instance]userID];
                            SurveyAndVoteViewController*vc=[[SurveyAndVoteViewController alloc]init];
                            vc.title=slideInfo.title;
                            //判断是否是投票和报名
                            NSString *str1 = @"surveyvote/survey/default.do";
                            NSString *str2 = @"surveyvote/vote/default.do";
                            NSString *newStr1 = @"ownerWeixin/survery/";
                            NSString *newStr2 = @"ownerWeixin/vote/";
                            NSLog(@"¥¥¥¥¥¥¥¥%@",slideInfo.url);
                            if (([slideInfo.url rangeOfString:str1].location != NSNotFound) || ([slideInfo.url rangeOfString:str2].location != NSNotFound)||([slideInfo.url rangeOfString:newStr1].location != NSNotFound)||([slideInfo.url rangeOfString:newStr2].location != NSNotFound))
                            {
                                if ([slideInfo.url rangeOfString:@"?"].location != NSNotFound)
                                {
                                    vc.url = [NSString stringWithFormat:@"%@&appMId=%@",slideInfo.url,userid];
                                }
                                else
                                {
                                    vc.url = [NSString stringWithFormat:@"%@?appMId=%@",slideInfo.url,userid];
                                }
                                //                                [self.navigationController pushViewController:vc animated:YES];
                                break;
                            }
                            else{
#pragma -mark 12-23 网络连接判断
                                BOOL netWorking = [Common checkNetworkStatus];
                                if (netWorking) {
                                    vc.url=slideInfo.url;
                                }
                                else
                                {
                                    [Common showBottomToast:Str_Comm_RequestTimeout];
                                    return;
                                }

                                //                                [self.navigationController pushViewController:vc animated:YES];
                            }
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }];
            return view;
        }
        else{
            CommonHeaderView *view = (CommonHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CommonHeaderViewNibName forIndexPath:indexPath];
            [view registBtnClickCallBack:^{
                switch(indexPath.section){
                        // 吃喝玩乐
                    case E_Section_EasyLive:
                    {
                        SurroundBusinessViewController *vc = [[SurroundBusinessViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }];
            return view;
        }
    }
    else{
        CommonFooterView *view = (CommonFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CommonFooterViewNibName forIndexPath:indexPath];
        return view;
    }
}


#pragma mark - 选择小区Delegate
- (void)setSelectedNeighborhoodId:(NSString *)projectId andName:(NSString *)projectName
{
    self.projectId = projectId;
    self.projectName = projectName;

}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.adImgArray = [[NSMutableArray alloc] init];
    self.slideInfoArray = [[NSMutableArray alloc] init];
    self.replaceContentArray = [[NSMutableArray alloc] init];
    self.houseKeepReplaceArray = [[NSMutableArray alloc] init];
    self.doorToDoorReplaceArray = [[NSMutableArray alloc] init];
#pragma mark-2015.11.13  12-08物业缴费
    self.communityServiceItemArray = @[
                                       /* @[Img_HoueseKeep_Property, Img_HoueseKeep_Property, Str_HouseKeep_PropertyNotify],*/
                                       @[Img_Home_VisitorAccessNor, Img_Home_VisitorAccessNor, Str_Comm_VisitorAccess],
                                       @[Img_Home_PostItRepairNor, Img_Home_PostItRepairNor, Str_Comm_PostItRepair],
                                       //@[Img_HoueseKeep_Question, Img_HoueseKeep_Question, Str_Comm_Questionnaire],
                                       @[Img_Home_PropertyBillNor, Img_Home_PropertyBillNor, Str_Comm_PropertyBill],
                                       @[Img_Home_ConvenientPhoneNor, Img_Home_ConvenientPhoneNor, Str_Comm_ConvenientPhone]
                                       ];


    // 吃喝玩乐数据数组
    self.easyLiveDataArray = [[NSMutableArray alloc] init];

    self.projectId = @"-1";
}

#pragma mark-广告轮播屏蔽2015.11.13
// 从服务器上获取首页广告图片
- (void)getSlideListDataFromService
{
    NSString* bindTel = [[LoginConfig Instance]getBindPhone];
    if ([bindTel isEqualToString:testTel]) {
        return;
    }
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[projectId] forKeys:@[@"projectId"]];

    // 请求服务器获取数据
    [self getArrayFromServer:SlideList_Url path:SlideList_Path method:@"GET" parameters:dic xmlParentNode:@"slide" success:^(NSMutableArray *result) {
        [self.slideInfoArray removeAllObjects];
        [self.adImgArray removeAllObjects];
        for (NSDictionary *dic in result) {
            AdImgSlideInfo *slideInfo = [[AdImgSlideInfo alloc] initWithDictionary:dic];
            [self.slideInfoArray addObject:slideInfo];
            NSString*imgUrl=[[NSString alloc]init];
            imgUrl=slideInfo.picPath;
//            NSString *
            [self.adImgArray addObject:imgUrl];//轮播广告图片url添加到数组
        }
        [self.collectionView.header endRefreshing];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.collectionView.header endRefreshing];
        [self.collectionView reloadData];
    }];
}

//从服务器获取物业通知（若有获取前三条）＝＝＝2016.02.22
- (void)getMessageListDataFromService
{

//    [titleDatas removeAllObjects];
//    [typeDatas removeAllObjects];

    NSString *userid = [[LoginConfig Instance]userID];//获得项目的projectId
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    //2
   NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:projectId,@"projectId",userid,@"userId",@"1",@"toModule",@"1",@"pageNum",@"20",@"perSize",nil];

    [self getArrayFromServer:CommunityMessage_URL path:CommunityMessage_Path method:@"GET" parameters:dic xmlParentNode:@"/msgPushBeans/msgPush" success:^(NSMutableArray *result) {
        [titleDatas removeAllObjects];
        [typeDatas removeAllObjects];

        NSMutableArray*objsArray=[[NSMutableArray alloc]init];
        NSMutableArray *typearr = [[NSMutableArray alloc] init];
        NSMutableArray *titlearr = [[NSMutableArray alloc] init];

        for (NSDictionary *dic in result) {
            //创建数据模型
             MessageModel*modelData=[[MessageModel alloc]initWithDictionary:dic];
            //数据模型添加到可变数组
            [objsArray addObject:modelData];

            [typearr addObject:[NSString stringWithFormat:@"%@",modelData.newsTypeString]];
    
            //将title分割成标题和内容＝＝＝2016.02.23
            NSString*str=@"图文消息";
            NSString*strr=@"文字";
            if ([modelData.msgTypeString isEqual:str] || [modelData.msgTypeString isEqual:strr]) {
                 NSArray *titleeArray = [modelData.titlelString componentsSeparatedByString:@":"];
                if (titleeArray.count > 0) {
                    if ([modelData.msgTypeString isEqual:str]) {
                        NSString * titlestr=[titleeArray[0] substringFromIndex:6];
                        [titlearr addObject:titlestr];
                    }
                    else
                    {
                        NSString * titlestr=[titleeArray[0] substringFromIndex:4];
                        [titlearr addObject:titlestr];
                    }
                }
                else
                {
//                    YjqLog(@"无内容");
                }
            }
            else
            {
//                YjqLog(@"无标题");
            }


        }

        //存储数据模型
        dataSourceArray=objsArray;
        if (typearr.count >0) {
            typeArray = typearr;
            titleArray = titlearr;
//            YjqLog(@"title:%ld   type:%ld",(unsigned long)titleArray.count,(unsigned long)typeArray.count);
            int numCount = (dataSourceArray.count>3)?3:dataSourceArray.count;
            for (int i = 0; i<numCount; i++) {
                [titleDatas addObject:titleArray[i]];
                [typeDatas addObject:typeArray[i]];
            }
//            YjqLog(@"标题：%lu 类型：%lu",(unsigned long)titleDatas.count,(unsigned long)typeDatas.count);
        }

        //没有数据的时候
        if (dataSourceArray.count==0) {
            //        [titleDatas addObject:@"暂无消息"];
        }
        else{
            //        self.tableView.hidden=NO;
        }
        //刷新tableView数据
        [self.collectionView reloadData];


    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];

    }];

}

// 从服务器上获取首页动态替换内容（物业服务、团购、限时购 -- 封面和链接）
- (void)getReplaceContentFromServer
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[projectId] forKeys:@[@"projectId"]];

    // 请求服务器获取数据
    [self getArrayFromServer:SlideList_Url path:ReplaceContent_Path method:@"GET" parameters:dic xmlParentNode:@"slide" success:^(NSMutableArray *result0) {
        [_doorToDoorReplaceArray removeAllObjects];
        [_houseKeepReplaceArray removeAllObjects];
        for (NSDictionary *dic in result0) {
            AdImgSlideInfo *slideInfo = [[AdImgSlideInfo alloc] initWithDictionary:dic];
            if (slideInfo.relatetype == nil) {
                continue;
            }
            if ([slideInfo.relatetype isEqualToString:@"4"]) {
                _grouponReplaceContent = slideInfo;
            }else if ([slideInfo.relatetype isEqualToString:@"3"]){
                _limitBuyReplaceContent = slideInfo;
            }else if([slideInfo.relatetype isEqualToString:@"6"]){
                [_doorToDoorReplaceArray addObject:slideInfo];
            }else if([slideInfo.relatetype isEqualToString:@"-2"]){
                [_houseKeepReplaceArray addObject:slideInfo];
            }
        }
        [self.collectionView.header endRefreshing];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.collectionView.header endRefreshing];
        [self.collectionView reloadData];
    }];
}


// 从服务器端获取吃喝玩乐数据
- (void)getEasyLiveDataFromServer
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.projectId = [userDefault objectForKey:KEY_PROJECTID];

    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.projectId] forKeys:@[@"projectId"]];

    // 请求服务器获取数据
    [self getArrayFromServer:SurroundBusiness_Url path:SurroundBusiness_Path method:@"GET" parameters:dic xmlParentNode:@"crmManageSeller" success:^(NSMutableArray *result0) {
        [self.easyLiveDataArray removeAllObjects];
        for (NSDictionary *dic in result0) {
            [self.easyLiveDataArray addObject:[[SurroundBusinessModel alloc] initWithDictionary:dic]];
            //            YjqLog(@"dic========%@",dic);
            //            YjqLog(@"result0======%@",result0);
        }
        [self.collectionView.header endRefreshing];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self.collectionView.header endRefreshing];
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


// 注册CollectionView的Cell Nib
- (void)registNibForCollectionVew
{
    // 社区服务系列
    [self.collectionView registerClass:[CommunityServiceCollectionViewCell class] forCellWithReuseIdentifier:CommunityServiceCollectionCellNibName];

    //物业通知＝＝＝2016.02.22
    UINib *nib = [UINib nibWithNibName:@"CommunityMessageCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CommunityMessageCollectionViewCell"];

    // 惠民专区
    UINib *nibForBenefit = [UINib nibWithNibName:BenefitPeopleCollectionViewCellNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForBenefit forCellWithReuseIdentifier:BenefitPeopleCollectionViewCellNibName];

    // 吃喝玩乐
    UINib *nibForEasyLive = [UINib nibWithNibName:EasyLiveCollectionViewCellNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForEasyLive forCellWithReuseIdentifier:EasyLiveCollectionViewCellNibName];

    // 空白CollectionCell
    UINib *nibForBlank = [UINib nibWithNibName:BlankCollectionViewCellNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForBlank forCellWithReuseIdentifier:BlankCollectionViewCellNibName];

    // 第一个HeaderView(包含通知栏和轮播)
    UINib *nibForFirstHeader = [UINib nibWithNibName:FirstHeaderViewNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForFirstHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FirstHeaderViewNibName];

    // 第一个FooterView
    UINib *nibForFooterHeader = [UINib nibWithNibName:FirstFooterViewNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForFooterHeader forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FirstFooterViewNibName];

    // 共通HeaderView
    UINib *nibForCommonHeader = [UINib nibWithNibName:CommonHeaderViewNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForCommonHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CommonHeaderViewNibName];

    // 共通FooterView
    UINib *nibForCommonFooter = [UINib nibWithNibName:CommonFooterViewNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForCommonFooter forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CommonFooterViewNibName];

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

             //            BOOL netWorking = [Common checkNetworkStatus];
             //            if (netWorking) {
             /**
              * 接口请求成功---已认证
              */
             if ([dict[@"code"] isEqualToString:@"IOD00000"]) {
                 //已认证
                 if ([authStatus isEqualToString:@"1"]) {
                     NewVieitorViewController *newVC = [[NewVieitorViewController alloc] init];
                     [self.navigationController pushViewController:newVC animated:NO];
                     //                        vc = [(NewVieitorViewController *)[NewVieitorViewController alloc] init];
                 }
                 else
                 {
                     alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"提示" message:@"认证失败"  cancel:@"取消" other:@""];

                     [self.view addSubview:alertView];
                     [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];
                 }
             }
             /**
              * 用户没有认证
              */
             else if ([dict[@"code"] isEqualToString:@"IODB0002"])
             {
                 NSUserDefaults*defaultsAuthen=[NSUserDefaults standardUserDefaults];
                 NSString*authenStatutring=[defaultsAuthen objectForKey:@"authenStatus"];
                 if ([authenStatutring isEqualToString:@"NO"] || [authenStatutring isEqualToString:@""] || [authenStatutring isEqualToString:@"CANCLE"]) {

                     alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"认证" message:@"先认证才可以开门哦!"  cancel:@"取消" other:@"认证"];
                     alertView.lookBaojiaBlock = ^void() {
                         //未认证，去认证
                         RoadAddressManageViewController* next = [[RoadAddressManageViewController alloc]init];
                         next.isAddressSel = addressSel_Auth;
                         next.showType = ShowDataTypeAuth;
                         [self.navigationController pushViewController:next animated:YES];

                     };
                     [self.view addSubview:alertView];

                 }
                 if ([authenStatutring isEqualToString:@"MID"]) {

                     alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"认证中" message:@"物业人员会尽快为您认证，请等待通知哦"  cancel:@"好" other:@""];

                     [self.view addSubview:alertView];
                     [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];

                 }
                 YjqLog(@"3214r");
             }

             else  if ([dict[@"code"] isEqualToString:@"IOD0020"])//
             {
                 [Common showBottomToast:@"已认证的社区暂无开门服务哦"];
             }
             else
             {
                 [Common showBottomToast:@"门禁较远或升级，请靠前或刷卡"];
             }

             //                else
             //                {
             //                    alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"认证" message:@"先认证才可以开门哦!"  cancel:@"取消" other:@"认证"];
             //                    alertView.lookBaojiaBlock = ^void() {
             //                        //未认证，去认证
             //                        RoadAddressManageViewController* next = [[RoadAddressManageViewController alloc]init];
             //                        next.isAddressSel = addressSel_Auth;
             //                        next.showType = ShowDataTypeAuth;
             //                        [self.navigationController pushViewController:next animated:YES];
             //
             //                    };
             //                    [self.view addSubview:alertView];
             ////                    FKAlertView *alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"无连接" message:@"未检测到有效设备"  cancel:@"好" other:@""];
             ////                    [self.view addSubview:alertView];
             //
             //                }
         } failure:^(NSURLSessionDataTask *operation, NSError *error) {
             [Common showBottomToast:Str_Comm_RequestTimeout];
             YjqLog(@"%@", error.localizedDescription);
         }];

     }
                     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}

// 物业服务选项点击事件处理函数
- (void)communityServiceItemClickHandler:(NSInteger)itemID
{
    BaseViewController *vc = nil;
    switch (itemID) {
            /*
             // 访客通行
             case 0:
             if(![[LoginConfig Instance] userLogged])
             {
             [Common weiXinLoginOrIphoneLogin];

             }else
             {
             //                vc = (VisitorPassportViewController *)[[VisitorPassportViewController alloc] init];
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您所在的社区暂不支持该功能,敬请期待！" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:@"确定", nil];
             [alertView show];
             }
             break;
             */
#pragma mark-屏蔽物业报修，工程保修

            // 访客通行--添加新访客
        case 0:

            //            vc = (VisitorPassportViewController *)[[VisitorPassportViewController alloc] init];
        {
#pragma -mark 12-23 网络连接判断
            [self requestAuthenData];

            //            }
            //            else
            //            {
            //                [Common showBottomToast:Str_Comm_RequestTimeout];
            //                return;
            //            }
        }
            break;
            //工程报修
        case 1:
        {
            vc = (CategorySelectedViewController *)[[CategorySelectedViewController alloc] init];//信则
#pragma   数据埋点日志提交参数
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key];//用户ID

            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            NSString *projectId = [userDefault objectForKey:@"projectId"];
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:userId,@"ownerId",projectId,@"projectId",@"10",@"moduleId",@"40",@"fromId",nil];
            //     请求服务器获取数据
            [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


            } failure:^(NSError *error) {

                //                [Common showBottomToast:@"请开启网络设置"];
            }];


        }
            break;
            // 物业缴费
        case 2:
        {
            if ([[LoginConfig Instance] userLogged]) {
#pragma -mark 12-23 网络连接判断
                BOOL netWorking = [Common checkNetworkStatus];
                if (netWorking) {
                    vc = [(PropertyBillWebViewController *)[PropertyBillWebViewController alloc] init];
                }
                else
                {
                    [Common showBottomToast:Str_Comm_RequestTimeout];
                    return;
                }

            }else {
                [Common weiXinLoginOrIphoneLogin];
            }
#pragma -mark 数据埋点日志提交参数
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key];//用户ID
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            NSString *projectId = [userDefault objectForKey:@"projectId"];
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:userId,@"ownerId",projectId,@"projectId",@"40",@"moduleId",@"40",@"fromId",nil];
            //     请求服务器获取数据
            [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


            } failure:^(NSError *error) {

                //        [Common showBottomToast:@"请开启网络设置"];
            }];

        }
            break;
            //办事通
        case 3:
        {
            if(![[LoginConfig Instance] userLogged])
            {
                [Common weiXinLoginOrIphoneLogin];
            }else
            {
                //                vc = (QuestionnaireSurveyViewController *)[[QuestionnaireSurveyViewController alloc] init];

                vc = (UserfulTelNoListViewController *)[[UserfulTelNoListViewController alloc] init];//新增
            }
#pragma -mark 数据埋点日志提交参数
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key];//用户ID
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            NSString *projectId = [userDefault objectForKey:@"projectId"];
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:userId,@"ownerId",projectId,@"projectId",@"50",@"moduleId",@"40",@"fromId",nil];
            //     请求服务器获取数据
            [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


            } failure:^(NSError *error) {

                //        [Common showBottomToast:@"请开启网络设置"];
            }];

        }
            break;
            // 办事通
        case 4:
            //            vc = (UserfulTelNoListViewController *)[[UserfulTelNoListViewController alloc] init];
            break;
        default:
            break;
    }

    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 导航栏Title点击-选择小区
- (void)selectProject
{
    GYZChooseCityController *vc = [[GYZChooseCityController alloc] init];
    //    SelectNeighborhoodViewController *vc = [[SelectNeighborhoodViewController alloc] init];
    vc.isSaveData = TRUE;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 导航栏右侧按钮（推送消息）点击事件处理函数
- (void)navBarRightItemClick
{
    [self pushWithVCClassName:@"ComTestController" properties:@{@"title":@"测试demo"}];
    
//    [self toMessage];
}
-(IBAction)toMessage:(id)sender
{
//    [self toMessage];
}

-(void)toMessage
{
    MessageViewController *vc = [[MessageViewController alloc] init];
    //    vc.messageType = MessageTypeAll;
    [self.navigationController pushViewController:vc animated:YES];

#pragma -mark 数据埋点日志提交参数
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key];//用户ID
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:@"projectId"];
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:userId,@"ownerId",projectId,@"projectId",@"20",@"moduleId",@"40",@"fromId",nil];
    //     请求服务器获取数据
    [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


    } failure:^(NSError *error) {

        //        [Common showBottomToast:@"请开启网络设置"];
    }];

}


#pragma mark - 摇一摇部分代码
- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark-开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {

    [MobClick event:@"opendoor_homepage_shake"];

    [self openDoorMethod];

    //    //获取当前时间
    //    NSData *now = [NSDate date];
    //    NSLog(@"now date is: %@", now);
    //
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    //
    //    NSInteger year = [dateComponent year];
    //    NSInteger month = [dateComponent month];
    //    NSInteger day = [dateComponent day];
    //    NSInteger hour = [dateComponent hour];
    //    NSInteger minute = [dateComponent minute];
    //    NSInteger second = [dateComponent second];
    //
    //
    //    startArr = @[@(hour),@(minute),@(second)];
    //
    //
    //    datestr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",(long)year,(long)month,(long)day,(long)hour,(long)minute,(long)second];
    //
    //#pragma -mark 12-23 网络连接判断
    //        BOOL netWorking = [Common checkNetworkStatus];
    //        if (netWorking) {
    //            /**
    //             * 接口请求成功 且为认证状态
    //             **/
    //            //  &&且 ||与
    //            //        YjqLog(@"+++++++%@++++++",dict);
    //            if ([dict[@"code"] isEqualToString:@"IOD00000"] ){
    //                if ([authStatus isEqualToString:@"1"]) {
    //#if TARGET_IPHONE_SIMULATOR
    //#else
    //                    moPro = [[iZHC_MoProtocol alloc] init];
    //#endif
    //                    NSMutableArray *arrr = [[NSMutableArray alloc] init];
    //                    for (int i = 0;i<_dataArray.count;i++) {
    //                        NSString *sttr = _dataArray[i];
    //                        NSDictionary *dicc = @{@"encryptStr": sttr};
    //                        //array为从服务器获取到的数据
    //                        [arrr addObject:dicc];
    //                        //这是解key的操作，bleNameArray为解析出的蓝牙名数组，FIDArray为解析出的fid数组
    //                    }
    //                    [moPro decodeKey:arrr];//解key
    //                }
    ////                //新
    ////                [self searchOpenDoor];
    //            }
    //
    //            /*
    //             用户未认证
    //             */
    //            else if ([dict[@"code"] isEqualToString:@"IODB0002"])//
    //            {
    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"只有认证用户才能使用摇一摇功能哦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往认证", nil];
    //                [alert show];
    //
    //            }
    //
    //            /*
    //             接口请求失败导致的开门失败
    //             */
    //            else
    //            {
    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您认证的社区还没有开通摇一摇开门功能" delegate:self  cancelButtonTitle:@"3S" otherButtonTitles:nil];
    //                [alert show];
    //                [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
    //            }
    //            //新
    //            [self searchOpenDoor];
    //
    //        }
    //        else
    //        {
    //            [Common showBottomToast:Str_Comm_RequestTimeout];
    //            return;
    //        }
    //
    //
    //    //创建BLE搜索对象
    //
    //#if TARGET_IPHONE_SIMULATOR
    //#else
    //    self.gattManager = [[GattManager alloc] init];
    //#endif
    //    self.gattManager.delegate = self;
    //    //新
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BLEmonitor:) name:@"BLENotification" object:nil];

}
#pragma mark-瑶瑶，点击，下拉调用此方法可执行开门效果
//瑶瑶，点击，下拉调用此方法可执行开门效果
-(void)openDoorMethod
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
#pragma -mark 12-23 网络连接判断
        //    BOOL netWorking = [Common checkNetworkStatus];
        //    if (netWorking) {

        /**
         * 接口请求成功 且为认证状态
         **/
        //  &&且  ||与
        YjqLog(@"+++++++%@++++++",dict);
        if ([dict[@"code"] isEqualToString:@"IOD00000"] ){
            if ([authStatus isEqualToString:@"1"]) {
                _isWillClick = YES;

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
                //                [timerSearch setFireDate:[NSDate distantPast]];
            }
            //新
            [self searchOpenDoor];
        }
        /*
         用户未认证
         */
        else if ([dict[@"code"] isEqualToString:@"IODB0002"])//
        {

            //            //声音设置
            //            [self soundSetting];
            NSUserDefaults*defaultsAuthen=[NSUserDefaults standardUserDefaults];
            NSString*authenStatutring=[defaultsAuthen objectForKey:@"authenStatus"];
            if ([authenStatutring isEqualToString:@""]|| [authenStatutring isEqualToString:@"NO"]) {

                alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"认证" message:@"先认证才可以开门哦!"  cancel:@"取消" other:@"认证"];
                alertView.quxiaoBlock = ^void() {
                    _isWillClick = YES;
                };
                alertView.lookBaojiaBlock = ^void() {
                    //未认证，去认证
                    RoadAddressManageViewController* next = [[RoadAddressManageViewController alloc]init];
                    next.isAddressSel = addressSel_Auth;
                    next.showType = ShowDataTypeAuth;
                    [self.navigationController pushViewController:next animated:YES];

                };
                [self.view addSubview:alertView];

                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"认证" message:@"先认证才可以开门哦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"认证", nil];
                //                [alert show];
                self.key = @"";
                datestr = @"";
                self.resultStr = @"false";
                self.resultReason = @"未认证";
                [self openDoorResult];//上传开门数据

            }
            if ([authenStatutring isEqualToString:@"MID"]) {

                alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"认证中" message:@"物业人员会尽快为您认证，请等待通知哦"  cancel:@"好" other:@""];
                alertView.quxiaoBlock = ^void() {
                    _isWillClick = YES;

                };
                [self.view addSubview:alertView];
                [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"认证中" message:@"物业人员会尽快为您认证，请等待通知哦" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                //                [alert show];
                self.key = @"";
                datestr = @"";
                self.resultStr = @"false";
                self.resultReason = @"认证中";
                [self openDoorResult];//上传开门数据
            }
        }
        /*
         接口请求失败导致的开门失败
         */
        else  if ([dict[@"code"] isEqualToString:@"IOD0020"])//
        {
            [Common showBottomToast:@"已认证的社区暂无开门服务哦"];

            //            FKAlertView *alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"无连接" message:@"未检测到有效设备"  cancel:@"好" other:@""];
            //            //                alertView.center = self.view.center;
            //            alertView.quxiaoBlock = ^void() {
            _isWillClick = YES;
            //            };
            //             [self.view addSubview:alertView];

            self.key = @"";
            datestr = @"";
            self.resultStr = @"false";
            self.resultReason = @"开门失败";
            [self openDoorResult];//上传开门数据
            //            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
        }
        else
        {
            [Common showBottomToast:@"门禁较远或升级，请靠前或刷卡"];
            _isWillClick = YES;
            self.key = @"";
            datestr = @"";
            self.resultStr = @"false";
            self.resultReason = @"开门失败";
            [self openDoorResult];//上传开门数据
        }


    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
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



//提示框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == UpdateAlertTagNoNeed) {
        switch (buttonIndex) {
            case 0:
            {
                // 更新，跳转到appstore
                [self gotoAppstore];
                break;
            }
            case 1:{
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSDate date] forKey:UserDefaultKeyUpdateTip];
                break;
            }
            default:
                break;
        }
    }
    else if (alertView.tag == UpdateAlertTagNeed) {
        [self gotoAppstore];
        [self showUpdateAlert:alertView.message isNeedUpdate:YES];
    }
    else {
        //🍎
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            if (![[LoginConfig Instance] userLogged]) {
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

#pragma -mark 12-12摇一摇添加手机震动功能
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    if(event.subtype == UIEventSubtypeMotionShake)
//    {
//        YjqLog(@"停止摇动2");
//    }
//}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
}

//3🍎上
#pragma mark - 隔一定时间后如果还没得到回应就重新搜索
//搜索设备
-(void)searchOpenDoor
{
#pragma -mark 调用等待加载。。。
    //给蓝牙类的蓝牙数组和Fid数组赋值
    self.gattManager.gattUserInfoArray = moPro.bleNameArray;
    self.gattManager.gattUserFIDArray = moPro.FIDArray;
    self.gattManager.gattUserKeyArray = moPro.keyArray;
    [self.gattManager setUp];//实例化中心角色
    [self.gattManager setFlagDefault];
    [self.gattManager scan:2];//整形参数为搜索次数，代表周边蓝牙设备的数目，当搜索次数到达此整数还未搜索到目标设备则返回未搜索到设备。

    NSLog(@"%d",self.UseTime);//1
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


#pragma mark - GattBLE Delegate
-(void)getBleSearchAnswer:(int)result resultString:(NSString *)str26
{
    switch (result) {
        case 0:
        {
            NSLog(@"开门成功");
            //添加声音
            [self soundSetting];

            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开门成功" message:@"用时1000ms" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            //            [alert show];
            NSLog(@"openKey = %@",[self.gattManager getOpenKey]);


            //#pragma mark-开门动画
            //            //设置开门声音
            //            [self soundSetting];
            //            self.openAnimationWindow.hidden=NO;
            //            self.openAnimationWindow=[OpenDoorAnimation showOpenDoorAnimation:[NSString stringWithFormat:@"%d",self.UseTime]andSuccessOrFail:0];

            [Common showBottomToast:@"欢迎回家"];

            //            FKAlertView *alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"" message:@""  cancel:@"欢迎回家" other:@""];
            //            [self.view addSubview:alertView];

            //            [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];

            self.resultStr = @"ture";
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
            break;
        }

        default:

            break;
    }
    //    [self openDoorResult];//上传开门结果

    if(self.gattManager)
        [self.gattManager setFlagDefault];
}


-(void)BLEmonitor:(NSNotification *)notification{
    NSNumber *result = [notification object];
    NSLog(@"result = %@",result);//个数
    switch ([result intValue]) {
        case 2:
        {
            NSLog(@"未搜索到设备");

            [Common showBottomToast:@"门禁较远或升级，请靠前或刷卡"];

            //            FKAlertView *alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"无连接" message:@"未检测到有效设备，请靠近门禁哦"  cancel:@"好" other:@""];
            //            [self.view addSubview:alertView];
            //            alertView.quxiaoBlock = ^void() {
            _isWillClick = YES;
            //            };
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
            break;
        }
        case 4:
        {
            NSLog(@"连接成功");
            break;
        }
            //        case 5:
            //        {
            //            NSLog(@"连接超时");
            //        }
        case 6:
        {
            NSLog(@"连接失败");
        }
        case 7:
        {
            NSLog(@"未找到服务或特性");



            alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"开门失败" message:@"门禁设备暂时出现故障，请尝试其他途径哦"  cancel:@"好" other:@""];
            //                alertView.center = self.view.center;
            [self.view addSubview:alertView];
            alertView.quxiaoBlock = ^void() {
                _isWillClick = YES;
            };
            [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];
            self.key = @"";
            datestr = @"";
            self.resultStr = @"false";
            self.resultReason = @"开门失败";
            [self openDoorResult];//上传开门数据

            break;
        }
        default:
            break;
    }

    self.UseTime = 230;
    //    [self openDoorResult];//上传开门数据
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
#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

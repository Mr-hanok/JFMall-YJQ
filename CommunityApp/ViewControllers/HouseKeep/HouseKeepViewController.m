//
//  HouseKeepViewController.m
//  CommunityApp
//
//  Created by iss on 8/5/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HouseKeepViewController.h"
#import "HouseKeepHeadCollectionReusableView.h"
#import "CommunityServiceCollectionViewCell.h"
#import "CategorySelectedViewController.h"//分类
#import "PropertyBillViewController.h"//物业计费
#import "PropertyBillWebViewController.h"//新物业缴费
#import "VisitorPassportViewController.h"//访客通行
#import "UserfulTelNoListViewController.h"//办事通
#import "QuestionnaireSurveyViewController.h"//问卷
#import "MessageViewController.h"
#import "CustomerServiceCenterCollectionViewCell.h"
#import "AdImgSlideInfo.h"
#import "FirstFooterView.h"
#import "FirstHeaderView.h"

#import <AFNetworking.h>
#import "NewVieitorViewController.h"//新访客页
#import "RoadAddressManageViewController.h"//路址认证


typedef enum {
    Section_HouseKeepService=0,
    Section_HouseKeepCount,
}Section_HouseKeep_Type;
@interface HouseKeepViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSDictionary *dict;//发送好友解析的判断是否认证的dict
    NSString *authStatus;//认证状态
    CGRect rect;//alertview位置大小
    FKAlertView *alertView;

    NSString *pointuserId;//用户ID
    NSString *pointprojectId;//项目ID


}
@property (strong,nonatomic) IBOutlet UICollectionView* collection;
@property (strong,nonatomic) NSArray* ServiceArray;
@property (strong,nonatomic) NSMutableArray* PicArray;


@end
// Cell Nib文件名定义
#define ServiceCollectionCellNibName       @"CustomerServiceCenterCollectionViewCell"
#define HeadCollectionReusableView         @"HouseKeepHeadCollectionReusableView"
#define FooterCollectionReusableView       @"FirstFooterView"
#define HEADHEIGHT 200.0f

#pragma mark-管家类
@implementation HouseKeepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    rect = CGRectMake(self.view.frame.size.width/6, self.view.frame.size.height/10, CGRectGetWidth(self.view.frame) * 0.8, CGRectGetHeight(self.view.frame) * 0.4);
    self.hidesBottomBarWhenPushed = NO;    // Push的时候隐藏TabBar
    [self registNib];
    [self initBasicDataInfo];
    self.navigationItem.title = Str_Comm_HouseKeep;

    pointuserId = [[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key];//用户ID
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    pointprojectId = [userDefault objectForKey:@"projectId"];


}
// 重载viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.frame = CGRectMake(0, Screen_Height-BottomBar_Height, Screen_Width, BottomBar_Height);
    [self getSlideListDataFromService];
    [self AFNetworking];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [alertView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark 访客通行－－ 添加新访客
- (void)AFNetworking
{
    //上传设备信息
    UIDevice *device = [UIDevice currentDevice];
    NSString *model = device.model; //获取设备的类别
    NSString *type = device.localizedModel; //获取本地化版本
    NSString *systemVersion = device.systemVersion;//获取当前系统的版
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];//每次删除app都会发生变化
    YjqLog(@"********%@",identifierForVendor);
    NSString *rst = [NSString stringWithFormat:@"%@#@#%@#@#%@#@#%@",model,type,systemVersion,identifierForVendor];
    //因为有汉字要utf8编码
    NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //🍎AFNetWorking解析数据
    AFHTTPSessionManager  *_manager
    =[AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"ownerId",VersionNumber,@"version",rstt,@"rst", nil];//dic是向服务器上传的参数
    YjqLog(@"dic:%@",dic);//输入
    [_manager POST:OwnerApprove_Url parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {
        //解析数据
        dict=[NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *bodyDict = dict[@"body"];

        if ([dict[@"code"] isEqualToString:@"IOD00000"] ) {
            authStatus= bodyDict[@"authStatus"];//认证状态
        }

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

        [Common showBottomToast:Str_Comm_RequestTimeout];
        YjqLog(@"%@", error.localizedDescription);
    }];

}
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        //[alert release];
    }
}
#pragma mark---other

// 从服务器上获取首页广告图片
- (void)getSlideListDataFromService
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];

    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[projectId] forKeys:@[@"projectId"]];

    // 请求服务器获取数据
    [self getArrayFromServer:HouseKeep_Url path:HouseKeep_Path method:@"GET" parameters:dic xmlParentNode:@"tbgProjectSetting" success:^(NSMutableArray *result) {
        [self.PicArray removeAllObjects];
        for (NSDictionary *dic in result) {
            AdImgSlideInfo *slideInfo = [[AdImgSlideInfo alloc] initWithDictionary:dic];
            NSString *imgUrl = slideInfo.picPath;
            //            NSRange rang = [imgUrl rangeOfString:FileManager_Address];
            //            NSURL *iconUrl ;
            //            if(rang.length == 0)
            //            {
            //                iconUrl = [NSURL URLWithString:[Common setCorrectURL:imgUrl]];
            //            }
            //            else
            //            {
            //                iconUrl = [NSURL URLWithString:imgUrl];
            //            }
            [self.PicArray  addObject:imgUrl];
            //            NSData *data = [NSData dataWithContentsOfURL:iconUrl];
            //            if(data) {
            //                [self.PicArray addObject:[UIImage imageWithData:data]];
            //            }
        }
        [self.collection reloadData];

    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.collection reloadData];
    }];
}
-(void)registNib
{
    UINib *nibForService = [UINib nibWithNibName:ServiceCollectionCellNibName bundle:[NSBundle mainBundle]];
    [self.collection registerNib:nibForService forCellWithReuseIdentifier:ServiceCollectionCellNibName];

    UINib *nibForFooterHeader = [UINib nibWithNibName:HeadCollectionReusableView bundle:[NSBundle mainBundle]];
    [self.collection registerNib:nibForFooterHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadCollectionReusableView];
    UINib *nibForFooter = [UINib nibWithNibName:FooterCollectionReusableView bundle:[NSBundle mainBundle]];
    [self.collection registerNib:nibForFooter forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterCollectionReusableView];
}
#pragma mark - 文件域内公共方法
// 初始化基本数据  12-08天加物业缴费
- (void)initBasicDataInfo
{
    self.PicArray = [[NSMutableArray alloc] init];

    self.ServiceArray = @[@[Img_Home_PostItRepairNor, Img_Home_PostItRepairPre, Str_Comm_PostItRepair],
                          @[Img_Home_PropertyBillNor, Img_Home_PropertyBillPre,Str_Comm_PropertyBill],
                          @[Img_Home_VisitorAccessNor, Img_Home_VisitorAccessPre, Str_Comm_VisitorAccess],
                          @[Img_Home_ConvenientPhoneNor,Img_Home_ConvenientPhonePre, Str_Comm_ConvenientPhone],
                          @[Img_HoueseKeep_Property, Img_HoueseKeep_PropertyPre, Str_HouseKeep_PropertyNotify],
                          @[Img_HoueseKeep_Question, Img_HoueseKeep_QuestionPre, Str_Comm_Questionnaire]];
}
#pragma mark---UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == Section_HouseKeepService) {
        return [_ServiceArray count];
    }
    else return 0;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return Section_HouseKeepCount;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == Section_HouseKeepService)
    {
        CustomerServiceCenterCollectionViewCell *cell = (CustomerServiceCenterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ServiceCollectionCellNibName forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setCell: [self.ServiceArray objectAtIndex:indexPath.row]];
        return cell;
    }

    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark-屏蔽修改
#pragma mark - CollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewController *vc = nil;
    if (indexPath.section == Section_HouseKeepService) {

        switch (indexPath.row) {
                //工程报修
            case 0:
            {
                vc = (CategorySelectedViewController *)[[CategorySelectedViewController alloc] init];//工程报修
#pragma -mark 数据埋点日志提交参数

                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:pointuserId,@"ownerId",pointprojectId,@"projectId",@"10",@"moduleId",@"40",@"fromId",nil];
                //     请求服务器获取数据
                [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


                } failure:^(NSError *error) {

                    //        [Common showBottomToast:@"请开启网络设置"];
                }];
                break;
            }
                // 物业缴费
            case 1:
            {
                if ([[LoginConfig Instance] userLogged]) {
                    [MobClick event:@"PropertyPayment_housekeeper_icon"];
                    //  vc = (PropertyBillViewController *)[[PropertyBillViewController alloc] init];//物业缴费
                    vc = [(PropertyBillWebViewController *)[PropertyBillWebViewController alloc] init];//新物业缴费
                }else {
                    [Common weiXinLoginOrIphoneLogin];
                }
#pragma -mark 数据埋点日志提交参数

                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:pointuserId,@"ownerId",pointprojectId,@"projectId",@"40",@"moduleId",@"40",@"fromId",nil];
                //     请求服务器获取数据
                [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


                } failure:^(NSError *error) {

                    //        [Common showBottomToast:@"请开启网络设置"];
                }];

            }
                break;
                // 访客通行
            case 2:
            {
#pragma -mark 12-23 网络连接判断
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


                    //                    else
                    //                    {
                    //                        alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"认证" message:@"先认证才可以开门哦!"  cancel:@"取消" other:@"认证"];
                    //                        alertView.lookBaojiaBlock = ^void() {
                    //                            //未认证，去认证
                    //                            RoadAddressManageViewController* next = [[RoadAddressManageViewController alloc]init];
                    //                            next.isAddressSel = addressSel_Auth;
                    //                            next.showType = ShowDataTypeAuth;
                    //                            [self.navigationController pushViewController:next animated:YES];
                    //
                    //                        };
                    //                        [self.view addSubview:alertView];
                    //                        //                    FKAlertView *alertView = [[FKAlertView alloc] initWithFrame:rect withTitle:@"无连接" message:@"未检测到有效设备"  cancel:@"好" other:@""];
                    //                        //                    [self.view addSubview:alertView];
                    //
                    //                    }
                } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                    [Common showBottomToast:Str_Comm_RequestTimeout];
                    YjqLog(@"%@", error.localizedDescription);
                }];

            }

                break;

                //办事通
            case 3:
            {
                //                vc = (MessageViewController *)[[MessageViewController alloc] init];
                //                MessageViewController* vctmp = (MessageViewController*)vc;
                //                vctmp.messageType = MessageTypeAll;//消息类 //11.26
                vc = (UserfulTelNoListViewController *)[[UserfulTelNoListViewController alloc] init];//办事通
#pragma -mark 数据埋点日志提交参数

                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:pointuserId,@"ownerId",pointprojectId,@"projectId",@"50",@"moduleId",@"40",@"fromId",nil];
                //     请求服务器获取数据
                [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


                } failure:^(NSError *error) {

                    //        [Common showBottomToast:@"请开启网络设置"];
                }];
            }
                break;

                //物业通知
            case 4:
            {
                MessageViewController *newMessages = (MessageViewController *)[[MessageViewController alloc] init];
                //                newMessages.messageType = MessageTypeAll;
                vc = newMessages;
#pragma -mark 数据埋点日志提交参数

                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:pointuserId,@"ownerId",pointprojectId,@"projectId",@"20",@"moduleId",@"40",@"fromId",nil];
                //     请求服务器获取数据
                [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


                } failure:^(NSError *error) {

                    //        [Common showBottomToast:@"请开启网络设置"];
                }];
            }
                break;
                // 问卷调查
            case 5:{
                if([[LoginConfig Instance] userLogged])
                {
                    vc = (QuestionnaireSurveyViewController *)[[QuestionnaireSurveyViewController alloc] init];//2015.11.13

                }else
                {
                    [Common weiXinLoginOrIphoneLogin];
                    //
                }
#pragma -mark 数据埋点日志提交参数

                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:pointuserId,@"ownerId",pointprojectId,@"projectId",@"60",@"moduleId",@"40",@"fromId",nil];
                //     请求服务器获取数据
                [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


                } failure:^(NSError *error) {

                    //        [Common showBottomToast:@"请开启网络设置"];
                }];
            }
                break;
                //            case 3:
                //
                //                vc = (VisitorPassportViewController *)[[VisitorPassportViewController alloc] init];//访客行
                ////                vc = (UserfulTelNoListViewController *)[[UserfulTelNoListViewController alloc] init];//办事通//11.26
                //                break;
            default:
                break;

        }
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if (buttonIndex == 1) {
    //        [self initBasicDataInfo];
    //    }
    //🍎
    if (buttonIndex == 0)
    {
        return;
    }
    else
    {
        //未认证
        RoadAddressManageViewController* next = [[RoadAddressManageViewController alloc]init];
        next.isAddressSel = addressSel_Auth;
        next.showType = ShowDataTypeAuth;
        [self.navigationController pushViewController:next animated:YES];
    }
    //🍎
    if (buttonIndex == 1) {
        [self initBasicDataInfo];
    }


}
#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 0;
    CGFloat height = 0;

    switch (indexPath.section) {
        case Section_HouseKeepService:
        {
            width = Screen_Width/3.0 -0.5;
            height = 105;
        }
            break;
        default:
            break;
    }

    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}


//// 设置Header和FooterView
// 设置Header和FooterView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == Section_HouseKeepService) {
            HouseKeepHeadCollectionReusableView *view = (HouseKeepHeadCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeadCollectionReusableView forIndexPath:indexPath];
            //            [view setDefaultImgName:@"HouseKeepSildeDefaultImg"];
            //            [view loadHeaderData:_PicArray];
            return view;
        }

    }
    if (kind == UICollectionElementKindSectionFooter){
        if (indexPath.section == Section_HouseKeepService) {
            FirstFooterView* view = (FirstFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterCollectionReusableView forIndexPath:indexPath];
            return view;
            
        }
    }
    return nil;
}


// 设置Sectionheader大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeMake(0, 0);
    switch (section) {
        case Section_HouseKeepService:
            itemSize = CGSizeMake(Screen_Width, Screen_Width * (2.0 / 5.0)+30);
            break;
            
        default:
            break;
    }
    
    return itemSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeMake(0, 0);
    switch (section) {
        case Section_HouseKeepService:
            itemSize = CGSizeMake(Screen_Width, 0.5);
            break;
            
        default:
            break;
    }
    
    return itemSize;
}
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(Screen_Height/15, 0, 0, 0);
//}
@end

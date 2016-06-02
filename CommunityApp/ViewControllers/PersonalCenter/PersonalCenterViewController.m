//
//  PersonalCenterViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterMeCell.h"
#import "PersonalCenterAboutViewController.h"
#import "PersonalCenterBaseInfoViewController.h"
#import "PersonalCenterMyOrderViewController.h"
#import "PersonalCenterHotlineViewController.h"
#import "RoadAddressManageViewController.h"
#import "MyPostRepairViewController.h"
#import "UserModel.h"
#import "SelectNeighborhoodViewController.h"
#import "GYZChooseCityController.h"//////////////
#import "PersonalCenterIntegralViewController.h"
#import "PersonalCenterAuthenticationViewController.h"
#import "MyCouponsViewController.h"
#import "GrouponOrderListViewController.h"
#import "ShoppingCartViewController.h"
#import "PersonalCenterMyOrderViewController.h"
#import "CouponViewController.h"
#import "PersonalCenterMyFavoriteViewController.h"
#import "PayMethodViewController.h"
#import "MyFleaMarketViewController.h"
#import "PersonalCenterLoginType.h"

#import "SDWebImageDownloader.h"
#import "UIImageView+AFNetworking.h"
#import "PersonalCenterBindTelViewController.h"
#import "AGImagePickerViewController.h"
//🍎
#import "MyVisitorViewController.h"//我的访客
#import "MyExpressViewController.h"//快递订单
#import "MyPropertyBillViewController.h"//物业缴费订单

//🍎
#import "WebViewController.h"
#import "Interface.h"
#import "LoginConfig.h"
#import "ServiceOrderWebViewController.h"

#import <AFNetworking.h>

#import "RoadAddressManageViewController.h"
#import "PersonalWeinXinLoginViewController.h"
//服务订单
//#import "ServerOrderViewController.h"

//协议内容控制器
#import "ProtocoViewController.h"
//#import "MainViewController.h"
#import "IntegralMallHomeViewController.h"
#define SECTION_NUM 3
#define CELL1_NUM 3
#define CELL2_NUM 4

typedef enum {
    toCart = 0,//购物车
    toCommodityOrder,//实物订单
    toServiceOrder,//服务订单
    //toGrouponOrder,
    toMyPropertyBill,//我的物业缴费🍎

    toMyCoupon,//优惠券
    toMyGroupon,//团购券
    toMyFleaMarket,//跳蚤市场
    toFavorite,//收藏夹

    toAbout,//关于我们

    toMyExchangeOrder,//我的兑换劵
}toCaseType;

@interface PersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UITextFieldDelegate, SetMyAvatarImgDelegate>
{
    NSArray *array;
    NSArray *unLoginarray;

    NSDictionary *dict;//发送好友解析的判断是否认证的dict

    NSString *pointuserId;//用户ID
    NSString *pointprojectId;//项目ID
}
@property(strong,nonatomic)IBOutlet UILabel* userName;

@property(strong,nonatomic)IBOutlet UITableView* table;
@property(strong,nonatomic)IBOutlet UIView* tableHead;
@property(strong,nonatomic)IBOutlet UIImageView* headIcon;
@property(strong,nonatomic)IBOutlet UIView* myBussinessView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (strong,nonatomic) NSMutableArray* roadList;
@property (assign,nonatomic) BOOL  loadedRoaldList;
@property(strong,nonatomic)IBOutlet UIView* loginView;
@property(strong,nonatomic)IBOutlet UIView* userInfoView;


@property(strong,nonatomic)IBOutlet UITextField* loginUserName;
@property(strong,nonatomic)IBOutlet UITextField* code;
@property (weak, nonatomic) IBOutlet UIImageView *hLine1;
@property (weak, nonatomic) IBOutlet UIImageView *hLine2;
@property(strong,nonatomic)NSString* openid;

@property (nonatomic, strong) NSTimer *idCodeTimer;
@property(nonatomic, assign)NSInteger idCodeTime;
@property(nonatomic, retain)NSString *randString;
@property(strong, nonatomic)IBOutlet UIButton *btnIdCode;

@property(strong, nonatomic)IBOutlet UIView *bgView;

@property(strong,nonatomic)IBOutlet UIButton* checkBox;//选择协议按钮
@property(weak,nonatomic)IBOutlet UIButton *userProtocolButton;//用户协议按钮
@property (nonatomic ,strong) NSString *namestring;


@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏
    //    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Comm_Me;

    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];

    //array =@[@[Img_MyShoppingCart,Str_Comm_Cart],@[Img_CommodityOrder,Str_CommodityOrder],@[Img_ServiceOrder,Str_ServiceOrder], @[Img_MyCoupon,Str_MyCoupons],@[Img_MyGroupon,Str_MyCoupons_Title],@[Img_MyFleaOrder,Str_MyFleaMarket],@[Img_MyFavorite,Str_MyFavorites],@[Img_MyVisitor,Str_MyVisitor_title],@[Img_about,Str_About]];
    //🍎
    array =@[@[@[Img_MyShoppingCart,Str_Comm_Cart],@[Img_CommodityOrder,Str_CommodityOrder],@[Img_ServiceOrder,Str_ServiceOrder],@[Img_ExpressOrder, Str_ExpressOrder],@[Img_MyPropertyBill,Str_MyPropertyBill_title]], @[/*@[Img_MyExchangeOrder,Str_ExchageOrder],*/@[Img_MyCoupon,Str_MyCoupons],/*@[Img_MyGroupon,Str_MyCoupons_Title],*/@[Img_MyFleaOrder,Str_MyFleaMarket],@[Img_MyFavorite,Str_MyFavorites]],@[@[Img_about,Str_About]]];

    unLoginarray = @[@[Img_about,Str_About]];

    //在此处调用一下就可以啦 ：此处假设tableView的name叫：tableView
    _headIcon.layer.cornerRadius = _headIcon.frame.size.width / 2;
    _headIcon.clipsToBounds = YES;

    self.table.tableHeaderView=_tableHead;
    self.hidesBottomBarWhenPushed = NO;    // Push的时候隐藏TabBar
    _roadList = [[NSMutableArray alloc]init];

    [Common updateLayout:_hLine1 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine2 where:NSLayoutAttributeHeight constant:0.5];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponder)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

    //设置用户协议是否选中按钮
    [_checkBox setImage:[UIImage imageNamed:@"checkBoxNO"] forState:UIControlStateNormal];
    [_checkBox setImage:[UIImage imageNamed:@"checkBoxOK"] forState:UIControlStateSelected];
    [_checkBox setSelected:TRUE];//协议默认设为被选择
    if ((_loginUserName.text=testTel)) {
        _code.text=[NSString stringWithFormat:@"%d",testTelCode];
        _randString=[NSString stringWithFormat:@"%d",testTelCode];
        //_btnIdCode.enabled=NO;
    }


    pointuserId = [[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key];//用户ID
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    pointprojectId = [userDefault objectForKey:@"projectId"];
    //登录输入手机号码后点击查看用户协议返回手机号消失
    [self initView];

}
-(void)getAddressInfo
{
    if([[LoginConfig Instance] userLogged] == FALSE)
    {
        return;
    }
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    // 请求服务器获取数据
    NSString *userId = user.userId;
    //    if(_loadedRoaldList)
    //    {
    //        [self displayAuthAddress];
    //        return;
    //    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: userId,@"userId",nil];
    [self getArrayFromServer:ServiceInfo_Url path:GetRoadAddressList_Path method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result)
     {
         [_roadList removeAllObjects];
         for (NSDictionary *dicResult in result)
         {
             [self.roadList addObject:[[RoadData alloc] initWithDictionary:dicResult]];
         }
         // if(self.roadList.count !=0)
         {
             [self displayAuthAddress];
         }
         _loadedRoaldList = TRUE;
     }
                     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}
-(void)displayAuthAddress
{

    NSMutableString* address = [[NSMutableString alloc]initWithFormat:@"%@",[[LoginConfig Instance]userName]];
    if ([address isEqualToString:@""]) {
        [address appendString:[[LoginConfig Instance] userAccount]];
    }
    BOOL authTag = FALSE;
    for (RoadData* road in self.roadList) {

        if ([road.authen isEqualToString:@"1"]) {
            if(authTag == FALSE)
            {
                [address appendString:@" 认证社区:"];
                authTag = TRUE;
            }
            [address appendFormat:@"%@ ",road.projectName] ;
        }

    }
    if([address isEqualToString:@""]==FALSE)
    {
        [_userName setText:address];
    }
    else
    {
        [_userName setText:@"个人信息"];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if([Common appDelegate].userArray.count == 0)
    {
        [self stopTiming];
    }

}
-(void)initView  //我的页面
{
    [[self.bgView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if([Common appDelegate].userArray.count == 0)
    {
        _loginView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-BottomBar_Height-Navigation_Bar_Height);
        [self.bgView addSubview:_loginView];
        _code.text = @"";
        _loginUserName.text = @"";
        [self stopTiming];
        self.navigationItem.title = Str_Login_Title;
    }
    else{
        self.navigationItem.title = Str_Comm_Me;
//        _userInfoView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-BottomBar_Height-Navigation_Bar_Height);
        [self.bgView addSubview:_userInfoView];

        if (_myAvatar) {
            [_headIcon setImage:_myAvatar];
        }else{
            NSString *filePath = [[LoginConfig Instance] userIcon];
            NSURL *iconUrl = [NSURL URLWithString:filePath];
            [_headIcon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"head"]];
        }

        [self getAddressInfo];
        [_table reloadData];
    }


}
// 重载viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.frame = CGRectMake(0, Screen_Height-BottomBar_Height, Screen_Width, BottomBar_Height);
#pragma -mark 检测设备是否安装微信 11-15
    //    self.weixinview.hidden = YES;
    //    self.otherview.hidden = YES;
    //    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
    //    {
    //        self.weixinview.hidden = NO;
    //        self.otherview.hidden = NO;
    //    }



    //    if([Common appDelegate].userArray.count == 0)
    //    {
    //        [_userName setText:@"登录/注册"];
    //        [_myBussinessView setHidden:TRUE];
    //        [_table reloadData];
    //        _loadedRoaldList = FALSE;
    //      return;
    //    }
    //
    //    [_myBussinessView setHidden:FALSE];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView

{

    UIView *view =[ [UIView alloc]init];

    view.backgroundColor = [UIColor clearColor];

    [tableView setTableFooterView:view];


}

#pragma mark-table view

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return section == 0 ?0:10.f;;

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* headIdentify = @"headIdentify";
    UITableViewHeaderFooterView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headIdentify];
    if(view==nil)
    {
        view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headIdentify];
        UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 10.f)];
        [bg setBackgroundColor:COLOR_RGB(243, 243, 243)];
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10-0.5, Screen_Width, 0.5)];
        [line setBackgroundColor:COLOR_RGB(211, 209, 210)];
        [view addSubview:line];
        [view setBackgroundView:bg];
    }
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if([Common appDelegate].userArray.count ==0)
        return 1;
    //return SECTION_NUM;
    return array.count;//🍎
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    static NSString *identifier = @"PersonalCenterMeCell";
//    PersonalCenterMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//
//    if (cell == nil)
//    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalCenterMeCell" owner:self options:nil] lastObject];
//    }
//
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if([Common appDelegate].userArray.count == 0)
//    {
//        [cell setIconPath:[[unLoginarray objectAtIndex:indexPath.row] objectAtIndex:0]];
//        [cell setName:[[unLoginarray objectAtIndex:indexPath.row] objectAtIndex:1] isBottom:TRUE];
//
//        return  cell;
//    }
//
//    NSInteger index = 0;
//    if (indexPath.section == 0) {
//         index = indexPath.row;
//    }
//    else if (indexPath.section == 1)
//    {
//        index = indexPath.row + CELL1_NUM;
//    }
//    else
//    {
//        index = indexPath.row + CELL1_NUM + CELL2_NUM;
//    }
//
//
//    [cell setIconPath:[[array objectAtIndex:index] objectAtIndex:0]];
//
//    [cell setName:[[array objectAtIndex:index] objectAtIndex:1] isBottom:TRUE];
//
//    return cell;
//}
//🍎
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"PersonalCenterMeCell";
    PersonalCenterMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalCenterMeCell" owner:self options:nil] lastObject];
    }


    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([Common appDelegate].userArray.count == 0)
    {
        [cell setIconPath:[[unLoginarray objectAtIndex:indexPath.row] objectAtIndex:0]];
        [cell setName:[[unLoginarray objectAtIndex:indexPath.row] objectAtIndex:1] isBottom:TRUE];

        return  cell;
    }

    [cell setIconPath:array[indexPath.section][indexPath.row][0]];

    [cell setName:array[indexPath.section][indexPath.row][1] isBottom:TRUE];

    return cell;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if([Common appDelegate].userArray.count == 0)
    {
        return [unLoginarray count];
    }
    //    if(section != SECTION_NUM -1)
    //        return CELL_NUM;
    //🍎
    //    switch (section) {
    //        case 0:
    //            return CELL1_NUM;
    //            break;
    //        case 1:
    //            return CELL2_NUM;
    //            break;
    //        default:
    //            return 1;
    //            break;
    //}

    return [array[section] count];

}
//🍎
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if([Common appDelegate].userArray.count == 0)
//    {
//        [self toAbout];
//        return;
//    }
//
//    NSInteger index = 0;
//    if (indexPath.section == 0) {
//        index = indexPath.row;
//    }
//    else if (indexPath.section == 1) {
//        index = indexPath.row + CELL1_NUM;
//    }
//    else {
//        index = indexPath.row + CELL1_NUM + CELL2_NUM;
//    }
//
//    switch (index) {
//        case toAbout:
//            [self toAbout];
//            break;
//        case toCart:
//            [self toCart];
//            break;
//        case toMyCoupon:
//            [self toMyCoupon];
//            break;
//        case toMyGroupon:
//            [self toMyGroupon];
//            break;
//        case toFavorite:
//            [self toMyFavorite];
//            break;
////        case toGrouponOrder:
////            [self toGrouponOrder];
////            break;
//        case toCommodityOrder:
//            [self toCommodityOrder];
//            break;
//        case toServiceOrder:
//            [self toServiceOrder];
//            break;
//        case toMyFleaMarket:
//            [self toFleaMarket];
//            break;
////            //🍎
////        case toMyVisitor:
////            [self toMyVisitor];
////            break;
//        default:
//            break;
//    }
//}
#pragma mark-点击cell进入相应页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([Common appDelegate].userArray.count == 0)
    {
        [self toAbout];
        return;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self toCart];
        }
        else if (indexPath.row == 1) {
            [self toCommodityOrder];
        }
        else if (indexPath.row == 2) {
            [self toServiceOrder];
        }
        //11-13
        else if (indexPath.row == 3) {
            [self toExpressOrder];
        }
        else
        {
            [MobClick event:@"PropertyPayment_mypage_order"];
            [self toMyPropertyBill];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self toMyCoupon];
        }
        //11-13
        else if (indexPath.row == 1) {
            [self toFleaMarket];
        }
        else if (indexPath.row == 2) {
            [self toMyFavorite];
        }

    }

    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self toAbout];
        }
    }
}
#pragma mark-button click

-(IBAction)loginClick:(id)sender
{
    [MobClick event:@"login_mobile"];

    //login
    if(![[LoginConfig Instance] userLogged])
    {
        [Common weiXinLoginOrIphoneLogin];
    }
    else
    {
        PersonalCenterBaseInfoViewController *next = [[PersonalCenterBaseInfoViewController alloc] init];
        next.delegate = self;
        next.myAvatarImg = _myAvatar;
        [self.navigationController pushViewController:next animated:YES];

    }
}

-(IBAction)toIntegral:(id)sender
{
    PersonalCenterIntegralViewController* next = [[PersonalCenterIntegralViewController alloc]init];
    [self.navigationController pushViewController:next animated:YES];
}

-(IBAction)clickHeadSel:(id)sender
{
    AGImagePickerViewController* vc = [[AGImagePickerViewController alloc]init];
    vc.imgUrlArray = @[[[LoginConfig Instance] userIcon]];
    [self.navigationController pushViewController:vc animated:TRUE];
}

#pragma mark-skip selctor
//我的认证
-(IBAction)toAuthentication
{
    RoadAddressManageViewController* next = [[RoadAddressManageViewController alloc]init];
    next.isAddressSel = addressSel_Auth;
    next.showType = ShowDataTypeAuth;
    [self.navigationController pushViewController:next animated:YES];
#pragma -mark 数据埋点日志提交参数

    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:pointuserId,@"ownerId",pointprojectId,@"projectId",@"70",@"moduleId",@"40",@"fromId",nil];
    //     请求服务器获取数据
    [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


    } failure:^(NSError *error) {

        //        [Common showBottomToast:@"请开启网络设置"];
    }];

}
//我的报事
-(IBAction)toMyPostRepairView
{
    MyPostRepairViewController* next = [[MyPostRepairViewController alloc]init];
    [self.navigationController pushViewController:next animated:YES];
#pragma -mark 数据埋点日志提交参数
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:pointuserId,@"ownerId",pointprojectId,@"projectId",@"10",@"moduleId",@"40",@"fromId",nil];
    //     请求服务器获取数据
    [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


    } failure:^(NSError *error) {

        //        [Common showBottomToast:@"请开启网络设置"];
    }];

}
//关于
-(void)toAbout
{
    PersonalCenterAboutViewController* next = [[PersonalCenterAboutViewController alloc]init];
    [self.navigationController pushViewController:next animated:YES];
}
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        //[alert release];

    }
}

//🍎我的兑换劵
-(void)toMyExchangeOrder
{
    //新加一页
}
//我的团购卷
-(void)toMyGroupon
{
    MyCouponsViewController* next = [[MyCouponsViewController alloc]init];
    [self.navigationController pushViewController:next animated:YES];

}
//我的优惠卷
-(void)toMyCoupon
{
    CouponViewController* vc = [[CouponViewController alloc]init];
    vc.leftBtnBackToRoot = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
//购物车
-(void)toCart
{
    ShoppingCartViewController* vc = [[ShoppingCartViewController alloc]init];
    vc.eFromType = E_CartViewFromType_Push;
    [self.navigationController pushViewController:vc animated:TRUE];
}
//实物订单
-(void)toCommodityOrder
{
    PersonalCenterMyOrderViewController* vc = [[PersonalCenterMyOrderViewController alloc]init];
    vc.orderType = OrderType_Commodity;
    [self.navigationController pushViewController:vc animated:TRUE];
}
#pragma mark-服务订单列表
//服务订单🍎－到家服务：改
-(void)toServiceOrder
{
    /*旧服务订单
     PersonalCenterMyOrderViewController* vc = [[PersonalCenterMyOrderViewController alloc]init];
     vc.orderType = OrderType_Service;
     [self.navigationController pushViewController:vc animated:TRUE];
     */

    ServiceOrderWebViewController *vc = [[ServiceOrderWebViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)toGrouponOrder
{
    // 团购订单
    GrouponOrderListViewController *vc = [[GrouponOrderListViewController alloc]init];

    [self.navigationController pushViewController:vc animated:YES];

}
//我的跳蚤市场
-(void)toFleaMarket
{
    MyFleaMarketViewController *vc = [[MyFleaMarketViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//我的收藏夹
-(void)toMyFavorite
{
    PersonalCenterMyFavoriteViewController* vc = [[PersonalCenterMyFavoriteViewController alloc]init];
    [self.navigationController pushViewController:vc animated:TRUE];
}

// 跳转到快递订单页面
- (void)toExpressOrder
{
    MyExpressViewController *vc = [[MyExpressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
#pragma -mark 数据埋点日志提交参数

    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:pointuserId,@"ownerId",pointprojectId,@"projectId",@"30",@"moduleId",@"40",@"fromId",nil];
    //     请求服务器获取数据
    [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


    } failure:^(NSError *error) {

        //        [Common showBottomToast:@"请开启网络设置"];
    }];

}
//物业缴费
- (void)toMyPropertyBill
{
    MyPropertyBillViewController *vc = [[MyPropertyBillViewController alloc] init];
    // UINavigationController*nvc=[];
    [self.navigationController pushViewController:vc animated:NO];
#pragma -mark 数据埋点日志提交参数

    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:pointuserId,@"ownerId",pointprojectId,@"projectId",@"40",@"moduleId",@"40",@"fromId",nil];
    //     请求服务器获取数据
    [self getOrignStringFromServer:Buriedpoint_Url path:Buriedpoint_Path method:@"GET" parameters:dic success:^(NSString *result) {


    } failure:^(NSError *error) {

        //        [Common showBottomToast:@"请开启网络设置"];
    }];

}

#pragma mark --- textFiled delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
#pragma mark--other
-(void)resignCurrentResponder
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:TRUE];
}

#pragma mark--timer
//1
- (IBAction) startTiming:(id)sender{
    //把输入的手机号存起来，防止输入验证码后修改手机号
//    _namestring = _loginUserName.text;
    if([Common checkPhoneNumInput:_loginUserName.text]==FALSE)
    {
        [Common showBottomToast:@"请输入正确手机号"];
        return;
    }

    [self sendRandom];
    //    [self isPhoneLogin];
    // 定义一个NSTimer


}
-(void)popRegister
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机未注册，是否立即注册？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];

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
-(void)isPhoneLogin
{
    if (![Common checkPhoneNumInput:_loginUserName.text]) {
        [Common showBottomToast:@"请输入正确手机号"];
        return;
    }

    // 获取 本机 软件版本号
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSDictionary* dic = [[NSDictionary alloc]initWithObjects:@[_loginUserName.text,_code.text,currentVersion] forKeys:@[@"phoneNum",@"checkCode",@"version"]];
    [self getStringFromServer:ServiceInfo_Url path:IsPhoneLogined_Path method:@"" parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"1"]) {
            [self initBasicDataInfo];
        }
        if ([result isEqualToString:@"-1"]) {
            [Common showBottomToast:@"请输入正确验证码"];
            return ;
        }
        //12.9
        //        else
        //        {
        //            [self popRegister];
        //        }
        //12.9
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
-(void)idCodePaint
{
    NSDate* date = [NSDate date];
    NSInteger interval = [date timeIntervalSinceReferenceDate]-_idCodeTime;
    [_btnIdCode setTitle:[NSString stringWithFormat:@"(%ld)",(60-interval)] forState:UIControlStateNormal];
    if(interval >=60)
        [self stopTiming];

}
// 停止定时器

- (void) stopTiming{
    //验证码过期后置空
//    _randString = @"";
    [_btnIdCode setEnabled:TRUE];
    [_btnIdCode setTitle:Str_getCode_Text forState:UIControlStateNormal];

    if (self.idCodeTimer != nil){

        // 定时器调用invalidate后，就会自动执行release方法。不需要在显示的调用release方法

        [self.idCodeTimer invalidate];

    }
    self.idCodeTimer = nil;
}

-(void)sendRandom
{
    // 获取 本机 软件版本号
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    if (([_loginUserName.text isEqual:@"13716778994"])) {
        _randString = [NSString stringWithFormat:@"%d",583526];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[_loginUserName.text, _randString, @"1",currentVersion] forKeys:@[@"mobiles", @"content", @"type",@"version"]];
        [self getStringFromServer:ServerSMS_Url path:ServerSMS_Path method:@"POST" parameters:dic success:^(NSString *result) {
            if ([result isEqualToString:@"1"]) {
                [Common showBottomToast:@"验证码已发送"];
                NSDate* date = [NSDate date];
                _idCodeTime = [date timeIntervalSinceReferenceDate];
                // _idCodeTime = 60;
                [_btnIdCode setEnabled:FALSE];
                self.idCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                    target:self
                                                                  selector:@selector(idCodePaint)  userInfo:nil
                                                                   repeats:YES];
            }else {
                [Common showBottomToast:@"验证码发送失败"];
            }
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
    }
    else{
        _randString = [NSString stringWithFormat:@"%ld",[self getRandom:6]];

        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[_loginUserName.text, _randString, @"1",currentVersion] forKeys:@[@"mobiles", @"content", @"type",@"version"]];
        [self getStringFromServer:ServerSMS_Url path:ServerSMS_Path method:@"POST" parameters:dic success:^(NSString *result) {
            if ([result isEqualToString:@"1"]) {
                [Common showBottomToast:@"验证码已发送"];
                NSDate* date = [NSDate date];
                _idCodeTime = [date timeIntervalSinceReferenceDate];
                // _idCodeTime = 60;
                [_btnIdCode setEnabled:FALSE];
                self.idCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                    target:self
                                                                  selector:@selector(idCodePaint)  userInfo:nil
                                                                   repeats:YES];
            }else {
                [Common showBottomToast:@"验证码发送失败"];
            }
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
    }
}

-(long) getRandom:(NSInteger)len
{
    srand((unsigned)time(0));
    NSInteger irand = 0;
    long random = 0;
    while (len>0) {
        irand = rand()%10;
        random*=10;
        random +=irand;
        len--;
    }
    return  random;
}

// 从服务器端获取数据
- (void)getDataFromServer
{
     //输入验证码后改变手机号还可登录
    if(_loginUserName.text==nil || [_loginUserName.text isEqualToString:@""]||[Common checkPhoneNumInput:_loginUserName.text]==FALSE)
//    if(_loginUserName.text==nil || [_loginUserName.text isEqualToString:@""]||[Common checkPhoneNumInput:_loginUserName.text]==FALSE || ![_loginUserName.text isEqualToString:_namestring])
    {
        [Common showBottomToast:@"请输入正确的手机号!"];
        return;
    }

    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];

    // 获取 本机 软件版本号
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    // 初始化参数
//    NSDictionary *writedict=[[NSDictionary alloc]initWithObjectsAndKeys:rstt,@"rst",selectProjectId,@"selectProjectId",nearlyProjectId,@"nearlyProjectId",lon,@"userLon",lat,@"userLat",userid,@"ownerinfoId",@"1",@"type",nil];
//    NSDictionary *dic22 = [[NSDictionary alloc]initWithObjects:@[_loginUserName.text,@"2",projectId,_code.text,currentVersion] forKeys:@[@"openid",@"type",@"projectId",@"checkCode",@"version"]];
    if ([projectId isEqual:nil]) {
        projectId = @"";
    }

    NSDictionary* dic22 = [[NSDictionary alloc]initWithObjectsAndKeys:_loginUserName.text,@"openid",@"2",@"type",_code.text,@"checkCode",currentVersion,@"version",projectId,@"projectId", nil];
    NSLog(@"openid2:%@",_loginUserName.text);
    // 请求服务器获取数据
    [self getArrayFromServer:ServiceInfo_Url path:CodeLogin_Path method:@"POST" parameters:dic22 xmlParentNode:@"list" success:^(NSMutableArray *result) {
        [[Common appDelegate].userArray  removeAllObjects];
        for (NSDictionary *dicResult in result)
        {
            if ([[dicResult objectForKey:@"result"] isEqualToString:@"-1"]) {
                [Common showBottomToast:@"请输入正确验证码"];
                return ;
            }
            if ([[dicResult objectForKey:@"result"] isEqualToString:@"2"]) {
                [Common showBottomToast:Str_Login_AccountForbid];
                return ;
            }
            if ([[dicResult objectForKey:@"result"] isEqualToString:@"1"]) {
                [Common showBottomToast:Str_Login_RegisterAndLogin];
            }

            UserModel* user = [[UserModel alloc] initWithDictionary:dicResult];
            user.loginType = LoginType_Code;
            [[Common appDelegate] setIsWillLogin:YES];
            [[Common appDelegate].userArray addObject:user];
            [[LoginConfig Instance] setUserIcon:user.filePath];
            NSURL *iconUrl = [NSURL URLWithString:user.filePath];
            [_headIcon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"head"]];

            [[LoginConfig Instance] saveUserInfo:dicResult loginType:LoginType_Code];
            //            [[Common appDelegate] goOnline];
            //            [[Common appDelegate] userLogout];
#pragma -mark 手机号登录后跳转到首页11－15
            //[self initView];

            //11-15登陆逻辑
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            NSString *value = [userDefault objectForKey:KEY_PROJECTID];

            if (!value)//未经选择小区
            {
                //                SelectNeighborhoodViewController *vc = [[SelectNeighborhoodViewController alloc] init];
                GYZChooseCityController *vc = [[GYZChooseCityController alloc] init];
                vc.isRootVC = TRUE;
                vc.isSaveData = TRUE;
                UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
                //self.window.rootViewController = nvc;
                [self presentViewController:nvc animated:YES completion:nil];
            }
            else//已选择小区
            {
                //手机已经存在该软件，直接进入登陆
                //装载根视图
                MainViewController *mainVC = [[MainViewController alloc] init];
                //[self.navigationController pushViewController:mainVC animated:YES];
                [self presentViewController:mainVC animated:YES completion:nil];

            }
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
-(void)wxXMPPLogin
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * projectId= [userDefault objectForKey:KEY_PROJECTID];

    // 初始化参数
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:_openid,@"openid", @"1",@"type", projectId, @"projectId", nil];
    // 请求服务器获取数据
    [self getArrayFromServer:ServiceInfo_Url path:CodeLogin_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        [[Common appDelegate].userArray  removeAllObjects];
        NSString *isFirstLogin = @"NO";
        for (NSDictionary *dicResult in result)
        {
            if ([[dicResult objectForKey:@"result"] isEqualToString:@"2"]) {
                [Common showBottomToast:Str_Login_AccountForbid];
                return ;
            }
            if ([[dicResult objectForKey:@"result"] isEqualToString:@"1"]) {
                [Common showBottomToast:Str_Login_RegisterAndLogin];
                isFirstLogin = @"YES";
            }

            UserModel* user = [[UserModel alloc] initWithDictionary:dicResult];
            user.loginType = LoginType_Code;
            [[Common appDelegate] setIsWillLogin:YES];
            [[Common appDelegate].userArray addObject:user];
            [[LoginConfig Instance] saveUserInfo:dicResult loginType:LoginType_Weixin];
            //            [[Common appDelegate] goOnline];
            //            [[Common appDelegate] userLogout];
#pragma mark-判断微信是否绑定手机号   12月8号
            //            NSString* bindTel = [[LoginConfig Instance]getBindPhone];
            //            if (bindTel==nil) {
            //                if ([isFirstLogin isEqualToString:@"YES"]) {
            //                    PersonalCenterBindTelViewController *vc = [[PersonalCenterBindTelViewController alloc] init];
            //                    vc.isFirstLogin = YES;
            //                    vc.backVC = self;
            //                    [self.navigationController pushViewController:vc animated:YES];
            //                }else {
            //                    [self initView];
            //                }
            //            }
            //            else{
            //                [self weiXinBangDing];
            //            }
#pragma mark-11.26
            //            if ([isFirstLogin isEqualToString:@"YES"]) {
            //                PersonalCenterBindTelViewController *vc = [[PersonalCenterBindTelViewController alloc] init];
            //                vc.isFirstLogin = YES;
            //                vc.backVC = self;
            //                [self.navigationController pushViewController:vc animated:YES];
            //            }else {
            //                [self initView];
            //            }
            [[Common appDelegate]loadSWRevealViewController]; //微信登陆
        }

    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];

}

#pragma mark-第一次安装微信登陆，如果绑定手机进入小区，否则进入主页
//-(void)weiXinBangDing
//{
//    //11-15登陆逻辑
//    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *value = [userDefault objectForKey:KEY_PROJECTID];
//
//    if (!value)//未经选择小区
//    {
//        SelectNeighborhoodViewController *vc = [[SelectNeighborhoodViewController alloc] init];
//        vc.isRootVC = TRUE;
//        vc.isSaveData = TRUE;
//        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
//        //self.window.rootViewController = nvc;
//        [self presentViewController:nvc animated:YES completion:nil];
//    }
//    else//已选择小区
//    {
//        //手机已经存在该软件，直接进入登陆
//        //装载根视图
//        MainViewController *mainVC = [[MainViewController alloc] init];
//        //[self.navigationController pushViewController:mainVC animated:YES];
//        [self presentViewController:mainVC animated:YES completion:nil];
//
//    }
//
//}

-(void)initBasicDataInfo
{
    // 请求服务器获取数据
    [self getDataFromServer];
}

#pragma mark - SetMyAvatarImgDelegate
- (void)setMyAvatarImg:(UIImage *)avatar
{
    _myAvatar = avatar;
}
#pragma mark-勾选是否同意协议按钮
- (IBAction)checkBoxClick:(id)sender
{
    if (_checkBox.selected==TRUE) {
        _checkBox.selected=FALSE;
        [_checkBox setImage:[UIImage imageNamed:@"checkBoxNO"] forState:UIControlStateNormal];
    }else{
        _checkBox.selected=TRUE;
        [_checkBox setImage:[UIImage imageNamed:@"checkBoxOK"] forState:UIControlStateSelected];
    }
}
#pragma mark-进入协议内容按钮
-(IBAction)userProtocolButton:(id)sender
{
    ProtocoViewController*protocolVC=[[ProtocoViewController alloc]init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}

#pragma mark-退出之后进入的登录界面
- (IBAction)LoginBtnClick:(id)sender
{
    if([_checkBox isSelected] == FALSE)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"请同意用户使用协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else{
#pragma -mark 短信暂时屏蔽
        if(_code.text.length){
//            if ([_code.text isEqualToString:_randString])
//            {
                [self initBasicDataInfo];
                [self isPhoneLogin];
//            }
//            else
//            {
//                [Common showBottomToast:@"请输入正确的验证码"];
//            }
//            
        }
        else{
            [Common showBottomToast:@"验证码不能为空"];
            
        }
    }
}
#pragma mark-退出之后进入的登陆界面：其他登录方式的微信登陆
- (IBAction)weixinBtnClick:(id)sender
{
    //    [self wxLogin];
}
#pragma mark- 积分商城
- (IBAction)integralMallBtnClick:(UIButton *)sender {
    if (sender.tag == 101) {
        [self pushWithVCClassName:@"IntegralMallHomeViewController" properties:@{@"title":@"积分商城"}];
    }
    if (sender.tag == 102) {
        [self pushWithVCClassName:@"JFIntegralOrderViewController" properties:@{@"title":@"积分订单"}];
    }
    if (sender.tag == 103) {
        [self pushWithVCClassName:@"ManJianViewController" properties:@{@"title":@"满减活动"}];
    }
    
}
@end

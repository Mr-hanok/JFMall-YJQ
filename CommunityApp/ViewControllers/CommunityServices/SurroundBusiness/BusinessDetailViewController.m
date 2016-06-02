//
//  BusinessDetailViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BusinessDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TQStarRatingView.h"
#import "BusinessUserEvaluateViewController.h"
#import "AGImagePickerViewController.h"
#import "WebViewController.h"
#import "BaiduMapViewController.h"


@interface BusinessDetailViewController ()
@property (retain, nonatomic) IBOutlet UIImageView *businessPic;
@property (retain, nonatomic) IBOutlet UILabel *businessName;
@property (retain, nonatomic) IBOutlet UILabel *businessAddr;
@property (retain, nonatomic) IBOutlet UILabel *businessTelno;
@property (retain, nonatomic) IBOutlet UILabel *businessDesc;
@property (retain, nonatomic) IBOutlet UIView *businessDescBgView;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) TQStarRatingView *startView;
@property (strong, nonatomic) IBOutlet UIView * startBgView;
@property (retain, nonatomic) IBOutlet UILabel *perComsumption;
@property (retain, nonatomic) IBOutlet UILabel *userAssess;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *businessNameWidth;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (strong,nonatomic)  SurroundBusinessModel* businessDetailModel;
//@property(nonatomic,strong)UIWebView*webViewCall;//用来打电话
@end

@implementation BusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Store_BusinessDetail;
    [self setNavBarLeftItemAsBackArrow];
    
    _startView  = [[TQStarRatingView alloc]initWithFrame:CGRectMake(104, 42, 18*5, 15)];
    _startView.isEdit = FALSE;
    [self.startBgView addSubview:self.startView];
    
    _vipBtn.layer.borderColor = Color_Orange_RGB.CGColor;
    _vipBtn.layer.borderWidth = 0.5;
    _vipBtn.layer.cornerRadius = 4;
    
    [self initBasicDataInfo];
    [self getBusinessDetailFromService];
}


#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    NSArray* imgsArray =  [self.businessModel.businessPicUrl componentsSeparatedByString:@","];
    if(imgsArray != nil && imgsArray.count > 0)
    {
        NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:[imgsArray objectAtIndex:0]]];
        [self.businessPic setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"BusinessDefaultImg"]];
    }
    
    CGFloat width = [Common labelDemandWidthWithText:self.businessModel.businessName font:[UIFont systemFontOfSize:15.0] size:CGSizeMake(Screen_Width-257, 21)];
    self.businessNameWidth.constant = width;
    
    NSString* price = self.businessModel.perConsumption;
    if ([price isEqualToString:@""]) {
        price = @"0.0";
    }
    [self.perComsumption setText:[ NSString stringWithFormat:@"￥%@/人",price]];
    [self.businessName setText:self.businessModel.businessName];
    [self.businessAddr setText:self.businessModel.address];
    [self.businessTelno setText:self.businessModel.phone];
    if ([self.businessModel.isVerified isEqualToString:@"1"]) {
        [_vipBtn setHidden:NO];
    }else {
        [_vipBtn setHidden:YES];
    }
    
//    [self.businessDesc setText:self.businessModel.label];
    NSArray *strings = [self.businessModel.label componentsSeparatedByString:@"|"];
    [self insertLabelForStrings:strings toView:self.labelView andMaxWidth:Screen_Width-114];
    
    if (self.businessModel.reviewNumber != nil && [self.businessModel.reviewNumber isEqualToString:@""]==FALSE) {
        [self.userAssess setText:[NSString stringWithFormat:@"用户评价(%@条)",self.businessModel.reviewNumber]];
    }
     [_startView setScore:(int)([self.businessModel.score floatValue] + 0.5)/kNUMBER_OF_STAR withAnimation:TRUE];
    self.headerView.frame = CGRectMake(0, 0, Screen_Width, 220);
    self.tableView.tableHeaderView = self.headerView;
    
    [self displayBusinessDetailInfo];
}


// 为指定字符串数组添加标签 For吃喝玩乐列表
-(void)insertLabelForStrings:(NSArray *)strings toView:(UIView *)view andMaxWidth:(CGFloat)maxWidth
{
    CGFloat labelHeight = 20.0;                 // 标签高度
    CGFloat labelMargin = 6.0;                  // 标签之间的Margin
    CGFloat additionalWidth = 6.0;              // label附加宽度
    UIFont  *font = [UIFont systemFontOfSize:13.0];  // 字体大小
    
    [Common insertLabelForStrings:strings toView:view andViewHeight:26.0 andMaxWidth:maxWidth andLabelHeight:labelHeight andLabelMargin:labelMargin andAddtionalWidth:additionalWidth andFont:font andBorderColor:Color_Comm_LabelBorder andTextColor:COLOR_RGB(120, 120, 120)];
}


// 从服务器上获取商品数据
- (void)getBusinessDetailFromService
{
    // 初始化参数
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.businessModel.businessId,projectId] forKeys:@[@"sellerId",@"projectId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:SurroundBusiness_Url path:SurroundBusinessDetail_Path method:@"GET" parameters:dic xmlParentNode:@"crmManageSeller" success:^(NSMutableArray *result) {
        for (NSDictionary *dic in result) {
            self.businessModel = [[SurroundBusinessModel alloc] initWithDictionary:dic];
        }
        [self initBasicDataInfo];
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

// 更新画面数据
- (void)displayBusinessDetailInfo
{
    
    // label自适应高度
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(Screen_Width-66,CGFLOAT_MAX);
   // self.businessDesc.frame = [Common labelDemandRectWithText:self.businessModel.descp font:font size:size];
    //[self.businessDesc setText:self.businessModel.descp];
    
    CGFloat height = 100.0;
//    if (self.businessDesc.frame.size.height > height) {
//        height = self.businessDesc.frame.size.height;
//    }
    
    self.footerView.frame = CGRectMake(0, 0, Screen_Width, height);
    self.tableView.tableFooterView = self.footerView;
    
    [self.tableView reloadData];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark--按钮点击
// 跳转到地图
- (IBAction)clickAddress:(id)sender
{
    if (self.businessModel == nil || [self.businessModel.address isEqualToString:@""]) {
        [Common showBottomToast:@"该商家没有地址信息"];
        return;
    }
    
    if (self.businessModel.latitude == nil || self.businessModel.longitude == nil || self.businessModel.address == nil || [self.businessModel.latitude isEqualToString:@""] || [self.businessModel.longitude isEqualToString:@""]) {
        [Common showBottomToast:@"该商家没有提供经纬度信息"];
        return;
    }
        
    BaiduMapViewController *vc = [[BaiduMapViewController alloc] init];
    vc.addr = [[AddressModel alloc] initWithLatitude:[self.businessModel.latitude floatValue] andLongitude:[self.businessModel.longitude floatValue] andAddrName:self.businessModel.address];
    [self.navigationController pushViewController:vc animated:YES];
}

// 拨打电话
- (IBAction)clickTelno:(id)sender
{
    if (self.businessModel == nil || [self.businessModel.phone isEqualToString:@""]) {
        return;
    }
    
    NSString *dialTel = [NSString stringWithFormat:@"tel://%@", self.businessModel.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialTel]];
    //打完电话可以返回到本程序
//    if (_webViewCall==nil) {
//        self.webViewCall=[[UIWebView alloc]initWithFrame:CGRectZero];
//    }
//    [_webViewCall loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dialTel]]];
}

// 用户评价
-(IBAction)clickUserEvaluate:(id)sender
{
    if (self.businessModel == nil || [self.businessModel.businessId isEqualToString:@""]) {
        return;
    }
    
    BusinessUserEvaluateViewController* vc = [[BusinessUserEvaluateViewController alloc]init];
    vc.sellerId = self.businessModel.businessId;
    [self.navigationController pushViewController:vc animated:TRUE];
}

// 图文详情
-(IBAction)clickImageDetail:(id)sender
{
    if (self.businessModel == nil || [self.businessModel.descp isEqualToString:@""]) {
        return;
    }
    
    WebViewController *vc = [[WebViewController alloc] init];
    vc.navTitle = Str_Comm_PicDetail;
    vc.url = [NSString stringWithFormat:@"%@%@",Service_Address, self.businessModel.descp];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

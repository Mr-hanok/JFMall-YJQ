//
//  DetailServiceViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//  服务详情

#import "DetailServiceViewController.h"
#import "ServiceOrderViewController.h"
#import "DetailServicePriceViewController.h"
#import "ServiceDetail.h"
#import "UIImageView+AFNetworking.h"
#import "DetailServiceTableViewCell.h"

#pragma mark - 宏定义区
#define DetailServiceTableViewCellNibName           @"DetailServiceTableViewCell"

@interface DetailServiceViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UIButton *myButton;
@property (retain, nonatomic) IBOutlet UIImageView *servicePicture;
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIButton *payTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceNameViewHight;

@property (retain, nonatomic) IBOutlet UILabel *servicePrice;
@property (retain, nonatomic) IBOutlet UILabel *serviceDetail;

@property (retain, nonatomic) ServiceDetail     *detail;

@end

@implementation DetailServiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Service_Detail;
    [self setNavBarLeftItemAsBackArrow];
    
    // 设置服务类型按钮的Border
    _payTypeBtn.layer.borderColor = COLOR_RGB(245, 164, 37).CGColor;
    _payTypeBtn.layer.borderWidth = 0.5;
    _payTypeBtn.layer.cornerRadius = 5.0;
    
    [self initBasicDataInfo];
    
    [_headerView setFrame:CGRectMake(0, 0, Screen_Width, (Screen_Width / 3.0))];
    _tableView.tableHeaderView = _headerView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 请求服务器获取数据
    [self getDataFromServer];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#pragma mark - tableview datasource delegate
// 设置Section的cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
//    return self.detail==nil?0:1;
}

// 装载Cell元素
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailServiceTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:DetailServiceTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:self.detail.serviceName];
    
    return cell;
}


#pragma mark - 按钮点击事件函数区域
/**
 * 跳转到我的报事页面
 */
- (IBAction)actionJumpToEditOrderInfo:(id)sender
{
    
    ServiceOrderViewController *next = [[ServiceOrderViewController alloc]init];
    next.serviceDetail = self.detail;
    [self.navigationController pushViewController:next animated:YES];
}
/**
 * 跳转到价格详情
 */
- (IBAction)actionJumpToPriceDetail:(id)sender
{
    DetailServicePriceViewController *next =[[DetailServicePriceViewController alloc]init];
    next.priceDesc = self.detail.priceDesc;
    [self.navigationController pushViewController:next animated:YES];
}



#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    // 注册TableViewCell Nib
    UINib *nib = [UINib nibWithNibName:DetailServiceTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:DetailServiceTableViewCellNibName];
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.serviceId] forKeys:@[@"goodsId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:DoorToDoorDetail_Url path:DoorToDoorDetail_Path method:@"GET" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
        for (NSDictionary *dic in result) {
            self.detail = [[ServiceDetail alloc] initWithDictionary:dic];
        }
        self.detail.serviceId = self.serviceId;
        [self displayServiceDetailInfo];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


// 更新画面数据
- (void)displayServiceDetailInfo
{
    [self.serviceName setText:self.detail.serviceName];
    
    // 定义标签数组
    if (self.detail.supportCoupons != nil && self.detail.supportCoupons.length > 0) {
        NSArray *strings = [self.detail.supportCoupons componentsSeparatedByString:@","];
        [Common insertLabelForStrings:strings toView:self.labelView andViewHeight:35.0 andMaxWidth:(Screen_Width-16) andLabelHeight:24 andLabelMargin:6 andAddtionalWidth:6 andFont:[UIFont systemFontOfSize:13.0] andBorderColor:Color_Comm_LabelBorder andTextColor:COLOR_RGB(120, 120, 120)];
    }

    
    // 付费类型
    if (self.detail.payService != nil && ![self.detail.payService isEqualToString:@""]) {
        [self.payTypeBtn setTitle:self.detail.payService forState:UIControlStateNormal];
        [self.payTypeBtn setHidden:NO];
    }else {
        [self.payTypeBtn setHidden:YES];
    }
    
    // 根据付费类型设置服务价格或价格描述
    if ([self.detail.payService isEqualToString:@"先付费"]) {
        [self.servicePrice setText: [NSString stringWithFormat:@"￥%@",self.detail.servicePrice]];
        [self.servicePrice setHidden:NO];
        [self.priceDetailBtn setHidden:YES];
    }else {
        [self.servicePrice setHidden:YES];
        [self.priceDetailBtn setHidden:NO];
    }
    
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:self.detail.servicePicUrl]];
    [self.servicePicture setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"WaresDetailDefaultImg"]];
//    NSData *data = [NSData dataWithContentsOfURL:iconUrl];
//    UIImage *img = [UIImage imageWithData:data];
//    if (img != nil) {
//        UIImage *scaledImg = [Common imageCompressForWidth:img targetWidth:Screen_Width];
//        CGFloat targetHight = scaledImg.size.height;
//        [self.servicePicture setImage:scaledImg];
//        [_headerView setFrame:CGRectMake(0, 0, Screen_Width, targetHight)];
//    }else {
//        [_headerView setFrame:CGRectMake(0, 0, Screen_Width, 0)];
//    }
//    self.tableView.tableHeaderView = _headerView;
    
    // label自适应高度
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(Screen_Width-30,CGFLOAT_MAX);
    CGRect frame = [Common labelDemandRectWithText:self.detail.serviceDesc font:font size:size];
    self.serviceDetail.frame = CGRectMake(15, 0, frame.size.width, frame.size.height) ;
    [self.serviceDetail setText:self.detail.serviceDesc];
    
    // footerView自适应高度
    CGFloat height = 35.0;
    if (self.serviceDetail.frame.size.height > height) {
        height = self.serviceDetail.frame.size.height;
    }
    self.footerView.frame = CGRectMake(0, 0, Screen_Width, height+179);
    self.tableView.tableFooterView = self.footerView;
    
    [self.tableView reloadData];
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

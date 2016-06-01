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
#import "PersonalCenterLoginViewController.h"


#pragma mark - 宏定义区
#define DetailServiceTableViewCellNibName           @"DetailServiceTableViewCell"

@interface DetailServiceViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UIButton *myButton;
@property (retain, nonatomic) IBOutlet UIImageView *servicePicture;

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
    
    [self initBasicDataInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 请求服务器获取数据
    [self getDataFromServer];
}
#pragma mark - tableview datasource delegate
// 设置Section的cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detail==nil?0:1;
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
    
    //self.headerView.frame = CGRectMake(0, 0, Screen_Width, 170);
  //  self.tableView.tableHeaderView = self.headerView;
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.serviceId] forKeys:@[@"serviceId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:ServiceDetail_Url path:ServiceDetail_Path method:@"GET" parameters:dic xmlParentNode:@"serviceType" success:^(NSMutableArray *result) {
        for (NSDictionary *dic in result) {
            self.detail = [[ServiceDetail alloc] initWithDictionary:dic];
        }
        [self displayServiceDetailInfo];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


// 更新画面数据
- (void)displayServiceDetailInfo
{
    [self.servicePrice setText: [NSString stringWithFormat:@"￥%@",self.detail.servicePrice]];
    
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:self.detail.servicePicUrl]];
    NSData *data = [NSData dataWithContentsOfURL:iconUrl];
    UIImage *img = [UIImage imageWithData:data];
    if (img != nil) {
        UIImage *scaledImg = [Common imageCompressForWidth:img targetWidth:Screen_Width];
        CGFloat targetHight = scaledImg.size.height;
        [self.servicePicture setImage:scaledImg];
   // [self.servicePicture setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
        [_headerView setFrame:CGRectMake(0, 0, Screen_Width, targetHight)];

    }
    _tableView.tableHeaderView = _headerView;
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
    self.footerView.frame = CGRectMake(0, 0, Screen_Width, height+109);
    self.tableView.tableFooterView = self.footerView;
    
    [self.tableView reloadData];
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

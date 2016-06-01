//
//  DetailServicePriceViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "DetailServicePriceViewController.h"

@interface DetailServicePriceViewController ()
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UILabel *priceDetail;


@end

@implementation DetailServicePriceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化导航栏信息
    self.navigationItem.title = Str_Service_PriceIntroduce;
    [self setNavBarLeftItemAsBackArrow];
    [self initBasicDataInfo];
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    // 请求服务器获取周边商家数据
    [self displayPriceDetailInfo];
    
    self.headerView.frame = CGRectMake(0, 0, Screen_Width, 10);
    self.tableView.tableHeaderView = self.headerView;
}


// 更新画面数据
- (void)displayPriceDetailInfo
{
    // label自适应高度
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(Screen_Width-20,CGFLOAT_MAX);
    self.priceDetail.frame = [Common labelDemandRectWithText:self.priceDesc font:font size:size];
    [self.priceDetail setText:self.priceDesc];
    
    // footerView自适应高度
    CGFloat height = 21.0;
    if (self.priceDetail.frame.size.height > height) {
        height = self.priceDetail.frame.size.height;
    }
    self.footerView.frame = CGRectMake(0, 0, Screen_Width, height+20);
    self.tableView.tableFooterView = self.footerView;
    
    [self.tableView reloadData];
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

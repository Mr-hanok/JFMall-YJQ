//
//  SurroundBusinessViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "SurroundBusinessViewController.h"
#import "SurroundBusinessTableViewCell.h"
#import "SurroundChoiceTableViewCell.h"
#import "BusinessDetailViewController.h"
#import "SurroundBusinessModel.h"
#import "MJRefresh.h"

#pragma mark - 宏定义区
#define SurroundBusinessTableViewCellNibName          @"SurroundBusinessTableViewCell"

@interface SurroundBusinessViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain) IBOutlet UITableView *tableView;

// 商家数据数组
@property (nonatomic, retain) NSMutableArray     *businessArray;


@end

@implementation SurroundBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Comm_SurroundBusiness;
    [self setNavBarLeftItemAsBackArrow];
    
    [self initBasicDataInfo];
    
    // 添加下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataFromServer];   // 请求服务器获取周边商家数据
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
}


#pragma mark - tableview datasource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.businessArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurroundBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SurroundBusinessTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.businessArray objectAtIndex:indexPath.row]];
    [cell setDialToStoreBlock:^{
        SurroundBusinessModel *model = [self.businessArray objectAtIndex:indexPath.row];
        NSString *dialTel = [NSString stringWithFormat:@"tel://%@", model.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialTel]];
    }];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessDetailViewController *vc = [[BusinessDetailViewController alloc] init];
    vc.businessModel = [self.businessArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.businessArray = [[NSMutableArray alloc] init];

    // 请求服务器获取周边商家数据
    [self getDataFromServer];
    
    // 注册TableViewCell Nib
    UINib *nibForBusiness = [UINib nibWithNibName:SurroundBusinessTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForBusiness forCellReuseIdentifier:SurroundBusinessTableViewCellNibName];
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.projectId] forKeys:@[@"projectId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:SurroundBusiness_Url path:SurroundBusiness_Path method:@"GET" parameters:dic xmlParentNode:@"crmManageSeller" success:^(NSMutableArray *result) {
        [self.businessArray removeAllObjects];
        for (NSDictionary *dic in result) {
            [self.businessArray addObject:[[SurroundBusinessModel alloc] initWithDictionary:dic]];
        }
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

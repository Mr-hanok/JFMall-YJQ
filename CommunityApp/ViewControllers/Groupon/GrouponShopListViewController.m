//
//  GrouponShopListViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/25.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponShopListViewController.h"
#import "GrouponShopListTableViewCell.h"


#pragma mark - 宏定义区
#define GrouponShopListTableViewCellNibName     @"GrouponShopListTableViewCell"


@interface GrouponShopListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *shopDataArray;

@end

@implementation GrouponShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏
    self.navigationItem.title = @"适用店铺";
    [self setNavBarLeftItemAsBackArrow];
    
    // 初始化基本信息
    [self initBasicDataInfo];
    
    // 从服务器获取数据
    [self getShopDataFromServer];
}

#pragma mark - 初始化基本信息
- (void)initBasicDataInfo
{
    self.shopDataArray = [[NSMutableArray alloc] init];
    
    // 注册cell
    UINib *nib = [UINib nibWithNibName:GrouponShopListTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:GrouponShopListTableViewCellNibName];
}


#pragma mark - 从服务器获取数据
- (void)getShopDataFromServer
{
    NSDictionary    *dic = [[NSDictionary alloc] initWithObjects:@[_goodsId] forKeys:@[@"goodsId"]];
    
    [self getArrayFromServer:GrouponShopList_Url path:GrouponShopList_Path method:@"GET" parameters:dic xmlParentNode:@"shop" success:^(NSMutableArray *result) {
        [self.shopDataArray removeAllObjects];
        for (NSDictionary *dic in result) {
            [self.shopDataArray addObject:[[GrouponShop alloc] initWithDictionary:dic]];
        }
        [self.tableView reloadData];
    }failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GrouponShopListTableViewCell *cell = (GrouponShopListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:GrouponShopListTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.shopDataArray objectAtIndex:indexPath.row]];
    
    [cell setDialToShopBlock:^(NSString *telno) {
        NSString *dialTel = [NSString stringWithFormat:@"tel://%@", telno];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialTel]];
    }];
    
    return cell;
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

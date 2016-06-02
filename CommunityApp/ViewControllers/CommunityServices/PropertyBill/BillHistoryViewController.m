//
//  BillHistoryViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BillHistoryViewController.h"
#import "BillHistoryTableViewCell.h"
#import "PaymentHistoryModel.h"
#import "LoginConfig.h"

#pragma mark - 宏定义区
#define BillHistoryTableViewCellNibName     @"BillHistoryTableViewCell"

@interface BillHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

// 物业缴费历史数据数组
@property (nonatomic, retain) NSMutableArray    *billHistoryArray;

@end

@implementation BillHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏
    self.navigationItem.title = @"缴费历史";
    [self setNavBarLeftItemAsBackArrow];
    
    [self initBasicDataInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview datasource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.billHistoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BillHistoryTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.billHistoryArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    // 测试数据 TODO
    NSArray *historys = @[@[@"现金",   @"123", @"2015-04-06"],
                          @[@"支付宝",  @"123", @"2015-04-06"],
                          @[@"银行转账", @"123", @"2015-04-06"],
                          @[@"现金",     @"456", @"2015-04-06"],
                          @[@"现金",     @"456", @"2015-04-06"],
                          @[@"银行转账", @"456", @"2015-03-06"],
                          @[@"银行转账", @"789", @"2015-04-06"],
                          @[@"银行转账", @"789", @"2015-04-06"]];
    self.billHistoryArray = [[NSMutableArray alloc] init];
    
    // 注册TableViewCell Nib
    UINib *nibForBillHistory = [UINib nibWithNibName:BillHistoryTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForBillHistory forCellReuseIdentifier:BillHistoryTableViewCellNibName];
    [self getBillHistoryListInfoFromServerForBuildingId:_buildingId];
}


// 从服务器获取账单历史
-(void)getBillHistoryListInfoFromServerForBuildingId:(NSString *)buildingId
{
    
   UserModel* user =  [[LoginConfig Instance] getUserInfo];
    if(user == nil)
    {
        return;
    }
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[buildingId,user.ownerPhone] forKeys:@[@"buildingId", @"phone"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:CommunityBill_Url path:PaymentHistoryList_Path method:@"GET" parameters:dic xmlParentNode:@"paymentRecord" success:^(NSMutableArray *result)
     {
         [_billHistoryArray removeAllObjects];
         for (NSDictionary *dicResult in result)
         {
             [self.billHistoryArray addObject:[[PaymentHistoryModel alloc] initWithDictionary:dicResult]];
         }
         
         [self.tableView reloadData];
     }
     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}

@end

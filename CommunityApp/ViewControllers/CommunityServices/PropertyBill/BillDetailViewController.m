//
//  BillDetailViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BillDetailViewController.h"
#import "BillDetailTableViewCell.h"
#import "BillListModel.h"


#pragma mark - 宏定义区
#define BillDetailTableViewCellNibName     @"BillDetailTableViewCell"


@interface BillDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *totalCost;
@property (weak, nonatomic) IBOutlet UILabel *paidCost;
// 物业缴费详情数据数组
@property (nonatomic, retain) NSMutableArray    *billDetailArray;
@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化导航栏信息
    self.navigationItem.title = Str_PropBill_BillDetail;
    [self setNavBarLeftItemAsBackArrow];
    
    [self initBasicDataInfo];
}


#pragma mark - tableview datasource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.billDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BillDetailTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.billDetailArray objectAtIndex:indexPath.row]];
    
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
    NSArray *details = @[@[@"电费  2015-04-06",   @"288", @"150"],
                         @[@"水费 2015-04-06",  @"123", @"230.50"],
                         @[@"水费 2015-04-06",  @"123", @"230.50"],
                         @[@"水费 2015-04-06",  @"123", @"230.50"],
                         @[@"水费 2015-04-06",  @"123", @"230.50"],
                         @[@"水费 2015-04-06",  @"123", @"230.50"],
                         @[@"水费 2015-04-06",  @"123", @"230.50"],
                         @[@"水费 2015-04-06",  @"123", @"230.50"]];
    self.billDetailArray = [[NSMutableArray alloc] init];
    
    // 注册TableViewCell Nib
    UINib *nibForDetail = [UINib nibWithNibName:BillDetailTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForDetail forCellReuseIdentifier:BillDetailTableViewCellNibName];
    
    self.footerView.frame = CGRectMake(0, 0, Screen_Width, 44);
    self.tableView.tableFooterView = self.footerView;
    [self getBillDetailInfoFromServiceWithBuilding:_buildingId];
    
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getBillDetailInfoFromServiceWithBuilding:(NSString*)buildingId
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[buildingId,[dateFormatter stringFromDate:[NSDate date]]] forKeys:@[@"buildingId ", @"date"]];//为什么buildingId key需要一个空格
    
    // 请求服务器获取数据
    [self getArrayFromServer:CommunityBill_Url  path:BillList_Path method:@"GET" parameters:dic xmlParentNode:@"bill" success:^(NSMutableArray *result)
     {
         [_billDetailArray removeAllObjects];
         for (NSDictionary *dicResult in result)
         {
             [self.billDetailArray addObject:[[BillListModel alloc] initWithDictionary:dicResult]];
         }
         [self freshPage];
     }
    failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}

-(void)freshPage
{
    [self.tableView reloadData];
    float totalCost = 0.0f;
    float payCost = 0.0f;
    for (BillListModel* model in _billDetailArray) {
       totalCost =  totalCost + [model.receivable floatValue];
        if ([model.settlementStatus isEqualToString:@"1"]) {
            payCost = payCost+[model.receivable floatValue];
        }
    }
    NSString* string = [NSString stringWithFormat:@"￥%.2f ",totalCost];
    [_totalCost setText:string];
    string = [NSString stringWithFormat:@"￥%.2f ",payCost];
    [_paidCost setText:string];
}
@end

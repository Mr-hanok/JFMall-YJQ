//
//  MyPostRepairFollowViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//  报事跟踪

#import "MyPostRepairFollowViewController.h"
#import "MyPostRepairFollowTableViewCell.h"

@interface MyPostRepairFollowViewController ()

//订单编号
@property (strong,nonatomic) IBOutlet UILabel *orderIdLebel;
@property (strong,nonatomic) IBOutlet UILabel *orderState;
@property (retain,nonatomic) NSMutableArray *myDataArray;
@end

@implementation MyPostRepairFollowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = Str_MyPostTracer_Title;
    [self setNavBarLeftItemAsBackArrow];
    
    self.myDataArray = [[NSMutableArray alloc]init];
    
    NSString *orderId = self.data.orderId;
    
    [self.orderIdLebel setText:self.data.orderNum];
    [self.orderState setText:self.data.state];
    [self initBasicDataInfo:orderId];
}


/**
 * 获取table view数据个数
 */
-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"MyPostRepairFollowTableViewCell";
    
    MyPostRepairFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellId owner:self options:nil]lastObject];
    }
    
    [cell loadCellData:[self.myDataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

/**
 * 初始化
 */
- (void)initBasicDataInfo:(NSString *)orderId
{
    // NSString *orderId = @"68cc691e-7561-4e25-8ed3-c1e938ef505e";
    [self.myDataArray removeAllObjects];
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId,@"orderId",nil];
    
    // 请求服务器获取数据
    [self getArrayFromServer:SelectCategory_Url path:MyPostRepair_Follow_Detail method:@"GET" parameters:dic xmlParentNode:@"result" success:^(NSMutableArray *result)
     {
         for (NSDictionary *dicResult in result)
         {
             [self.myDataArray addObject:[[OrderTrackModel alloc] initWithDictionary:dicResult]];
         }
         
         [self.myTableView reloadData];
     }
     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

//
//  PersonalCenterMyOrderTrackViewController.m
//  CommunityApp
//
//  Created by iss on 6/10/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderTrackViewController.h"
#import "PersonalCenterMyOrderTrackCell.h"
#import "OrderTrackModel.h"

@interface PersonalCenterMyOrderTrackViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray* array;
    NSMutableArray* orderTracks;
}
@property(strong,nonatomic)IBOutlet UITableView* table;
@property(strong,nonatomic)IBOutlet UILabel* Id;
@property(strong,nonatomic)IBOutlet UILabel* status;
@property(strong,nonatomic)IBOutlet UIImageView* tableFooter;
@property(nonatomic,copy)NSString* orderId;
@property(nonatomic,copy)NSString* orderNum;
@property(nonatomic,copy)NSString* orderState;
@property(nonatomic,assign)OrderTypeEnum orderType;
@end

@implementation PersonalCenterMyOrderTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title= Str_MyOrderTrack_Title;
    
    //
    array=@[@[@"2014-02-02 14:30",@"已分配服务人员(张三)",@"13921166655"],@[@"2014-02-02 13:30",@"订单已被接受，请等待发货",@""],@[@"2014-02-02 12:30",@"订单已被发出，请等待商家接受",@""],@[@"2014-02-02 12:30",@"订单已被发出",@"耐心等待"]];
    
  //  [self.table setTableFooterView:[self tableFooter]];
    orderTracks = [[NSMutableArray alloc]init];
    [self.Id setText:self.orderNum];
    [self.status setText:self.orderState];
    [self initBasicDataInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-init data
-(void)initData:(NSString*)orderId orderNum:(NSString*)orderNum orderState:(NSString*)orderState orderType:(OrderTypeEnum)orderType
{
    self.orderId = orderId;
    self.orderNum = orderNum;
    self.orderState = orderState;
    self.orderType = orderType;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 120.0;
    
    OrderTrackModel *model = [orderTracks objectAtIndex:indexPath.row];
    height = [Common labelDemandHeightWithText:model.trackDesc font:[UIFont systemFontOfSize:15.0] size:CGSizeMake(Screen_Width-20, CGFLOAT_MAX)];
    if (height < 20) {
        height = 120.0;
    }else {
        height +=70;
    }
    
    return height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify=@"PersonalCenterMyOrderTrackCell";
    PersonalCenterMyOrderTrackCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identify owner:self options:nil] lastObject];
    }
    [cell setCellText:[orderTracks objectAtIndex:indexPath.row]];
    return  cell;
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [orderTracks count];
}
#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    [orderTracks removeAllObjects];
    
 
    [self getDataFromServer];
    
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.orderId,@"orderId",nil];
    NSString* url = Commodity_OrderInfo_Url;
    NSString* path = Commodity_OrderTrack_Path;

    [self getArrayFromServer:url   path:path method:@"GET" parameters:dic xmlParentNode:@"result" success:^(NSMutableArray *result) {
        for (NSDictionary *dicResult in result)
        {
            
            [orderTracks addObject:[[OrderTrackModel alloc] initWithDictionary:dicResult]];
            
        }
        [_table reloadData];
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


@end

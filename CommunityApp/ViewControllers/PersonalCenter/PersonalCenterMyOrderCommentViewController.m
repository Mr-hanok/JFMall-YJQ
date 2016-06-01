//
//  PersonalCenterMyOrderCommentViewController.m
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderCommentViewController.h"
#import "PersonalCenterMyOrderCommentTableViewCell.h"
#import "PersonalCenterCommodityCommentViewController.h"

#define CELLNIBNAME @"PersonalCenterMyOrderCommentTableViewCell"
@interface PersonalCenterMyOrderCommentViewController ()<UITableViewDataSource,UITableViewDelegate,PersonalCenterMyOrderCommentDelegate>
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) id order;
@end

@implementation PersonalCenterMyOrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_OrderComment_Title;
    [self registNib];
    [self getDataFromServer];
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---other

//if (_orderType == OrderType_Commodity) {
//    data = [orderArray objectAtIndex:btn.tag];
//    
//}
//if (_orderType == OrderType_Commodity) {
//    data = [orderArray objectAtIndex:btn.tag];
//    
//}

-(void)getDataFromServer
{
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderId,@"orderId",nil];
//    if (_orderType == OrderType_Service) {
//        // 请求服务器获取数据
//        [self getArrayFromServer:Service_OrderInfo_Url path:Service_OrderDetail_Path method:@"GET" parameters:dic xmlParentNode:@"crmOrder" success:^(NSMutableArray *result) {
//            for (NSDictionary *dicResult in result)
//            {
//                
//                _order = [[ServiceOrderModel alloc] initWithDictionary:dicResult];
//            }
//             [_table reloadData];
//        } failure:^(NSError *error) {
//            [Common showBottomToast:Str_Comm_RequestTimeout];
//        }];
//    }
//    else
    if (_orderType == OrderType_Commodity || _orderType == OrderType_Service)
    {
        // 请求服务器获取数据
        [self getArrayFromServer:Commodity_OrderInfo_Url path:Commodity_OrderDetail_Path method:@"GET" parameters:dic xmlParentNode:@"crmOrder" success:^(NSMutableArray *result) {
            for (NSDictionary *dicResult in result)
            {
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithDictionary:dicResult];
                [dic setObject:@"1" forKey:@"isDetailMaterials"];
                _order = [[CommodityOrderDetailModel alloc] initWithDictionary:dic];
            }
            [_table reloadData];
            
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
    }

}
-(void)registNib
{
    UINib* nib = [UINib nibWithNibName:CELLNIBNAME bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:CELLNIBNAME];
}
#pragma mark---UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_order == nil)
        return 0;
    if ([_order isKindOfClass:[CommodityOrderDetailModel class]]) {
    
        CommodityOrderDetailModel* commodity = (CommodityOrderDetailModel*)_order;
        return commodity.orderBase.materialsArray.count;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalCenterMyOrderCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLNIBNAME];
    cell.delegate = self;
    if ([_order isKindOfClass:[CommodityOrderDetailModel class]]) {
        CommodityOrderDetailModel* commodity = (CommodityOrderDetailModel*)_order;
        materialsModel* material =  [commodity.orderBase.materialsArray objectAtIndex:indexPath.row];
        
        [cell setCanComment:!(material.CommodityReviews && [material.CommodityReviews isEqualToString:@"1"])];
        
        [cell loadCellData:material.CommodityName img:material.CommodityPic isButtom:indexPath.row == commodity.orderBase.materialsArray.count-1];
    }
    
    return cell; 
}
#pragma mark---PersonalCenterMyOrderCommentDelegate
-(void)toComment:(PersonalCenterMyOrderCommentTableViewCell*)cell
{
    NSIndexPath* index = [_table indexPathForCell:cell];
    PersonalCenterCommodityCommentViewController* vc = [[PersonalCenterCommodityCommentViewController alloc]init];
    CommodityOrderDetailModel* commodity = (CommodityOrderDetailModel*)_order;
    materialsModel* material =  [commodity.orderBase.materialsArray objectAtIndex:index.row];
    [vc loadBasicData:material.CommodityId andOrderId:commodity.orderBase.orderId];
    [self.navigationController pushViewController:vc animated:true];
}

@end

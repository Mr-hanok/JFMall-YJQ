//
//  MyCouponsRefundApplyViewController.m
//  CommunityApp
//
//  Created by iss on 8/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "MyCouponsRefundApplyViewController.h"
#import "AfterSaleDetail.h"
#import "AfterSaleHistoryViewController.h"

@interface MyCouponsRefundApplyViewController ()
@property (strong,nonatomic) IBOutlet UILabel* orderState;
@property (strong,nonatomic) IBOutlet UILabel* refundReason;
@property (strong,nonatomic) IBOutlet UILabel* refundGrouponId;
@property (strong,nonatomic) IBOutlet UILabel* refundMoney;
@property (strong,nonatomic) IBOutlet UILabel* lastHistoryTitle;
@property (strong,nonatomic) IBOutlet UILabel* lastHistoryTime;

@property (strong,nonatomic) NSString* orderId;
@property (strong,nonatomic) NSString* goodsId;
@property (strong,nonatomic) AfterSaleDetail* detail;
@end

@implementation MyCouponsRefundApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_MyCoupons_RefundApply_Title;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getRefundApplyDataFromServer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setApplyOrderId:(NSString*)orderId goodsId:(NSString*)goodsId
{
    _orderId = orderId;
    _goodsId = goodsId;
}
#pragma mark --- 从服务器获取数据

-(void)getRefundApplyDataFromServer
{
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:_orderId,@"orderId",_goodsId,@"goodsId", nil];
    [self getArrayFromServer:TbgAfterSaleDetail_Url path:TbgAfterSaleDetail_Path method:@"GET" parameters:dic xmlParentNode:@"tbgAfterSale" success:^(NSMutableArray *result) {
        if (result.count!=0) {
            _detail = [[AfterSaleDetail alloc] initWithDictionary:[result objectAtIndex:0]];
            [self freshPage];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    
}
#pragma mark --- other
-(void)freshPage
{
    [_orderState setText:_detail.afterSalesStateName];
    [_refundReason setText: _detail.afterSaleReasonId];
    [_refundGrouponId setText:[_detail.allTicketsNum substringToIndex:_detail.allTicketsNum.length-1]];
    [_refundMoney setText:_detail.refundAmount];
    [_lastHistoryTitle setText:_detail.latestActionTitle];
   // _lastHistoryTime;
}
#pragma mark---IBAction
-(IBAction)toHistory:(id)sender
{
    AfterSaleHistoryViewController* vc = [[AfterSaleHistoryViewController alloc]init];
    vc.afterSalesId = _detail.afterSalesId;
    [self.navigationController pushViewController:vc animated:TRUE];
}
@end

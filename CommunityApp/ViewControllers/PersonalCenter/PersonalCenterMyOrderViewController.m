//
//  PersonalCenterMyOrderViewController.m
//  CommunityApp
//
//  Created by iss on 6/9/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderViewController.h"
#import "PersonalCenterMyOrderCell.h"
#import "PersonalCenterMyOrderDetailViewController.h"
#import "PersonalCenterMyOrderTrackViewController.h"
#import "OrderModel.h"
#import "UserModel.h"
#import "PersonalCenterMyOrderFooterView.h"
#import "PersonalCenterMyOrderHeadView.h"
#import "PersonalCenterMyOrderCommentViewController.h"
#import "PayMethodViewController.h"
#import "PersonalCenterApplyRefundViewController.h"
#import "AfterSaleApplyViewController.h"
#import "AfterSaleCheckViewController.h"
#import <MJRefresh.h>
#import "CommitResultViewController.h"


#define pageSize 10
#define FooterNibName  @"PersonalCenterMyOrderFooterView"
#define CellNibName   @"PersonalCenterMyOrderCell"
@interface PersonalCenterMyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,PersonalCenterMyOrderFooterViewDelegate,PayMethodViewDelegate>
{
    NSArray* array;
    NSMutableArray* orderArray;
    NSInteger selIndex;
    BOOL isLoadServiceOk;
    BOOL isLoadCommodityOk;
    NSInteger scrollNum;
}
@property(nonatomic,strong)IBOutlet UITableView* table;
@property (weak, nonatomic)IBOutlet UIView *headerSelectorView;
@property(strong,nonatomic)IBOutlet UIButton* selBtn;
@property(strong,nonatomic)IBOutlet UIButton* unselBtn;
@property(strong,nonatomic)IBOutlet UIView* btnView;
@property (assign,nonatomic)NSInteger pageNum;
@end

@implementation PersonalCenterMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    array = @[@[@"2004-06-07 08:09",@"1",@"便民服务-开锁1",@"100",@"2"],@[@"2014-06-07 18:09",@"2",@"便民服务-开锁2",@"50",@"3"],@[@"2013-04-07 18:09",@"3",@"便民服务-开锁3",@"70",@"3"],@[@"2018-16-07 18:09",@"4",@"便民服务-开锁4",@"40",@"4"]];
    orderArray = [[NSMutableArray alloc]init];
    [self.btnView setFrame:CGRectMake(2, 5, Screen_Width-4, [self.btnView bounds].size.height)];
    [self.unselBtn setFrame:CGRectMake(0, 0, Screen_Width/2-2, [self.unselBtn bounds].size.height)];
    [self.selBtn setFrame:CGRectMake(Screen_Width/2-2, 0, Screen_Width/2-2, [self.unselBtn bounds].size.height)];
    [self.table setFrame:CGRectMake(0, [self.btnView bounds].size.height+2, Screen_Width, Screen_Height-[self.btnView bounds].size.height-Navigation_Bar_Height-2)];
    [self.unselBtn setSelected:TRUE];
    
    // 初始化导航栏样式
    [Common setRoundBorder:_headerSelectorView borderWidth:0.5 cornerRadius:5 borderColor:Color_Gray_RGB];
    _selBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _unselBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
    
    //设置导航栏
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title=Str_CommodityOrder;
    selIndex = 0;
    isLoadServiceOk = NO;
    isLoadCommodityOk = NO;
 
    [_table registerNib:[UINib nibWithNibName:FooterNibName bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:FooterNibName];
    [_table registerNib:[UINib nibWithNibName:CellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellNibName];

//    [self initBasicDataInfo];
    _pageNum = 1;
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getDataFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (orderArray.count == self.pageNum*pageSize) {
            self.pageNum++;
            [self getDataFromServer];
        }else{
            [self.table.footer endRefreshing];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.table.header = header;
    self.table.footer = footer;
    [self.table reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.pageNum = 1;
    //请求服务器获取物品数据
    [self getDataFromServer];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--table view
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(scrollNum>0){
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        scrollNum =0;
    }
    PersonalCenterMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellNibName];
    
    [cell setFrame:CGRectMake((Screen_Width-[cell bounds].size.width)/2, 0, [cell bounds].size.width, [cell bounds].size.height)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSObject* order = [orderArray objectAtIndex:indexPath.section];
    if ([order isKindOfClass:[CommodityOrderListModel class]]) {
        CommodityOrderListModel* data = (CommodityOrderListModel *)order;
        if (indexPath.row == data.orderBase.materialsArray.count-1) {
            [cell setCommodityCell:[data.orderBase.materialsArray objectAtIndex:indexPath.row] totalPrice:[NSString stringWithFormat:@"%.2f",data.payInfo.money.floatValue]];
            
        }
        else
        {
            [cell setCommodityCell:[data.orderBase.materialsArray objectAtIndex:indexPath.row] totalPrice:nil];
        }
    }
    else if([order isKindOfClass:[ServiceOrderModel class]])
    {
        [cell setServiceCell:(ServiceOrderModel *)order];
    }
//#pragma -mark 实物订单的上别
//    PersonalCenterMyOrderHeadView*head=[[PersonalCenterMyOrderHeadView alloc]init];
//    [head setViewFrame:CGRectMake(0, 0, _table.bounds.size.width,30)];
//    if ([order isKindOfClass:[CommodityOrderListModel class]]) {
//        CommodityOrderListModel* data = (CommodityOrderListModel *)order;
//        [head setHeadText:data.orderBase.createDate orderId:data.orderBase.orderNum   state:data.orderBase.state];
//#pragma -mark 11-27 订单编号为16位时隐藏退款按钮   _orderId
//        //11-27
////        head.orderstr = data.orderBase.orderNum;//获取订单编号
//        //11-27
//
//    }
//    
//    else if([order isKindOfClass:[ServiceOrderModel class]])
//    {
//        ServiceOrderModel* data = (ServiceOrderModel *)order;
//        [head setHeadText:data.orderBase.createDate orderId:data.orderBase.orderNum state:data.orderBase.state];
//    }
//
//    [cell addSubview:head];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [orderArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSObject* order = [orderArray objectAtIndex:section];
    if ([order isKindOfClass:[CommodityOrderListModel class]]) {
        CommodityOrderListModel* data = (CommodityOrderListModel*) order;
        return data.orderBase.materialsArray.count;
    }
    else if([order isKindOfClass:[ServiceOrderModel class]])
    {
        return 1;
    }
    return 0;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selerID = %d",1);
    
    PersonalCenterMyOrderDetailViewController* next = [[PersonalCenterMyOrderDetailViewController alloc]init];
    NSObject* order =  [orderArray objectAtIndex:indexPath.section];
    NSString* orderId  = 0;
    OrderTypeEnum orderType ;
    if ([order isKindOfClass:[CommodityOrderListModel class]]) {
        CommodityOrderListModel* data = (CommodityOrderListModel *)order;
        orderId = data.orderBase.orderId;
        orderType = OrderType_Commodity;
    }
    else if([order isKindOfClass:[ServiceOrderModel class]])
    {
        ServiceOrderModel* data = (ServiceOrderModel *)order;
        orderId = data.orderBase.orderId;
        orderType = OrderType_Service;
    }
    [next setOrderId:orderId orderType:orderType];
    [self.navigationController pushViewController:next animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSArray* btnArray = [self setFooterBtnClickWithSection:section];
    if(btnArray.count == 0)
        return 20;
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#pragma -mark 实物订单的上别
    NSObject* order = [orderArray objectAtIndex:section];
    PersonalCenterMyOrderHeadView*head=[[PersonalCenterMyOrderHeadView alloc]init];
    [head setViewFrame:CGRectMake(0, 0, _table.bounds.size.width,30)];
    if ([order isKindOfClass:[CommodityOrderListModel class]]) {
        CommodityOrderListModel* data = (CommodityOrderListModel *)order;
        [head setHeadText:data.orderBase.createDate orderId:data.orderBase.orderNum   state:data.orderBase.state];

    }
    else if([order isKindOfClass:[ServiceOrderModel class]])
    {
        ServiceOrderModel* data = (ServiceOrderModel *)order;
        [head setHeadText:data.orderBase.createDate orderId:data.orderBase.orderNum state:data.orderBase.state];
    }

    return head;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    NSObject* order = [orderArray objectAtIndex:section];
//    if ([order isKindOfClass:[CommodityOrderListModel class]]) {
//        CommodityOrderListModel* data = (CommodityOrderListModel *)order;
//#pragma -mark 11-27 订单编号为16位时隐藏退款按钮   _orderId
//        //11-27
//        data.orderstr = data.orderBase.orderNum;//获取订单编号
//        //11-27
//        
//    }
    NSArray* btnArray = [self setFooterBtnClickWithSection:section];
    if (btnArray.count == 0) {
        static NSString* footerLine = @"footerLine";
       UIView*  view =  [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerLine];
        if(view == nil)
        {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _table.bounds.size.width, 10)];
            UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _table.bounds.size.width, 5)];
            [img setImage:[UIImage imageNamed:@"MyOrderFooter"]];
            [view addSubview:img];
        }
        return view;
    }
    PersonalCenterMyOrderFooterView* footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FooterNibName];
    
    [footer setViewWithTag:section];
    footer.delegate = self;
    footer.btnArray = [self setFooterBtnClickWithSection:section];

    return footer;
}

- (void)setUIBtnClickState {
    _selBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _unselBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    if (_selBtn.selected){
        _selBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
    }
    else if (_unselBtn.selected){
        _unselBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
    }
}

#pragma mark--IBAction
//已完成
- (IBAction)selBtnClick:(UIButton *)sender {

    [self.selBtn setSelected:TRUE];
    [self.unselBtn setSelected:NO];
    [self setUIBtnClickState];
    [self initBasicDataInfo];
}
//未完成
- (IBAction)unselBtnClick:(id)sender {

    [self.selBtn setSelected:NO];
    [self.unselBtn setSelected:TRUE];
    [self setUIBtnClickState];
    [self initBasicDataInfo];
}
-(NSString*)getOrderIdWithSection:(NSInteger)section
{
    NSString* orderId;
    if (_orderType == OrderType_Commodity) {
        CommodityOrderListModel* commodity = [orderArray objectAtIndex:section];
        orderId = commodity.orderBase.orderId;
    }
    if (_orderType == OrderType_Service) {
        ServiceOrderModel* service = [orderArray objectAtIndex:section];
        orderId = service.orderBase.orderId;
        
    }
    
    return orderId;
}
-(NSString*)getOrderNoWithSection:(NSInteger)section
{
    NSString* orderNo;
    if (_orderType == OrderType_Commodity) {
        CommodityOrderListModel* commodity = [orderArray objectAtIndex:section];
        orderNo = commodity.orderBase.orderNum;
    }
    if (_orderType == OrderType_Service) {
        ServiceOrderModel* service = [orderArray objectAtIndex:section];
        orderNo = service.orderBase.orderNum;
        
    }
    
    return orderNo;
}
-(void)toRefundDetail:(id)Sender
{
    UIButton* btn = (UIButton*)Sender;
    AfterSaleCheckViewController* vc = [[AfterSaleCheckViewController alloc]init];
    NSString* orderId;
    NSString* goodsId = @"";
    NSString *moduleType = @"";
    if (_orderType == OrderType_Service) {
        ServiceOrderModel* service = [orderArray objectAtIndex:btn.tag];
        orderId = service.orderBase.orderId;
    }
    else if(_orderType == OrderType_Commodity){
        CommodityOrderListModel* commdity = [orderArray objectAtIndex:btn.tag];
        orderId = commdity.orderBase.orderId;
        moduleType = commdity.moduleType;
    }
    [vc setOrderId:orderId andGoodsId:goodsId];
    vc.moduleType = moduleType;
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(void)toPay:(id)Sender
{
    UIButton* btn = (UIButton*)Sender;
    selIndex = btn.tag;
    PayMethodViewController* vc = [[PayMethodViewController alloc]init];
    vc.orderId = [self getOrderNoWithSection:btn.tag];
    if (_orderType == OrderType_Service) {
        ServiceOrderModel* service = [orderArray objectAtIndex:btn.tag];
        vc.amount = [service.payInfo.money floatValue];
    }else if(_orderType == OrderType_Commodity){
        CommodityOrderListModel* commdity = [orderArray objectAtIndex:btn.tag];
        vc.amount = [commdity.payInfo.money floatValue];
    }
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(void)toRefund:(id)Sender
{
    UIButton* btn = (UIButton*)Sender;
    
    AfterSaleApplyViewController* vc = [[AfterSaleApplyViewController alloc]init];
    AfterSaleApplyModel* refund = [[AfterSaleApplyModel alloc]init];
    vc.asModel = refund;
    
     if (_orderType == OrderType_Service) {
         ServiceOrderModel* service = [orderArray objectAtIndex:btn.tag];
         
         refund.orderId = service.orderBase.orderId;
         refund.refundAmount = service.payInfo.money;
         refund.afterSalesType = OnlyRefund;
     }
     else if(_orderType == OrderType_Commodity){
         CommodityOrderListModel* commdity = [orderArray objectAtIndex:btn.tag];
        // refund.sellerId =  commdity.orderBase.sellerId;
         refund.orderId = commdity.orderBase.orderId;
         refund.refundAmount = commdity.payInfo.money;
         if ([commdity.orderBase.state isEqualToString:@"待发货"])//已付款
         {
             refund.afterSalesType = OnlyRefund;
         }else  if ([commdity.orderBase.state isEqualToString:@"待收货"]){
             refund.afterSalesType = ReturnAndRefund;
         }
     }
    [self.navigationController pushViewController:vc animated:TRUE];
 
    
}
-(void)toTrace:(id)Sender
{
    UIButton* btn = (UIButton*)Sender;
    [self toTrackOrder:btn.tag];
}
-(void)toComment:(id)Sender
{
    UIButton* btn = (UIButton*)Sender;
    PersonalCenterMyOrderCommentViewController* vc = [[PersonalCenterMyOrderCommentViewController alloc]init];
    NSString* orderId = [self getOrderIdWithSection:btn.tag];
    vc.orderId = orderId;
    vc.orderType = _orderType;
    [self.navigationController pushViewController:vc animated:TRUE];
    
}
-(void)toAccepted:(id)Sender
{
    UIButton* btn = (UIButton*)Sender;
    NSString* orderId = [self getOrderIdWithSection:btn.tag];
    if(orderId==nil)
        return;
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:orderId,@"orderId", nil];
    // 请求服务器获取数据
    [self getStringFromServer:Commodity_OrderInfo_Url path:Commodity_OrderConfirm_Path method:@"GET" parameters:dic   success:^(NSString *result) {
        [self getDataFromServer];
        }
      failure:^(NSError *error) {
         [Common showBottomToast:Str_Comm_RequestTimeout];
        }
     ];
}
-(void)toCancel:(id)Sender
{
    UIButton* btn = (UIButton*)Sender;
    [self toDeleteOrder:btn.tag];
}
#pragma mark---PayMethodViewDelegate
-(void)paymentOkTodo
{
    NSString* orderId=[self getOrderIdWithSection:selIndex];
    NSString* orderNo=[self getOrderNoWithSection:selIndex];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *path = PaySuccessServiceOrder_Path;
    if (_orderType == OrderType_Commodity) {
        path = PayOrderSuccess_Path;
        [dic setValue:orderNo forKey:@"orderNo"];
    }else if (_orderType == OrderType_Service) {
        path = PaySuccessServiceOrder_Path;
        [dic setValue:orderId forKey:@"orderId"];
    }
    if ([path isEqualToString:PayOrderSuccess_Path]) {
        [self getArrayFromServer:SubmitOrder_Url path:PayOrderSuccess_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
            NSDictionary *resultDic = [result firstObject];
            if ([resultDic[@"result"] isEqualToString:@"0"]) {
                [Common showBottomToast:@"提交订单失败"];
                return ;
            }else {
                CommitResultViewController *vc = [[CommitResultViewController alloc] init];
                vc.eFromViewID = E_ResultViewFromViewID_SubmitCommodityOrder;
                vc.resultTitle = @"支付成功";
                vc.resultDesc = [NSString stringWithFormat:@"订单编号:%@", orderNo];
                vc.couponsStr = resultDic[@"coupons"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
    }
    else {
        [self getStringFromServer:SubmitOrder_Url path:path method:@"POST" parameters:dic success:^(NSString *result) {
            if ([result isEqualToString:@"0"]) {
                return ;
            }else {
                CommitResultViewController *vc = [[CommitResultViewController alloc] init];
                vc.resultTitle = @"支付成功";
                vc.resultDesc = [NSString stringWithFormat:@"订单编号:%@", orderNo];
                if (_orderType == OrderType_Commodity) {
                    vc.eFromViewID = E_ResultViewFromViewID_SubmitCommodityOrder;
                }else if (_orderType == OrderType_Service) {
                    vc.eFromViewID = E_ResultViewFromViewID_SubmitServiceOrder;
                }
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
    }

}
-(void)paymentFailTodo
{
    
}
#pragma mark--PersonalCenterMyOrderCellDelegate
- (NSArray*)setFooterBtnClickWithSection:(NSInteger)section
{
//    NSSelectorFromString(@"");
    NSObject* order = [orderArray objectAtIndex:section];
    if ([order isKindOfClass:[CommodityOrderListModel class]]) {
        CommodityOrderListModel* data = (CommodityOrderListModel *)order;
#pragma -mark 11-27 订单编号为16位时隐藏退款按钮   _orderId
        //11-27
        self.orderstr = data.orderBase.orderNum;//获取订单编号
        //11-27
        
    }
    NSMutableArray* btnArray = [[NSMutableArray alloc]init];
    if(section>=orderArray.count)
        return btnArray;
    if (_orderType == OrderType_Service) {//服务订单
       
        ServiceOrderModel* serviceOrder = [orderArray objectAtIndex:section];
        if([serviceOrder.payInfo.payment isEqualToString:@"0"])//先付费服务
        {
            if([serviceOrder.payInfo.ifPay isEqualToString:@"0"] && ![serviceOrder.orderBase.state isEqualToString:@"已关闭"])//未付款

            {
                NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                [fixBtn setObject:Str_Order_ToPay forKey:@"text"];
                [fixBtn setObject:@"toPay:" forKey:@"function"];
                [btnArray addObject:fixBtn];
                NSMutableDictionary* leftBtn = [[NSMutableDictionary alloc]init];
                [leftBtn setObject:Str_Order_Cancel forKey:@"text"];
                [leftBtn setObject:@"toCancel:" forKey:@"function"];

                    [btnArray addObject:fixBtn];

            }
            else
            {
                // 未处理，处理中，已完成,已取消
                if([serviceOrder.orderBase.state isEqualToString:@"已关闭"])
                {
                    NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                    if ([serviceOrder.payInfo.asState isEqualToString:@"0"]) {
                        [fixBtn setObject:Str_Order_Refund forKey:@"text"];//退款
                        [fixBtn setObject:@"toRefund:" forKey:@"function"];
                    }else if ([serviceOrder.payInfo.asState isEqualToString:@"1"]){
                        [fixBtn setObject:Str_Order_Refund_In forKey:@"text"];
                        [fixBtn setObject:@"toRefundDetail:" forKey:@"function"];
                    }else if ([serviceOrder.payInfo.asState isEqualToString:@"2"]){
                        [fixBtn setObject:Str_Order_Refund_Reject forKey:@"text"];
                        [fixBtn setObject:@"toRefundDetail:" forKey:@"function"];
                    }else if ([serviceOrder.payInfo.asState isEqualToString:@"3"]){
                        [fixBtn setObject:Str_Order_Refund_Agree forKey:@"text"];
                        [fixBtn setObject:@"toRefundDetail:" forKey:@"function"];
                    }else if ([serviceOrder.payInfo.asState isEqualToString:@"4"]){
                        [fixBtn setObject:Str_Order_Refund_In forKey:@"text"];
                        [fixBtn setObject:@"toRefundDetail:" forKey:@"function"];
                    }else if([serviceOrder.payInfo.asState isEqualToString:@"5"]){
                        [fixBtn setObject:Str_Order_Refund_OK forKey:@"text"];
                        [fixBtn setObject:@"toRefundDetail:" forKey:@"function"];
                    }
//11-27
                  //  if (self.orderstr.length != 16) {
                        [btnArray addObject:fixBtn];
                   // }
//11-27
                }else if([serviceOrder.orderBase.state isEqualToString:@"待处理"])
                {
                    NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                    [fixBtn setObject:Str_Order_Cancel forKey:@"text"];
                    [fixBtn setObject:@"toCancel:" forKey:@"function"];
                    //11-27
                   // if (self.orderstr.length != 16) {
                        [btnArray addObject:fixBtn];
                    //}
                    //11-27
                }
                else if([serviceOrder.orderBase.state isEqualToString:@"处理中"])
                {
                    NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                    [fixBtn setObject:Str_Order_Trace forKey:@"text"];
                    [fixBtn setObject:@"toTrace:" forKey:@"function"];
                    [btnArray addObject:fixBtn];
                }
                else if([serviceOrder.orderBase.state isEqualToString:@"已完成"])
                {
                    if([serviceOrder.orderBase.reviews isEqualToString:@"1"])//可以评价
                    {
//                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
//                        [fixBtn setObject:Str_Order_Comment forKey:@"text"];
//                        [fixBtn setObject:@"toComment:" forKey:@"function"];
                        //11-27---11-29
                        if (self.orderstr.length != 16) {
//                            [btnArray addObject:fixBtn];
                        }
                        //11-27----11-29
                    }
                    else //已评价
                    {
//                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
//                        [fixBtn setObject:Str_Order_Commented forKey:@"text"];
                        //11-27
                        //if (self.orderstr.length != 16) {
//                            [btnArray addObject:fixBtn];
                        //}
                        //11-27
                    }
                }
            }
        }
        else//后付费服务
        {
            if([serviceOrder.payInfo.ifPay isEqualToString:@"0"])//未付款
            {
                // 未处理，处理中，已完成,已取消
                 if([serviceOrder.orderBase.state isEqualToString:@"待处理"])
                {
                    NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                    [fixBtn setObject:Str_Order_Cancel forKey:@"text"];
                    [fixBtn setObject:@"toCancel:" forKey:@"function"];
                    //11-27
                   // if (self.orderstr.length != 16) {
                        [btnArray addObject:fixBtn];
                   // }
                    //11-27
                }
                else if([serviceOrder.orderBase.state isEqualToString:@"处理中"])
                {
                    NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                    [fixBtn setObject:Str_Order_Trace forKey:@"text"];
                    [fixBtn setObject:@"toTrace:" forKey:@"function"];
                    //11-27
                   // if (self.orderstr.length != 16) {
                        [btnArray addObject:fixBtn];
                    //}
                    //11-27
                }
                else if([serviceOrder.orderBase.state isEqualToString:@"待付款"])
                {
                    NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                    [fixBtn setObject:Str_Order_ToPay forKey:@"text"];
                    [fixBtn setObject:@"toPay:" forKey:@"function"];
                    //11-27
                   // if (self.orderstr.length != 16) {
                        [btnArray addObject:fixBtn];
                    //}
                    //11-27
                }

                else if([serviceOrder.orderBase.state isEqualToString:@"已完成"])
                {
                    if([serviceOrder.orderBase.reviews isEqualToString:@"1"])//可以评价
                    {
//                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
//                        [fixBtn setObject:Str_Order_Comment forKey:@"text"];
//                        [fixBtn setObject:@"toComment:" forKey:@"function"];
                        //11-27
                       // if (self.orderstr.length != 16) {
//                            [btnArray addObject:fixBtn];
                        //}
                        //11-27
                        
                    }
//                    NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
//                    [fixBtn setObject:Str_Order_ToPay forKey:@"text"];
//                    [fixBtn setObject:@"toPay:" forKey:@"function"];
//                    [btnArray addObject:fixBtn];
                    else //已评价
                    {
//                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
//                        [fixBtn setObject:Str_Order_Commented forKey:@"text"];
                        //11-27
                       // if (self.orderstr.length != 16) {
//                            [btnArray addObject:fixBtn];
                        //}
                        //11-27
                    }
                }
               
            }
            else
            {
                if([serviceOrder.orderBase.state isEqualToString:@"已完成"])
                {
                    if([serviceOrder.orderBase.reviews isEqualToString:@"1"])//可以评价
                    {
//                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
//                        [fixBtn setObject:Str_Order_Comment forKey:@"text"];
//                        [fixBtn setObject:@"toComment:" forKey:@"function"];
                        //11-27
                        //if (self.orderstr.length != 16) {
//                            [btnArray addObject:fixBtn];
                        //}
                        //11-27
                    }
                    else //已评价
                    {
//                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
//                        [fixBtn setObject:Str_Order_Commented forKey:@"text"];
                        //11-27
                        //if (self.orderstr.length != 16) {
//                            [btnArray addObject:fixBtn];
                        //}
                        //11-27
                    }
                }
            }
        }
       
    }
    else if(_orderType == OrderType_Commodity)//实物订单
    {
        CommodityOrderListModel* commodityOrder = [orderArray objectAtIndex:section];
        if([commodityOrder.payInfo.payment isEqualToString:@"0"])//在线支付
        {
            if([commodityOrder.payInfo.ifPay isEqualToString:@"0"])//未付款
            {
                
                if([commodityOrder.orderBase.state isEqualToString:@"待付款"])
                {
                    NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                    [fixBtn setObject:Str_Order_ToPay forKey:@"text"];
                    [fixBtn setObject:@"toPay:" forKey:@"function"];
                    [btnArray addObject:fixBtn];
                    NSMutableDictionary* leftBtn = [[NSMutableDictionary alloc]init];
                    [leftBtn setObject:Str_Order_Cancel forKey:@"text"];
                    [leftBtn setObject:@"toCancel:" forKey:@"function"];

                   // [btnArray addObject:fixBtn];
                    [btnArray addObject:leftBtn];
                }
            }
            else//已支付
            {


                if(_selBtn.selected == TRUE) //已完成
                {
                    //if([commodityOrder.orderBase.stateId isEqualToString:@"3"])//（1未处理2处理中3已完成4已取消）
                    {
                        //0.未申请、1.申请中、2.已拒绝、3.已通过、4.已撤销、5.已完成
                         NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                        NSMutableDictionary* trackFix = [[NSMutableDictionary alloc]init];
                        if([commodityOrder.payInfo.asState isEqualToString:@"0"])
                        {
                            // 虚拟商品不能退款；中秋福利券不能退款（订单订单号为16位长）
                            if (self.orderstr.length != 16 && ![commodityOrder.orderBase.orderType isEqualToString:@"2"]) {
                                [fixBtn setObject:Str_Order_Refund forKey:@"text"];
                                [fixBtn setObject:@"toRefund:" forKey:@"function"];
                                [btnArray addObject:fixBtn];
                            }
                            
                            if (![commodityOrder.orderBase.orderType isEqualToString:@"2"]) {
                                [trackFix setObject:Str_Order_Trace forKey:@"text"];
                                [trackFix setObject:@"toTrace:" forKey:@"function"];
                                [btnArray addObject:trackFix];
                            }
                        }
                        else
                        {
                            [fixBtn setObject:@"toRefundDetail:" forKey:@"function"];
                            
                            if([commodityOrder.payInfo.asState isEqualToString:@"1"])
                            {
                                [fixBtn setObject:Str_Order_Refund_In forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"2"])
                            {
                                [fixBtn setObject:Str_Order_Refund_Reject forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"3"])
                            {
                                [fixBtn setObject:Str_Order_Refund_Agree forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"4"])
                            {
                                [fixBtn setObject:Str_Order_Refund_Cancel forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"5"])
                            {
                                [fixBtn setObject:Str_Order_Refund_OK forKey:@"text"];
                            }
                            [btnArray addObject:fixBtn];
                        }

                        

                        if([commodityOrder.payInfo.asState isEqualToString:@"4"]==false &&[commodityOrder.payInfo.asState isEqualToString:@"5"] == false && [commodityOrder.payInfo.asState isEqualToString:@"2"]==false)
                        {
                             if([commodityOrder.orderBase.reviews isEqualToString:@"1"])//可以评价
                             {
//                                 NSMutableDictionary* leftBtn = [[NSMutableDictionary alloc]init];
//                                 [leftBtn setObject:Str_Order_Comment forKey:@"text"];
//                                 [leftBtn setObject:@"toComment:" forKey:@"function"];
//#pragma -mark 已完成订单的左边的评价按钮
//                                   //  [btnArray addObject:fixBtn];
//                                 [btnArray addObject:leftBtn];

                             }
                             else //已评价
                             {
//                                 NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
//                                 [fixBtn setObject:Str_Order_Commented forKey:@"text"];
//                                 [btnArray addObject:fixBtn];

                             }
                        }
                    }
//                    else if([commodityOrder.orderBase.stateId isEqualToString:@"4"])//（1未处理2处理中3已完成4已取消）
//                    {
//                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
//                        [fixBtn setObject:Str_Order_Refund forKey:@"text"];
//                        [fixBtn setObject:@"toRefund:" forKey:@"function"];
//                        [btnArray addObject:fixBtn];
//
//                    }
                }
               // else 未完成
                {
                    //（待发货，待收货，待付款）
                    if([commodityOrder.orderBase.state isEqualToString:@"待发货"])
                    {
                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                        if([commodityOrder.payInfo.asState isEqualToString:@"0"])
                        {
                            // 虚拟商品不能退款；中秋福利券不能退款（实物订单订单号为16位长）
                            if (self.orderstr.length != 16 && ![commodityOrder.orderBase.orderType isEqualToString:@"2"] ) {
                                [fixBtn setObject:Str_Order_Refund forKey:@"text"];
                                [fixBtn setObject:@"toRefund:" forKey:@"function"];
                                [btnArray addObject:fixBtn];
                            }
                        }
                        else
                        {
                            [fixBtn setObject:@"toRefundDetail:" forKey:@"function"];
                            
                            if([commodityOrder.payInfo.asState isEqualToString:@"1"])
                            {
                                [fixBtn setObject:Str_Order_Refund_In forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"2"])
                            {
                                [fixBtn setObject:Str_Order_Refund_Reject forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"3"])
                            {
                                [fixBtn setObject:Str_Order_Refund_Agree forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"4"])
                            {
                                [fixBtn setObject:Str_Order_Refund_Cancel forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"5"])
                            {
                                [fixBtn setObject:Str_Order_Refund_OK forKey:@"text"];
                            }
                            [btnArray addObject:fixBtn];

                        }

#pragma mark-付款后没有取消订单按钮 11.25

                        if (![commodityOrder.orderBase.orderType isEqualToString:@"2"]) {
                            NSMutableDictionary* leftBtn = [[NSMutableDictionary alloc]init];
                            [leftBtn setObject:Str_Order_Trace forKey:@"text"];
                            [leftBtn setObject:@"toTrace:" forKey:@"function"];
                            [btnArray addObject:leftBtn];
                        }
                    } else if([commodityOrder.orderBase.state isEqualToString:@"待收货"])
                    {
                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                        [fixBtn setObject:Str_Order_Accepted forKey:@"text"];
                        [fixBtn setObject:@"toAccepted:" forKey:@"function"];

                            [btnArray addObject:fixBtn];
                        
                        if (![commodityOrder.orderBase.orderType isEqualToString:@"2"]) {
                            NSMutableDictionary* leftBtn = [[NSMutableDictionary alloc]init];
                            [leftBtn setObject:Str_Order_Trace forKey:@"text"];
                            [leftBtn setObject:@"toTrace:" forKey:@"function"];
                            [btnArray addObject:leftBtn];
                        }
                    }
                }
            }
        }
        else//货到付款---线下交易
        {
            //（待发货，待收货，待付款）
            if([commodityOrder.payInfo.ifPay isEqualToString:@"0"]) //线下交易未付款
            {
                if([commodityOrder.orderBase.state isEqualToString:@"待发货"])
                {
                    if (![commodityOrder.orderBase.orderType isEqualToString:@"2"]) {
                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                        [fixBtn setObject:Str_Order_Trace forKey:@"text"];
                        [fixBtn setObject:@"toTrace:" forKey:@"function"];
                        [btnArray addObject:fixBtn];
                    }
                    NSMutableDictionary* leftBtn = [[NSMutableDictionary alloc]init];
                    [leftBtn setObject:Str_Order_Cancel forKey:@"text"];
                    [leftBtn setObject:@"toCancel:" forKey:@"function"];
                    [btnArray addObject:leftBtn];
                }
                else if([commodityOrder.orderBase.state isEqualToString:@"待收货"])
                {
                    NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                    [fixBtn setObject:Str_Order_Accepted forKey:@"text"];
                    [fixBtn setObject:@"toAccepted:" forKey:@"function"];
                        [btnArray addObject:fixBtn];
                    
                    if (![commodityOrder.orderBase.orderType isEqualToString:@"2"]) {
                        NSMutableDictionary* leftBtn = [[NSMutableDictionary alloc]init];
                        [leftBtn setObject:Str_Order_Trace forKey:@"text"];
                        [leftBtn setObject:@"toTrace:" forKey:@"function"];
                        [btnArray addObject:leftBtn];
                    }
                }
                else if([commodityOrder.orderBase.state isEqualToString:@"待收款"])
                {
                    if (![commodityOrder.orderBase.orderType isEqualToString:@"2"]) {
                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                        [fixBtn setObject:Str_Order_Trace forKey:@"text"];
                        [fixBtn setObject:@"toTrace:" forKey:@"function"];

                        [btnArray addObject:fixBtn];
                    }
                }

            }
            else //线下交易已付款
            {
                if(_selBtn.selected == TRUE)//已完成
                {
                    //if([commodityOrder.orderBase.stateId isEqualToString:@"3"])//（1未处理2处理中3已完成4已取消）
                    {
                        //0.未申请、1.申请中、2.已拒绝、3.已通过、4.已撤销、5.已完成
                        NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
                        if([commodityOrder.payInfo.asState isEqualToString:@"0"])
                        {
                            if (self.orderstr.length != 16 && ![commodityOrder.orderBase.orderType isEqualToString:@"2"]) {
                                [fixBtn setObject:Str_Order_Refund forKey:@"text"];
                                [fixBtn setObject:@"toRefund:" forKey:@"function"];
                                [btnArray addObject:fixBtn];
                            }
                        }
                        else
                        {
                            if([commodityOrder.payInfo.asState isEqualToString:@"1"])
                            {
                                [fixBtn setObject:Str_Order_Refund_In forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"2"])
                            {
                                [fixBtn setObject:Str_Order_Refund_Reject forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"3"])
                            {
                                [fixBtn setObject:Str_Order_Refund_Agree forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"4"])
                            {
                                [fixBtn setObject:Str_Order_Refund_Cancel forKey:@"text"];
                            }
                            else if([commodityOrder.payInfo.asState isEqualToString:@"5"])
                            {
                                [fixBtn setObject:Str_Order_Refund_OK forKey:@"text"];
                            }

                            [fixBtn setObject:@"toRefundDetail:" forKey:@"function"];
                            [btnArray addObject:fixBtn];
                        }
                        

                        if([commodityOrder.payInfo.asState isEqualToString:@"4"]==false &&[commodityOrder.payInfo.asState isEqualToString:@"5"] == false)
                        {
                             if([commodityOrder.orderBase.reviews isEqualToString:@"1"])//可以评价
                             {
//                                 NSMutableDictionary* leftBtn = [[NSMutableDictionary alloc]init];
//                                 [leftBtn setObject:Str_Order_Comment forKey:@"text"];
//                                 [leftBtn setObject:@"toComment:" forKey:@"function"];
//                                 [btnArray addObject:leftBtn];
                             }
                             else //已评价
                             {
//                                 NSMutableDictionary* fixBtn = [[NSMutableDictionary alloc]init];
//                                 [fixBtn setObject:Str_Order_Commented forKey:@"text"];
//
//                                     [btnArray addObject:fixBtn];

                             }
                        }
                    }
                }
            }
        }
    }
    return btnArray;
}


-(void)toTrackOrder:(NSInteger)orderIndex
{
    NSObject* order = [orderArray objectAtIndex:orderIndex];
    if(order==nil)
        return;
    PersonalCenterMyOrderTrackViewController* next = [[PersonalCenterMyOrderTrackViewController alloc]init];
    if ([order isKindOfClass:[CommodityOrderListModel class]]) {
        CommodityOrderListModel* data = (CommodityOrderListModel *)order;
        [next initData:data.orderBase.orderId orderNum:data.orderBase.orderNum orderState:data.orderBase.state orderType:OrderType_Commodity];

    }
    else if([order isKindOfClass:[ServiceOrderModel class]])
    {
        ServiceOrderModel* data = (ServiceOrderModel *)order;
       [next initData:data.orderBase.orderId orderNum:data.orderBase.orderNum orderState:data.orderBase.state orderType:OrderType_Service];
    }
    [self.navigationController pushViewController:next animated:TRUE];
}
-(void)toDeleteOrder:(NSInteger)orderIndex
{
    selIndex = orderIndex;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Str_MyOrder_Prompt message:Str_MyOrder_Message delegate:self cancelButtonTitle:Str_Comm_Ok   otherButtonTitles:Str_Comm_Cancel, nil];
    [alert show];
    
}
#pragma mark-- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0) {
        NSString* orderId;
        NSString* url ;
       NSObject* order = [orderArray objectAtIndex:selIndex];
        if ([order isKindOfClass:[CommodityOrderListModel class]]) {
            CommodityOrderListModel* data = (CommodityOrderListModel *)order;
            orderId = data.orderBase.orderId ;
            url = Commodity_OrderInfo_Url;
            
        }
        else if([order isKindOfClass:[ServiceOrderModel class]])
        {
            ServiceOrderModel* data = (ServiceOrderModel *)order;
            orderId = data.orderBase.orderId;
            url = Service_OrderInfo_Url;
        }
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId,@"orderId",nil];
        
        // 请求服务器获取数据
        [self getStringFromServer:Commodity_OrderInfo_Url path:CancelOrder_Path method:@"POST" parameters:dic success:^(NSString* success)  {
            [self initBasicDataInfo];
            
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];

    }
}
#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    isLoadServiceOk = NO;
    isLoadCommodityOk = NO;
    scrollNum = 1;
    self.pageNum = 1;
    [self getDataFromServer];
}

// 从服务器端获取数据
- (void)getDataFromServer
{
 
    if([[LoginConfig Instance]userLogged]==FALSE)
        return;
    NSMutableArray* user = [Common appDelegate].userArray;
    if(user.count == 0)
        return;
    UserModel* userdata = [user objectAtIndex:0];
    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:userdata.userId forKey:@"userId"];
    NSString* url;
    NSString* path;
    NSString* parentNode = @"crmOrder";
  
    [dic setObject:[NSString stringWithFormat:@"%ld",_pageNum] forKey:@"pageNum"];
    [dic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"perSize"];
    if (_orderType == OrderType_Commodity) {

        [dic setObject:[_unselBtn isSelected]?@"0":@"1" forKey:@"orderType"];
        url = Commodity_OrderInfo_Url;
        path = Commodity_OrderList_Path;
    }
    else if(_orderType == OrderType_Service)
    {
        [dic setObject:@"6" forKey:@"moduleType"];
        [dic setObject:[_unselBtn isSelected]?@"0":@"1" forKey:@"orderStatu"];
        url = Commodity_OrderInfo_Url;
        path = Commodity_ServiceOrderList_Path;
    }
    
    // 请求服务器获取数据
    [self getArrayFromServer:url path:path method:@"GET" parameters:dic xmlParentNode:parentNode success:^(NSMutableArray *result) {
        
        if(_pageNum == 1)
        {
            [orderArray removeAllObjects];
        }
        
        for (NSDictionary *dicResult in result)
        {
            if (_orderType == OrderType_Commodity)
            {
                [orderArray addObject:[[CommodityOrderListModel alloc] initWithDictionary:dicResult]];
            }
            else if(_orderType == OrderType_Service)
            {
                [orderArray addObject:[[ServiceOrderModel alloc] initWithDictionary:dicResult]];
            }
        }
        [_table reloadData];
        [self.table.header endRefreshing];
        [self.table.footer endRefreshing];
        if (orderArray.count < _pageNum*pageSize) {
            [self.table.footer noticeNoMoreData];
        }
        if (orderArray.count == 0) {
            [Common showBottomToast:@"暂无数据"];
        }
    } failure:^(NSError *error) {
        if(_pageNum == 1)
        {
            [orderArray removeAllObjects];
        }
        
        [_table reloadData];
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.table.header endRefreshing];
        [self.table.footer endRefreshing];

    }];

}
@end

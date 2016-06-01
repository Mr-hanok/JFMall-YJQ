//
//  PersonalCenterMyOrderDetailViewController.m
//  CommunityApp
//
//  Created by iss on 6/9/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderDetailViewController.h"
#import "PersonalCenterMyOrderServiceDetailCell.h"
#import "PersonalCenterMyOrderCommodityDetailCell.h"
#import "PersonalCenterMyOrderCouponDetailCell.h"

#import "OrderModel.h"
#import "DetailServiceViewController.h"
#import "AGImagePickerViewController.h"
#import "PersonalCenterApplyRefundViewController.h"
#import "AfterSaleApplyViewController.h"
#import "UseCouponsViewController.h"
#import "GrouponTicket.h"
#import "AfterSaleApplyModel.h"
#import "DetailServiceViewController.h"
#import "WaresDetailViewController.h"
#import "PersonalCenterArbitrateViewController.h"
#import "PayMethodViewController.h"
#import "AfterSaleHistoryViewController.h"
#import "CouponShareViewController.h"
#import "PersonalCenterMyOrderCodeListViewController.h"

#define cellServiceNib @"PersonalCenterMyOrderServiceDetailCell"
#define cellCommdityNib @"PersonalCenterMyOrderCommodityDetailCell"
#define cellCouponNib @"PersonalCenterMyOrderCouponDetailCell"
@interface PersonalCenterMyOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PersonalCenterMyOrderCommodityDelegate>
{
    NSArray* array;
    NSMutableArray* orderDetail;
}
@property(strong,nonatomic)IBOutlet UILabel* No;//订单号
@property (weak, nonatomic) IBOutlet UILabel *gpName;
@property(strong,nonatomic)IBOutlet UILabel* state;//订单状态
@property(strong,nonatomic)IBOutlet UILabel* name;
@property(strong,nonatomic)IBOutlet UILabel* tel;
@property(strong,nonatomic)IBOutlet UILabel* address;
@property(strong,nonatomic)IBOutlet UILabel* serviceName;
@property(strong,nonatomic)IBOutlet UILabel* appointTime;
@property(strong,nonatomic)IBOutlet UILabel* remark;
@property(strong,nonatomic)IBOutlet UILabel* payment;
@property(strong,nonatomic)IBOutlet UILabel* useCoupon;
@property (strong, nonatomic) IBOutlet UIView *couponBaseView;
@property (weak, nonatomic) IBOutlet UIView *couponTitleView;
@property (weak, nonatomic) IBOutlet UIView *applyRefundView;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsMoney;
@property (weak, nonatomic) IBOutlet UILabel *deliveryMoney;

@property(strong,nonatomic)IBOutlet UILabel* projectName;
@property (weak, nonatomic) IBOutlet UILabel *sellerName;

@property(strong,nonatomic)IBOutlet UITableView* table;
@property(strong,nonatomic)IBOutlet UIView* tableHead;
@property (strong, nonatomic) IBOutlet UIView *tableCouponHead;
@property(strong,nonatomic)IBOutlet UIView* tableServiceFooter;
@property(strong,nonatomic)IBOutlet UIView* tableCommodityFooter;
@property(strong,nonatomic)IBOutlet UIView* tableCouponFooter;
@property(strong,nonatomic)IBOutlet UILabel* totalPrice;
@property(strong,nonatomic)IBOutlet UILabel* label1;
@property(strong,nonatomic)IBOutlet UILabel* label2;
@property(strong,nonatomic)IBOutlet UILabel* labelValue1;
@property(strong,nonatomic)IBOutlet UILabel* labelValue2;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint* headViewHegiht;
@property (strong,nonatomic) IBOutlet UIImageView* line1;
@property (strong,nonatomic) IBOutlet UIView* headView1;
@property (weak, nonatomic) IBOutlet UILabel *commodityTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *commodityMaterialsPrice;
@property(retain,nonatomic)NSString* orderId;
@property(assign,nonatomic)OrderTypeEnum orderType;

@property(strong,nonatomic) IBOutlet UIView* codeView;
@property(strong,nonatomic) IBOutlet UIView* codeV1;
@property(strong,nonatomic) IBOutlet UIView* codeV2;
@property(strong,nonatomic) IBOutlet UIView* codeV3;
@property(strong,nonatomic) IBOutlet UIView* codeV4;
@property(strong,nonatomic) IBOutlet UIButton* codeMore;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint* codeViewHeight1;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint* codeViewHeight2;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint* codeViewHeight3;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint* codeViewHeight4;

@property(strong,nonatomic) IBOutlet UILabel* codeLabel1;
@property(strong,nonatomic) IBOutlet UILabel* codeLabel2;
@property(strong,nonatomic) IBOutlet UILabel* codeLabel3;
@property(strong,nonatomic) IBOutlet UILabel* priceLabel1;
@property(strong,nonatomic) IBOutlet UILabel* priceLabel2;
@property(strong,nonatomic) IBOutlet UILabel* priceLabel3;

@property(strong,nonatomic) IBOutlet UIView* addressView;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint* addressViewHeightCons;

@end

@implementation PersonalCenterMyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置导航栏
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title=Str_MyOrderDetail_Title;
    
    _applyRefundView.layer.borderWidth = 0.5;
    _applyRefundView.layer.borderColor = Color_Gray_RGB.CGColor;
    _applyRefundView.layer.cornerRadius = 0.2;
    
    switch (_orderType) {
        case OrderType_Commodity:
            self.table.tableHeaderView = self.tableHead;
            self.table.tableFooterView = self.tableCommodityFooter;
            [_line1 setHidden:TRUE];
            break;
          case OrderType_Coupon:
            self.table.tableHeaderView = self.tableCouponHead;
            self.table.tableFooterView = self.tableCouponFooter;
            _headViewHegiht.constant = 30;
            [_headView1 setHidden:TRUE];
            [self initCouponOrderStyle];
            break;
        case OrderType_Service:
            self.table.tableHeaderView = self.tableHead;
//             self.table.tableFooterView = self.tableServiceFooter;
            self.table.tableFooterView = self.tableCommodityFooter;
            [_line1 setHidden:TRUE];
            break;
        default:
            break;
    }
    
    array =@[@[@"",@"kaimenfuwu",@"1"],@[@"logo",@"kaimenfuwu1",@"2"],@[@"suggest",@"kaimenfuwu",@"3"],@[@"",@"kaimenfuwu1",@"2"]];
    orderDetail = [[NSMutableArray alloc]init];
    [_table registerNib:[UINib nibWithNibName:cellCommdityNib bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellCommdityNib
     ];
    [_table registerNib:[UINib nibWithNibName:cellServiceNib bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellServiceNib];
    [_table registerNib:[UINib nibWithNibName:cellCouponNib bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellCouponNib];
    [self initBasicDataInfo];
    if (_orderType != OrderType_Coupon) {
       // [self setNavBarRightItemTitle:Str_Arbitrate_Title andNorBgImgName:nil andPreBgImgName:nil];//屏蔽订单详情仲裁
    }
    else {
        [self setNavBarItemRightViewForNorImg:@"ShareBtnNor" andPreImg:@"ShareBtnPre"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCodeView {
    CommodityOrderDetailModel* detail = [orderDetail objectAtIndex:0];
    NSArray *goodsExchCodesArray = detail.orderBase.goodsExchCodesArray;
    
    _codeLabel1.text = goodsExchCodesArray.count > 0 ? goodsExchCodesArray[0][@"code"] : @"";
    _codeLabel2.text = goodsExchCodesArray.count > 1 ? goodsExchCodesArray[1][@"code"] : @"";
    _codeLabel3.text = goodsExchCodesArray.count > 2 ? goodsExchCodesArray[2][@"code"] : @"";
    _priceLabel1.text = goodsExchCodesArray.count > 0 ? goodsExchCodesArray[0][@"price"] : @"";
    _priceLabel2.text = goodsExchCodesArray.count > 1 ? goodsExchCodesArray[1][@"price"] : @"";
    _priceLabel3.text = goodsExchCodesArray.count > 2 ? goodsExchCodesArray[2][@"price"] : @"";
    
    _codeView.hidden = goodsExchCodesArray.count == 0;
    _codeV1.hidden = _codeView.hidden;
    _codeV2.hidden = goodsExchCodesArray.count < 2;
    _codeV3.hidden = goodsExchCodesArray.count < 3;
    _codeMore.hidden = goodsExchCodesArray.count <= 3;
    
    _codeViewHeight1.constant = _codeV1.hidden ? 0 : 30;
    _codeViewHeight2.constant = _codeV2.hidden ? 0 : 30;
    _codeViewHeight3.constant = _codeV3.hidden ? 0 : 30;
    _codeViewHeight4.constant = _codeView.hidden ? 0 : 30;
    
    [_codeLabel1 addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doLongPress:)]];
    [_codeLabel2 addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doLongPress:)]];
    [_codeLabel3 addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doLongPress:)]];
}

- (void)doLongPress:(UIGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    [Common showBottomToast:@"兑换码已经复制到剪切板"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = label.text;
}

- (IBAction)showMoreCode:(id)sender {
    PersonalCenterMyOrderCodeListViewController *ctro = [[PersonalCenterMyOrderCodeListViewController alloc] init];
    CommodityOrderDetailModel* detail = [orderDetail objectAtIndex:0];
    ctro.goodsExchCodesArray = detail.orderBase.goodsExchCodesArray;
    [self.navigationController pushViewController:ctro animated:YES];
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    [orderDetail removeAllObjects];
    
    // 请求服务器获取周边商家数据
    [self getDataFromServer];
    
}

- (void)initCouponOrderStyle {
    _couponBaseView.layer.borderWidth = 0.5;
    _couponBaseView.layer.cornerRadius = 1;
    _couponBaseView.layer.masksToBounds = YES;
    _couponBaseView.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1] CGColor];
    _couponTitleView.layer.backgroundColor = [[UIColor colorWithRed:255/255.0 green:212/255.0 blue:212/255.0 alpha:0] CGColor];
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderId,@"orderId",nil];
//    if (_orderType == OrderType_Service) {
//         // 请求服务器获取数据
//        [self getArrayFromServer:Service_OrderInfo_Url path:Service_OrderDetail_Path method:@"GET" parameters:dic xmlParentNode:@"crmOrder" success:^(NSMutableArray *result) {
//            for (NSDictionary *dicResult in result)
//            {
//            
//            [orderDetail addObject:[[ServiceOrderModel alloc] initWithDictionary:dicResult]];
//            }
//            [self FreshPage];
//        
//            } failure:^(NSError *error) {
//                [Common showBottomToast:Str_Comm_RequestTimeout];
//            }];
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
                [orderDetail addObject:[[CommodityOrderDetailModel alloc] initWithDictionary:dic]];
            }
            [self FreshPage];
            
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
    }
    else  if (_orderType == OrderType_Coupon)
    {
        // 请求服务器获取数据
        [self getArrayFromServer:GetOrderDetailForGroupBuy_Url path:GetOrderDetailForGroupBuy_Path method:@"GET" parameters:dic xmlParentNode:@"groupBuyOrder" success:^(NSMutableArray *result) {
            for (NSDictionary *dicResult in result)
            {
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithDictionary:dicResult];
                [orderDetail addObject:[[GrouponTicket alloc] initWithDictionary:dic]];
            }
            [self FreshPage];
            
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
    }

}


-(void)FreshPage
{
    if (_orderType == OrderType_Service) {
//        [_label1 setText:@"服务金额"];
//        [_label2 setText:@"优惠金额"];
        [_goodsMoneyLabel setText:@"服务费"];
        [_deliveryMoneyLabel setText:@"材料费"];
        CommodityOrderDetailModel* detail = [orderDetail  objectAtIndex:0];
        [_No setText:detail.orderBase.orderNum];
        [_state setText:detail.orderBase.state];
        [_name setText:[NSString stringWithFormat:@"%@ %@",detail.userInfo.linkName ,detail.userInfo.linkTel]];
        [_address setText:detail.userInfo.address];
//        [_name setText:detail.userInfo.linkName];
//        [_tel setText:detail.userInfo.linkTel];
//        [_address setText:detail.userInfo.address];
//        if (detail.orderBase.materialsArray != nil && detail.orderBase.materialsArray.count > 0) {
//            materialsModel* material = [detail.orderBase.materialsArray objectAtIndex:0];
//            [_serviceName setText:material.CommodityName];
//        }
     
       // [_appointTime setText:detail.orderBase.appointmenTime];
//        [_remark setText:detail.userInfo.remarks];
//        float total = 0.0f;
//        if([detail.orderBase.money isEqualToString:@""]==FALSE)
//            total = [detail.orderBase.money floatValue];
//        [_totalPrice setText:[NSString stringWithFormat:@"￥%.2f",total]];
//        [_sellerName setText:detail.orderBase.sellerName];
//        [_projectName setText:detail.orderBase.projectName];
        [_remark setText:detail.userInfo.remarks];
        if([detail.payInfo.payment isEqualToString:@"1"])
        {
            [_payment setText:@"后付费服务"];
        }else {
            [_payment setText:@"先付费服务"];
        }
        if (detail.payInfo.couponsId && [detail.payInfo.couponsId isEqualToString:@""]==FALSE) {
            [_useCoupon setText:[NSString stringWithFormat:@"使用%@ 优惠￥%@", [self getCouponsType:detail.payInfo.cpType], detail.payInfo.couponsMoney]];
        }
        [_sellerName setText:detail.orderBase.sellerName];
        [_projectName setText:detail.orderBase.projectName];
        
        CGFloat deliveryMoney = [detail.orderBase.sendMoney floatValue];
        CGFloat totalMoeny = [detail.payInfo.money floatValue];
        CGFloat couponsMoney = [detail.payInfo.couponsMoney floatValue];
        [_commodityMaterialsPrice setText:[NSString stringWithFormat:@"￥%.2f",deliveryMoney]];
        [_commodityTotalPrice setText:[NSString stringWithFormat:@"¥%.2f", totalMoeny]];
        
        CGFloat goodsMoney = totalMoeny + couponsMoney - deliveryMoney;
        [_goodsMoney setText:[NSString stringWithFormat:@"￥%.2f", goodsMoney]];
    }
    else if(_orderType == OrderType_Commodity)
    {
        [_goodsMoneyLabel setText:@"商品金额"];
        [_deliveryMoneyLabel setText:@"配送费"];
        CommodityOrderDetailModel* detail = [orderDetail  objectAtIndex:0];
        [_No setText:detail.orderBase.orderNum];
        [_state setText:detail.orderBase.state];
        [_name setText:[NSString stringWithFormat:@"%@ %@",detail.userInfo.linkName ,detail.userInfo.linkTel]];
        [_address setText:detail.userInfo.address];
        [_remark setText:detail.userInfo.remarks];
        if([detail.payInfo.payment isEqualToString:@"1"])
        {
          [_payment setText:@"货到付款"];
        }
        if (detail.payInfo.couponsId && [detail.payInfo.couponsId isEqualToString:@""]==FALSE) {
            [_useCoupon setText:[NSString stringWithFormat:@"使用%@ 优惠￥%@", [self getCouponsType:detail.payInfo.cpType], detail.payInfo.couponsMoney]];
        }
        [_sellerName setText:detail.orderBase.sellerName];
        [_projectName setText:detail.orderBase.projectName];
//        float total = 0;
//        for (int i = 0; i<detail.orderBase.materialsArray.count; i++) {
//            materialsModel* material = [detail.orderBase.materialsArray objectAtIndex:i];
//    
//            total += [material.CommodityNum intValue]*[material.CommodityPrice floatValue];
//        }
        CGFloat deliveryMoney = [detail.orderBase.sendMoney floatValue];
        CGFloat totalMoeny = [detail.payInfo.money floatValue];
        CGFloat couponsMoney = [detail.payInfo.couponsMoney floatValue];
        [_commodityMaterialsPrice setText:[NSString stringWithFormat:@"￥%.2f",deliveryMoney]];
        [_commodityTotalPrice setText:[NSString stringWithFormat:@"¥%.2f", totalMoeny]];
        
        CGFloat goodsMoney = totalMoeny + couponsMoney - deliveryMoney;
        [_goodsMoney setText:[NSString stringWithFormat:@"￥%.2f", goodsMoney]];
        [self showCodeView];
        
        // 虚拟商品隐藏地址收货栏
        if ([detail.orderBase.orderType isEqualToString:@"2"]) {
            _addressView.hidden = YES;
            _addressViewHeightCons.constant = 0;
        }
    }
    else if(_orderType == OrderType_Coupon)
    {
        GrouponTicket* detail = [orderDetail  objectAtIndex:0];
        [_No setText:detail.orderNum];
        [_gpName setText:detail.gbTitle];
   
        switch ([detail.orderStatus integerValue]) {
            case 1:
                [_state setText:@"待处理"];
                break;
            case 2:
                [_state setText:@"处理中"];
                break;
            case 3:
                [_state setText:@"已完成"];
                [_operationLabel setText:@"申请退款"];
                break;
            case 4:
                [_state setText:@"已取消"];
                break;
            case 5:
                [_state setText:@"待付款"];
                [_operationLabel setText:@"去支付"];
                break;
            case 6:
                [_state setText:@"待发货"];
                break;
            case 7:
                [_state setText:@"待收货"];
                break;
            case 8:
                [_state setText:@"待收款"];
                break;
            default:
                break;
        }
        
        [_label1 setText:@"团购金额"];
        [_label2 setText:@"优惠金额"];
        [_labelValue1 setText:[NSString stringWithFormat:@"+%@",detail.payMoney]];
        if([detail.couponsMoney isEqual:@""])
        {
            [_labelValue2 setText:[NSString stringWithFormat:@"-0.0"]];
        }
        else
        {
            [_labelValue2 setText:[NSString stringWithFormat:@"-%@",detail.couponsMoney]];
        }
        
        [_totalPrice setText:[NSString stringWithFormat:@"¥%@", detail.totalMoney]];
    }
    [_table reloadData];
}


- (NSString *)getCouponsType:(NSString *)cpType
{
    NSString *couponsType;
    switch ([cpType integerValue]) {
        case 1:
            couponsType = Str_Coupon_Type_Cash;
            break;
        case 2:
            couponsType = Str_Coupon_Type_Discount;
            break;
        case 3:
            couponsType = Str_Coupon_Type_Full;
            break;
        case 4:
            couponsType = Str_Coupon_Type_Gift;
            break;
        case 5:
            couponsType = Str_Coupon_Type_Benifit;
            break;
        default:
            break;
    }

    return couponsType;
}


#pragma mark-table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_orderType == OrderType_Service)
    {
        return [orderDetail count];
    }
    else if (_orderType == OrderType_Commodity)
    {
        if (orderDetail.count == 0) {
            return 0;
        }
        CommodityOrderDetailModel* detail = [orderDetail  objectAtIndex:0];
        return [detail.orderBase.materialsArray count];
        
    }
    else if (_orderType == OrderType_Coupon)
    {
        if (orderDetail.count == 0) {
            return 0;
        }
        GrouponTicket* ticket = [orderDetail  objectAtIndex:0];
        return ticket.ticketsList.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if (_orderType == OrderType_Service)
//    {
//         ServiceOrderModel* detail = [orderDetail  objectAtIndex:0];
//        PersonalCenterMyOrderServiceDetailCell* cell = (PersonalCenterMyOrderServiceDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellServiceNib];
//        [cell setCellText:@"" service:detail.orderBase.materials num:@"1"];
//         cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//
//    }
//    else
    if (_orderType == OrderType_Commodity || _orderType == OrderType_Service)

    {
        PersonalCenterMyOrderCommodityDetailCell* cell = (PersonalCenterMyOrderCommodityDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellCommdityNib];
        CommodityOrderDetailModel* order = [orderDetail  objectAtIndex:0];
        materialsModel *matetial = [order.orderBase.materialsArray objectAtIndex:indexPath.row];
        [cell setCellText:matetial.CommodityPic service:matetial.CommodityName num:matetial.CommodityNum];
        cell.delegate = self;
        return cell;

    }
     else if (_orderType == OrderType_Coupon)
     {
         PersonalCenterMyOrderCouponDetailCell* cell = (PersonalCenterMyOrderCouponDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellCouponNib];
         GrouponTicket* order = [orderDetail  objectAtIndex:0];
         [cell loadCellData:[order.ticketsList objectAtIndex:indexPath.row] atIndex:indexPath.row+1 isButtom:indexPath.row == order.ticketsList.count-1];
         [cell setSelectGrouponsBlock:^(BOOL isSelected) {
            ticketModel *model = [order.ticketsList objectAtIndex:indexPath.row];
             model.isSelected = isSelected;
         }];
         return cell;
     }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_orderType == OrderType_Service || _orderType == OrderType_Commodity)
    {
        CommodityOrderDetailModel* order = [orderDetail objectAtIndex:0];
        materialsModel* material = [order.orderBase.materialsArray objectAtIndex:indexPath.row];
        if (_orderType == OrderType_Service) {
            DetailServiceViewController* vc = [[DetailServiceViewController alloc]init];
            vc.serviceId = material.CommodityId;
            [self.navigationController pushViewController:vc animated:TRUE];
        }
        else
        {
            WaresDetailViewController* vc = [[WaresDetailViewController alloc]init];
            vc.waresId = material.CommodityId;
            [self.navigationController pushViewController:vc animated:TRUE];
        }
        
    }else
    {
        AfterSaleHistoryViewController* vc = [[AfterSaleHistoryViewController alloc]init];
        GrouponTicket* ticket = [orderDetail objectAtIndex:0];
        ticketModel* model = [ticket.ticketsList objectAtIndex:indexPath.row];
        vc.ticketId = model.ticketId;
        [self.navigationController pushViewController:vc animated:TRUE];
    }
        
//    OrderDetailModel* detail = [orderDetail  objectAtIndex:0];
//    DetailServiceViewController *vc = [[DetailServiceViewController alloc] init];
//     vc.serviceId = detail.serviceId;
//    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark---other
-(void)setOrderId:(NSString*)orderId orderType:(OrderTypeEnum)orderType
{
    _orderId = orderId;
    _orderType = orderType;
}
#pragma mark---IBAction
-(IBAction)clickImgDetail:(id)sender
{
    AGImagePickerViewController* vc =[[AGImagePickerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(IBAction)clickApplyRefund:(id)sender
{
    GrouponTicket* order = [orderDetail  objectAtIndex:0];
    if ([order.orderStatus isEqualToString:@"3"]) {     // 订单状态为已完成
        NSMutableArray *ticketsArray = [[NSMutableArray alloc] init];
        for (ticketModel *model in order.ticketsList) {
            if (model.isSelected) {
                [ticketsArray addObject:model];
            }
        }
        if (ticketsArray.count <= 0) {
            [Common showBottomToast:@"请选择购物券"];
            return;
        }
        
        PersonalCenterApplyRefundViewController* vc = [[PersonalCenterApplyRefundViewController alloc]init];
        vc.selectedTicketsArray = ticketsArray;
        vc.grouponTicket = order;
        
        CGFloat totalMoney = [order.totalMoney floatValue];
        CGFloat nums = [order.quantity integerValue];
        CGFloat refundMoney = (totalMoney/nums)*ticketsArray.count;
        vc.refundMoney = [NSString stringWithFormat:@"%.2f", refundMoney];
        [self.navigationController pushViewController:vc animated:TRUE];
    }else if ([order.orderStatus isEqualToString:@"5"]) {  // 订单状态待付款
        PayMethodViewController *vc = [[PayMethodViewController alloc] init];
        vc.orderId = order.orderId;
        vc.amount = [order.totalMoney floatValue];
        [self.navigationController pushViewController:vc animated:YES];
    }

}
#pragma mark --- PersonalCenterMyOrderCommodityDelegate
-(void)toCustomerService:(PersonalCenterMyOrderCommodityDetailCell *)cell
{
    NSIndexPath* indexPath = [_table indexPathForCell:cell];
    CommodityOrderDetailModel* order = [orderDetail  objectAtIndex:0];
    materialsModel *matetial = [order.orderBase.materialsArray objectAtIndex:indexPath.row];
   // matetial.CommodityId;
    
    NSDictionary *dic = [[NSDictionary alloc]
                         initWithObjects:@[order.orderBase.orderId,
                                           matetial.CommodityId,
                                           @"2",
                                           @"",
                                           matetial.CommodityNum,
                                           matetial.CommodityPrice,
                                           @"",
                                           [LoginConfig Instance].userID,
                                           order.orderBase.sellerId,
                                           @""]
                        forKeys:@[@"orderId",@"goodsId",@"afterSalesType",@"afterSalesReason",@"returnGoodsNum",@"refundAmount",@"details",@"userId",@"sellerId",@"recordId"]];
    
    AfterSaleApplyModel *asApplyModel = [[AfterSaleApplyModel alloc]initWithDictionary:dic];
    
    AfterSaleApplyViewController *vc = [[AfterSaleApplyViewController alloc]init];
    vc.asModel = asApplyModel;
    [self.navigationController pushViewController:vc animated:TRUE];
}
#pragma mark---导航栏右按钮时间
-(void)navBarRightItemClick
{
    if (_orderType == OrderType_Coupon) {
        if (orderDetail.count == 0) {
            [Common showBottomToast:@"没有可分享的优惠券"];
            return;
        }
        CouponShareViewController *next = [[CouponShareViewController alloc] init];
        next.order = [orderDetail firstObject];
        [self.navigationController pushViewController:next animated:YES];
    }
    else {
        PersonalCenterArbitrateViewController* vc = [[PersonalCenterArbitrateViewController alloc]init];
        vc.orderId = _orderId;
        [self.navigationController pushViewController:vc animated:TRUE];
    }
}
@end

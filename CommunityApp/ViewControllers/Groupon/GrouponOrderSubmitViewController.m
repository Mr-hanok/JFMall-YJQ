//
//  GrouponOrderSubmitViewController.m
//  CommunityApp
//
//  Created by iss on 8/3/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "GrouponOrderSubmitViewController.h"
#import "CartCountButton.h"
#import "ContactSelect.h"
#import "CouponSelectViewController.h"
#import "GrouponTicket.h"
#import "GrouponPurchaseSuccessViewController.h"
#import "PayMethodViewController.h"
#import "CommitResultViewController.h"

@interface GrouponOrderSubmitViewController ()<ContactSelectDelegate,UIActionSheetDelegate,CartCountButtonDelegate, PayMethodViewDelegate>
@property (strong,nonatomic) IBOutlet UIView* cartView;
@property (nonatomic, retain) CartCountButton *countBtn;
@property (strong,nonatomic) IBOutlet UILabel* contact;
@property (strong,nonatomic) IBOutlet UILabel* payment;
@property (strong,nonatomic) IBOutlet UILabel* discount;
@property (copy,nonatomic) NSString*name;
@property (copy,nonatomic) NSString*telno;
@property (strong,nonatomic) IBOutlet UILabel* unitPrice;
@property (strong,nonatomic) IBOutlet UILabel* price;
@property (strong,nonatomic) IBOutlet UILabel* totalPrice;
@property (strong,nonatomic) IBOutlet UILabel* grouponName;

@property (weak, nonatomic) IBOutlet UIImageView *hLine1;
@property (weak, nonatomic) IBOutlet UIImageView *hLine2;
@property (weak, nonatomic) IBOutlet UIImageView *hLine3;
@property (weak, nonatomic) IBOutlet UIImageView *hLine4;
@property (weak, nonatomic) IBOutlet UIImageView *hLine5;
@property (weak, nonatomic) IBOutlet UIImageView *hLine6;
@property (weak, nonatomic) IBOutlet UIImageView *hLine7;
@property (weak, nonatomic) IBOutlet UIImageView *hLine8;
@property (weak, nonatomic) IBOutlet UIImageView *hLine9;
@property (weak, nonatomic) IBOutlet UIImageView *hLine10;
@property (weak, nonatomic) IBOutlet UIImageView *hLine11;

//@property (strong,nonatomic) CouponsDetail* couponDetail;
@property (strong,nonatomic) Coupon *couponDetail;
@property (strong,nonatomic) GrouponTicket* ticket;
@property (assign,nonatomic) float discountAmount;

@property (nonatomic, assign) NSInteger     allGoodsCount;
@property (nonatomic, copy)   NSString      *couponIds;
@property (nonatomic, assign) CGFloat       allGoodsPrice;
@property (nonatomic, assign) CGFloat       payMoney;
@property (nonatomic, retain) Coupon        *useCoupon;

@end

@implementation GrouponOrderSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Cart_SubmitOrder;
    self.countBtn = [CartCountButton instanceCartButton];
    self.countBtn.delegate = self;
    [self.cartView addSubview:self.countBtn];
    _discountAmount = 0.0f;
    _allGoodsCount = 1;
    _allGoodsPrice = 0.0f;
    _payMoney = 0.0f;
    _couponIds = @"";
    
    [self freshPage];
    
    [Common updateLayout:_hLine1 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine2 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine3 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine4 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine5 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine6 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine7 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine8 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine9 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine10 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine11 where:NSLayoutAttributeHeight constant:0.5];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponse)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}


-(void)resignCurrentResponse
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)freshPage
{
    NSString *linkName = [[LoginConfig Instance] userName];
    NSString *linkTel = [[LoginConfig Instance] getBindPhone];
    
    if (linkTel == nil || [linkTel isEqualToString:@""]) {
        linkTel = @"未绑定手机号";
    }
    
    [_grouponName setText:_gpOrder.goodsName];
    [_unitPrice setText:[NSString stringWithFormat:@"￥%@",_gpOrder.totalMoney]];
    [_totalPrice setText:[NSString stringWithFormat:@"￥%@",_gpOrder.totalMoney]];
    [_price setText:[NSString stringWithFormat:@"￥%@",_gpOrder.totalMoney]];
    [_discount setText:[NSString stringWithFormat:@"-￥%.2f",_discountAmount]];
    [self setSelectedContactName:linkName andTelno:linkTel];
    //[self setSelectedContactName:@"联系方式" andTelno:@""];
}

// 选择优惠券后刷新
- (void)freshDiscount
{
    _allGoodsPrice = [_gpOrder.totalMoney floatValue] * _allGoodsCount;
    [_totalPrice setText:[NSString stringWithFormat:@"￥%.2f",_allGoodsPrice]];
    _payMoney = _allGoodsPrice - _discountAmount;
    [_price setText:[NSString stringWithFormat:@"￥%.2f",_payMoney]];
    [_discount setText:[NSString stringWithFormat:@"-￥%.2f",_discountAmount]];
}


-(void)toPaymentSelectScreen
{
    PayMethodViewController *vc = [[PayMethodViewController alloc] init];
    vc.orderId = _ticket.orderNum;
    NSString *orderPrice = [_price.text substringFromIndex:1];
    vc.amount = [orderPrice floatValue];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)toPurchaseSuccess
{
    GrouponPurchaseSuccessViewController* vc = [[GrouponPurchaseSuccessViewController alloc]init];
    vc.grouponTicket = _ticket;
    vc.groupBuyListVC = self.groupBuyListVC;
    [self.navigationController pushViewController:vc animated:TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark--- IBAction
-(IBAction)clickPayment:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles: Str_Payment_Online, nil];
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

-(IBAction)clickCommit:(id)sender
{     [_payment setText:Str_Payment_Online];
    if (![self isGoToLogin]) {
        return;
    }
    
    if (([_payment.text isEqualToString:@"选择支付方式"] || _payment.text == nil)) {
        [Common showBottomToast:@"请选择支付方式"];
        return;
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *endTime = [formatter dateFromString:_gpOrder.groupBuyEndTime];
    if ([now compare:endTime] == NSOrderedDescending) {
        [Common showBottomToast:@"该团购商品已过期"];
        return;
    }
    
    if (_couponIds == nil) {
        _couponIds = @"";
    }
    
    [self uploadGoodsOrderForGroupBuyToServer];
}

-(IBAction)toCoupon:(id)sender
{
    CouponSelectViewController *vc = [[CouponSelectViewController alloc]init];
//    [vc setSelectCouponBlock:^(Coupon *coupon) {
//        self.couponDetail = coupon;
//    }];
    
    [vc setSelectCouponsBlock:^(NSArray *coupons) {
        CGFloat discount = 0.0;
        if (coupons.count == 1) {
            _useCoupon = [coupons firstObject];
            _couponIds = _useCoupon.cpId;
        }else if (coupons.count > 1) {
            _useCoupon = [coupons firstObject];
            for (Coupon *coupon in coupons) {
                discount += [coupon.preferentialPrice floatValue];
                _couponIds = [_couponIds stringByAppendingString:[NSString stringWithFormat:@"%@,", coupon.cpId]];
            }
            if (_couponIds.length > 0) {
                _couponIds = [_couponIds substringWithRange:NSMakeRange(0, _couponIds.length-1)];
            }
        }
        [Common showBottomToast:@"多余金额不退换"];
        [self reCaculateDiscount];
        [self freshDiscount];
    }];

    vc.selectCouponIds = [_couponIds componentsSeparatedByString:@","];
    
    vc.goodsId = _gpOrder.goodsIds;
    [self.navigationController pushViewController:vc animated:TRUE];
}


// 重新计算优惠金额
- (void)reCaculateDiscount
{
    _discountAmount = 0.00;
    if (_useCoupon != nil) {
        if ([_useCoupon.ticketstype isEqualToString:@"4"]) { //买赠券
            if ([_gpOrder.goodsIds isEqualToString:_useCoupon.supportGoodsIds] &&
                (_allGoodsCount - [_useCoupon.buyNumber integerValue]-[_useCoupon.givenNumber integerValue] >= 0)) {
                _discountAmount = [_useCoupon.givenNumber integerValue] * [_gpOrder.totalMoney floatValue];
            }
        }else if ([_useCoupon.ticketstype isEqualToString:@"1"]) {  //现金券
            CGFloat totalPrice = [_gpOrder.totalMoney floatValue] * _allGoodsCount;
            if (totalPrice - [_useCoupon.conditionsPrice floatValue] > 0) {
                if ([_useCoupon.preferentialPrice floatValue] - totalPrice > 0) {
                    _discountAmount = totalPrice;
                }else {
                    _discountAmount = [_useCoupon.preferentialPrice floatValue];
                }
            }
        }else if ([_useCoupon.ticketstype isEqualToString:@"5"]) {  //福利券
            CGFloat totalPrice = [_gpOrder.totalMoney floatValue] * _allGoodsCount;
            if ([_useCoupon.preferentialPrice floatValue] - totalPrice > 0) {
                _discountAmount = totalPrice;
            }else {
                _discountAmount = [_useCoupon.preferentialPrice floatValue];
            }
        }else {
            _discountAmount = [_useCoupon getDiscountMoneyWithPrice:([_gpOrder.totalMoney floatValue]*_allGoodsCount)];
        }
    }
}



#pragma mark --- ContactSelectDelegate
- (void)setSelectedContactName:(NSString *)name andTelno:(NSString *)telno
{
    if (name == nil || [name isEqualToString:@""]) {
        [self.contact setText:[NSString stringWithFormat:@"%@",telno]];
    }else {
        [self.contact setText:[NSString stringWithFormat:@"%@   %@",name,telno]];
    }
    
    self.name = name;
    self.telno = telno;
}

#pragma mark---UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [_payment setText:Str_Payment_Online];
    }
}

#pragma mark---CartCountButtonDelegate
- (void)cartCountChange:(NSInteger)count
{
    _allGoodsCount = count;
    [self reCaculateDiscount];
    [self freshDiscount];
}

#pragma mark -- 向服务器提交订单
- (void)uploadGoodsOrderForGroupBuyToServer {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_gpOrder.creator forKey:@"creator"];
    [dic setObject:@"" forKey:@"address"];
    if (self.name == nil) {
        [dic setObject:@"" forKey:@"linkName"];
    }else {
        [dic setObject:self.name forKey:@"linkName"];
    }
    
    [dic setObject:self.telno forKey:@"linkTel"];
    [dic setObject:@"" forKey:@"remarks"];
    [dic setObject:[NSString stringWithFormat:@"%@:%@:%@",_gpOrder.goodsIds,_gpOrder.totalMoney,[NSString stringWithFormat:@"%ld", (long)_allGoodsCount]] forKey:@"goodsIds"];
    [dic setObject:_gpOrder.ownerid forKey:@"ownerid"];
    [dic setObject:[Common vaildString:_gpOrder.sellerId] forKey:@"sellerId"];
    _allGoodsPrice = [_gpOrder.totalMoney floatValue] * _allGoodsCount;
    
    NSString *orderPrice = [_price.text substringFromIndex:1];
    _payMoney = [orderPrice floatValue];
    
    [dic setObject:_couponIds forKey:@"couponsId"];
    [dic setObject:[NSString stringWithFormat:@"%.2f", _discountAmount] forKey:@"couponsMoney"];
    [dic setObject:[NSString stringWithFormat:@"%.2f", _allGoodsPrice] forKey:@"totalMoney"];
    [dic setObject:[NSString stringWithFormat:@"%.2f", _payMoney] forKey:@"payMoney"];

    [self getArrayFromServer:UploadGoodsOrderForGroupBuy_Url path:UploadGoodsOrderForGroupBuy_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        if(result.count != 0)
        {
            _ticket = [[GrouponTicket alloc]initWithDictionary:[result objectAtIndex:0]];
            if (_payMoney - 0.0099 < 0) {
                [self paymentOkTodo];
            }else {
                [Common showBottomToast:@"订单提交成功,前往支付"];
                [self toPaymentSelectScreen];
            }
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


// 付款成功后调用的Delegate方法
- (void)paymentOkTodo
{
    [self getGrouponsByAfterPay];
}

// 付款失败后的调用的Delegate方法
- (void)paymentFailTodo
{
    CommitResultViewController *vc = [[CommitResultViewController alloc] init];
    vc.eFromViewID = E_ResultViewFromViewID_OrderPayResult;
    vc.resultTitle = @"支付失败";
    vc.resultDesc = @"亲，订单没有支付成功";
    [self.navigationController pushViewController:vc animated:YES];
}


// 支付成功后获取团购券信息
- (void)getGrouponsByAfterPay
{
    //初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[_ticket.orderId] forKeys:@[@"orderId"]];
    
    [self getArrayFromServer:UploadGoodsOrderForGroupBuy_Url path:GetGrouponsAfterPay_Path method:@"POST" parameters:dic xmlParentNode:@"groupBuyOrder" success:^(NSMutableArray *result) {
        for (NSDictionary *dic in result) {
            _ticket = [[GrouponTicket alloc] initWithDictionary:dic];
        }
        [self toPurchaseSuccess];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


@end
//
//  WaresOrderSubmitViewController.m
//  CommunityApp
//
//  Created by iss on 8/18/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "WaresOrderSubmitViewController.h"

#import "CouponSelectViewController.h"
#import "ExpressTypeViewController.h"
#import "CartCountButton.h"
#import "RoadAddressManageViewController.h"
#import <UIImageView+AFNetworking.h>
#import "CommitResultViewController.h"
#import "PayMethodViewController.h"
#import "RemarkViewController.h"
#import "NSString+Helper.h"
#import <UIActionSheet+Block/UIActionSheet+Block.h>

#define ConfirmOrderTableViewCellNibName        @"ConfirmOrderTableViewCell"
#define ConfirmOrderHeaderViewNibName           @"ConfirmOrderHeaderView"
#define ConfirmOrderFooterViewNibName           @"ConfirmOrderFooterView"
 
@interface WaresOrderSubmitViewController ()< UITextFieldDelegate, UITextViewDelegate,CartCountButtonDelegate, PayMethodViewDelegate, UIGestureRecognizerDelegate>
 
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableFooter;
@property (strong, nonatomic) IBOutlet UIView *tableHead;

@property (weak, nonatomic) IBOutlet UILabel *ExpressLabel;
@property (weak, nonatomic) IBOutlet UILabel *CouponLabel;
@property (weak, nonatomic) IBOutlet UILabel *allGoodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarks;
@property (weak, nonatomic) IBOutlet UILabel *remarksTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *allWareCount;

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;

@property (weak, nonatomic) IBOutlet UIView * cartCountView;
@property (strong, nonatomic) IBOutlet UIView *wareLabelView;
@property (strong, nonatomic) IBOutlet UILabel *unitPrice;
@property (strong, nonatomic) IBOutlet UIImageView *wareImage;
@property (strong, nonatomic) IBOutlet UILabel *wareName;
@property (weak, nonatomic) IBOutlet UILabel *shopTitle;

@property (nonatomic, assign) CGFloat           discount;
@property (nonatomic, assign) CGFloat           allGoodsPrice;
@property (strong, nonatomic) Coupon*           useCoupon;
@property (strong, nonatomic) Coupon*           selectedCoupon;
@property (strong,nonatomic)ExpressTypeModel*   useExpress;
@property (nonatomic, copy) NSString            *payMethod;     // 支付方式
@property (strong,nonatomic) RoadData*           useRoad;
@property (nonatomic, copy) NSString            *couponIds;
@property (nonatomic, copy) NSString            *mOrderNo;

//首件特价
@property (weak, nonatomic) IBOutlet UIView *specialPriceBg;
@property (nonatomic, weak) IBOutlet UILabel*specialOfferPriceLabel;//首件特价，优惠价
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specialPriceHight;

//优惠券
@property (weak, nonatomic) IBOutlet UIView *couponBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponHight;

//地址栏
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addresHeight;

@end

@implementation WaresOrderSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _waresDetail.shopGoodsCount = 1;
    
    // Do any additional setup after loading the view from its nib.
    [_tableFooter setFrame:CGRectMake(0, 0, Screen_Width, 153)];
    [_tableHead setFrame:CGRectMake(0, 0, Screen_Width,315)];
    
    _tableView.tableFooterView = _tableFooter;
    _tableView.tableHeaderView = _tableHead;
    CartCountButton* cartCount  = [CartCountButton instanceCartButton];
    cartCount.delegate = self;
    [_cartCountView addSubview:cartCount];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Cart_SubmitOrder;
    
    [self getDefaultUseRoad];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurResponse)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    _couponIds = @"";
    _discount = 0.00f;
    
    [self initSpecialOffer];
    [self refreshCouponView];
    
    [self displayWareInfo];
    [self freshDiscount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- CartCountButtonDelegate
-(void)cartCountChange:(NSInteger)count
{
    _waresDetail.shopGoodsCount = count;
    [self freshDiscount];
    [_allWareCount setText:[NSString stringWithFormat:@"共%ld件商品", count]];
}

- (void)initSpecialOffer {
    //判断商品是否是特价商品,设置界面
    if ([_waresDetail isHasSpecialOfferRight]) {
        self.specialPriceHight.constant = 44;
        self.specialPriceBg.hidden = NO;
    }
    else{
        self.specialPriceHight.constant = 0;
        self.specialPriceBg.hidden = YES;
    }
}

- (void)refreshCouponView {
    //判断商品是否是特价商品,设置界面
    if ([_waresDetail isSpecialOfferGoods]) {
        self.couponHight.constant = 0;
        self.couponBg.hidden = YES;
        _useCoupon = nil;
    }
    else{
        self.couponHight.constant = 44;
        self.couponBg.hidden = NO;
        _useCoupon = _selectedCoupon;
    }
}

#pragma mark - other
-(void)freshDiscount
{
    [self reCaculateDiscount];

    [_CouponLabel setText:[NSString stringWithFormat:@"优惠:￥%.2f",_discount]];
    _allGoodsPrice = [_waresDetail calculationTotlePrice] - _discount;
    if (_useExpress != nil) {
        [_ExpressLabel setText:[NSString stringWithFormat:@"%@ ¥%@", _useExpress.ExpressTypeName, _useExpress.ExpressTypePrice]];
        _allGoodsPrice += [_useExpress.ExpressTypePrice floatValue];
    }
    [_allGoodsPriceLabel setText:[NSString stringWithFormat:@"总计￥%.2f",_allGoodsPrice]];
}

- (void)displayWareInfo
{
    self.specialOfferPriceLabel.text=[NSString stringWithFormat:@"优惠：¥%.2f", _waresDetail.goodsPrice.floatValue - _waresDetail.specialOfferPrice.floatValue];//首件特价优惠
    
    if(_waresDetail.deliveryType==nil  ||  [_waresDetail.deliveryType isEqualToString:@""])
    {
        [_ExpressLabel setText:@"全场包邮"];//2015.11.12
    }
    
    NSString* shopName = @"社区自营";
    if(_waresDetail.sellerName && [_waresDetail.sellerName isEqualToString:@""]==FALSE)
        shopName = _waresDetail.sellerName;
    [_shopTitle setText:shopName];
    if ([_waresDetail isHasSpecialOfferRight]) {
        [_unitPrice setNewPrice:_waresDetail.specialOfferPrice oldPrice:_waresDetail.goodsPrice];
    }
    else {
        [_unitPrice setText:[NSString stringWithFormat:@"￥%@",_waresDetail.goodsPrice]];
    }
    [_wareName setText:[NSString stringWithFormat:@"%@",_waresDetail.goodsName]];
    NSArray* picsUrl = [ _waresDetail.goodsUrl componentsSeparatedByString:@","];
    if(picsUrl.count)
    {
        NSURL* url = [NSURL URLWithString:[Common setCorrectURL:[picsUrl objectAtIndex:0]]];
        [_wareImage setImageWithURL:url placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    }
    if(_waresDetail.label)
    {
        NSArray* strings = [_waresDetail.selectedStyle componentsSeparatedByString:@","];
        CGFloat labelHeight = 20.0;                 // 标签高度
        CGFloat labelMargin = 6.0;                  // 标签之间的Margin
        CGFloat additionalWidth = 6.0;              // label附加宽度
        UIFont  *font = [UIFont systemFontOfSize:13.0];  // 字体大小
        
        [Common insertLabelForStrings:strings toView:_wareLabelView andViewHeight:_wareLabelView.bounds.size.height andMaxWidth:_wareLabelView.bounds.size.width andLabelHeight:labelHeight andLabelMargin:labelMargin andAddtionalWidth:additionalWidth andFont:font andBorderColor:Color_Comm_LabelBorder andTextColor:COLOR_RGB(120, 120, 120)];
        
    }
}

#pragma mark - 提交订单到服务器（商品详情->立即购买——>提交订单）

- (IBAction)submitOrderToServer
{
    if(![self isGoToLogin])
    {
        return;
    }
    
    self.payMethod=Str_Cart_OnlinePay;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSString *projectName = [userDefault objectForKey:KEY_PROJECTNAME];
    
    NSString *userId = [[LoginConfig Instance] userID];
    NSString *userName = [[LoginConfig Instance] userName];
    NSString *payType = @"1";
    if (_waresDetail.shopGoodsCount > self.remainCount.intValue) {
        [Common showBottomToast:@"库存不足"];
        return;
    }
    if ([self.payMethod isEqualToString:Str_Cart_OnlinePay]) {
        payType = @"0";
    }else if ([self.payMethod isEqualToString:Str_Cart_ArrivePay]) {
        payType = @"1";
    }else {
        [Common showBottomToast:@"请选择支付方式"];
        return;
    }
    
    if (![_waresDetail.goodsType isEqualToString:@"2"]) {
        if (self.useRoad == nil || self.useRoad.contactName == nil || [self.useRoad.contactName isEqualToString: @""] || self.useRoad.contactTel == nil || [self.useRoad.contactTel isEqualToString:@""]) {
            [Common showBottomToast:@"请选择正确的联系方式"];
            return;
        }
        if ([self.addressLabel.text isEqualToString:@"请选择联系地址"]&&[self.contactLabel.text isEqualToString:@"请选择联系人" ]) {
            [Common showBottomToast:@"请选择联系人和联系地址"];
            return;
        }
        
        // 记录本次使用的地址
        NSDictionary *lastAddress = [NSDictionary dictionaryWithObjectsAndKeys:_useRoad.contactName, @"contactName", _useRoad.contactTel, @"contactTel", _useRoad.address, @"address", _useRoad.projectName, @"projectName", nil];
        [userDefault setObject:lastAddress forKey:[NSString stringWithFormat:@"lastAddress%@", userId]];
        [userDefault synchronize];
    }

    _mOrderNo = [Common createMainOrderNo];
    NSString *sOrderNo = [Common createSubOrderNoWithSubNo:1];
    
    NSString* expressPrice = @"0.0";
    if(_useExpress ){
        expressPrice = _useExpress.ExpressTypePrice;
    }
#pragma mark-配送方式改为全场包邮 2015.11.12
//    else{
//        [Common showBottomToast:@"请选择配送方式"];
//        return;
  //  }

    NSString    *shopId = @"";  //商家ID
    NSString    *cpNo = @"";    //使用的优惠券编号
 
    NSMutableString *goods = [[NSMutableString alloc] initWithString:@""];
    [goods appendString:[NSString stringWithFormat:@"%@:%ld:%@:%@",_waresDetail.goodsId,(unsigned long)_waresDetail.shopGoodsCount, _waresDetail.selectedStyle, _waresDetail.goodsPrice]];
    if ([_waresDetail isHasSpecialOfferRight]) {
        [goods appendString:[NSString stringWithFormat:@":%@", _waresDetail.specialOfferPrice]];
    }
    
    YjqLog(@"%@",_waresDetail.goodsPrice);
    shopId =  _waresDetail.sellerId;
    
    if (_useCoupon) {
        cpNo = _couponIds ? _couponIds : @"";
    }
    
    NSString* remark = @"";
    if ([_remarks.text isEqualToString:@"请填写"]==FALSE) {
        remark = _remarks.text;
    }
    if (remark.length > 200) {
        [Common showBottomToast:@"亲,备注不能超过200字"];
        return;
    }
    
    if ([remark stringContainsEmoji]) {
        [Common showBottomToast:@"亲,备注不能包含表情符号"];
        return;
    }
    
    
    // 初始化参数
    /*上传设备信息*/
    UIDevice *device = [UIDevice currentDevice];
    //     NSString *name = device.name;       //获取设备所有者的名称
    NSString *model = device.model;      //获取设备的类别@"iPhone"
    NSString *type = device.localizedModel; //获取本地化版本@"iPhone"
    //     NSString *systemName = device.systemName;   //获取当前运行的系统@"iOS"
    NSString *systemVersion = device.systemVersion;//获取当前系统的版9.1
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];//每次删除app都会发生变化序列号
    YjqLog(@"********%@",identifierForVendor);
    NSString *rst = [NSString stringWithFormat:@"%@#@#%@#@#%@#@#%@",model,type,systemVersion,identifierForVendor];
    //因为有汉字要utf8编码
    NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    YjqLog(@"****%@",rstt);
    /*2016.03.09添加上传参数payClient：2（iOS）rst：设备信息
     */
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[shopId,cpNo, goods, _ExpressLabel.text, remark, userId, userName, self.useRoad.contactName, self.useRoad.contactTel, _addressLabel.text, payType, [NSString stringWithFormat:@"%.2f", _allGoodsPrice], projectId, projectName, expressPrice, _mOrderNo, sOrderNo, [NSString stringWithFormat:@"%.2f", _discount],@"2",rstt,_waresDetail.goodsType] forKeys:@[@"sellerId", @"couponsId", @"goodsIds", @"deliveryType", @"content", @"userId", @"userName", @"receiveName", @"receiveTelphone", @"address", @"payType", @"payMoney", @"projectId", @"projectName", @"sendMoney", @"mOrderNo", @"sOrderNo", @"couponsMoney",@"payClient",@"rst",@"orderType"]];
    YjqLog(@"dic=====%@",dic);
    [self getArrayFromServer:SubmitOrder_Url path:SubmitOrder_NewPath method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
            NSString *rst = @"0";
            NSString *errorMsg = @"订单提交失败";
            for (NSDictionary *dic in result) {
                rst = [dic objectForKey:@"result"];
                errorMsg = [dic objectForKey:@"errorMsg"];
            }
            if ([rst isEqualToString:@"1"]) {
                if ([self.payMethod isEqualToString:Str_Cart_OnlinePay]) {
                    [Common showBottomToast:@"订单提交成功"];
                    if(_allGoodsPrice - 0.0099 < 0){
                        [self paymentOkTodo];
                    }else {
                        PayMethodViewController *vc = [[PayMethodViewController alloc] init];
                        
                        vc.orderId = _mOrderNo;
                        
                        vc.amount = _allGoodsPrice;
                        vc.delegate = self;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }else {
                    CommitResultViewController *vc = [[CommitResultViewController alloc] init];
                    vc.eFromViewID = E_ResultViewFromViewID_SubmitCommodityOrder;
                    vc.resultTitle = @"下单成功";
                    vc.resultDesc = @"您已成功提交订单";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else {
                if (errorMsg) {
                    [Common showBottomToast:errorMsg];
                }else {
                    [Common showBottomToast:@"订单提交失败"];
                }
            }
    }failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark---IBAction
- (IBAction)toEditRemark
{
    RemarkViewController* vc = [[RemarkViewController alloc]init];
    vc.strRemark = _remarks.text;
    [vc setWriteRemarkBlock:^(NSString *remark) {
        _remarks.text = remark;
    }];

    [self.navigationController pushViewController:vc animated:TRUE];
}
//配送
- (IBAction)toSelExpress {
    if(_waresDetail.deliveryType==nil  ||  [_waresDetail.deliveryType isEqualToString:@""])
        return;
    NSArray *deliverStrings = [_waresDetail.deliveryType componentsSeparatedByString:@","];
    
    ExpressTypeViewController* vc = [[ExpressTypeViewController alloc]init];
    NSMutableArray *delivers = [[NSMutableArray alloc] init];
        for (NSString *strDelivers in deliverStrings) {
            if (![strDelivers isEqualToString:@""]) {
                NSArray *deliverArray = [strDelivers componentsSeparatedByString:@"@ebei@"];
                ExpressTypeModel *newExpress = [[ExpressTypeModel alloc] initWithArray:deliverArray];
                BOOL isAddExpress = YES;
                for (ExpressTypeModel *express in delivers) {
                    if ([express.ExpressTypeName isEqualToString:newExpress.ExpressTypeName]) {
                        isAddExpress = NO;
                        break;
                    }
                }
                if (isAddExpress) {
                    [delivers addObject:newExpress];
                }
           
            }
        }

    vc.expressList = delivers;
    
    [vc setSelectExpressTypeBlock:^(ExpressTypeModel *model) {
        _useExpress = model;
        [self freshDiscount];
    }];

    [self.navigationController pushViewController:vc animated:TRUE];
}

- (IBAction)toSelPayment
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithCancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.paymentTypes];
    [sheet showInView:self.view usingBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            self.payMethod = self.paymentTypes[buttonIndex];
            [_paymentLabel setText:self.payMethod];
        }
    }];
}
- (IBAction)toSelCoupon
{
    CouponSelectViewController* vc = [[CouponSelectViewController alloc]init];
    vc.goodsId = _waresDetail.goodsId;
    vc.selectCouponIds = [_couponIds componentsSeparatedByString:@","];
    [vc setSelectCouponsBlock:^(NSArray *coupons) {
        CGFloat discount = 0.0;
        if (coupons.count == 1) {
            Coupon *coupon = [coupons firstObject];
            _useCoupon = coupon;
            _selectedCoupon = _useCoupon;
            _couponIds = coupon.cpId;
            if ([_waresDetail.goodsPrice floatValue] < [coupon.preferentialPrice floatValue]) {
                [Common showBottomToast:@"多余金额不退换"];
            }
        }else if (coupons.count > 1) {
            _useCoupon = [coupons firstObject];
            _selectedCoupon = _useCoupon;
            _couponIds = @"";
            CGFloat couponPrice = 0.0f;
            for (Coupon *coupon in coupons) {
                discount += [coupon.preferentialPrice floatValue];
                _couponIds = [_couponIds stringByAppendingString:[NSString stringWithFormat:@"%@,", coupon.cpId]];
                couponPrice += [coupon.preferentialPrice floatValue];
            }
            _useCoupon.preferentialPrice = [NSString stringWithFormat:@"%.2f", discount];
            if (_couponIds.length > 0) {
                _couponIds = [_couponIds substringWithRange:NSMakeRange(0, _couponIds.length-1)];
            }
            if ([_waresDetail.goodsPrice floatValue] < couponPrice) {
                [Common showBottomToast:@"多余金额不退换"];
            }
        }
        else {
            _useCoupon = nil;
            _couponIds = nil;
            _selectedCoupon = _useCoupon;
        }
        [self freshDiscount];
    }];
    
    [self.navigationController pushViewController:vc animated:TRUE];
}

// 重新计算优惠金额
- (void)reCaculateDiscount
{
    _discount = 0.00;
    if (_useCoupon != nil) {
        if ([_useCoupon.ticketstype isEqualToString:@"4"]) { //买赠券
            if ([_waresDetail.goodsId isEqualToString:_useCoupon.supportGoodsIds] &&
                (_waresDetail.shopGoodsCount - [_useCoupon.buyNumber integerValue]-[_useCoupon.givenNumber integerValue] >= 0)) {
                _discount = [_useCoupon.givenNumber integerValue] * [_waresDetail.goodsPrice floatValue];
            }
        }else if ([_useCoupon.ticketstype isEqualToString:@"1"]) {  //现金券
            CGFloat totalPrice = [_waresDetail calculationTotlePrice];
            if (totalPrice - [_useCoupon.conditionsPrice floatValue] > 0) {
                if (_useExpress) {
                    totalPrice += [_useExpress.ExpressTypePrice floatValue];
                }
                if ([_useCoupon.preferentialPrice floatValue] - totalPrice > 0) {
                    _discount = totalPrice;
                }else {
                    _discount = [_useCoupon.preferentialPrice floatValue];
                }
            }
        }else if ([_useCoupon.ticketstype isEqualToString:@"5"]) {  //福利券
            CGFloat totalPrice = [_waresDetail calculationTotlePrice];
            if (_useExpress) {
                totalPrice += [_useExpress.ExpressTypePrice floatValue];
            }
            if ([_useCoupon.preferentialPrice floatValue] - totalPrice > 0) {
                _discount = totalPrice;
            }else {
                _discount = [_useCoupon.preferentialPrice floatValue];
            }
        }else {
            _discount = [_useCoupon getDiscountMoneyWithPrice:[_waresDetail calculationTotlePrice]];
        }
    }
}

- (IBAction)toSelContact
{
//    [self resignCurResponse];
    RoadAddressManageViewController* vc = [[RoadAddressManageViewController alloc]init];
    vc.isAddressSel = addressSel_Default;
    [vc setSelectRoadData:^(RoadData *road) {
        _useRoad = road;
        [_addressLabel setText:[NSString stringWithFormat:@"%@ %@",_useRoad.projectName,_useRoad.address]];
        if (_useRoad.contactName && _useRoad.contactTel) {
            [_contactLabel setText:[NSString stringWithFormat:@"%@ %@",_useRoad.contactName,_useRoad.contactTel]];
        }
       
    }];
    [self.navigationController pushViewController:vc animated:TRUE];
}

// 付款成功后调用的Delegate方法
- (void)paymentOkTodo
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: _mOrderNo,@"orderNo",nil];
    [self getArrayFromServer:SubmitOrder_Url path:PayOrderSuccess_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        NSDictionary *resultDic = [result firstObject];
        if ([resultDic[@"result"] isEqualToString:@"0"]) {
            [Common showBottomToast:@"提交订单失败"];
            return ;
        }else {
            CommitResultViewController *vc = [[CommitResultViewController alloc] init];
            vc.eFromViewID = E_ResultViewFromViewID_SubmitCommodityOrder;
            vc.resultTitle = @"支付成功";
            vc.resultDesc = [NSString stringWithFormat:@"您已成功付款:￥%.2f", _allGoodsPrice];
            vc.couponsStr = resultDic[@"coupons"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    /*
    [self getStringFromServer:SubmitOrder_Url path:PayOrderSuccess_Path method:@"POST" parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"0"]) {
            [Common showBottomToast:@"提交订单失败"];
            return ;
        }else {
            CommitResultViewController *vc = [[CommitResultViewController alloc] init];
            vc.eFromViewID = E_ResultViewFromViewID_SubmitCommodityOrder;
            vc.resultTitle = @"支付成功";
            vc.resultDesc = [NSString stringWithFormat:@"您已成功付款:￥%.2f", _allGoodsPrice];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
     */
//    CommitResultViewController *vc = [[CommitResultViewController alloc] init];
//    vc.eFromViewID = E_ResultViewFromViewID_SubmitCommodityOrder;
//    vc.resultTitle = @"支付成功";
//    vc.resultDesc = [NSString stringWithFormat:@"订单编号:%@", _mOrderNo];
//    [self.navigationController pushViewController:vc animated:YES];
}

// 付款失败后的调用的Delegate方法
- (void)paymentFailTodo
{
    CommitResultViewController *vc = [[CommitResultViewController alloc] init];
    vc.eFromViewID = E_ResultViewFromViewID_OrderPayResult;
    vc.resultTitle = @"支付失败";
    vc.resultDesc = [NSString stringWithFormat:@"订单编号:%@", _mOrderNo];
    [self.navigationController pushViewController:vc animated:YES];
}

// 取得默认路址
- (void)getDefaultUseRoad {
//    // 虚拟商品不需要地址
//    if ([_waresDetail.goodsType isEqualToString:@"2"]) {
//        self.addressView.hidden = YES;
//        self.addresHeight.constant = 0;
//        self.useRoad = [[RoadData alloc] init];
//        return;
//    }
    
    NSString *userId = [[LoginConfig Instance] userID];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: userId,@"userId",nil];
    
    [self getArrayFromServer:ServiceInfo_Url path:DefaultRoadAddress_path method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result){
        // 先查看是否有默认地址
        for (NSDictionary *dicResult in result)
        {
            if (dicResult.count > 0) {
                self.useRoad = [[RoadData alloc] initWithDictionary:dicResult];
                _useRoad = self.useRoad;
            }
        }
        
        if (self.useRoad == nil) {
            // 如果没有默认的地址就查看上次有没有填写过地址
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *lastAddress = [userDefaults dictionaryForKey:[NSString stringWithFormat:@"lastAddress%@", userId]];
            if (lastAddress != nil) {
                self.useRoad = [[RoadData alloc] initWithDictionary:lastAddress];
                _useRoad = self.useRoad;
            }
        }
        
        if (self.useRoad.address == nil) {
            [self.addressLabel setText:[NSString stringWithFormat:@"请选择联系地址"]];
            [self.contactLabel setText:[NSString stringWithFormat:@"请选择联系人"]];
        }
        else {
            [self.addressLabel setText:[NSString stringWithFormat:@"%@ %@", self.useRoad.projectName,self.useRoad.address]];
            [self.contactLabel setText:[NSString stringWithFormat:@"%@ %@", self.useRoad.contactName, self.useRoad.contactTel]];
        }
        
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:TRUE];
    return TRUE;
}
-(void)resignCurResponse
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:TRUE];
}

@end

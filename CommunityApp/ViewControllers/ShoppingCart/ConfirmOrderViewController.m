//
//  ConfirmOrderViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "ConfirmOrderFooterView.h"
#import "ConfirmOrderHeaderView.h"
#import "ConfirmOrderTableViewCell.h"
#import "OrderAttachInfo.h"
#import "RoadAddressManageViewController.h"
#import "CouponSelectViewController.h"
#import "ExpressTypeViewController.h"
#import "PayMethodViewController.h"
#import "RemarkViewController.h"
#import "DBOperation.h"
#import "CommitResultViewController.h"
#import "WaresDetailViewController.h"
#import "PersonalCenterMyOrderViewController.h"
#import <UIActionSheet+Block.h>
#import "ShoppingCartViewController.h"
#import "NSString+Helper.h"

#pragma mark - 宏定义区
#define ConfirmOrderTableViewCellNibName        @"ConfirmOrderTableViewCell"
#define ConfirmOrderHeaderViewNibName           @"ConfirmOrderHeaderView"
#define ConfirmOrderFooterViewNibName           @"ConfirmOrderFooterView"


@interface ConfirmOrderViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIActionSheetDelegate, PayMethodViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableFooter;
@property (weak, nonatomic) IBOutlet UILabel *allGoodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allGoodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hLine1;
@property (weak, nonatomic) IBOutlet UIImageView *hLine2;
@property (weak, nonatomic) IBOutlet UIImageView *hLine3;
@property (weak, nonatomic) IBOutlet UIImageView *hLine4;
@property (weak, nonatomic) IBOutlet UIImageView *hLine5;
@property (nonatomic, retain) NSMutableArray    *orderInfoArray;
@property (nonatomic, retain) NSMutableArray    *submitGoodsArray;
@property (nonatomic, assign) NSInteger         allGoodsCount;
@property (nonatomic, assign) CGFloat           allGoodsPrice;
@property (nonatomic, copy) NSString            *payMethod;     // 支付方式
@property (nonatomic, retain) RoadData          *roadData;
@property (nonatomic, assign) BOOL isCallBack;

@property (nonatomic, assign) NSInteger     shouldSubmitCount;      // 应提交数
@property (nonatomic, assign) NSInteger     hasSubmittedCount;      // 已提交数
@property (nonatomic, assign) NSInteger     hasReturnResultCount;   // 已返回结果数

@property (nonatomic, copy) NSString        *orderIds;
@property (nonatomic, copy) NSString        *orderNos;
@property (nonatomic, strong) NSMutableArray *supportPaymentTypes; /**< 支持的付款方式 */
@property (nonatomic, strong) NSMutableArray *paymentTypes; /**< 付款方式 */

@property (nonatomic, assign) BOOL isAllVirtualGoods; /** 是否都是虚拟商品 */
//地址栏
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addresHeight;

@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Cart_SubmitOrder;
    [self setNavBarLeftItemAsBackArrow];
    _isCallBack = NO;
    // 初始化基本信息
    [self initBasicDataInfo];
    
    [self initLineStyle];
    
    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self getDefaultUseRoad];
//
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_submitGoodsArray.count == 0) {
        self.tableView.tableFooterView = nil;
    }else {
        self.tableView.tableFooterView = _tableFooter;
    }
    [self updateAllOrderInfo];
    [self.tableView reloadData];
}

// 初始化横线高度
- (void)initLineStyle
{
    [Common updateLayout:_hLine1 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine2 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine3 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine4 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine5 where:NSLayoutAttributeHeight constant:0.5];
}


#pragma mark - 初始化基本信息
- (void)initBasicDataInfo
{
    self.submitGoodsArray = [[NSMutableArray alloc] init];
    self.orderInfoArray = [[NSMutableArray alloc] init];
    
    //    self.payMethod = @"";
    
    self.orderIds = @"";
    self.orderNos = @"";
    
    for (NSArray *goodsArray in self.cartGoodsArray) {
        // 过滤应该提交订单的商品
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected==YES and type==0"];
        NSArray *waresArray = [goodsArray filteredArrayUsingPredicate:predicate];
        if (waresArray.count > 0) {
            [self.submitGoodsArray addObject:waresArray];
        }
    }
#pragma mark-支付类型 12.2
    self.supportPaymentTypes = [[NSMutableArray alloc] init];
    self.paymentTypes = [[NSMutableArray alloc] init];
    _isAllVirtualGoods = YES;
    for (NSInteger i = 0; i < self.submitGoodsArray.count; i++) {
        NSMutableArray *payments = [[NSMutableArray alloc] init];
        NSArray *goods = [self.submitGoodsArray objectAtIndex:i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"paymentType contains[cd] '1'"];//"1"在线支付
        NSArray *online = [goods filteredArrayUsingPredicate:predicate];
        
        if (_isAllVirtualGoods) {
            NSPredicate *orderPredicate = [NSPredicate predicateWithFormat:@"goodsType contains[cd] '1'"];//"1"实物商品
            NSArray *orderGoods = [goods filteredArrayUsingPredicate:orderPredicate];
            _isAllVirtualGoods = orderGoods.count <= 0;
        }
        
        
        if (online.count == goods.count) {
            [payments addObject:Str_Cart_OnlinePay];
        }
//        if (offline.count == goods.count) {
//            [payments addObject:Str_Cart_ArrivePay];
//        }//12.2
        [self.supportPaymentTypes addObject:payments];
        [self.paymentTypes addObject:Str_Cart_OnlinePay];//12.2
    }
    
    for (int i=0; i<self.submitGoodsArray.count; i++) {
        NSArray *waresArray = [self.submitGoodsArray objectAtIndex:i];
        
        OrderAttachInfo *info = [[OrderAttachInfo alloc] initWithGoods:waresArray];
        [self.orderInfoArray addObject:info];
    }
    
    
    // 注册TableViewCell Nib
    // 商品用CellNib
    UINib *nibForWares = [UINib nibWithNibName:ConfirmOrderTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForWares forCellReuseIdentifier:ConfirmOrderTableViewCellNibName];
    
    // SectionHeaderNib
    UINib *headerNib = [UINib nibWithNibName:ConfirmOrderHeaderViewNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:ConfirmOrderHeaderViewNibName];
    
    // SectionFooterNib
    UINib *footerNib = [UINib nibWithNibName:ConfirmOrderFooterViewNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:footerNib forHeaderFooterViewReuseIdentifier:ConfirmOrderFooterViewNibName];
    
    self.tableFooter.frame = CGRectMake(0, 0, 320, 263);
    self.tableView.tableFooterView = self.tableFooter;
}
-(NSString *)roundUp:(float)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

// 更新订单整体信息
- (void)updateAllOrderInfo
{
    self.allGoodsCount = 0;
    self.allGoodsPrice = 0.0;
    
    for (int i=0; i<self.submitGoodsArray.count; i++) {
        NSArray *waresArray = [self.submitGoodsArray objectAtIndex:i];
        NSInteger count = 0;
        CGFloat price = [ShopCartModel calculationPrice:waresArray];
        NSString *priceString = [NSString stringWithFormat:@"%.2f", price];
        price = priceString.floatValue; // 防止计算中出现-0.0000009999被格式化成-0.00，所以先格式化一次
        
        for (ShopCartModel *model in waresArray) {
            count += model.count;
        }
        //        OrderAttachInfo *info = [[OrderAttachInfo alloc] initWithGoodsCount:count andTotalPrice:price];
        //        [self.orderInfoArray addObject:info];
        self.allGoodsCount += count;
        self.allGoodsPrice += price;
        
        OrderAttachInfo *info = [self.orderInfoArray objectAtIndex:i];
        self.allGoodsPrice -= [info.coupon floatValue];
        self.allGoodsPrice += [info.deliverPrice floatValue];
        
        
        info.totalPrice = price - [info.coupon floatValue] + [info.deliverPrice floatValue];
    }
    
    [self.allGoodsCountLabel setText:[NSString stringWithFormat:@"以上总计%ld件商品", self.allGoodsCount]];
    [self.allGoodsPriceLabel setText:[NSString stringWithFormat:@"合计¥%.2f", self.allGoodsPrice]];
    
    self.hasReturnResultCount = 0;
    self.hasSubmittedCount = 0;
    self.shouldSubmitCount = self.submitGoodsArray.count;
}


// 取得默认路址
- (void)getDefaultUseRoad {
//    // 虚拟商品不需要地址
//    if (_isAllVirtualGoods) {
//        self.addressView.hidden = YES;
//        self.addresHeight.constant = 0;
//        self.roadData = [[RoadData alloc] init];
//        return;
//    }
    
    NSString *userId = [[LoginConfig Instance] userID];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: userId,@"userId",nil];
    
    [self getArrayFromServer:ServiceInfo_Url path:DefaultRoadAddress_path method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result){
        // 先查看是否有默认地址
        for (NSDictionary *dicResult in result)
        {
            if (dicResult.count > 0) {
                self.roadData = [[RoadData alloc] initWithDictionary:dicResult];
            }
        }
        
        if (self.roadData == nil) {
            // 如果没有默认的地址就查看上次有没有填写过地址
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *lastAddress = [userDefaults dictionaryForKey:[NSString stringWithFormat:@"lastAddress%@", userId]];
            if (lastAddress != nil) {
                self.roadData = [[RoadData alloc] initWithDictionary:lastAddress];
            }
        }
        
        if (self.roadData.address == nil) {
            [self.addressLabel setText:[NSString stringWithFormat:@"请选择联系地址"]];
            [self.contactLabel setText:[NSString stringWithFormat:@"请选择联系人"]];
        }
        else {
            [self.addressLabel setText:[NSString stringWithFormat:@"%@ %@", self.roadData.projectName,self.roadData.address]];
            [self.contactLabel setText:[NSString stringWithFormat:@"%@ %@", self.roadData.contactName, self.roadData.contactTel]];
        }
        
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

//#pragma mark - 获取默认路址
//-(void)getDefaultRoad
//{
//    NSString *userId = [[LoginConfig Instance] userID];
//    
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: userId,@"userId",nil];
//    
//    [self getArrayFromServer:ServiceInfo_Url path:DefaultRoadAddress_path method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result){
//        for (NSDictionary *dicResult in result)
//        {
//            YjqLog(@"result====%@",result);
//            if (dicResult.count > 0) {
//                self.roadData = [[RoadData alloc] initWithDictionary:dicResult];
//            }
//        }
//        if (self.roadData != nil) {
//            
//            [self.addressLabel setText:[NSString stringWithFormat:@"%@  %@",self.roadData.projectName, self.roadData.address]];
//            [self.contactLabel setText:[NSString stringWithFormat:@"%@ %@", self.roadData.contactName, self.roadData.contactTel]];
//        }
//        
//    } failure:^(NSError *error) {
//        [Common showBottomToast:Str_Comm_RequestTimeout];
//    }];
//    
//}


#pragma mark - TableView DataSource
// Section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.submitGoodsArray.count;
}


// Cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *waresArray = [self.submitGoodsArray objectAtIndex:section];
    return waresArray.count;
}

#pragma mark-装载cell
// 装载Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfirmOrderTableViewCell *cell = (ConfirmOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConfirmOrderTableViewCellNibName forIndexPath:indexPath];
    NSArray *waresArray = [self.submitGoodsArray objectAtIndex:indexPath.section];
    [cell loadCellData:[waresArray objectAtIndex:indexPath.row]];
    return cell;
}

// Cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = [self.cartGoodsArray objectAtIndex:indexPath.section];
    ShopCartModel * model = [sectionArray objectAtIndex:indexPath.row];
    if (model.type == 0 && model.wsId.length > 0) {
        WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
        vc.waresId = model.wsId;
        vc.efromType = E_FromViewType_CartView;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


// Section Header高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

// Section Footer高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 176.0f;
    
    OrderAttachInfo *info = [self.orderInfoArray objectAtIndex:section];
    
    if (info.isUseSpecialOffer) {
        height += 44.0f;
    }
    
    if (info.isUseCoupon) {
        height += 44.0f;
    }
    
    return height;
}

// Section Header View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ConfirmOrderHeaderView *header = (ConfirmOrderHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ConfirmOrderHeaderViewNibName];
    NSArray *waresArray = [self.submitGoodsArray objectAtIndex:section];
    if (waresArray.count > 0) {
        ShopCartModel *model = [waresArray objectAtIndex:0];
        if (model.sellerName != nil && ![model.sellerName isEqualToString:@""]) {
            [header.storeName setText:model.sellerName];
        }else {
            [header.storeName setText:@"社区自营"];
        }
    }
    
    return header;
}

// Section Footer View
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ConfirmOrderFooterView *footer = (ConfirmOrderFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ConfirmOrderFooterViewNibName];
    
    OrderAttachInfo *info = [self.orderInfoArray objectAtIndex:section];
    if ([info.deliverMethod isEqualToString:@"全场包邮"]) {
        [footer.deliverMethodLabel setText:info.deliverMethod];
        //    }else {
        //        [footer.deliverMethodLabel setText:[NSString stringWithFormat:@"%@  ¥%@", info.deliverMethod, info.deliverPrice]];
    }
    
    [footer.remarkTextView setText:info.remark];
    
    [footer.goodsCount setText:[NSString stringWithFormat:@"共%li件商品", (unsigned long)info.goodsCount]];
    
    [footer.paymentTypeLabel setText:[self.paymentTypes[section] length] == 0 ? @"请选择支付方式":self.paymentTypes[section]];
    //    info.totalPrice += [info.deliverPrice floatValue];
    [footer.goodsPrice setText:[NSString stringWithFormat:@"总计¥%.2f", info.totalPrice]];
    
    footer.remarkTextView.tag = section;
    footer.remarkTextView.delegate = self;
    
    [footer.remarkLabel setText:info.remark];
    
    [footer showSpecialOffer:info.isUseSpecialOffer];
    if (info.isUseSpecialOffer) {
        [footer.discountLabel setText:[NSString stringWithFormat:@"优惠：¥%.2f", info.specialOfferDiscountPrice]];
    }
    
    [footer showCouponView:info.isUseCoupon];
    if (info.isUseCoupon) {
        [footer.couponLabel setText:[NSString stringWithFormat:@"优惠：¥%@", info.coupon]];
    }
    
    
    
    // 选择优惠券
    [footer setSelectCouponBlock:^{
        CouponSelectViewController *vc = [[CouponSelectViewController alloc] init];
        NSMutableArray *selectCouponIds = [[NSMutableArray alloc] init];
        NSMutableArray *otherSelectCouponIds = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.orderInfoArray.count; i++) {
            OrderAttachInfo *orderAttachInfo = self.orderInfoArray[i];
            if (i == section) {
                NSArray *conponIds = [orderAttachInfo.couponIds componentsSeparatedByString:@","];
                [selectCouponIds addObjectsFromArray:conponIds];
            }
            else {
                NSArray *conponIds = [orderAttachInfo.couponIds componentsSeparatedByString:@","];
                [otherSelectCouponIds addObjectsFromArray:conponIds];
            }
        }
        vc.selectCouponIds = selectCouponIds;
        vc.otherSelectCouponIds = otherSelectCouponIds;
        NSArray *goodsArray = [self.submitGoodsArray objectAtIndex:section];
        NSString *goodsIds = @"";
        NSInteger index = 0;
        for (ShopCartModel *model in goodsArray) {
            goodsIds = [goodsIds stringByAppendingString:model.wsId];
            index++;
            if (index != goodsArray.count) {
                goodsIds = [goodsIds stringByAppendingString:@"|"];
            }
        }
        vc.goodsId = goodsIds;
        
        [vc setSelectCouponsBlock:^(NSArray *coupons) {
            CGFloat discount = 0.0;
            info.couponIds = @"";
            if (coupons.count == 1) {
                info.useCoupon = [coupons firstObject];
                info.couponIds = info.useCoupon.cpId;
                if (info.allPrice < [info.useCoupon.preferentialPrice floatValue]) {
                    [Common showBottomToast:@"多余金额不退换"];
                }
            }else if (coupons.count > 1) {
                info.useCoupon = [coupons firstObject];
                for (Coupon *coupon in coupons) {
                    discount += [coupon.preferentialPrice floatValue];
                    info.couponIds = [info.couponIds stringByAppendingString:[NSString stringWithFormat:@"%@,", coupon.cpId]];
                }
                if (info.couponIds.length > 0) {
                    info.couponIds = [info.couponIds substringWithRange:NSMakeRange(0, info.couponIds.length-1)];
                }
                info.useCoupon.preferentialPrice = [NSString stringWithFormat:@"%.2f", discount];
                if (info.allPrice < discount) {
                    [Common showBottomToast:@"多余金额不退换"];
                }
            }
            else {
                info.useCoupon = nil;
                info.couponIds = nil;
            }
            [self reCaculateDiscount:section];
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
#pragma mark-选择的支付方式 只有在线支付（购物车进入的提交订单）12。2
    [footer setSelectPaymentTypeBlock:^{
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithCancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.supportPaymentTypes[section]];
        [sheet showInView:self.view usingBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex != actionSheet.cancelButtonIndex) {
                [self.paymentTypes replaceObjectAtIndex:section withObject:self.supportPaymentTypes[section][buttonIndex]];
                [self.tableView reloadData];
            }
        }];
    }];
    
    // 选择配送方式
    [footer setSelectExpressTypeBlock:^{
        ExpressTypeViewController *vc = [[ExpressTypeViewController alloc] init];
        NSMutableArray *delivers = [[NSMutableArray alloc] init];
        NSArray *goodsArray = [self.submitGoodsArray objectAtIndex:section];
        for (ShopCartModel *model in goodsArray) {
            if (model.deliveryType != nil && ![model.deliveryType isEqualToString:@""]) {
                //    NSArray *deliverStrings = @[@"物业配送", @"普通快递"];
                NSArray *deliverStrings = [model.deliveryType componentsSeparatedByString:@","];
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
            }
        }
        vc.expressList = delivers;
        [vc setSelectExpressTypeBlock:^(ExpressTypeModel *model) {
            info.deliverMethod = model.ExpressTypeName;
            info.deliverPrice = model.ExpressTypePrice;
            info.useExpress = model;
            [self reCaculateDiscount:section];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // 填写备注
    [footer setWriteRemarkBlock:^{
        RemarkViewController *vc = [[RemarkViewController alloc] init];
        vc.strRemark = info.remark;
        [vc setWriteRemarkBlock:^(NSString *remark) {
            [footer.remarkLabel setText:remark];
            info.remark = remark;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    return footer;
}


// 重新计算优惠金额
- (void)reCaculateDiscount:(NSInteger)section
{
    OrderAttachInfo *info = [self.orderInfoArray objectAtIndex:section];
    NSArray *goodsArray = [self.submitGoodsArray objectAtIndex:section];
    CGFloat waresPrice = [ShopCartModel calculationPrice:goodsArray];
    
    CGFloat _discount = 0.00f;
    Coupon *_useCoupon = info.useCoupon;
    
    if (_useCoupon != nil) {
        if ([_useCoupon.ticketstype isEqualToString:@"4"]) { //买赠券
            for (ShopCartModel *model in goodsArray) {
                if ([model.wsId isEqualToString:info.useCoupon.supportGoodsIds] &&
                    (model.count - [info.useCoupon.buyNumber integerValue]-[info.useCoupon.givenNumber integerValue] >= 0)) {
                    _discount = [info.useCoupon.givenNumber integerValue] * [model.currentPrice floatValue];
                    break;
                }
            }
        }else if ([_useCoupon.ticketstype isEqualToString:@"1"]) {  //现金券
            CGFloat totalPrice = waresPrice;
            if (totalPrice - [_useCoupon.conditionsPrice floatValue] > 0) {
                if (info.useExpress) {
                    totalPrice += [info.useExpress.ExpressTypePrice floatValue];
                }
                if ([_useCoupon.preferentialPrice floatValue] - totalPrice > 0) {
                    _discount = totalPrice;
                }else {
                    _discount = [_useCoupon.preferentialPrice floatValue];
                }
            }
        }else if ([_useCoupon.ticketstype isEqualToString:@"5"]) {  //福利券
            CGFloat totalPrice = waresPrice;
            if (info.useExpress) {
                totalPrice += [info.useExpress.ExpressTypePrice floatValue];
            }
            if ([_useCoupon.preferentialPrice floatValue] - totalPrice > 0) {
                _discount = totalPrice;
            }else {
                _discount = [_useCoupon.preferentialPrice floatValue];
            }
        }else {
            _discount = [_useCoupon getDiscountMoneyWithPrice:(waresPrice)];
        }
    }
    info.coupon = [NSString stringWithFormat:@"%.2f", _discount];
}



#pragma mark - 提交订单到服务器（购物车——>立即结算——>提交订单）
- (void)submitOrderToServer
{
    if (![self isGoToLogin]) {
        return;
    }
    NSInteger section = 0;
    NSString *mOrderNo = [Common createMainOrderNo];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSString *projectName = [userDefault objectForKey:KEY_PROJECTNAME];
    
    NSString *userId = [[LoginConfig Instance] userID];
    NSString *userName = [[LoginConfig Instance] userName];
    NSString *payType = @"1";
    for (NSString *paymentStr in self.paymentTypes) {
        if (paymentStr.length == 0) {
            [Common showBottomToast:@"请选择支付方式"];
            return;
        }
    }
    /*
     if ([self.payMethod isEqualToString:Str_Cart_OnlinePay]) {
     payType = @"0";
     }else if ([self.payMethod isEqualToString:Str_Cart_ArrivePay]) {
     payType = @"1";
     }else {
     [Common showBottomToast:@"请选择支付方式"];
     return;
     }
     */
    if (!_isAllVirtualGoods) {
        if (self.roadData == nil || self.roadData.contactName == nil || [self.roadData.contactName isEqualToString: @""] || self.roadData.contactTel == nil || [self.roadData.contactTel isEqualToString:@""]) {
            [Common showBottomToast:@"请选择正确的联系方式"];
            return;
        }
    }
    
    
    for (int i=0; i<self.submitGoodsArray.count; i++) {
        OrderAttachInfo *info = [self.orderInfoArray objectAtIndex:i];
        //        if ([info.deliverMethod isEqualToString:@"全场包邮"]) {//2015.11.12
        //            [Common showBottomToast:@"请选择商品的配送方式"];
        //            return;
        //        }
        
        if (info.remark.length > 200) {
            [Common showBottomToast:@"亲,备注不能超过200字"];
            return;
        }
        
        if ([info.remark stringContainsEmoji]) {
            [Common showBottomToast:@"亲,备注不能包含表情符号"];
            return;
        }
    }
    for (NSInteger i = 0; i < self.submitGoodsArray.count; i++) {
        NSArray *goodsArray = self.submitGoodsArray[i];
        NSString    *shopId = @"";  //商家ID
        NSString    *cpNo = @"";    //使用的优惠券编号
        NSString    *sOrderNo = [Common createSubOrderNoWithSubNo:(section+1)];
        
        OrderAttachInfo *info = [_orderInfoArray objectAtIndex:section];
        if (info.couponIds) {
            cpNo = info.couponIds;
        }
        
        NSString *orderType = @"";
        NSMutableString *goods = [[NSMutableString alloc] initWithString:@""];
        for (ShopCartModel *model in goodsArray) {
            [goods appendString:[NSString stringWithFormat:@"%@:%ld:%@:%@",model.wsId,(long)model.count, model.waresStyle, model.currentPrice]];
            if ([model isUseSpecialOfferRight]) {
                [goods appendString:[NSString stringWithFormat:@":%@", model.specialOfferPrice]];
            }
            [goods appendString:@","];
            
            shopId =  model.sellerId;
            // 现在的判断规则是，如果有一个是虚拟商品，就都是
            orderType = model.goodsType;
        }
        NSString *payMethod = self.paymentTypes[i];
        if ([payMethod isEqualToString:Str_Cart_OnlinePay]) {
            payType = @"0";
        }
        else if ([payMethod isEqualToString:Str_Cart_ArrivePay]) {
            payType = @"1";
        }
        if (goods.length > 0) {
            NSRange range = NSMakeRange((goods.length-1),1);
            [goods deleteCharactersInRange:range];
            
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
            NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[shopId, cpNo, goods, info.deliverMethod, info.remark, userId, userName, self.roadData.contactName, self.roadData.contactTel, self.addressLabel.text, payType, [NSString stringWithFormat:@"%.2f", info.totalPrice], projectId, projectName, info.deliverPrice, mOrderNo, sOrderNo, info.coupon,@"2",rstt,orderType] forKeys:@[@"sellerId", @"couponsId", @"goodsIds", @"deliveryType", @"content", @"userId", @"userName", @"receiveName", @"receiveTelphone", @"address", @"payType", @"payMoney", @"projectId", @"projectName", @"sendMoney", @"mOrderNo", @"sOrderNo", @"couponsMoney",@"payClient",@"rst",@"orderType"]];
            
            [self getArrayFromServer:SubmitOrder_Url path:SubmitOrder_NewPath method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
                NSString *rst = @"0";
                NSString *errorMsg = @"订单提交失败";
                NSString *orderId = @"";
                NSString *orderNo = @"";
                for (NSDictionary *dic in result) {
                    rst = [dic objectForKey:@"result"];
                    orderId = [dic objectForKey:@"orderId"];
                    orderNo = [dic objectForKey:@"orderNo"];
                    errorMsg = [dic objectForKey:@"errorMsg"];
                }
                
                if ([rst isEqualToString:@"1"]) {
                    self.orderIds = mOrderNo;
                    self.orderNos = [self.orderNos stringByAppendingString:[NSString stringWithFormat:@"%@,", orderNo]];
                    for (ShopCartModel *model in goodsArray) {
                        [[DBOperation Instance] deleteWaresDataFromCart:model.wsId withWaresStyle:model.waresStyle];
                    }
                    [self.submitGoodsArray removeObject:goodsArray];
                    
                    if(info.totalPrice - 0.0099 < 0){
                        [self paymentOkTodoWithId:sOrderNo];
                    }
                    
                    [self judgeIsHasSubmitSuccess];
                    [self judgeIsHasAllReturnResult];
                    
                }else {
                    [self judgeIsHasAllReturnResult];
                    if (errorMsg) {
                        [Common showBottomToast:errorMsg];
                    }else {
                        [Common showBottomToast:@"订单提交失败"];
                    }
                }
            }failure:^(NSError *error) {
                [self judgeIsHasAllReturnResult];
                [Common showBottomToast:Str_Comm_RequestTimeout];
            }];
        }
        section++;
    }
}

#pragma mark - 判断请求是否已经全部返回结果
- (void)judgeIsHasAllReturnResult
{
    self.hasReturnResultCount++;
    if (self.hasReturnResultCount == self.shouldSubmitCount
        && self.hasSubmittedCount != self.shouldSubmitCount) {
        if (self.hasSubmittedCount == 0) {
            [Common showBottomToast:@"订单提交不成功,请重新提交"];
        }else {
            [Common showBottomToast:[NSString stringWithFormat:@"%ld个订单提交不成功,请重新提交", (long)(self.shouldSubmitCount-self.hasSubmittedCount)]];
            [self updateAllOrderInfo];
            [self.tableView reloadData];
        }
    }
}


#pragma mark - 判断是否已经全部提交成功
- (void)judgeIsHasSubmitSuccess
{
    self.hasSubmittedCount++;
    if (self.hasSubmittedCount == self.shouldSubmitCount) {
        if ([self.paymentTypes containsObject:Str_Cart_OnlinePay]) {
            [Common showBottomToast:@"订单提交成功"];
            CGFloat amount = 0.0f;
            for (NSInteger i = 0; i < self.orderInfoArray.count; i ++) {
                OrderAttachInfo *info = [self.orderInfoArray objectAtIndex:i];
                if ([self.paymentTypes[i] isEqualToString:Str_Cart_OnlinePay]) {
                    amount += info.totalPrice;
                }
            }
            if (amount - 0.0099 < 0) {
                [self paymentOkTodo];
            }
            else {
                PayMethodViewController *vc = [[PayMethodViewController alloc] init];
                vc.orderId = self.orderIds;
                vc.amount = amount;
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else {
            CommitResultViewController *vc = [[CommitResultViewController alloc] init];
            vc.eFromViewID = E_ResultViewFromViewID_SubmitCommodityOrder;
            vc.resultTitle = @"下单成功";
            self.orderNos = [self.orderNos substringWithRange:NSMakeRange(0, self.orderNos.length-1)];
            vc.resultDesc = @"您已成功提交订单";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ShoppingCartChangedNotification object:nil];
    }
}

#pragma mark - TextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self autoUpdateFooterViewHeightForSection:textView.tag];
}

// 自动更新FooterView高度
- (void)autoUpdateFooterViewHeightForSection:(NSInteger)section
{
    ConfirmOrderFooterView *footer = (ConfirmOrderFooterView *)[self.tableView footerViewForSection:section];
    
    CGFloat height = 28.0;
    if (IOS7) {
        CGRect textFrame=[[footer.remarkTextView layoutManager]usedRectForTextContainer:[footer.remarkTextView textContainer]];
        height = textFrame.size.height;
    }else {
        height = footer.remarkTextView.contentSize.height;
    }
    
    if (height > 28.0) {
        footer.remarkTextViewHeight.constant = 44.0 + height - 28.0;
    }
    
    
    if (footer.remarkTextViewHeight.constant - 44.0 > 0) {
        CGFloat height = 176.0 + footer.remarkTextViewHeight.constant - 44.0;
        footer.frame = CGRectMake(footer.frame.origin.x, footer.frame.origin.y, Screen_Width, height);
        self.tableView.tableFooterView = _tableFooter;
    }
}


#pragma mark - 联系人选择按钮点击事件处理函数（购物车进入的提交订单）
- (IBAction)contactBtnClickHandler:(id)sender
{
    _isCallBack = NO;
    RoadAddressManageViewController *vc = [[RoadAddressManageViewController alloc] init];
    vc.isAddressSel = addressSel_Default;
    [vc setSelectRoadData:^(RoadData *roadData) {
        _isCallBack = YES;
        self.roadData = roadData;
        [self.addressLabel setText:[NSString stringWithFormat:@"%@  %@",roadData.projectName, roadData.address]];
        [self.contactLabel setText:[NSString stringWithFormat:@"%@ %@", roadData.contactName, roadData.contactTel]];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}


 #pragma mark - 支付方式选择按钮点击事件处理函数  12.2
/* - (IBAction)paymentBtnClickHandler:(id)sender
 {
 UIActionSheet   *sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_Cart_ArrivePay,Str_Cart_OnlinePay, nil];
 [sheet showInView:self.view];
 }
 
 #pragma mark -ActionSheet代理
 - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 if (buttonIndex == 0) {
 self.payMethod = Str_Cart_ArrivePay;
 [self.paymentLabel setText:Str_Cart_ArrivePay];
 }
 else if (buttonIndex == 1)
 {
 self.payMethod = Str_Cart_OnlinePay;
 [self.paymentLabel setText:Str_Cart_OnlinePay];
 }
 }*/


#pragma mark - UIAlertView Delegate 12.2
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else if (buttonIndex == 1) {
//        PersonalCenterMyOrderViewController *vc = [[PersonalCenterMyOrderViewController alloc] init];
//        vc.orderType = OrderType_Commodity;
//        [self.navigationController popToViewController:vc animated:YES];
//    }
//}

#pragma mark - 提交订单按钮点击事件处理函数
- (IBAction)submitBtnClickHandler:(id)sender
{
    [self submitOrderToServer];
}


// 付款成功后调用的Delegate方法
- (void)paymentOkTodo
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: self.orderIds,@"orderNo",nil];
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
     [Common showBottomToast:@"该订单不存在"];
     }else if ([result isEqualToString:@"1"]) {
     CommitResultViewController *vc = [[CommitResultViewController alloc] init];
     vc.eFromViewID = E_ResultViewFromViewID_SubmitCommodityOrder;
     vc.resultTitle = @"支付成功";
     vc.resultDesc = [NSString stringWithFormat:@"您已成功付款:￥%.2f", _allGoodsPrice];
     [self.navigationController pushViewController:vc animated:YES];
     }else {
     [Common showBottomToast:@"提交订单失败"];
     }
     
     } failure:^(NSError *error) {
     [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
     */
    //    CommitResultViewController *vc = [[CommitResultViewController alloc] init];
    //    vc.eFromViewID = E_ResultViewFromViewID_SubmitCommodityOrder;
    //    vc.resultTitle = @"支付成功";
    //    vc.resultDesc = [NSString stringWithFormat:@"订单编号:%@", self.orderIds];
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)paymentOkTodoWithId:(NSString *)orderId
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: orderId,@"orderNo",nil];
    [self getArrayFromServer:SubmitOrder_Url path:PayOrderSuccess_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        NSDictionary *resultDic = [result firstObject];
        if ([resultDic[@"result"] isEqualToString:@"0"]) {
            [Common showBottomToast:@"提交订单失败"];
            return ;
        }else {
            CommitResultViewController *vc = [[CommitResultViewController alloc] init];
        }
    } failure:^(NSError *error) {
        
    }];
}


// 付款失败后的调用的Delegate方法
- (void)paymentFailTodo
{
    CommitResultViewController *vc = [[CommitResultViewController alloc] init];
    vc.eFromViewID = E_ResultViewFromViewID_OrderPayResult;
    vc.resultTitle = @"支付失败";
    vc.resultDesc = @"亲，您的订单支付失败啦";
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 手势隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

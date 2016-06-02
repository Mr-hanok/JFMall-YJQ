//
//  PayMethodViewController.m
//  CommunityApp
//
//  Created by issuser on 15/7/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PayMethodViewController.h"
#import "PayMethodTableViewCell.h"
//aipay
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
//wxpay
#import "AFHTTPSessionManager.h"
//#import "AFHTTPRequestOperationManager.h"
#import "CommonUtil.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "DoorToDoorServiceViewController.h"
#import "PersonalCenterMyOrderViewController.h"

#pragma mark - 宏定义区
#define PayMethodTableViewCellNibName       @"PayMethodTableViewCell"
typedef enum
{
    payment_Alipay = 0,
    payment_WeiXin,
    payment_UnionPay,
}payment_Type;
@interface PayMethodViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *amountLabel;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *payMethodArray;
@property (assign,nonatomic) Payment_Goal payment;

//wxpay
@property (copy) NSString *accessToken;
@property (copy) NSString *timeStamp;
@property (copy) NSString *nonceStr;
@property (copy) NSString *traceId;
@property (copy) NSString *package;
@property (copy) NSString *prepayid;
@end

@implementation PayMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Cart_PayMethod;
    
    //  设置tableView不可移动
    self.tableView.scrollEnabled = NO;
    
    [self initPayMethodListData];
     [_amountLabel setText: [NSString stringWithFormat:@"￥%.2f",_amount]];
    [[Common appDelegate] setWxPayOKtoDo:^(BOOL result) {
        if (result == TRUE) {
             if([self.delegate respondsToSelector:@selector(paymentOkTodo)])
             {
                 [self.delegate paymentOkTodo];
             }
        }
        else
        {
            if([self.delegate respondsToSelector:@selector(paymentFailTodo)])
            {
                [self.delegate paymentFailTodo];
            }

        }
    }
    ];
     
    // Do any additional setup after loading the view from its nib.
}

- (void)navBarLeftItemBackBtnClick
{
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    [viewControllers removeObjectAtIndex:viewControllers.count-2];
    
    PersonalCenterMyOrderViewController *vc = [[PersonalCenterMyOrderViewController alloc] init];
    vc.orderType = OrderType_Commodity;
    [viewControllers insertObject:vc atIndex:viewControllers.count-1];
    
    self.navigationController.viewControllers = viewControllers;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.payMethodArray.count;
}

 
-(void)setPayInfo:(PaymentProductModel*)product
{
    _amount = [product.productPrice floatValue];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PayMethodTableViewCellNibName forIndexPath:indexPath];
    
    //  填充数据
    NSString *name = [[self.payMethodArray objectAtIndex:indexPath.row] objectAtIndex:0];
    NSString *icon = [[self.payMethodArray objectAtIndex:indexPath.row] objectAtIndex:1];
    
    [cell setPayMethodName:name setPayMethodIcon:icon];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma -mark  网络连接判断
    BOOL netWorking = [Common checkNetworkStatus];
    if (netWorking) {
        PayMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PayMethodTableViewCellNibName forIndexPath:indexPath];
        cell.backgroundColor=[UIColor grayColor];
        
        if(_payment == Payment_Prepay || _payment == Payment_Bill)///////
        {
            if (indexPath.row == 0) {
                [self aiPay];
            }
            else///////////
            {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
                {
                    [self wxPayAction];//////////
                }
                else
                {
                    UIAlertView*aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机未安装微信，请安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [aler show];
                }
            }
            [self.HUD show:YES];
        }
    }
    else
    {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        return;
    }
}
// 初始化基本数据
- (void)initPayMethodListData
{
#pragma -mark 12-12 到家屏蔽微信支付
    NSArray *payMethod;
    if (self.daojiaNo == nil || self.daojiaNo == Nil) {
        payMethod = @[@[Str_PayMethod_Alipay, Img_PayMethod_Alipay],   // 支付宝支付
                               @[Str_PayMethod_Wechat, Img_PayMethod_Wechat]];     // 微信支付

    }
    else
    {
        payMethod = @[@[Str_PayMethod_Alipay, Img_PayMethod_Alipay]];  // 支付宝支付

    }
//    NSArray *payMethod = @[@[Str_PayMethod_Alipay, Img_PayMethod_Alipay],   // 支付宝支付
//                           @[Str_PayMethod_Wechat, Img_PayMethod_Wechat]];     // 微信支付

//    NSArray *payMethod = @[@[Str_PayMethod_Alipay, Img_PayMethod_Alipay]];   // 支付宝支付
    
    self.payMethodArray = [[NSMutableArray alloc] initWithArray:payMethod];
    
    // 注册TableViewCell Nib
    UINib *nibForPayMethod = [UINib nibWithNibName:PayMethodTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForPayMethod forCellReuseIdentifier:PayMethodTableViewCellNibName];
}

// 向服务器发送预交费用动作

// 向服务器发送交费用动作
//-(void)postBillToServerForBuildingId:(NSString *)buildingId
//{
//    UserModel* user = [[LoginConfig Instance] getUserInfo];
//    if(user == nil )
//    {
//        return;
//    }
//    // 初始化参数
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[buildingId,_receivableIds,user.userAccount] forKeys:@[@"buildingId", @"receivableIds",@"userAccount"]];
//    
//    // 请求服务器获取数据
//    [self getStringFromServer:CommunityBill_Url path:paymentBill_Path parameters:dic success:^(NSString *result) {
//        if([result isEqualToString:@"1"])
//        {
//            NSLog(@"缴费账单成功");
//            [self.navigationController popViewControllerAnimated:TRUE];
//        }
//    } failure:^(NSError *error){
//        [Common showBottomToast:Str_Comm_RequestTimeout];
//    }];
//}
#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

-(void)aiPay
{
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = AliPartnerId;
    NSString *seller = AliSellerId;
    NSString *privateKey = PartnerPrivKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    if (self.orderId != nil && ![self.orderId isEqualToString:@""]) {
        order.tradeNO = self.orderId;
    }else {
        order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    }
    
    order.productName = @"亿街区"; //商品标题
    order.productDescription = @"亿街区"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",_amount]; //商品价格
    order.notifyURL =  AlipayNotifyUrl; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在info.plist定义URL types
    NSString *appScheme = @"CommunityApp";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString* payResult = [resultDic objectForKey:@"resultStatus"];
            NSString* result = [resultDic objectForKey:@"result"];
            NSString* aipayResult = @"fail";
            NSArray *resultStringArray =[result componentsSeparatedByString:NSLocalizedString(@"&", nil)];
            for (NSString *str in resultStringArray)
            {
                NSString *newstring = nil;
                newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
                for (int i = 0 ; i < [strArray count] ; i++)
                {
                    NSString *st = [strArray objectAtIndex:i];
                    
                    if ([st isEqualToString:@"success"]) {
                        aipayResult = [strArray objectAtIndex:1];
                    }
                }
            }
            if([payResult isEqualToString:@"9000"] && [aipayResult isEqualToString:@"true"])
            {
                if ([self.delegate respondsToSelector:@selector(paymentOkTodo)]) {
                [self.delegate paymentOkTodo];
                }
                
                if ([self.delegate respondsToSelector:@selector(paymentOkTodo:)]) {
                    [self.delegate paymentOkTodo:result];
                }
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(paymentFailTodo)]) {
                    [self.delegate paymentFailTodo];
                }

            }
           //[self.navigationController popViewControllerAnimated:YES];

        }];

    }
}
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
 
}
- (void)wxPayAction{
        //{{{
        //本实例只是演示签名过程， 请将该过程在商户服务器上实现
        
        //创建支付签名对象
        payRequsestHandler *req = [[payRequsestHandler alloc] init];
        //初始化支付签名对象
        [req init:kWXAppID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];
        float fee = round(_amount*100);
        NSString *feeStr = [NSString stringWithFormat:@"%ld",(NSInteger)(fee<1?1:fee) ];
        [req setFee: feeStr andOrderNo:_orderId];
    
        //}}}
        
        //获取到实际调起微信支付的参数后，在app端调起支付
        NSMutableDictionary *dict = [req sendPay];
        
        if(dict == nil){
            [self.HUD show:NO];
            //错误提示
            NSString *debug = [req getDebugifo];
            [self alert:@"提示信息" msg:@"微信支付异常，请重新尝试~"];
//            [self alert:@"提示信息" msg:debug];
            YjqLog(@"%@",debug);
            
        }else{
            //屏蔽微信支付
            NSLog(@"%@\n\n",[req getDebugifo]);
//            [self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
            
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            
            [WXApi sendReq:req];
            [self.HUD show:NO];
        }
}

 
 
@end

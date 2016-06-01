//
//  PayBillViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PayBillViewController.h"
#import "PayMethodViewController.h"
#import "PayMethodViewController.h"

@interface PayBillViewController ()<PayMethodViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *unpayMoneyLabel;
@property (retain, nonatomic) IBOutlet UILabel *prepayMoneyLabel;
@property (retain, nonatomic) IBOutlet UITextField *payValue;
@property (retain, nonatomic) IBOutlet UIButton *useCheckBox;
@property (retain,nonatomic) NSString* prepayMoney;
@property (retain,nonatomic) NSString* unpayMoney;
@end

@implementation PayBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_PropBill_PayBill;
    [self setNavBarLeftItemAsBackArrow];
    
    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self getBillGeneralInfoFromServerForBuildingId:_buildingId];
}

#pragma mark - 按钮点击事件处理函数
// 确认按钮点击事件处理函数
- (IBAction)confirmBtnClickHandler:(id)sender
{
    if ([_payValue.text floatValue] < 0.1) {
        [Common showBottomToast:@"最低缴费金额为0.1元"];
        return;
    }
    NSString *orderId = [Common createPropertyBillOrderNo];
    [self postBillToServerForBuildingId:_buildingId payment:@"409" tradeNo:orderId];      // 409: 转账 (字典数据)
}

-(void)paymentOkTodo:(NSString*)result
{
    [Common showBottomToast:@"缴费成功"];
//    NSString* tradeNo = @"";
//    NSString* payment = @"";
//    NSArray *resultStringArray =[result componentsSeparatedByString:NSLocalizedString(@"&", nil)];
//    for (NSString *str in resultStringArray)
//    {
//        NSString *newstring = nil;
//        newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
//        for (int i = 0 ; i < [strArray count] ; i++)
//        {
//            NSString *st = [strArray objectAtIndex:i];
//            
//            if ([st isEqualToString:@"out_trade_no"])
//            {
//                tradeNo = [strArray objectAtIndex:1];
//            }
//            if ([st isEqualToString:@"payment_type"]) {
//                payment = [strArray objectAtIndex:1];
//            }
//        }
//    }
//    [self postBillToServerForBuildingId:_buildingId payment:payment tradeNo:tradeNo];
}

-(void)paymentFailTodo{
    [Common showBottomToast:@"缴费失败"];
}
-(void)postBillToServerForBuildingId:(NSString *)buildingId payment:(NSString*)payment tradeNo:(NSString*)tradeNo
{
    /*
     paymentAmount		缴费金额
     paymentDate			缴费时间
     ownerId				缴费人ID
     buildingId			楼址ID
     paymentType			缴费方式（码值1:支付宝 2：微信 2：银联）
     paySerNo				支付流水号
     */
    CGFloat amount = [self.payValue.text floatValue];
    UserModel* user = [[LoginConfig Instance] getUserInfo];
    if(user == nil )
    {
        return;
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* curDate = [dateFormatter stringFromDate:[NSDate date]];
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[buildingId,[NSString stringWithFormat:@"%.2f",amount],user.userId,curDate,payment,tradeNo] forKeys:@[@"buildingId", @"paymentAmount",@"ownerId",@"paymentDate",@"paymentType",@"paySerNo"]];
    
    // 请求服务器获取数据
    [self getStringFromServer:CommunityBill_Url path:prePaymentBill_Path parameters:dic success:^(NSString *result) {
        if([result isEqualToString:@"1"])
        {
            CGFloat amount = [self.payValue.text floatValue];
            
            PayMethodViewController *next = [[PayMethodViewController alloc] init];
            next.delegate = self;
            next.amount = amount;
            
            [self.navigationController pushViewController:next animated:TRUE];
            
//            [self.navigationController popViewControllerAnimated:TRUE];
        }
    } failure:^(NSError *error){
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
// 使用CheckBox点击事件处理函数
- (IBAction)useBtnClickHandler:(id)sender
{
    [self.useCheckBox setSelected:!self.useCheckBox.selected];
}


#pragma mark - 手势隐藏键盘
- (void)hideKeyBoard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getBillGeneralInfoFromServerForBuildingId:(NSString *)buildingId
{
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[buildingId] forKeys:@[@"buildingId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:CommunityBill_Url  path:PaymentList_Path method:@"GET" parameters:dic xmlParentNode:@"payment" success:^(NSMutableArray *result)
     {
         NSDictionary* dic = [result objectAtIndex:0];
         _prepayMoney = [dic objectForKey:@"prepaidAmount"];
         if(_prepayMoney == nil || [_prepayMoney isEqualToString:@""])
             _prepayMoney = @"0.0";
         [_prepayMoneyLabel setText:[NSString stringWithFormat:@"￥%@",_prepayMoney]];
         _unpayMoney =  [dic objectForKey:@"unpaidAmount"];
         if(_unpayMoney == nil || [_unpayMoney isEqualToString:@""])
             _unpayMoney = @"0.0";
         [_unpayMoneyLabel setText:[NSString stringWithFormat:@"￥%@",_unpayMoney]];
     }
                     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}

@end

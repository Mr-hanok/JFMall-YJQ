//
//  ServiceOrderWebViewController.m
//  CommunityApp
//
//  Created by 张艳清 on 15/11/30.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "ServiceOrderWebViewController.h"
#import "Interface.h"
#import "LoginConfig.h"
//js与ios交互三方库
#import <JavaScriptCore/JavaScriptCore.h>//方法二

//请选择支付方式页
#import "PayMethodViewController.h"
#import "CommitResultViewController.h"

@interface ServiceOrderWebViewController ()<UIWebViewDelegate,PayMethodViewDelegate>


@property (nonatomic,strong) UIWebView *webView;
//js与iOS交互（方法二）
@property (copy,nonatomic) NSString* orderId;
@property (copy,nonatomic) NSString* orderNo;
@property (assign,nonatomic) double orderMoney;
@property (copy,nonatomic) NSString* resultStr;
@property (nonatomic,strong) JSContext *context;

@end

@implementation ServiceOrderWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化导航栏
    self.navigationItem.title = Str_ServiceOrder;
    [self setNavBarLeftItemAsBackArrow];


    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scalesPageToFit = YES;//设置网页适配屏幕
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    

    self.hidesBottomBarWhenPushed=NO;


#pragma -mark js 调用iOS方法
    _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

//    [self payOk];
}

#pragma mark---PayMethodViewDelegate
-(void)paymentOkTodo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

    [dic setValue:self.orderId forKey:@"orderId"];

    //NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: _orderId,@"orderId",nil];
    [self getArrayFromServer:SubmitOrder_Url path:PaySuccessServiceOrder_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        NSDictionary *resultDic = [result firstObject];
        if ([resultDic[@"result"] isEqualToString:@"0"]) {
            [Common showBottomToast:@"提交订单成功"];
            CommitResultViewController *vc = [[CommitResultViewController alloc] init];
            vc.eFromViewID = E_ResultViewFromViewID_SeverOrderPayResult;
            vc.resultTitle = @"支付成功";
            vc.resultDesc = [NSString stringWithFormat:@"订单编号:%@", self.orderNo];
            vc.couponsStr = resultDic[@"coupons"];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            YjqLog(@"33333");
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];

    [self payOk];
}
-(void)payOk
{
//    if(_orderId == nil)
//        return;

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: _orderId,@"orderId",nil];

    [self getStringFromServer:SubmitOrder_Url path:PaySuccessServiceOrder_Path method:@"POST" parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"0"]) {
            [Common showBottomToast:@"提交订单成功"];
            //提交订单成功,三个参数：支付结果result，orderNo,orderMoney
            _resultStr = result;//支付成功结果
            JSValue *function = _context[@"alipayinfo"];
            JSValue *result = [function callWithArguments:@[@"1",self.orderNo,[NSString stringWithFormat:@"%.2f",self.orderMoney]]];
            YjqLog(@"---------%@",result);
//            return ;//跳出方法
        }


    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
#pragma -mark webview加载回调事件
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    NSString *userAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    YjqLog(@"*******%@",userAgent);

    _context[@"clickOnIOSForOrderInfo"] = ^() {
        //支付宝支付
        NSArray *infoArr = [JSContext currentArguments];
        //        YjqLog(@"%@",infoArr);
        JSValue *jsorderId = infoArr[0];
        self.orderId = jsorderId.toString;
        JSValue *jsorderNo = infoArr[1];
        self.orderNo = jsorderNo.toString;
        JSValue *jsorderMoney = infoArr[2];
        self.orderMoney = jsorderMoney.toDouble;
        /*
         将data传给支付界面进行支付,data字典类型
         */
        //跳转支付界面
        PayMethodViewController* vc = [[PayMethodViewController alloc]init];
        vc.delegate = self;
        vc.orderId = self.orderNo;//orderId订单号
        vc.amount = self.orderMoney;//money价格
        vc.daojiaNo = self.orderNo;//判断到家微信支付
        [self.navigationController pushViewController:vc animated:TRUE];
        return @"1";
    };

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self getServiceOrderDataFromService];
    //    // 将此webview与WebViewJavascriptBridge关联
    //    if (_bridge) { return; }
    //
    //    [WebViewJavascriptBridge enableLogging];
    //
    //    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
    //        NSLog(@"ObjC received message from JS: %@", data);//data字典类型，js穿给oc的值
    //        responseCallback(@"Response for message from ObjC");//oc返回给js的值
    //    }];
    //
    //
    //    //（1） js调oc方法（可以通过data给oc方法传值，使用responseCallback将值再返回给js）
    //    [_bridge registerHandler:@"clickOniOSForOrderInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
    //        YjqLog(@"%@",data);
    //        /*
    //         将data传给支付界面进行支付,data字典类型
    //         */
    ////跳转支付界面
    //
    ////        PayMethodViewController* vc = [[PayMethodViewController alloc]init];
    ////        vc.delegate = self;
    ////        vc.orderId = self.orderNo;//orderId订单号
    ////        vc.amount = 123;//money价格
    ////        [self.navigationController pushViewController:vc animated:TRUE];
    //
    //        NSLog(@"result called: %@", data);
    //        /*
    //         将支付结果返回给js
    //         */
    //        responseCallback(@"Response from clickOniOSForOrderInfo");
    //    }];
    //
    //    [_bridge registerHandler:@"clickOniOSForOrderNo" handler:^(id data, WVJBResponseCallback responseCallback) {
    //        responseCallback(@"OrderNo");
    //    }];
    //
    //    [_bridge registerHandler:@"clickOniOSForMoney" handler:^(id data, WVJBResponseCallback responseCallback) {
    //        responseCallback(@"Money");
    //    }];
}
#pragma -mark 从服务器获取不同社区服务列表
- (void)getServiceOrderDataFromService
{
    NSString *userid = [[LoginConfig Instance]userID];

    self.url = [NSString stringWithFormat:@"%@page/ebei/ownerWeixin/center/service/orderAIIOS.html?memberId=%@",Service_Address,userid];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _url]]];
    [self.webView loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{

}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

- (void)navBarLeftItemBackBtnClick
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

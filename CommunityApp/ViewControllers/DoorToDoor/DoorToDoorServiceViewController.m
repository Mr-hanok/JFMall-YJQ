//
//  DoorToDoorServiceViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "DoorToDoorServiceViewController.h"
#import "DoorToDoorServiceTableViewCell.h"
#import "DetailServiceViewController.h"
#import "ServiceList.h"
#import "MJRefresh.h"
//新到家
#import "WebViewController.h"
#import "Interface.h"
#import "LoginConfig.h"
//js和iOS交互
#import <JavaScriptCore/JavaScriptCore.h>//方法二
//请选择支付方式页
#import "PayMethodViewController.h"
#import "CommitResultViewController.h"


#define pageSize (10)
#define DoorToDoorServiceTableViewCellNibName @"DoorToDoorServiceTableViewCell"
@interface DoorToDoorServiceViewController ()<UIWebViewDelegate,PayMethodViewDelegate>
//新到家
@property(nonatomic,strong)UIWebView *webVC;
//12-01
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *doorToDoorServiceArray;
@property (assign, nonatomic) NSInteger pageNum;
//js与ios交互
@property (copy,nonatomic) NSString* orderId;
@property (copy,nonatomic) NSString* orderNo;
@property (assign,nonatomic) double orderMoney;
@property (copy,nonatomic) NSString* resultStr;
@property (nonatomic,strong) JSContext *context;

@end

@implementation DoorToDoorServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     
     */

    //初始化导航栏
    self.navigationItem.title = Str_Door_To_Door_Service_Title_new;
    //到家页添加左侧网页返回按钮
    [self setNavBarLeftItemAsBackArrow];
    
#pragma -新到家服务
    self.webVC = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44-64)];
    self.webVC.backgroundColor = [UIColor clearColor];
    self.webVC.scalesPageToFit = YES;//设置网页大小适配
    self.webVC.userInteractionEnabled = YES;//网页可交互
    self.webVC.delegate = self;
    [self.view addSubview:self.webVC];

    self.hidesBottomBarWhenPushed = NO;
#pragma -mark js 调用iOS方法
//    _context = [_webVC valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
/*

    self.navigationItem.title = Str_Door_To_Door_Service_Title;
    // 注册Cell
    UINib *nibForDoorToDoorService = [UINib nibWithNibName:DoorToDoorServiceTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForDoorToDoorService forCellReuseIdentifier:DoorToDoorServiceTableViewCellNibName];
    self.doorToDoorServiceArray = [[NSMutableArray alloc]init];


    // 添加下拉/上滑刷新更多
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getDoorToDoorServiceDataFromService];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.doorToDoorServiceArray.count == self.pageNum*pageSize) {
            self.pageNum++;
            [self getDoorToDoorServiceDataFromService];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
    self.tableView.footer = footer;
*/

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
            JSValue *function = _context[@"alipayinfoIOS"];
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
#pragma -mark js 调用iOS方法   支付宝支付界面

    _context[@"clickOnIOSForOrderInfo"] = ^() {
        //支付宝支付
        NSArray *infoArr = [JSContext currentArguments];
        YjqLog(@"%@",infoArr);
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
        vc.orderId = self.orderNo;//orderId订单号
        vc.amount = self.orderMoney;//money价格
        vc.daojiaNo = self.orderNo;//判断是否显示微信支付
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:TRUE];
        return @"1";
    };
}

#pragma -mark 设置网页返回按钮
- (void)navBarLeftItemBackBtnClick
{
    if ([self.webVC canGoBack]) {
        [self.webVC goBack];
    }
    else {
//        [self.navigationController popViewControllerAnimated:YES];
    }
}



// 重载viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.frame = CGRectMake(0, Screen_Height - BottomBar_Height, Screen_Width, BottomBar_Height);
    //从服务器读取数据
//    [self getDoorToDoorServiceDataFromService];

    
    //解析数据
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.projectId = [userDefault objectForKey:KEY_PROJECTID];
    YjqLog(@"----%@",self.projectId);
    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    YjqLog(@"---%@",userid);
    

    self.url = [NSString stringWithFormat:@"%@memberId=%@&commId=%@&type=2",SERVICE_TO_HOME_API,userid,self.projectId];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _url]]];
    [self.webVC loadRequest:request];
    self.hidesBottomBarWhenPushed = NO;
#pragma -mark js 调用iOS方法
    _context = [_webVC valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
}
#pragma -mark 从服务器获取不同社区的到家列表
- (void)getDoorToDoorServiceDataFromService
{
    //解析数据
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.projectId = [userDefault objectForKey:KEY_PROJECTID];
    YjqLog(@"----%@",self.projectId);
    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    YjqLog(@"---%@",userid);

    self.url = [NSString stringWithFormat:@"%@memberId=%@&commId=%@&type=2",SERVICE_TO_HOME_API,userid,self.projectId];
    YjqLog(@"%@",self.url);

    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _url]]];
    [self.webVC loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-tableView的代理和数据源
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.doorToDoorServiceArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DoorToDoorServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DoorToDoorServiceTableViewCellNibName forIndexPath:indexPath];
//    [cell loadCellData:[self.doorToDoorServiceArray objectAtIndex:indexPath.row]];
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return Screen_Width * (2.0 / 5.0);
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DetailServiceViewController *vc = [[DetailServiceViewController alloc]init];
//    ServiceList *service = [self.doorToDoorServiceArray objectAtIndex:indexPath.row];
//     vc.serviceId = service.serviceId;
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - 从服务器获取数据
//- (void)getDoorToDoorServiceDataFromService {
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
//    
//    // 初始化参数
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[projectId, [NSString stringWithFormat:@"%ld",(long)_pageNum], [NSString stringWithFormat:@"%ld", (long)pageSize]] forKeys:@[@"projectId", @"pageNum", @"perSize"]];
//
//    // 请求服务器获取数据
//    [self getArrayFromServer:DoorToDoorList_Url path:DoorToDoorList_Path method:@"GET" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
//        if (_pageNum == 1) {
//            [self.doorToDoorServiceArray removeAllObjects];
//        }
//        
//        for (NSDictionary *dic in result) {
//            [self.doorToDoorServiceArray addObject: [[ServiceList alloc] initWithDictionary:dic]];
//        }
//        [self.tableView reloadData];
//        [self.tableView.header endRefreshing];
//        [self.tableView.footer endRefreshing];
//        if (self.doorToDoorServiceArray.count < _pageNum*pageSize) {
//            [self.tableView.footer noticeNoMoreData];
//        }
//        if (self.doorToDoorServiceArray.count == 0) {
//            [Common showBottomToast:@"暂无到家服务"];
//        }
//    } failure:^(NSError *error) {
//        [_tableView reloadData];
//        [self.tableView.header endRefreshing];
//        [self.tableView.footer endRefreshing];
//        [Common showBottomToast:Str_Comm_RequestTimeout];
//    }];
//}

@end

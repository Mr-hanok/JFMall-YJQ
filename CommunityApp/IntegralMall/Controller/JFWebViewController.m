//
//  JFWebViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/5/26.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFWebViewController.h"
#import "JFPrizeListViewController.h"
#import "APIPrizeMsgReuqest.h"
#import "ApiAddToShopCarRequest.h"

@interface JFWebViewController ()<UIWebViewDelegate,APIRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic, copy) NSString *logid;
@property (nonatomic, strong) APIPrizeMsgReuqest *apiPrizeMsg;
@property (nonatomic, strong) ApiAddToShopCarRequest *apiAddShopCar;

@end
@implementation JFWebViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.webview.scalesPageToFit = YES;
    if (![self.bannerModel.jump_url hasPrefix:@"http://"]) {
        self.bannerModel.jump_url = [@"http://" stringByAppendingString:self.bannerModel.jump_url];
    }
   self.title = self.bannerModel.title;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    LoginConfig *login = [LoginConfig Instance];
    NSString *uid = [login userID];
    
    //http://d.bjyijiequ.com/mallyjq/wxr/activityapp1.htm
    //http://d.bjyijiequ.com/mallyjq/wxr/activityapp2.htm
    NSString *urlStr = [NSString stringWithFormat:@"%@?userId=%@&pub_type=3",self.bannerModel.jump_url,uid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.];
    [self.webview loadRequest:request];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
#pragma mark - UIWebViewDelegat

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [HUDManager showLoadingHUDView:self.webview];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [HUDManager hideHUDView];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [HUDManager hideHUDView];
    [HUDManager showWarningWithText:kDefaultWebErrorString];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [HUDManager hideHUDView];
    NSString *url = request.URL.description;
    if ([url hasPrefix:@"app://mactivity1/list"]) {//我的中奖纪录->大转盘
        [self pushWithVCClass:[JFPrizeListViewController class] properties:@{@"title":@"中奖纪录",@"active_type":@"1"}];
        return NO;
    }
    if ([url hasPrefix:@"app://mactivity2/list"]) {//我的中奖纪录->刮一刮
        [self pushWithVCClass:[JFPrizeListViewController class] properties:@{@"title":@"中奖纪录",@"active_type":@"2"}];
        return NO;
    }

    if ([url hasPrefix:@"app://mactivity1/award"]) {//大转盘实物奖品去领奖
        // app://mactivity1/award?prize_type=1&logid=145
        NSArray *logids =[url componentsSeparatedByString:@"logid="];
        self.logid = [logids lastObject];
        [self getPrizeMsgAndAddToShopCar];
    }
    if ([url hasPrefix:@"app://mactivity2/award"]) {//大转盘实物奖品去领奖
        // app://mactivity1/award?prize_type=1&logid=145
        NSArray *logids =[url componentsSeparatedByString:@"logid="];
        self.logid = [logids lastObject];
        [self getPrizeMsgAndAddToShopCar];
    }

    
    return YES;
}
#pragma mark -  APIRequestDelegate

- (void)serverApi_RequestFailed:(APIRequest *)api error:(NSError *)error {
    
    [HUDManager hideHUDView];
    [HUDManager showWarningWithText:kDefaultNetWorkErrorString];
}

- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr {
    
    [HUDManager hideHUDView];
    
    if (sr.dic == nil || [sr.dic isKindOfClass:[NSNull class]]) {
        return;
    }
    if (api == self.apiPrizeMsg) {//查询商品信息->加入购物车
        
        [self addToShopCarWithResult:sr];
    }
    if (api == self.apiAddShopCar) {//加入购物车
        
        NSString *gc_id = [ValueUtils stringFromObject:[sr.dic objectForKey:@"gc_id"]];
        [self pushWithVCClassName:@"JFCommitOrderViewController" properties:@{@"title":@"提交订单",
                       @"goodsId":gc_id,
                       @"isPrize":@YES,
                        @"log_id":self.logid,
                    @"order_flag":@"1"}];
    }
}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) {
        message = kDefaultServerErrorString;
    }
    [HUDManager showWarningWithText:message];
}



#pragma mark - private methods

- (void)getPrizeMsgAndAddToShopCar{
    self.apiPrizeMsg = [[APIPrizeMsgReuqest alloc]initWithDelegate:self];
    [self.apiPrizeMsg setApiParamsWithLog_id:self.logid];
    [APIClient execute:self.apiPrizeMsg];
}

- (void)addToShopCarWithResult:(APIResult *)sr{
    
    NSString *goodsId = [ValueUtils stringFromObject:[sr.dic objectForKey:@"goodsid"]];
    NSString *goodsPrice = [ValueUtils stringFromObject:[sr.dic objectForKey:@"price"]];
    NSString *goodsCount = [ValueUtils stringFromObject:[sr.dic objectForKey:@"count"]];
    NSString *goodsSkuid = [ValueUtils stringFromObject:[sr.dic objectForKey:@"skuid"]];
    NSString *goodsGsp = [ValueUtils stringFromObject:[sr.dic objectForKey:@"gsp"]];
    
    self.apiAddShopCar = [[ApiAddToShopCarRequest alloc]initWithDelegate:self];
    [self.apiAddShopCar setApiParamsWithGoodsId:goodsId
                                          count:goodsCount
                                       integral:goodsPrice
                                         sku_id:goodsSkuid
                                          gspid:goodsGsp];
    [APIClient execute:self.apiAddShopCar];

}
#pragma mark - event response
@end

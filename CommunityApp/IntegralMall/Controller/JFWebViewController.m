//
//  JFWebViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/5/26.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFWebViewController.h"
#import "JFPrizeListViewController.h"

@interface JFWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation JFWebViewController

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
    NSString *urlStr = [NSString stringWithFormat:@"http://d.bjyijiequ.com/mallyjq/wxr/activityapp1.htm?userId=%@",uid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
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
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [HUDManager hideHUDView];
//    [HUDManager showWarningWithText:kDefaultWebErrorString];
//}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [HUDManager hideHUDView];
    NSString *url = request.URL.description;
    if ([url hasPrefix:@"app://mactivity1/list"]) {//我的中奖纪录->大转盘
        [self pushWithVCClass:[JFPrizeListViewController class] properties:@{@"title":@"中奖纪录",@"active_type":@"1"}];
        return NO;
    }
    if ([url hasPrefix:@"app://mactivity1/award"]) {//实物奖品去领奖
        // app://mactivity1/award?prize_type=1&logid=145
        
    }
    
    return YES;
}
@end

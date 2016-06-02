//
//  JFWebViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/5/26.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFWebViewController.h"

@interface JFWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation JFWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营销活动";
    [self setNavBarLeftItemAsBackArrow];
    self.webview.scalesPageToFit = YES;
    if (![self.bannerModel.jump_url hasPrefix:@"http://"]) {
        self.bannerModel.jump_url = [@"http://" stringByAppendingString:self.bannerModel.jump_url];
    }
    NSURL *url = [NSURL URLWithString:self.bannerModel.jump_url];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [self.webview loadRequest:request];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webview loadHTMLString:@"" baseURL:nil];
    [self.webview stopLoading];
    [self.webview setDelegate:nil];
    [self.webview removeFromSuperview];
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
    return YES;
}
@end

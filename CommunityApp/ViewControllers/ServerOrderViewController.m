//
//  ServerOrderViewController.m
//  CommunityApp
//
//  Created by lsy on 15/11/10.
//  Copyright © 2015年 iss. All rights reserved.
//
//服务订单
#import "ServerOrderViewController.h"
#import "LoginConfig.h"
@interface ServerOrderViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView*webView;
@end

@implementation ServerOrderViewController
#pragma mark-懒加载
-(UIWebView *)webView
{
    if (_webView==nil) {
        self.webView=[[UIWebView alloc]init];
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化导航栏
    self.navigationItem.title = @"服务订单";
    self.hidesBottomBarWhenPushed =YES;    // Push的时候隐藏TabBar
    [self setNavBarLeftItemAsBackArrow];  //设置返回按钮
    [self.view addSubview:self.webView];   //webVIew添加到View上
    //@"http://d.bjyijiequ.com/qpi/page/ebei/ownerWeixin/center/service/order.html?memberId=116902
    //获得用户的memeberId
    NSString*userMemberId=[[LoginConfig Instance]userID];
    self.url=[NSString stringWithFormat:@"%@%@",SERVICE_TO_HOME_LIST_API,userMemberId];
    if (self.url.length != 0) {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _url]]];
        [self.webView loadRequest:request];
    }
    else if (self.filePath.length != 0){
        NSString *htmlString = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:self.filePath]];
    }
    self.hidesBottomBarWhenPushed=YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.frame = CGRectMake(0, Screen_Height-BottomBar_Height, Screen_Width, BottomBar_Height);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  MyPropertyBillViewController.m
//  CommunityApp
//
//  Created by 张艳清 on 15/12/8.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "MyPropertyBillViewController.h"
#import "Interface.h"
#import "LoginConfig.h"
#import "PersonalCenterViewController.h"


@interface MyPropertyBillViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation MyPropertyBillViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化导航栏
    self.navigationItem.title = Str_MyPropertyBill_title;
    [self setNavBarLeftItemAsBackArrow];


    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scalesPageToFit = YES;//设置网页适配屏幕
    self.webView.delegate = self;
    [self.view addSubview:self.webView];


//    NSString *userid = [[LoginConfig Instance]userID];

    self.url = [NSString stringWithFormat:@"%@page/ebei/propertyPayment_Payment_orderListClientPage.do",Service_Address];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _url]]];
    [self.webView loadRequest:request];
    self.hidesBottomBarWhenPushed=NO;
}
- (void)navBarLeftItemBackBtnClick
{
    PersonalCenterViewController *vc = [[PersonalCenterViewController alloc] init];
//    vc.backVC=self;
//    [self.navigationController pushViewController:vc animated:NO];
//    //如果web view需要返回则返回上一页
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//    }
//    else {
       [self.navigationController popViewControllerAnimated:YES];
//    }
}

@end

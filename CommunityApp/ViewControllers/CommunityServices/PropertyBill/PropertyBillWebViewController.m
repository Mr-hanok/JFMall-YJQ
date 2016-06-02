//
//  PropertyBillWebViewController.m
//  CommunityApp
//
//  Created by 张艳清 on 15/12/8.
//  Copyright © 2015年 iss. All rights reserved.
//


#import "PropertyBillWebViewController.h"
#import "Interface.h"
#import "HomeViewController.h"
#import "PersonalCenterViewController.h"
#import "MyPropertyBillViewController.h"
//js与ios交互三方库
#import <JavaScriptCore/JavaScriptCore.h>//方法二
#import <UIKit/UIKit.h>
#import "NSURL+Helper.h"
#define HTTPS @"https"
@interface PropertyBillWebViewController()<UIWebViewDelegate,NSURLConnectionDelegate>
{

    BOOL _authenticated;
    NSURLRequest *_originRequest;

}

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) JSContext *context;
@property(nonatomic, assign) BOOL isHasContent;


@end

@implementation PropertyBillWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化导航栏信息
    self.navigationItem.title = Str_Comm_PropertyBill;
    /*
     设置导航栏左侧按钮为返回键头
     */
    [self setNavBarLeftItemAsBackArrow];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    self.webView.backgroundColor = [UIColor clearColor];

    self.webView.scalesPageToFit = YES;//设置网页适配屏幕
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    self.url = [NSString stringWithFormat:@"%@/page/ebei/propertyPayment_Payment_indexClientPage.do",Service_Address];//
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _url]]];
    [self.webView loadRequest:request];
    self.hidesBottomBarWhenPushed=NO;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType;

{
    NSURL *url = request.URL;
    YjqLog(@"++++%@",url);

    if ([[url path] rangeOfString:@"page/ebei/propertyPayment/PaymentListClientPage.jsp"].location != NSNotFound) {

        MyPropertyBillViewController *mypropertybillVC = [[MyPropertyBillViewController alloc] init];
        [self.navigationController pushViewController: mypropertybillVC animated:NO];
        return NO;
    }
    else if ([[url path] rangeOfString:@"page/ebei/propertyPayment/PaymentHomeClientPage.jsp"].location != NSNotFound)
    {
        HomeViewController *homeVC = [[HomeViewController alloc]init];
        [self.navigationController pushViewController:homeVC animated:NO];
        return NO;
    }
    else {
        _isHasContent = YES;
        return YES;
    }

    return YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (!_isHasContent) {
        NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
        [controllers removeObject:self];
        self.navigationController.viewControllers = controllers;
    }
}
// 重载viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillAppear:animated];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    //    NSLog(@"***********error:%@,errorcode=%d,errormessage:%@",error.domain,error.code,error.description);
    //
    //    if (!([error.domain isEqualToString:@"WebKitErrorDomain"]
    //          && error.code ==102)) {
    //
    //        //[self dismissWithError:error animated:YES];
    //    }
}

#pragma -mark 设置导航栏左侧返回按钮返回页面
- (void)navBarLeftItemBackBtnClick
{
    //如果web view需要返回则返回上一页
    //    if ([self.webView canGoBack]) {
    //        [self.webView goBack];
    //    }
    //    else {
    [self.navigationController popViewControllerAnimated:YES];
    //    }
}
@end

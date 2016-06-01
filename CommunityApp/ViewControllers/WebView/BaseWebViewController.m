//
//  BaseWebViewController.m
//  CommunityApp
//
//  Created by lipeng on 16/3/15.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "BaseWebViewController.h"
#import "WaresDetailViewController.h"//商品详情页
#import "NSURL+Helper.h"
#import "GoodsForSaleViewController.h"

@interface BaseWebViewController()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webVC;
@property(nonatomic, assign) BOOL isHasContent;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    
    self.webVC = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    self.webVC.backgroundColor = [UIColor clearColor];
    self.webVC.scalesPageToFit = YES;//设置网页大小适配
    self.webVC.userInteractionEnabled = YES;//网页可交互
    self.webVC.delegate = self;
    [self.view addSubview:self.webVC];

    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSURLRequest *request;

    if (![_url containsString:@"projectId="]) {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_url]]];
    }
    else
    {
        if (![_url containsString:@"?"]) {
            request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&projectId=%@",_url,projectId]]];
        }
        else
        {
            request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?projectId=%@",_url,projectId]]];
        }
    }

    [self.webVC loadRequest:request];

    self.hidesBottomBarWhenPushed = YES;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = request.URL;
    YjqLog(@"++++%@",url);
    
    NSLog(@"Scheme: %@", [url scheme]);
    NSLog(@"Host: %@", [url host]);
    NSLog(@"Port: %@", [url port]);
    NSLog(@"Path: %@", [url path]);
    NSLog(@"Relative path: %@", [url relativePath]);
    NSLog(@"Path components as array: %@", [url pathComponents]);
    NSLog(@"Parameter string: %@", [url parameterString]);
    NSLog(@"Query: %@", [url query]);
    NSDictionary *recommendationDic = [url parseURLParams:[url query]];
    if ([[url path] containsString:recommendationPath] || [[url path] containsString:limitPath]) {

        WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
        vc.waresId = [recommendationDic objectForKey:@"goodsId"];
        vc.efromType = E_FromViewType_WareList;
        [self.navigationController pushViewController:vc animated:YES];
        
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

- (void)navBarLeftItemBackBtnClick
{
    if ([self.webVC canGoBack]) {
        [self.webVC goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

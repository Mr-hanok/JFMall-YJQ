//
//  WebViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //服务地址

    //初始化导航栏
    self.navigationItem.title = _navTitle;
    [self setNavBarLeftItemAsBackArrow];

    //---11-30
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    //---11-30
    if (self.url.length != 0) {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _url]]];
        [self.webView loadRequest:request];
    }
    else if (self.filePath.length != 0){
        NSString *htmlString = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:self.filePath]];
    }
    self.hidesBottomBarWhenPushed=NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    self.tabBarController.tabBar.hidden = NO;
//    self.tabBarController.tabBar.frame = CGRectMake(0, Screen_Height-BottomBar_Height, Screen_Width, BottomBar_Height);
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

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

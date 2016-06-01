//
//  ProtocoViewController.m
//  CommunityApp
//
//  Created by lsy on 15/11/11.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "ProtocoViewController.h"

@interface ProtocoViewController ()
@property(nonatomic,strong)UIWebView*protocolTextWeb;//存放协议内容

@end

@implementation ProtocoViewController
-(UIWebView *)protocolText
{
    if (_protocolTextWeb==nil) {
        self.protocolTextWeb=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _protocolTextWeb;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    //创建webView的大小
    self.protocolTextWeb=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //查找本地html
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"亿街区用户注册服务协议" withExtension:@"html"];
    NSString*html=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.protocolTextWeb loadHTMLString:html baseURL:baseUrl];
    //添加webView到View
    [self.view addSubview:self.protocolTextWeb];
    self.navigationController.tabBarController.hidesBottomBarWhenPushed=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

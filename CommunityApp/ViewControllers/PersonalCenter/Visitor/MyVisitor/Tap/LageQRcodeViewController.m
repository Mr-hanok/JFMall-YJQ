//
//  LageQRcode.m
//  CommunityApp
//
//  Created by lsy on 15/11/5.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "LageQRcodeViewController.h"
#import "VisitorDetailViewController.h"
@interface LageQRcodeViewController()
@property(nonatomic,strong)VisitorDetailViewController*visitorVC;
@property(nonatomic,strong)UIButton*backBtn;
@end
@implementation LageQRcodeViewController
#pragma mark-懒加载
-(UIImageView *)largeQRimage
{
    if (_largeQRimage==nil) {
        self.largeQRimage=[[UIImageView alloc]initWithFrame:CGRectMake(0,100,200,200)];
        self.largeQRimage.center=self.view.center;
        [self.view addSubview:self.largeQRimage];
    }
    return _largeQRimage;
}
-(void)viewDidLoad
{
    self.view.backgroundColor=[UIColor blackColor];
    self.largeQRimage=[[UIImageView alloc]initWithFrame:CGRectMake(0,100,200,200)];
    self.largeQRimage.center=self.view.center;
    YjqLog(@"%@",self.largeQRimage.image );
    [self.view addSubview:self.largeQRimage];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.visitorVC.keyurlView=self.largeQRimage;
}
@end

//
//  TapQRcodeViewController.m
//  CommunityApp
//
//  Created by 张艳清 on 15/11/19.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "TapQRcodeViewController.h"
#import "VisitorDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface TapQRcodeViewController ()
@property(nonatomic,strong)VisitorDetailViewController*visitorVC;
@property(nonatomic,strong)UIButton*backBtn;
@end

@implementation TapQRcodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    YjqLog(@"urlstr:%@",self.urlStr);
    //创建UIImageView
    UIImageView *QRview = [[UIImageView alloc] init];
    QRview.backgroundColor = [UIColor redColor];
    QRview.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width-20,[UIScreen mainScreen].bounds.size.width-20);
    QRview.center = self.view.center;
    [QRview sd_setImageWithURL:[NSURL URLWithString:self.urlStr]];
    [self.view addSubview:QRview];
}


//#pragma mark-懒加载
//-(UIImageView *)largeQRimage
//{
//    if (_largeQRimage==nil) {
//        self.largeQRimage=[[UIImageView alloc]initWithFrame:CGRectMake(0,100,200,200)];
//        self.largeQRimage.center=self.view.center;
//        [self.view addSubview:self.largeQRimage];
//    }
//    return _largeQRimage;
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor whiteColor];
//    self.largeQRimage=[[UIImageView alloc]initWithFrame:CGRectMake(0,100,200,200)];
//    self.largeQRimage.center=self.view.center;
//    YjqLog(@"largeQRimage1:%@",self.largeQRimage.image );//NIL
//    [self.view addSubview:self.largeQRimage];
//
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    self.visitorVC.keyurlView=self.largeQRimage;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

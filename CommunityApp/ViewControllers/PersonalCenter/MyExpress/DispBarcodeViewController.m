//
//  DispBarcodeViewController.m
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/22.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "DispBarcodeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Interface.h"
@interface DispBarcodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImgView;

@end

@implementation DispBarcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = @"查看二维码";
    [self setNavBarLeftItemAsBackArrow];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self dispQrCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 显示二维码
- (void)dispQrCode
{
    if (_qrCodeUrl && _qrCodeUrl.length>0) {
//        NSURL *url =[NSURL URLWithString:[Common setCorrectURL:_qrCodeUrl]];
        NSURL *url = [NSURL URLWithString:[Common setCorrectURLByServer:BarCodeImgServer_Addr andImgUrl:_qrCodeUrl]];
        [_qrCodeImgView setImageWithURL:url];
    }
}


@end

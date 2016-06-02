//
//  CreatQR.m
//  CommunityApp
//
//  Created by lsy on 15/11/11.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "CreatQR.h"
#import "QRCodeGenerator.h"
#import "NewVieitorViewController.h"
@interface CreatQR()
@property(nonatomic,strong)NewVieitorViewController*codeQRvc;
@end
@implementation CreatQR
//-(NewVieitorViewController *)QRvc
//{
//    if (_QRvc==nil) {
//        
//    }
//}
-(void)viewDidLoad
{
    // 根据字符串产生 二维码图片
    UIImage *img = [QRCodeGenerator qrImageForString:@"亿街区" imageSize:100];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 470, 100, 100)];
    imageView.tag = 100;
    imageView.image = img;
    [self.codeQRvc.view addSubview:imageView];
    
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = CGRectMake(100, 340, 100, 40);
//    [button setTitle:@"保存到相册" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}
- (void) buttonClick {
    UIImageView *iv = (UIImageView *)[self.view viewWithTag:100];
    // 写到相册
    UIImageWriteToSavedPhotosAlbum(iv.image, nil, nil, NULL);
    
}
@end

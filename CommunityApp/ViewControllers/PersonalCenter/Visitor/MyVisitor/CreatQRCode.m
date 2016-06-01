//
//  CreatQRCode.m
//  CommunityApp
//
//  Created by lsy on 15/11/5.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "CreatQRCode.h"
#import"QRCodeGenerator.h"
@implementation CreatQRCode

- (void) buttonClick {
    UIImageView *iv = (UIImageView *)[self.window viewWithTag:100];
    // 写到相册
    UIImageWriteToSavedPhotosAlbum(iv.image, nil, nil, NULL);
}
-(void)ll{
    // 根据字符串产生 二维码图片
    UIImage *img = [QRCodeGenerator qrImageForString:@"hahahah" imageSize:300];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 300, 300)];
    imageView.tag = 100;
    imageView.image = img;
    [self.window addSubview:imageView];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 340, 100, 40);
    [button setTitle:@"保存到相册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:button];
    
}
@end

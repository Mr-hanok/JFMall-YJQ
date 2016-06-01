//
//  BarCodeScanViewController.h
//  CRM_Test
//
//  Created by Destiny on 15/7/1.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
/*!
 @header BarCodeScanViewController
 @abstract 二维码扫描
 @author ISS
 */
@interface BarCodeScanViewController : BaseViewController <AVCaptureMetadataOutputObjectsDelegate>
@property (copy,nonatomic) void (^scanCode)(NSString*codeString);
@end

//
//  BarCodeScanViewController.m
//  CommunityApp
//
//  Created by Destiny on 15/7/1.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "BarCodeScanViewController.h"

@interface BarCodeScanViewController ()

typedef enum {
    CameraOK = 1,
    CameraNG = 2
}CameraStatus;

@end
@interface BarCodeScanViewController()
{
    AVCaptureDevice *device;
    AVCaptureSession *session;
    AVCaptureDeviceInput *input;
    AVCaptureMetadataOutput *output;
    AVCaptureVideoPreviewLayer *preview;
}
@end
@implementation BarCodeScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫描二维码";
    [self setNavBarLeftItemAsBackArrow];
    NSError *error;
    
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法启动相机" message:@"请在“设置”->‘“隐私”->“相机”中开启相机权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"设置", nil];
        [alert setTag:CameraNG];
        [alert show];
    }
    else
    {
        output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        session = [[AVCaptureSession alloc] init];
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([session canAddInput:input])
        {
            [session addInput:input];
        }
        
        if ([session canAddOutput:output])
        {
            [session addOutput:output];
        }
//改
//        [output setMetadataObjectTypes:@[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code,
//                                         AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code,
//                                         AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code,
//                                         AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code,
//                                         AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode,
//                                         AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code,
//                                         AVMetadataObjectTypeDataMatrixCode]];
        NSMutableArray *metaDataTypes = [[NSMutableArray alloc] init];
        //二维码
        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
            [metaDataTypes addObject:AVMetadataObjectTypeQRCode];
            
        }
        //UPCE码
        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeUPCECode]) {
            [metaDataTypes addObject:AVMetadataObjectTypeUPCECode];
            
        }
        //39码
        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeCode39Code]) {
            [metaDataTypes addObject:AVMetadataObjectTypeCode39Code];
            
        }
        //3943码
        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeCode39Mod43Code]) {
            [metaDataTypes addObject:AVMetadataObjectTypeCode39Mod43Code];
            
        }
        //EAN13
        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeEAN13Code]) {
            [metaDataTypes addObject:AVMetadataObjectTypeEAN13Code];
            
        }
        //EAN8
        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeEAN8Code]) {
            [metaDataTypes addObject:AVMetadataObjectTypeEAN8Code];
            
        }
        //93码
        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeCode93Code]) {
            [metaDataTypes addObject:AVMetadataObjectTypeCode93Code];
            
        }
        //128码
        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeCode128Code]) {
            [metaDataTypes addObject:AVMetadataObjectTypeCode128Code];
            
        }
        //PDF417码
        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypePDF417Code]) {
            [metaDataTypes addObject:AVMetadataObjectTypePDF417Code];
            
        }
        //Aztec码
        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeAztecCode]) {
            [metaDataTypes addObject:AVMetadataObjectTypeAztecCode];
            
        }
       
//        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeITF14Code]) {
//            [metaDataTypes addObject:AVMetadataObjectTypeITF14Code];
//            
//        }
//        if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeDataMatrixCode]) {
//            [metaDataTypes addObject:AVMetadataObjectTypeDataMatrixCode];
//            
//        }
        [output setMetadataObjectTypes:metaDataTypes];
        
        preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
        [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [preview setBackgroundColor:[[UIColor redColor] CGColor]];
        [preview setFrame:CGRectMake((Screen_Width - 300) / 2, (Screen_Height - 300-Navigation_Bar_Height) / 2, 300, 300)];
        [self.view.layer insertSublayer:preview atIndex:0];
        
        [session startRunning];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *result = @"";
    
    if ([metadataObjects count] > 0)
    {
        // 停止扫描
        [session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        result = metadataObject.stringValue;
    }
    
    if(self.scanCode)
    {
        self.scanCode(result);
    }
    [self.navigationController popViewControllerAnimated:TRUE];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert setTag:CameraOK];
//    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CameraOK)
    {
        [session startRunning];
    }
    else
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:NO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

@end

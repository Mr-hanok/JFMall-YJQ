//
//  CouponVerifyViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CouponVerifyViewController.h"
#import "CouponViewController.h"

@interface CouponVerifyViewController ()
@property (strong, nonatomic) NSMutableArray *couponDataArray;
@property (strong, nonatomic) Coupon *couponData;
@property (weak, nonatomic) IBOutlet UITextField *couponNoTextField;

@end

@implementation CouponVerifyViewController

#pragma mark - 重载方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Verify_No_Title;
    
    [self initBasicData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义方法
- (IBAction)clickVerifyBtn:(id)sender {
    NSString *couponCode = _couponNoTextField.text;
    
    if (couponCode.length == 0) {
        [Common showBottomToast:@"请输入验证码！"];
        return;
    }
    
    if(self.couponCode){
        self.couponCode(couponCode);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBasicData {
    self.couponDataArray = [[NSMutableArray alloc]init];
}
@end

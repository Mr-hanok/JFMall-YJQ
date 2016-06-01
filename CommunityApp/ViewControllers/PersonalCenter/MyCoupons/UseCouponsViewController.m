//
//  UseCouponsViewController.m
//  CommunityApp
//
//  Created by issuser on 15/7/29.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "UseCouponsViewController.h"
#import "SubmitOrderViewController.h"

@interface UseCouponsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *couponsTextFileld;

@end

@implementation UseCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Use_Coupons_Title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)verifiCouponsBtn:(id)sender {
    NSString *couponsCode = [[NSString alloc]init];
    couponsCode = self.couponsTextFileld.text;
    
    if (couponsCode == nil || [couponsCode isEqual:@""]){
        NSLog(@"请输入内容");
        return;
    }
    [sender endEditing:YES];
    [self verifiCouponsFromServer:couponsCode];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _couponsTextFileld.text = @"";
}

#pragma mark - 终端验证优惠券接口
- (void)verifiCouponsFromServer : (NSString *)couponsCode {
    SubmitOrderViewController* next = [[SubmitOrderViewController alloc]init];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:couponsCode, @"couponsCode",nil];
    
    [self getArrayFromServer:VerifiCouponsDetail_Url path:VerifiCouponsDetail_Path method:@"GET" parameters:dic xmlParentNode:nil success:^(NSMutableArray *result) {
        // 携带数据
        if (self.selectCouponsId) {
            CouponsDetail* detail = [result objectAtIndex:1];
            self.selectCouponsId(detail);
        }
        // 跳转到支付界面
        [self.navigationController pushViewController:next animated:YES];
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"优惠券编号验证未通过！" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

@end

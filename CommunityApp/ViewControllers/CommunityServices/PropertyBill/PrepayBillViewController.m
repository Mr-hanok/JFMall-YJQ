//
//  PrepayBillViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PrepayBillViewController.h"
#import "LoginConfig.h"
#import "PayMethodViewController.h"

@interface PrepayBillViewController ()<UITextFieldDelegate,PayMethodViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *balanceValue;
@property (retain, nonatomic) IBOutlet UITextField *prepayValue;
@property (retain, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation PrepayBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化导航栏
    self.navigationItem.title = Str_PropBill_PrepayBill;
    [self setNavBarLeftItemAsBackArrow];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TextField代理

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.confirmBtn.enabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 按钮点击事件处理函数
// 确认按钮点击事件处理函数
- (IBAction)confirmBtnClickHandler:(id)sender
{
    if([_prepayValue.text isEqualToString:@""])
    {
        return;
    }
    PayMethodViewController *next = [[PayMethodViewController alloc] init];
    
    next.amount = [_prepayValue.text floatValue];
    next.delegate = self;
    [self.navigationController pushViewController:next animated:TRUE];
}



@end

//
//  TimeViewController.m
//  CommunityApp
//
//  Created by 张艳清 on 15/10/25.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "TimeViewController.h"
#import "RBCustomDatePickerView.h"
#import "NewVieitorViewController.h"

@interface TimeViewController ()<giveTimeDelegate>
@end

@implementation TimeViewController
{
    NSString *timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    RBCustomDatePickerView *pickerView = [[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];

    
    pickerView.FKdelegate = self;
    [self.view addSubview:pickerView];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMaxX(pickerView.frame)/2-50, 400, 100, 60);
    button.backgroundColor = [UIColor orangeColor];
    button.layer.cornerRadius = 8;
    [button setTitle:@"选择时间" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(giveValueClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:button];
}
#pragma mark-开始时间
//确定按钮
- (void)giveValueClick:(id)sender
{
    if (timer==nil) {
        //获取当前系统时间
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *  currentTimeString=[dateformatter stringFromDate:senddate];
        timer=currentTimeString;
        /**
         传值
         */
       // __weak typeof(self) weakSelf = self;//iPhone 6 Plus崩溃
        __weak typeof(&*self) weakSelf = self;
        weakSelf.selectTime(timer);
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@",timer);

    }else{
        
        /**
         传值
         */
        //__weak typeof(self) weakSelf = self;
        __weak typeof(&*self) weakSelf = self;
        weakSelf.selectTime(timer);
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@",timer);
    }
}

#pragma mark - FKDelegate  代理传值
- (void)giveTimeString:(NSString *)giveTimeStr
{

    timer = giveTimeStr;
}



@end

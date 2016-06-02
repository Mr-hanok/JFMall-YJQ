//
//  CommitResultViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CommitResultViewController.h"
#import "MyPostRepairViewController.h"
#import "PersonalCenterMyOrderViewController.h"
#import "HomeViewController.h"
#import "MainViewController.h"
#import "CouponViewController.h"
#import "ServiceOrderWebViewController.h"

@interface CommitResultViewController ()
{
    NSDictionary *getCouponInfoDic;
    IBOutlet UIView *getCouponInfoView;
    IBOutlet UILabel *getCouponInfoLabel;
    IBOutlet UIButton *myCouponButton;
}

@property (weak, nonatomic) IBOutlet UILabel *resultTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultDescLabel;


@end

@implementation CommitResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor whiteColor];
    // 初始化导航栏信息
    if (self.eFromViewID == E_ResultViewFromViewID_OrderPayResult) {
        self.navigationItem.title = @"支付结果";
    }else {
        self.navigationItem.title = @"提交结果";
    }
    getCouponInfoLabel.preferredMaxLayoutWidth = Screen_Width - 40;
    if (self.couponsStr.length != 0) {
        getCouponInfoDic = [[Common getArrayFromJson:self.couponsStr] firstObject];
    }
    if (getCouponInfoDic && [getCouponInfoDic[@"couponsNum"] integerValue] != 0) {
        getCouponInfoView.hidden = NO;
        NSString *couponInfoStr = [NSString stringWithFormat:@"亲，%li张%.2f元的代金券已入账，送的哟~\n请进入我的优惠券查看。",  (unsigned long)[getCouponInfoDic[@"couponsNum"] integerValue], [getCouponInfoDic[@"price"] floatValue]];
        NSMutableAttributedString *couponInfoAttrStr = [[NSMutableAttributedString alloc] initWithString:couponInfoStr];
        NSRange myCouponStrRange = [couponInfoStr rangeOfString:@"我的优惠券"];
        [couponInfoAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:myCouponStrRange];
        getCouponInfoLabel.attributedText = couponInfoAttrStr;
    }
    else {
        getCouponInfoView.hidden = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.resultTitleLabel setText:self.resultTitle];
    [self.resultDescLabel setText:self.resultDesc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark---IBAction
//返回首页
-(IBAction)toRootView:(id)sender
{
#pragma -mark 12-04新到家服务改动
//    if (self.eFromViewID == E_ResultViewFromViewID_SubmitCommodityOrder || self.eFromViewID == E_ResultViewFromViewID_SubmitServiceOrder || self.eFromViewID == E_ResultViewFromViewID_OrderPayResult) {
        MainViewController *vc = [[MainViewController alloc] init];
        [Common appDelegate].window.rootViewController = vc;
//    }else {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}

- (IBAction)myCouponButtonClicked:(UIButton *)sender
{
    CouponViewController* vc = [[CouponViewController alloc]init];
    vc.leftBtnBackToRoot = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//查看订单
-(IBAction)toMyCase:(id)sender
{
    if (self.eFromViewID == E_ResultViewFromViewID_PostItRepair) {
        MyPostRepairViewController* next = [[MyPostRepairViewController alloc]init];
        next.leftOp = LeftNarvigate_ToRoot;
        [self.navigationController pushViewController:next animated:YES];
    }
    else if (self.eFromViewID == E_ResultViewFromViewID_SubmitCommodityOrder) {
        PersonalCenterMyOrderViewController *next = [[PersonalCenterMyOrderViewController alloc] init];
        next.orderType = OrderType_Commodity;//实物订单
        [self.navigationController pushViewController:next animated:YES];
    }
    else if(self.eFromViewID == E_ResultViewFromViewID_SubmitServiceOrder)
    {
        PersonalCenterMyOrderViewController *next = [[PersonalCenterMyOrderViewController alloc] init];
        next.orderType = OrderType_Service;//服务订单
        [self.navigationController pushViewController:next animated:YES];
    }
    else if (self.eFromViewID == E_ResultViewFromViewID_OrderPayResult) {
        
        PersonalCenterMyOrderViewController *next = [[PersonalCenterMyOrderViewController alloc] init];
        next.orderType = OrderType_Commodity;//新实物订单
        [self.navigationController pushViewController:next animated:YES];
       
        // 暂时空
    }
    #pragma -mark 12-04新到家服务改动
    else if (self.eFromViewID == E_ResultViewFromViewID_SeverOrderPayResult) {
        ServiceOrderWebViewController *next = [[ServiceOrderWebViewController alloc] init];
        next.orderType = OrderType_Service;//服务订单
        [self.navigationController pushViewController:next animated:YES];
    }
}
@end

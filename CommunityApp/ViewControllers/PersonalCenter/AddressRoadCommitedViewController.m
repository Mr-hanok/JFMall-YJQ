//
//  AddressRoadCommitedViewController.m
//  CommunityApp
//
//  Created by Andrew on 15/11/3.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "AddressRoadCommitedViewController.h"
#import "RoadAddressManageViewController.h"

@interface AddressRoadCommitedViewController ()

@end

@implementation AddressRoadCommitedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"提交成功";
    [self setNavBarLeftItemAsBackArrow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navBarLeftItemBackBtnClick
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (BaseViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[RoadAddressManageViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (IBAction)backToHomeButtonClicked:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backAddressListButtonClicked:(UIButton *)sender
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (BaseViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[RoadAddressManageViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

@end

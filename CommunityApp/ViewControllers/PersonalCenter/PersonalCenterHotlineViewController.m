//
//  PersonalCenterHotlineViewController.m
//  CommunityApp
//
//  Created by iss on 6/10/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterHotlineViewController.h"

@interface PersonalCenterHotlineViewController ()

@end

@implementation PersonalCenterHotlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_HotLine_Title;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark--IBAction
-(IBAction)telClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://02022178212"]];//telprompt
}
@end

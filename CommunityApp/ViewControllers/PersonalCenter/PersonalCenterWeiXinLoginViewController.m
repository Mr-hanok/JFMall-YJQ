//
//  PersonalCenterWeiXinLoginViewController.m
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterWeiXinLoginViewController.h"
#import "PersonalCenterLoginType.h"


@interface PersonalCenterWeiXinLoginViewController ()
@property (strong,nonatomic) IBOutlet UITextField* userName;
@property (strong,nonatomic) IBOutlet UITextField* userPwd;
@property (assign,nonatomic) LoginTypeEnum loginType;
@end

@implementation PersonalCenterWeiXinLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title= Str_WeixinLogin_Title;
    _loginType = LoginType_Weixin;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)toCommit:(id)sender
{
}
@end

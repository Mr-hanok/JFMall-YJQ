//
//  PersonalCenterCommonLoginViewController.m
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterCommonLoginViewController.h"
#import "PersonalCenterRegisterViewController.h"
#import "PersonalCenterFindPwdViewController.h"
#import "PersonalCenterLoginType.h"

@interface PersonalCenterCommonLoginViewController ()
@property (strong,nonatomic)IBOutlet UIView* registerView;
@property (strong,nonatomic) IBOutlet UITextField* UserName;
@property (strong,nonatomic) IBOutlet UITextField* UserPassword;
@end

@implementation PersonalCenterCommonLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = Str_Login_Title;
    [self.registerView setFrame:Rect_PropBill_NavBarRightItem];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponder)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self setNavBarItemRightView:self.registerView];
    [self setNavBarLeftItemAsBackArrow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toLogin:(id)sender
{
    [self toLoginFromServer];
}
- (IBAction)registerBtnClick:(id)sender
{
    PersonalCenterRegisterViewController *next = [[PersonalCenterRegisterViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}
- (IBAction)findPwdBtnClick:(id)sender
{
    PersonalCenterFindPwdViewController *next = [[PersonalCenterFindPwdViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
    
    
}
-(void)resignCurrentResponder
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES]; 
}

// 从服务器端获取数据
- (void)toLoginFromServer
{
    [[Common appDelegate].userArray  removeAllObjects];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *project = [userDefault objectForKey:KEY_PROJECTID];
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_UserName.text,@"userAccount",_UserPassword.text,@"passWord",project,@"projectId",nil];
    
    // 请求服务器获取数据
    [self getArrayFromServer:ServiceInfo_Url path:Login_Path method:@"GET" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        for (NSDictionary *dicResult in result)
        {
            if ([[dicResult objectForKey:@"result"] isEqualToString:@"1"] ==FALSE) {
                [Common showNoticeAlertView:@"用户名或密码错误，请重新输入!"];
                return ;
            }
            [[Common appDelegate].userArray addObject:[[UserModel alloc] initWithDictionary:dicResult]];
            [[LoginConfig Instance] saveUserInfo:dicResult loginType:LoginType_Common];
            [self.navigationController popToRootViewControllerAnimated:TRUE];
            
        }
        
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];

}
@end

//
//  PersonalCenterModPwdViewController.m
//  CommunityApp
//
//  Created by iss on 6/8/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterModPwdViewController.h"

@interface PersonalCenterModPwdViewController ()<UITextFieldDelegate>
@property (strong,nonatomic) IBOutlet UITextField* oldPwd;
@property(strong,nonatomic)IBOutlet UITextField* password;
@property(strong,nonatomic)IBOutlet UITextField* confirmPassword;
@end

@implementation PersonalCenterModPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title=Str_ModPsw_Title;
    
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
#pragma mark--textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
#pragma mark--IBAction
-(IBAction)clickCommit:(id)sender
{
    if(_oldPwd.text == nil || _password.text == nil || _confirmPassword.text == nil || [_password.text isEqualToString: _confirmPassword.text]==FALSE)
    {
        
        [Common showNoticeAlertView:@"请填写完整信息并且保证新密码和确认密码一致"];
        return;
        
    }
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:[[LoginConfig Instance]userAccount],@"userAccount",_oldPwd.text,@"oldPassWord", _password.text,@"newPassWord",nil];
        [self getStringFromServer:ServiceInfo_Url path:EditPsw_Path parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"1"])//edit success
        {
            [[NSUserDefaults standardUserDefaults] setObject:_password.text forKey:User_Password_Key];
            [self.navigationController popViewControllerAnimated:TRUE];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
@end

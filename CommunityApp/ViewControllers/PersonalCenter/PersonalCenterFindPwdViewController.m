//
//  PersonalCenterFindPwdViewController.m
//  CommunityApp
//
//  Created by iss on 6/5/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterFindPwdViewController.h"

@interface PersonalCenterFindPwdViewController ()<UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UITextField* userAccount;
@property(strong,nonatomic)IBOutlet UITextField* password;
@property(strong,nonatomic)IBOutlet UITextField* confirmPassword;
@property(strong,nonatomic)IBOutlet UITextField* IdCode;
@property(strong,nonatomic)IBOutlet UIButton* btnIdCode;
@property (nonatomic, strong) NSTimer *idCodeTimer;
@property(nonatomic,assign)NSInteger idCodeTime;
@property(nonatomic,retain)NSString* randString;
@end

@implementation PersonalCenterFindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponder)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
    //设置导航栏
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_resetPwd_Title;
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
    if([textField isEqual:_IdCode])
    {
        [self.view setFrame:CGRectMake(0, Navigation_Bar_Height, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    return TRUE;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, Navigation_Bar_Height, self.view.bounds.size.width, self.view.bounds.size.height)];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField isEqual:_IdCode])
    {
        [self.view setFrame:CGRectMake(0, Navigation_Bar_Height-40, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
}
#pragma mark-IBAction
-(IBAction)clickCommit
{
    if (_userAccount.text==nil||[_userAccount.text isEqualToString:@""]) {
        [Common showBottomToast:@"请输入手机号码"];
        return;
    }    if ([_confirmPassword.text isEqualToString:_password.text]==FALSE)
    {
        [Common showBottomToast:@"请输入相同的密码和验证码"];
        return;
    }
    if([_randString isEqualToString:_IdCode.text]==FALSE)
    {
        [Common showBottomToast:@"请输入正确的验证码"];
        return;
    }
    [self getDataFromServer];
}
#pragma mark-other
-(void)resignCurrentResponder
{
//    [_userAccount resignFirstResponder];
//    [_password resignFirstResponder];
//    [_confirmPassword resignFirstResponder];
//    [_IdCode resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTiming];
}
#pragma mark - 文件域内公共方法


// 从服务器端获取数据
- (void)getDataFromServer
{
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_userAccount.text,@"userAccount",_password.text,@"newPassWord",nil];
    
    // 请求服务器获取数据
    [self getStringFromServer:ServiceInfo_Url path:resetPsw_Path method:@"POST" parameters:dic success:^(NSString* string) {
        if ([string isEqualToString:@"1"])//reset success
        {
            [[NSUserDefaults standardUserDefaults] setObject:_password.text forKey:User_Password_Key];
            [self.navigationController popViewControllerAnimated:TRUE];
        }        
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark--timer

- (IBAction) startTiming:(id)sender{
    if([Common checkPhoneNumInput:_userAccount.text]==FALSE)
    {
        [Common showBottomToast:@"请输入正确手机号"];
        return;
    }
       [self sendRandom];
    
}

-(void)idCodePaint
{
    _idCodeTime--;
    [_btnIdCode setTitle:[NSString stringWithFormat:@"(%ld)",_idCodeTime] forState:UIControlStateNormal];
    if(_idCodeTime <=0)
        [self stopTiming];
}
// 停止定时器

- (void) stopTiming{
    [_btnIdCode setEnabled:TRUE];
    [_btnIdCode setTitle:Str_getCode_Text forState:UIControlStateNormal];
    
    if (self.idCodeTimer != nil){
        
        // 定时器调用invalidate后，就会自动执行release方法。不需要在显示的调用release方法
        
        [self.idCodeTimer invalidate];
        
    }
    
}

#pragma mark-IBAction

-(void)sendRandom
{
    _randString = [NSString stringWithFormat:@"%ld",[self getRandom:6]];
    
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"yibei",@"username",@"039395",@"userpwd",_userAccount.text,@"mobiles",  @"1",@"mobilecount",_randString,@"content",nil];
    [self getArrayFromSMSServer: SMS_Url path:SMS_Path method:@"post" parameters:dic xmlParentNode:@"sendresult" success:^(NSArray* result)
     {
         NSDictionary* objDic = [result objectAtIndex:0];
         if([[objDic objectForKey:@"errorcode"] isEqualToString:@"1"] == FALSE)//发送验证码失败
         {
             [Common showBottomToast:[objDic objectForKey:@"message"]];
         }
         else
         {
         // 定义一个NSTimer
         _idCodeTime = 60;
         [_btnIdCode setEnabled:FALSE];
         
         self.idCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                             
                                                             target:self
                             
                                                           selector:@selector(idCodePaint)  userInfo:nil
                             
                                                            repeats:YES];

         NSLog(@"发送消息成功");
         }
     }failure:^(NSError* error){
         NSLog(@"发送消息失败");
     }];
}

#pragma mark--other

-(long) getRandom:(NSInteger)len
{
    srand((unsigned)time(0));
    NSInteger irand = 0;
    long random = 0;
    while (len>0) {
        irand = rand()%10;
        random*=10;
        random +=irand;
        len--;
    }
    return  random;
}

@end

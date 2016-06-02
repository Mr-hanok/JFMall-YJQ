//
//  PersonalCenterRegisterViewController.m
//  CommunityApp
//
//  Created by iss on 6/5/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterRegisterViewController.h"
#import "UserModel.h"


@interface PersonalCenterRegisterViewController ()<UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UITextField* userAccount;
@property(strong,nonatomic)IBOutlet UITextField* password;
@property(strong,nonatomic)IBOutlet UITextField* confirmPassword;
@property(strong,nonatomic)IBOutlet UIButton* checkBox;//选择

@property (nonatomic, strong) NSTimer *idCodeTimer;
@property(nonatomic,assign)NSInteger idCodeTime;
@property(nonatomic,retain)NSString* randString;//验证码
@property(strong,nonatomic)IBOutlet UITextField* IdCode;
@property(strong,nonatomic)IBOutlet UIButton* btnIdCode;
@end

@implementation PersonalCenterRegisterViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置导航栏
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Register_Title;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponder)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [_checkBox setSelected:TRUE];
   
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
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_userAccount.text,@"userAccount",_password.text,@"passWord",nil];
   
    // 请求服务器获取数据
    [self getStringFromServer:ServiceInfo_Url path:Register_Path method:@"POST" parameters:dic success:^(NSString* string) {
        if ([string isEqualToString:@"1"])//register success
        {
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];

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

#pragma mark--timer

- (IBAction) startTiming:(id)sender{
    if([Common checkPhoneNumInput:_userAccount.text]==FALSE)
    {
        [Common showBottomToast:@"请输入正确手机号"];
        return;
    }

    [self sendRandom];
        // 定义一个NSTimer
    

}

-(void)idCodePaint
{
    _idCodeTime--;
    [_btnIdCode setTitle:[NSString stringWithFormat:@"(%ld)",(long)_idCodeTime] forState:UIControlStateNormal];
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
             NSLog(@"发送消息成功");
             _idCodeTime = 60;
             [_btnIdCode setEnabled:FALSE];
             self.idCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                 
                                                                 target:self
                                 
                                                               selector:@selector(idCodePaint)  userInfo:nil
                                 
                                                                repeats:YES];
         }
     }failure:^(NSError* error){
         NSLog(@"发送消息失败");
     }];
}


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

#pragma mark-IBAction
-(IBAction)register:(id)sender
{
    if([_password.text isEqualToString:_confirmPassword.text] == FALSE)
    {
        [Common showBottomToast:@"请输入相同的密码和验证码"];
        return;
    }
    if([_checkBox isSelected] == FALSE)
    {
        return;
    }
    if([_randString isEqualToString:_IdCode.text]==FALSE)
    {
        [Common showBottomToast:@"请输入正确的验证码"];
        return;
    }
     [self getDataFromServer];
}

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

#pragma mark-other
-(void)resignCurrentResponder
{
//    [_userAccount resignFirstResponder];
//    [_password resignFirstResponder];
//    [_confirmPassword resignFirstResponder];
//    [_IdCode resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
@end

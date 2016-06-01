//
//  PersonalCenterBindTelViewController.m
//  CommunityApp
//
//  Created by iss on 8/10/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterBindTelViewController.h"
#import "PersonalcenterViewController.h"
#import "WebViewController.h"
#import "SelectNeighborhoodViewController.h"
#import "GYZChooseCityController.h"/////选择小区
#import "MainViewController.h"

@interface PersonalCenterBindTelViewController ()
@property (strong,nonatomic) IBOutlet UITextField* userName;

@property (nonatomic, strong) NSTimer *idCodeTimer;
@property(nonatomic, assign)NSInteger idCodeTime;
@property(nonatomic, retain)NSString *randString;
@property(strong, nonatomic)IBOutlet UITextField *IdCode;
@property(strong, nonatomic)IBOutlet UIButton *btnIdCode;
@property (weak, nonatomic) IBOutlet UIButton *noBindLogin;
@property (weak, nonatomic) IBOutlet UIButton *agreeUseProtocalBtn;
@property (nonatomic, strong) IBOutlet UIButton *registerProtocolButton;
@property (nonatomic, strong) IBOutlet UIButton *agreeUseProtocolButton;
@property (nonatomic ,strong) NSString *namestring;

@end

@implementation PersonalCenterBindTelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Bind_Phone_Title;
    
    if (_isFirstLogin) {
        [_noBindLogin setHidden:NO];
    }else {
        [_noBindLogin setHidden:YES];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponder)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toCommit:(id)sender
{
//![_userName.text isEqualToString:_namestring]防止输入验证码后修改手机号还可绑定
    if(_userName.text == nil || [_userName.text isEqualToString:@""]||[Common checkPhoneNumInput:_userName.text]==FALSE || ![_userName.text isEqualToString:_namestring])
    {
        [Common showBottomToast:@"请输入正确的手机号!"];
        return;
    }
//    if([_randString isEqualToString:_IdCode.text]==FALSE)
//    if(FALSE)
    if(![_randString isEqualToString:_IdCode.text] )
    {
        [Common showBottomToast:@"请输入正确的验证码"];
        return;
    }
    
//    if (!_agreeUseProtocolButton.isSelected) {
//        [Common showBottomToast:@"请勾选同意用户使用协议"];
//        return;
//    }
    
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:_userName.text,@"telNum", [[LoginConfig Instance]userID],@"userId",nil];
    // 请求服务器获取数据
//    [self getStringFromServer: ServiceInfo_Url path:BindTel_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSString *result)
    [self getStringFromServer:ServiceInfo_Url path:BindTel_Path method:@"POST" parameters:dic success:^(NSString *result) {
        
        if([result isEqualToString:@"1"])
        {
            [Common showBottomToast:@"绑定成功"];
            [[LoginConfig Instance] saveBindPhone:_userName.text];
            [self.navigationController popViewControllerAnimated:TRUE];
            
        }else if ([result isEqualToString:@"2"]) {
            [Common showBottomToast:@"该手机号已注册"];//12-08手机号已绑定－－－>手机号已注册
        }else{
            [Common showBottomToast:@"绑定失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTiming];
}

#pragma mark--timer
- (IBAction) startTiming:(id)sender {
    //把输入的手机号存起来，防止输入验证码后修改手机号还可绑定
    _namestring = _userName.text;
    if([Common checkPhoneNumInput:_userName.text]==FALSE) {
        [Common showBottomToast:@"请输入正确手机号"];
        return;
    }
    [self sendRandom];
    // 定义一个NSTimer
}

- (IBAction)registerProtocolButtonClicked:(UIButton *)sender
{
    WebViewController *next = [[WebViewController alloc] init];
    next.navTitle = @"用户使用协议";
    next.filePath = [[NSBundle mainBundle] pathForResource:@"registerProtocol" ofType:@"html"];
    [self.navigationController pushViewController:next animated:YES];
}


- (void)idCodePaint {
    NSDate* date = [NSDate date];
    NSInteger interval = [date timeIntervalSinceReferenceDate]-_idCodeTime;
    [_btnIdCode setTitle:[NSString stringWithFormat:@"(%d)",60-interval] forState:UIControlStateNormal];
    if(interval >=60)
        [self stopTiming];
}

// 停止定时器
- (void) stopTiming {
    //验证码过期后置空
     _randString = @"";
    [_btnIdCode setEnabled:TRUE];
    [_btnIdCode setTitle:Str_getCode_Text forState:UIControlStateNormal];
    
    if (self.idCodeTimer != nil) {
        
        // 定时器调用invalidate后，就会自动执行release方法。不需要在显示的调用release方法
        
        [self.idCodeTimer invalidate];
    }
}

-(void)sendRandom {
//    _randString = [NSString stringWithFormat:@"%ld",[self getRandom:6]];
//    
//    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"yibei",@"username",@"039395",@"userpwd",_userName.text,@"mobiles",  @"1",@"mobilecount",_randString,@"content",nil];
//    [self getArrayFromSMSServer: SMS_Url path:SMS_Path method:@"post" parameters:dic xmlParentNode:@"sendresult" success:^(NSArray* result)
//     {
//         NSDictionary* objDic = [result objectAtIndex:0];
//         if([[objDic objectForKey:@"errorcode"] isEqualToString:@"1"] == FALSE)//发送验证码失败
//         {
//             [Common showBottomToast:[objDic objectForKey:@"message"]];
//         }
//         else
//         {
//             NSLog(@"发送消息成功");
//             NSDate* date = [NSDate date];
//             _idCodeTime = [date timeIntervalSinceReferenceDate];
//             [_btnIdCode setEnabled:FALSE];
//             self.idCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                 
//                                                                 target:self
//                                 
//                                                               selector:@selector(idCodePaint)  userInfo:nil
//                                 
//                                                                repeats:YES];
//         }
//     }failure:^(NSError* error){
//         NSLog(@"发送消息失败");
//     }];
    
    _randString = [NSString stringWithFormat:@"%ld",[self getRandom:6]];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[_userName.text, _randString, @"1"] forKeys:@[@"mobiles", @"content", @"type"]];
    [self getStringFromServer:ServerSMS_Url path:ServerSMS_Path method:@"POST" parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"1"]) {
            [Common showBottomToast:@"验证码已发送"];
            NSDate* date = [NSDate date];
            _idCodeTime = [date timeIntervalSinceReferenceDate];
            // _idCodeTime = 60;
            [_btnIdCode setEnabled:FALSE];
            self.idCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                target:self
                                                              selector:@selector(idCodePaint)  userInfo:nil
                                                               repeats:YES];
        }else {
            [Common showBottomToast:@"验证码发送失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    
}


-(long) getRandom:(NSInteger)len {
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

#pragma mark - 用户协议
- (IBAction)checkUseProtocal:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}

-(void)resignCurrentResponder
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma mark - 跳过绑定直接登录 11-15登陆逻辑修改
- (IBAction)noBindLogin:(id)sender {
    
    //11-15登陆逻辑
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *value = [userDefault objectForKey:KEY_PROJECTID];
    
    if (!value)//未经选择小区
    {
        SelectNeighborhoodViewController *vc = [[SelectNeighborhoodViewController alloc] init];
//        GYZChooseCityController *vc = [[GYZChooseCityController alloc] init];
        vc.isRootVC = TRUE;
        vc.isSaveData = TRUE;
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        //self.window.rootViewController = nvc;
        [self presentViewController:nvc animated:YES completion:nil];
    }
    else//已选择小区
    {
        //手机已经存在该软件，直接进入登陆
        //装载根视图
        MainViewController *mainVC = [[MainViewController alloc] init];
        //[self.navigationController pushViewController:mainVC animated:YES];
        [self presentViewController:mainVC animated:YES completion:nil];
        
    }
    
    
    //    if (self.backVC) {
    //        [self.navigationController popToViewController:self.backVC animated:YES];
    //            }else {
    //
    //        [self.navigationController popViewControllerAnimated:YES];
    //
    //    }
    
}

@end

//
//  PersonalWeinXinLoginViewController.m
//  CommunityApp
//
//  Created by lsy on 15/12/8.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "PersonalWeinXinLoginViewController.h"
//协议类
#import "ProtocoViewController.h"
//判断是否安装微信
#import "WXApi.h"

#import "PersonalCenterLoginType.h"
#import "UMSocialWechatHandler.h"

#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"


@interface PersonalWeinXinLoginViewController ()
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *registerBooButton;//是否选择协议
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;//协议
@property (weak, nonatomic) IBOutlet UIButton *weiXinLoginButton;//登陆
- (IBAction)weiXinLoginClick:(UIButton *)sender;
@property(strong,nonatomic)NSString* openid;
@property(nonatomic, assign) NSInteger    loginType;         //登陆方式

@end

@implementation PersonalWeinXinLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登陆";
    self.backgroundView.backgroundColor=UIColorFromRGB(0xfff4e8);
    self.weiXinLoginButton.backgroundColor=UIColorFromRGB(0x01cc00);
    //设置用户协议是否选中按钮
    [_registerBooButton setImage:[UIImage imageNamed:@"weiXincheckBoxNO@2x"] forState:UIControlStateNormal];
    [_registerBooButton setImage:[UIImage imageNamed:@"weiXincheckBoxOK@2x"] forState:UIControlStateSelected];
    [_registerBooButton setSelected:TRUE];//协议默认设为被选择}
    self.navigationController.tabBarController.hidesBottomBarWhenPushed=YES;

}

#pragma mark-勾选是否同意协议按钮
- (IBAction)registerBoolButtonClick:(id)sender
{
    if (_registerBooButton.selected==TRUE) {
        _registerBooButton.selected=FALSE;
        [_registerBooButton setImage:[UIImage imageNamed:@"weiXincheckBoxNO@2x"] forState:UIControlStateNormal];
    }else{
        _registerBooButton.selected=TRUE;
        [_registerBooButton setImage:[UIImage imageNamed:@"weiXincheckBoxOK@2x"] forState:UIControlStateSelected];
    }
}
#pragma mark-进入协议内容按钮
-(IBAction)userProtocolButton:(id)sender
{
    ProtocoViewController*protocolVC=[[ProtocoViewController alloc]init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}
#pragma mark-微信登陆按钮
- (IBAction)weiXinLoginClick:(UIButton *)sender {
    
    if([_registerBooButton isSelected] == FALSE)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"请同意用户使用协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else{
        [MobClick event:@"login_wechat"];
        
        [self wxLogin];
    }
}
-(void)wxLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];

            _openid = snsAccount.unionId;
//            _openid = snsAccount.usid;
            NSLog(@"_openid:%@",_openid);
            if(_openid)
            {
                [self wxXMPPLogin];
            }
            else
            {
                [Common showBottomToast:[NSString stringWithFormat:@"error:%@", @"登陆失败"]];
            }
        }
    });
    
}
-(void)wxXMPPLogin
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * projectId= [userDefault objectForKey:KEY_PROJECTID];
    
    // 初始化参数
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:_openid,@"openid", @"1",@"type", projectId, @"projectId", nil];
    // 请求服务器获取数据
    [self getArrayFromServer:ServiceInfo_Url path:CodeLogin_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        [[Common appDelegate].userArray  removeAllObjects];
        NSString *isFirstLogin = @"NO";
        for (NSDictionary *dicResult in result)
        {
            if ([[dicResult objectForKey:@"result"] isEqualToString:@"2"]) {
                [Common showBottomToast:Str_Login_AccountForbid];
                return ;
            }
            if ([[dicResult objectForKey:@"result"] isEqualToString:@"1"]) {
                [Common showBottomToast:Str_Login_RegisterAndLogin];
                isFirstLogin = @"YES";
            }
            
            UserModel* user = [[UserModel alloc] initWithDictionary:dicResult];
            user.loginType = LoginType_Code;
            [[Common appDelegate] setIsWillLogin:YES];
            [[Common appDelegate].userArray addObject:user];
            [[LoginConfig Instance] saveUserInfo:dicResult loginType:LoginType_Weixin];
            [[Common appDelegate]loadSWRevealViewController]; //微信登陆
        }
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    
}
// 重载viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.frame = CGRectMake(0, Screen_Height-BottomBar_Height, Screen_Width, BottomBar_Height);
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

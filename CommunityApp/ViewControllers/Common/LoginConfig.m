//
//  Common.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iSS. All rights reserved.
//

#import "LoginConfig.h"
#import "UMSocialSnsPlatformManager.h"

@interface LoginConfig ()

@end

@implementation LoginConfig

#pragma mark -
#pragma mark account
-(NSInteger)loginType
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:User_LoginType_Key];
}
-(BOOL)userLogged
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:User_Logined];
}

-(NSString *)userID
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key] length] == 0 ? @"" : [[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key];
}
- (NSString *)userName
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:User_Name_Key] length] == 0 ? @"" : [[NSUserDefaults standardUserDefaults] objectForKey:User_Name_Key];
}

- (NSString *)userAccount
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:User_UserAccount_Key] length] == 0 ? @"" : [[NSUserDefaults standardUserDefaults] objectForKey:User_UserAccount_Key];
}

- (NSString *)userPassword
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:User_Password_Key] length] == 0 ? @"" : [[NSUserDefaults standardUserDefaults] objectForKey:User_Password_Key];
}
- (NSString *)userXMPPAccount
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:User_OpenfireAccount_Key] length] == 0 ? @"" : [[NSUserDefaults standardUserDefaults] objectForKey:User_OpenfireAccount_Key];
}

-(NSString *)userIcon
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:User_Avatar_Key];
}

-(void)setUserIcon:(NSString *)userIcon
{
    [[NSUserDefaults standardUserDefaults] setObject:userIcon forKey:User_Avatar_Key];
}


-(NSString *)userGender
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:User_Sex_Key];
}

-(NSString *)userGenderName
{
    NSString *genderValue = [[NSUserDefaults standardUserDefaults] objectForKey:User_Sex_Key];
    
    if ([genderValue isEqualToString:@"0"])
    {
        return @"男";
    }
    else if ([genderValue isEqualToString:@"1"])
    {
        return @"女";
    }
    
    return @"保密";
}

- (BOOL)userRemeberPwd
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:User_RemeberPwd_Key] isEqual:@"YES"])
    {
        return YES;
    }
    
    return NO;
}

- (UserModel *)getUserInfo
{
    UserModel *userInfo = [[UserModel alloc] init];
    
    [userInfo setIsLogin:[[NSUserDefaults standardUserDefaults] boolForKey:User_Logined]];
 
 
    
    [userInfo setUserAccount:[[NSUserDefaults standardUserDefaults] objectForKey:User_UserAccount_Key]];
    [userInfo setUserName:[[NSUserDefaults standardUserDefaults] objectForKey:User_Name_Key]];
    [userInfo setPassWord:[[NSUserDefaults standardUserDefaults] objectForKey:User_Password_Key]];
 
    
    [userInfo setPropertyName:[[NSUserDefaults standardUserDefaults] objectForKey:User_PropertyName_Key]];
    [userInfo setPropertyId:[[NSUserDefaults standardUserDefaults] objectForKey:User_PropertyId_Key]];
    [userInfo setUserId:[[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key]];
    
    [userInfo setOpenfireAccount:[[NSUserDefaults standardUserDefaults] objectForKey:User_OpenfireAccount_Key]];
    [userInfo setSex:[[NSUserDefaults standardUserDefaults] objectForKey:User_Sex_Key]];
    [userInfo setArea:[[NSUserDefaults standardUserDefaults] objectForKey:User_Area_Key]];
    [userInfo setOwnerPhone:[[NSUserDefaults standardUserDefaults] objectForKey:User_OwnerPhone_Key]];
    [userInfo setLoginType:[[NSUserDefaults standardUserDefaults] integerForKey:User_LoginType_Key]];
    [userInfo setMembersLevel:[[NSUserDefaults standardUserDefaults] objectForKey:User_MembersLevel_Key]];
    [userInfo setCurrentIntegral:[[NSUserDefaults standardUserDefaults] objectForKey:User_CurrentIntegral_Key]];
    [userInfo setOwnerCall:[[NSUserDefaults standardUserDefaults] objectForKey:User_BindPhone_Key]];
    [userInfo setUserIcon:[[NSUserDefaults standardUserDefaults] objectForKey:User_Avatar_Key]];
    
    return userInfo;
}
-(NSString *)getUserKey{
    return @"ldsajfka";
}


-(NSArray *)getUserInfoArray
{
    NSArray *userInfoArray = [NSArray arrayWithObjects:
                              [self userAccount],
                              [self userName],
                              [[NSUserDefaults standardUserDefaults] objectForKey:User_UserId_Key],
                              [self userPassword],
                              [self userGenderName],
                              [[NSUserDefaults standardUserDefaults] objectForKey:User_PropertyId_Key],
                              [[NSUserDefaults standardUserDefaults] objectForKey:User_PropertyName_Key],
                              [[NSUserDefaults standardUserDefaults] objectForKey:User_OpenfireAccount_Key], nil];
    return userInfoArray;
}
-(void) saveUserBase:(UserModel*)user
{
    [[NSUserDefaults standardUserDefaults] setObject:user.userName forKey:User_Name_Key];
    [[NSUserDefaults standardUserDefaults] setValue:user.sex forKey:User_Sex_Key];
    [[NSUserDefaults standardUserDefaults] setValue:user.area forKey:User_Area_Key];
    [[NSUserDefaults standardUserDefaults] setValue:user.ownerPhone  forKey:User_OwnerPhone_Key];
    [[NSUserDefaults standardUserDefaults] setValue:user.propertyId forKey:User_PropertyId_Key];
    [[NSUserDefaults standardUserDefaults] setValue:user.propertyName  forKey:User_PropertyName_Key];
}
-(NSString*)getOwnerPhone
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:User_OwnerPhone_Key];
}
-(void)saveBindPhone:(NSString*)tel
{
  [[NSUserDefaults standardUserDefaults] setValue:tel  forKey:User_BindPhone_Key];
}
-(NSString*)getBindPhone
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:User_BindPhone_Key];
}
- (BOOL)saveUserInfo:(NSDictionary *)dic loginType:(NSInteger)loginType
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:User_Logined];
    NSString* userName = [dic objectForKey:@"userName"] ;
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:User_Name_Key];
    NSString* userPassword = [dic objectForKey:@"passWord"] ;
    [[NSUserDefaults standardUserDefaults] setObject:userPassword forKey:User_Password_Key];
    
 
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"userId"] forKey:User_UserId_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"userAccount"]  forKey:User_UserAccount_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"sex"]  forKey:User_Sex_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"propertyId"]  forKey:User_PropertyId_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"propertyName"]  forKey:User_PropertyName_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"area"]  forKey:User_Area_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"ownerPhone"]  forKey:User_OwnerPhone_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"ownerCall"]  forKey:User_BindPhone_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"filePath"]  forKey:User_Avatar_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"openfireAccount"]  forKey:User_OpenfireAccount_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"currentIntegral"]  forKey:User_CurrentIntegral_Key];
    [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"membersLevel"]  forKey:User_MembersLevel_Key];
    [[NSUserDefaults standardUserDefaults] setInteger:loginType   forKey:User_LoginType_Key];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    userName = [ud objectForKey:User_Name_Key];
//    userPassword = [ud objectForKey:User_Password_Key];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)clearUserInfo
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:User_Logined];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_Name_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_Password_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_RemeberPwd_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_UserId_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_UserAccount_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_Sex_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_PropertyId_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_PropertyName_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_OpenfireAccount_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_LoginType_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_CurrentIntegral_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_MembersLevel_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_OwnerPhone_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_BindPhone_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:User_Avatar_Key];
    [[NSUserDefaults standardUserDefaults] setValue:nil  forKey:User_Area_Key];
    
    return [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSString *)checkValue:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    return string.length == 0 ? @"" : string;
}

#pragma mark -
#pragma mark log Out
- (void)userLogout
{
    NSString *platformType = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeWechatSession];
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:platformType completion:nil];
    
    [self clearUserInfo];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:User_Logined];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark init
static LoginConfig * instance = nil;

- (void)initWithCustom
{
    
}

+(LoginConfig *)Instance
{
    @synchronized(self)
    {
        if (nil == instance)
        {
            [[self alloc] initWithCustom];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

-(void)changeNetStatus:(NSNumber *)status
{
    [[NSUserDefaults standardUserDefaults] setObject:status forKey:NetStatus];
}

-(NSNumber *)getNetStatus
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:NetStatus];
}

@end

//
//  LoginConfig.h
//  CommunityApp
//
//  Created by iss on 14-8-12.
//  Copyright (c) 2014年 iSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface LoginConfig : NSObject

/**
 * 检查用户是否登录
 * @return YES为已登录，NO为未登录
 */
-(BOOL)userLogged;

/**
 * 获取登录用户明
 * @return NSString 用户账号
 */
-(NSString *)userName;
/**
 * 获取登录用户账号
 * @return NSString 用户账号
 */
-(NSString *)userAccount;
/**
 * 获取登录ownerPhone
 * @return NSString 用户Phone
 */
-(NSString *)getOwnerPhone;
/**
 * 获取登录用户ID
 * @return NSString 用户ID
 */
-(NSString *)userID;
/**
 * 获取登录用户头像URL
 * @return NSString 用户头像
 */
-(NSString *)userIcon;

/* 设置用户头像 */
-(void)setUserIcon:(NSString *)userIcon;

/**
 * 获取登录用户密码
 * @return NSString 用户密码
 */
-(NSString *)userPassword;
/**
 * 获取Openfire账户
 * @return NSString Openfire账户
 */
- (NSString *)userXMPPAccount;
/**
 * 获取登录用户头像URL
 * @return NSString 用户头像
 */
-(NSString *)userGender;
-(NSString *)userGenderName;

/**
 * 获取记住密码选择状态
 * @return Bool 记住密码选择状态
 */
- (BOOL)userRemeberPwd;

/**
 * 获取用户全部信息
 */
- (UserModel *)getUserInfo;

/**
 * 获取用户Key
 */
- (NSString*)getUserKey;

 

/**
 * 用户注销登录
 */
- (void)userLogout;

/**
 * 登录成功后保存用户信息
 * @param name 用户账号
 * @param password 用户密码
 * @param remember 记住密码
 * @return YES为保存成功，NO为保存失败
 */
- (BOOL)saveUserInfo:(NSDictionary *)dic loginType:(NSInteger)loginType;
- (BOOL)clearUserInfo;
//保存用户基本信息
-(void) saveUserBase:(UserModel*)user;
//将用户信息以数组方式获取
-(NSArray *) getUserInfoArray;
//保存用户绑定手机
-(void)saveBindPhone:(NSString*)tel;
//获取用户绑定手机
-(NSString*)getBindPhone;
#pragma mark - init
+ (LoginConfig *) Instance;

+ (id) allocWithZone:(NSZone *)zone;

//获取网络连接状态
-(void)changeNetStatus:(NSNumber *)status;
-(NSNumber *) getNetStatus;
/**
 * 获取登录方式
 * @return  用户登陆方式
 */
-(NSInteger)loginType;
@end

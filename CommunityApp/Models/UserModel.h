//
//  UserModel.h
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel
@property(nonatomic, copy) NSString     *userName;
@property(nonatomic, copy) NSString     *propertyName;
@property(nonatomic, copy) NSString     *propertyId;
@property(nonatomic, copy) NSString     *userAccount;      //用户账号
@property(nonatomic, copy) NSString     *userId ;           //用户ID
@property(nonatomic, copy) NSString     *passWord;          //用户密码
@property(nonatomic, copy) NSString     *openfireAccount ;  //openfire账号
@property(nonatomic, copy) NSString     *sex ;               //性别
@property(assign, nonatomic) BOOL       isLogin ;               //是否登录
@property(nonatomic, copy) NSString     *area;
@property(nonatomic, copy) NSString     *ownerPhone;         //联系电话
@property(nonatomic, assign) NSInteger    loginType;         //登陆方式
@property(nonatomic, copy) NSString     *membersLevel;        //会员等级
@property(nonatomic, copy) NSString     *currentIntegral;    //会员积分
@property(nonatomic, copy) NSString     *userIcon;           //用户头像
@property(nonatomic, copy) NSString     *filePath;           //用户头像网络路径
@property(nonatomic, copy) NSString     *ownerCall;           //绑定电话
@property(nonatomic, copy) void(^avatarDisplayBlcok)(void);

@end

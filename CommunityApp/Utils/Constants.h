//
//  Constants.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#ifndef CommunityApp_Constants_h
#define CommunityApp_Constants_h

//屏幕适配

//导航栏高度
#define Navigation_Bar_Height ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ? 64 : 44)

//底部TabBar高度
#define BottomBar_Height 49

//屏幕宽度和高度
#define Screen_Width [[UIScreen mainScreen] bounds].size.width
#define Screen_Height [[UIScreen mainScreen] bounds].size.height

//Iphone版本判定
#define IPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IP5ELSE(_IPHONE5, _OTHER) (IPhone5?_IPHONE5:_OTHER)//判断手机
#define IP456ELSE(_IPHONE4, _IPHONE5,_IPHONE6) (IPhone6?_IPHONE6:IPhone5?_IPHONE5:_IPHONE4)//判断手机
//IOS版本判定
#define IOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ? YES : NO)
#define IOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0 ? YES : NO)
#define IOS9 ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0 ? YES : NO)

//可拉伸的图片
#define ResizableImage(name,top,left,bottom,right) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]
#define ResizableImageWithMode(name,top,left,bottom,right,mode) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]


//输出frame(frame是结构体，没法%@)
#define LOGFRAME(f) NSLog(@"\nx:%f\ny:%f\nwidth:%f\nheight:%f\n",f.origin.x,f.origin.y,f.size.width,f.size.height)
#define LOGBOOL(b) NSLog(@"%@",b?@"YES":@"NO");

//选择小区存储UserDefault
#define KEY_PROJECTID           @"projectId"
#define KEY_PROJECTNAME         @"projectName"
//🍎
#define KEY_qrCode              @"qrCode"

//Wifi
#define KEY_WIFI_SWITCH @"KEY_WIFI_SWITCH"

//搜索记录
#define KEY_SEARCH_TEXT @"KEY_SEARCH_TEXT"

//网络状态
#define NetStatus       @"NetStatus"

//用户登录信息
#define User_Logined            @"User_Logined"
#define User_Name_Key           @"User_Name_Key"
#define User_UserAccount_Key    @"User_UserAccount_Key"
#define User_Password_Key       @"User_Password_Key"
#define User_RemeberPwd_Key     @"User_RemeberPwd_Key"

#define User_PropertyName_Key   @"User_PropertyName_Key"
#define User_PropertyId_Key     @"User_PropertyId_Key"
#define User_UserId_Key         @"User_UserId_Key"
#define User_OpenfireAccount_Key  @"User_OpenfireAccount_Key"
#define User_Sex_Key              @"User_Sex_Key"
#define User_Area_Key             @"User_Area_Key"
#define User_OwnerPhone_Key       @"User_OwnerPhone_Key"
#define User_LoginType_Key        @"User_LoginType_Key"
#define User_BindPhone_Key        @"User_BindPhone_Key"
#define User_MembersLevel_Key     @"User_MembersLevel_Key"
#define User_CurrentIntegral_Key  @"User_CurrentIntegral_Key"
#define User_Avatar_Key           @"User_Avatar_Key"


// 便民服务默认三个服务的服务ID
#define ServiceID_HouseRepair           @"64"
#define ServiceID_PipeClean             @"63"
#define ServiceID_WaterElectricRepair   @"65"
#define ServiceID_HardWareFitting       @"66"


// 百度地图Key
#define BaiduMap_Key        @"NAhV2OVLwk5cLGOshFW8h2AU"

#define kUMengAppKey      @"561b44cf67e58e6189001c30"               //友盟appkey
#define kWXAppID          @"wxe22cb13bb75e9a71"               //APPID    wxe22cb13bb75e9a71
#define kWXAppSecret      @"35fcd7b29a9b268eae4ee5d034b04e96" //appsecret   35fcd7b29a9b268eae4ee5d034b04e96
//商户号，填写商户对应参数
#define MCH_ID          @"1273188301"   //1250223101     12.7
//商户API密钥，填写相应参数
#define PARTNER_ID      @"50yjq21b1j3e2zms6sl5c1310b9d2015"  //888fde4e9c2e2bb619514ecea888e888     12.7
//支付结果回调页面
#define WX_NOTIFY_URL      @"page/ebei/notify_url_wx.jsp"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"https://api.weixin.qq.com/sns/userinfo"
 

//支付宝信息
//商户私钥，自助生成
//#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBANjAxLumvyFQL3P7rkXlpcdpUTaOl1xDE14/ZdoIMhE3MHXTZsJ/F6V0LwyK4+GD+FnAvhrQhNnIJ8cl3hBVzL8luPTq9Xv9BxcyRP7GSR5DdWX4Tt7IThjv3EZ2GdtGWODdcDsgKs16V4QyWU6CZr3LMGbHue0JJ0kMNV7vVgFfAgMBAAECgYBNlxPVqKcaob2a4ylLVB23+Hdd9EUyfcBdKIypM+3YQ81RIE/Up/IrBCAjeUSB4d/xIRHsP2CPJRs4KtIHPu9/hDpxkmAKRnuo/gSl0Yj3cMs3/SM6IIP4c9q377qYp0mvgP7UrVotk7/bjocRSiiEcPBLCrV3qe2ekGewUKRnoQJBAP4wp8EeRrDPF+dUvOOhk2xYPxWuLGHYwnD8ZE4vbaZzcdK+esVlf31ssMvpC2u374eOoGyPXEExIh7RQgmHZCMCQQDaS980CXDZy1FKWmm2fsOFVKoiGgE7kodA0Kb8Mhhm0l9XtXynQX8/ErpzX6JF70pMT129rQypsu12pE/2j3OVAkA6WmcYcV/fFRuysoROaXhThgqtaner2rwAfiB0xnSQoq39qFa83CkhXQNVPGGvz+EAKKDxaxPNr37avkU/tMIrAkAsZOGvo3vfzwlpJZn6Ey2QH/e5l7BIfTQkakqLX2S3BHF/VNlU6m0GVri0Xe6SamehvUJDIL5ChLDmP+RDMElBAkBpnTe1Szvjxvw6CFJbv2ynMAeN7LpsLNOot6mEhr32HwhMZGaMS6qJN41v0l94Z4nf09AJcywuRvq95SkyeTwc"

#define PartnerPrivKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAN+HHUWPB2XSXaAAk8Qr+8PailQZK+y/bjCk+0waAuQxoHLpvg07Wy79wdYRrAxf1jXaPuVedqWOM/mFIrHw7UBIovDBwncYuGr6tpTVTHmRGlMQyCcKPacmjGYxWq3Tpz29pxAcEBj2AyEbs1VBfjjxajpKOKsHA3vtxvMqr1YTAgMBAAECgYA/7+wFi4X4MBYrwD6ELHiVaxuKNrEDxTYFoAtplz8germEZSvBqSrJ5DffvapS1870FHtNLJoPfP+M7fIgp+OUqLyMV2DvHIk19THSIgTWVL2QS3OcDMQzf0rJLHJYj6zb/CAnpyUZ9/UL5fmZ1dWfdIGBFIznjcHSxUVHD2P/MQJBAPj+/K5nvUkulSZgOYjLCtivLya/dloKLQuv5TzKTr6pL2yWQnus3dfeBqgWm+fRJqS0VNhycD5DamoHfu7IC4cCQQDl0LsvRxTZuLldQgScdpyqb5r7mOEwrPWXdQKlQUm5LPvCDjYpNoFS3xp3CHlyX7txtLM+Sl21M/m15JgyB3wVAkEAkc9wVQl29SYMPZ7X0l1kiqN77yrruap/2no0ubaXClu049fSMu52MvVX3JLw1X3LLWRU0zOguzVrWY/uKxKGfQJBALczkkS6EXEOxRYGzs477+AeYBo5YSsAdjdq29UJGtA3f+rOkXaBMM7zc5F4e/glQLQALPN3LQSKjoHl3T3koZECQQDEYB6amh8X6IkW96DVoz0/kd8KrC+i0gsa4efBMy4EHumgcYrytVQfGAeRva87fkMnfr0622qhGxUBXp4Ud9y0"


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB"
#define AliPartnerId @"2088911907317536"
#define AliSellerId  @"bjyijiequ@aliyun.com"

//#define AlipayNotifyUrl @"http://wx.bjyijiequ.com/yjqapp/page/ebei/notify_url.jsp"
//#define AlipayNotifyUrl @"http://d.bjyijiequ.com/qpi/page/ebei/notify_url.jsp"//测试地址
#define MSG_TYPE_PROPERTY_NOTICE @"PropertyNotice" // 物业通知
#define MSG_RECIVENEWMESSAGE_NOTICE @"RecieveNewMessage" // 收到新物业通知消息
#define MSG_TYPE_NORMAL @"normal" // 普通聊天消息

#define WeChat_First_Login      @"WeChatFirstLogin"     // 微信第一次登录

#define newAddnum 8000 //新增地址 楼栋 单元 楼层 房间 请求设置的数

#endif

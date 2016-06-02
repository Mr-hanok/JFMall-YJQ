//
//  ComDefine.h
//  CommonApp
//
//  Created by SunX on 15/7/15.
//  Copyright (c) 2015年 SunX. All rights reserved.
//

#if defined APP_DAILY

////-----------------------------------  测试环境  ------------------------------------

#define Service_Address     @"http://wx.bjyijiequ.com/yjqapp/"


#define XMPP_HostName               @"101.200.177.21"
#define Service_Address             @"http://d.bjyijiequ.com/qpi/"//测试接口http://10.24.33.42:8080/qpi/
//#define Service_Address             @"http://10.24.33.164:8080/qpi/"//定位测试IP
//#define Service_Address             @"http://10.24.35.42:9999/qpi/"//测试接口
#define FileManager_Address         @"http://gj.bjyijiequ.com:5903/"
#define ImageServer_Address         @"http://d.bjyijiequ.com/qpi/"
//🍎开门－测试环境
#define VersionNumber   @"1.0"
/// @"http://d.bjyijiequ.com/opendoormidface/owner/opendoor.do?ownerId=125007&version=1.0"
#define  OwnerApprove_Url             @"http://d.bjyijiequ.com/opendoormidface/owner/opendoor.do?"//业主认证
#define OpenResult_Url                @"http://d.bjyijiequ.com/opendoormidface/owner/savelog.do?version=1.0&md5=%@&rst=%@"//开门认证结果
#define VisitorList                  @"http://d.bjyijiequ.com/opendoormidface/visitor/list.do?"//访客列表
#define VisitorURL                   @"http://d.bjyijiequ.com/opendoormidface/visitor/opendoor.do?"//申请访客二维码
////#define VisitorURL                   @"http://d.bjyijiequ.com/opendoormidface/visitor/opendoor.do?version=1.0&rst=23444"//申请访客二维码


//🍎到家服务－测试环境
#define SERVICE_TO_HOME_API           @"http://d.bjyijiequ.com/wechat/serviceIndex/index.do?"//到家
#define SERVICE_TO_HOME_LIST_API       @"http://d.bjyijiequ.com/qpi/page/ebei/ownerWeixin/center/service/orderAIIOS.html?"//服务订单125116

//🍎物业缴费－测试环境
#define MyProperty_Url                  @"http://d.bjyijiequ.com/qpi/page/ebei/propertyPayment_Payment_indexClientPage.do"//物业缴费
#define PropertyBillList_Url            @"http://d.bjyijiequ.com/qpi/page/ebei/propertyPayment_Payment_orderListClientPage.do"//缴费订单
//🍎首页轮播图 内部URL的path

#define recommendationPath              @"/page/ebei/ownerWeixin/home/recommendation/detail.html"
#define limitPath                       @"/page/ebei/ownerWeixin/home/limit/detail.html"

//支付宝回调URL
#define AlipayNotifyUrl @"http://d.bjyijiequ.com/qpi/page/ebei/notify_url.jsp"//测试地址
//物业通知一键已读
#define CommunityMessageNewsreadURL @"http://d.bjyijiequ.com/qpi/property_GbSlideInfo_showDetailsClientPage.do?userId=%@&projectId=%@&onekeyRead=%@"

//🍎app装机首发代金卷发放代金劵
#define GivetokenYESorNO_URL                  @"http://d.bjyijiequ.com/appmarketactive/appcashcoupon/validateOwner.do?"
//发放代金劵
#define Givetoken_URL                           @"http://d.bjyijiequ.com/appmarketactive/appcashcoupon/assignAppFirstLoginCashCoupon.do"

// **********************************************************************************

#else

////-----------------------------------  生产环境  ------------------------------------

#define Service_Address     @"http://d.bjyijiequ.com/qpi/"


#define XMPP_HostName               @"123.57.209.140"
#define Service_Address             @"http://wx.bjyijiequ.com/yjqapp/"
#define FileManager_Address         @"http://gj.bjyijiequ.com:5903/"
#define ImageServer_Address          FileManager_Address   //@"http://123.57.254.25/ygj/"

//🍎开门－正式环境
#define VersionNumber   @"1.0"//版本号
#define  OwnerApprove_Url             @"http://wx.bjyijiequ.com/opendoormidface/owner/opendoor.do?"//业主认证
#define OpenResult_Url                @"http://wx.bjyijiequ.com/opendoormidface/owner/savelog.do?version=1.0&md5=%@&rst=%@"//开门认证结果
#define VisitorList                  @"http://wx.bjyijiequ.com/opendoormidface/visitor/list.do?"//访客列表
#define VisitorURL                   @"http://wx.bjyijiequ.com/opendoormidface/visitor/opendoor.do?"//申请访客二维码


//🍎到家服务－正式环境
#define SERVICE_TO_HOME_API           @"http://wx.bjyijiequ.com/wechat/serviceIndex/index.do?"//到家
#define SERVICE_TO_HOME_LIST_API       @"http://wx.bjyijiequ.com/yjqapp/page/ebei/ownerWeixin/center/service/orderAIIOS.html?"//服务订单


//🍎物业缴费-正式环境
#define MyProperty_Url                  @"http://wx.bjyijiequ.com/yjqapp/propertyPayment_Payment_indexClientPage.do"//物业缴费
#define PropertyBillList_Url            @"http://wx.bjyijiequ.com/yjqapp/propertyPayment_Payment_orderListClientPage.do"//缴费订单
//🍎首页轮播图 内部URL的path
#define recommendationPath              @"/yjqapp/page/ebei/ownerWeixin/home/recommendation/detail.html"
#define limitPath                       @"/yjqapp/page/ebei/ownerWeixin/home/limit/detail.html"
#define sellerPath                      @"/yjqapp/page/ebei/ownerWeixin/home/recommendation/seller-goods.html"
//支付宝回调URL
#define AlipayNotifyUrl @"http://wx.bjyijiequ.com/yjqapp/page/ebei/notify_url.jsp"
//物业通知一键已读
#define CommunityMessageNewsreadURL @"http://wx.bjyijiequ.com/yjqapp/property_GbSlideInfo_showDetailsClientPage.do?userId=%@&projectId=%@&onekeyRead=%@"
//🍎app装机首发代金卷发放代金劵
#define GivetokenYESorNO_URL                  @"http://wx.bjyijiequ.com/appmarketactive/appcashcoupon/validateOwner.do?"
//发放代金劵
#define Givetoken_URL                           @"http://wx.bjyijiequ.com/appmarketactive/appcashcoupon/assignAppFirstLoginCashCoupon.do"

#endif


////-----------------------------------  url  ------------------------------------

#define RootUrl     @"https://api.douban.com/"
#define BaseUrl     RootUrl@"v2/"

// 登陆接口
#define Login_Url      @"book/"
#define Login_Path     @"1220562"

// 图书接口
#define Book_Url      @"book/"
#define Book_Path     @"1220562"
#define BookSearch_Path     @"search"


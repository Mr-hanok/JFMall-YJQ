//
//  Interface.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#ifndef CommunityApp_Interface_h
#define CommunityApp_Interface_h


//测试服务器
//#define XMPP_HostName             @"42.121.137.221"
//#define Service_Address           @"http://42.121.137.221:5902/ebeitest/"
//#define FileManager_Address       @"http://42.121.137.221:5903/"
//#define ImageServer_Address       Service_Address


//孙伟服务器
//#define XMPP_HostName             @"10.0.0.35"
//#define Service_Address           @"http://10.0.0.35:8080/qpi/"
//#define FileManager_Address       @"http://10.0.0.35:5903/"

//周政服务器
//#define XMPP_HostName             @"192.168.11.7"
//#define Service_Address           @"http://192.168.11.7:8080/qpi/"
//#define FileManager_Address       @"http://192.168.11.7:5903/"
//#define ImageServer_Address         @"http://192.168.11.7:8080/qpi/"

#define SMS_Service_Address       @"http://sms.ue35.net/"
#define YOYEE_Service_Address     @"http://service.yoyee.cn/"


//图片传送
#define FileManager_URL(Path)   [NSString stringWithFormat:@"%@%@", FileManager_Address, Path]
#define FileManager_Url           @"filemanager"
#define FileManager_Path          @"FileUploadAndDownloadServlet"
//服务器地址
#define Service_URL(Path)   [NSString stringWithFormat:@"%@%@", Service_Address, Path]
#define YOYEE_Service_URL(Path)   [NSString stringWithFormat:@"%@%@", YOYEE_Service_Address, Path]
//YOYEE path
#define YOYEE_Path                 @"index.php"
//短信
#define SMS_URL(Path)             [NSString stringWithFormat:@"%@%@", SMS_Service_Address, Path]
#define SMS_Url                   @"sms/interface"
#define SMS_Path                  @"sendmess.htm"

#define ServerSMS_Url               @"rest/goodsModuleInfo"
#define ServerSMS_Path              @"saveMessageCartOrder"

//亿管家快递二维码图片下载服务器地址
#define BarCodeImgServer_Addr       @"http://123.57.254.25/ygj/"

//商家列表Path
#define SurroundBusiness_Url        @"rest/crmManageSellerInfo"
#define SurroundBusiness_Path       @"manageSellerList"
#define SurroundBusinessDetail_Path @"getSellerDetail"
#define Generul_Concat_Url          @"rest/crmManagePhoneInfo/"
//商家评价path
#define SurroundBusinessReviews_Path         @"getSellerReviews"
#define SurroundBusinessUploadReviews_Path   @"uploadSellerReview"
//登录path
#define  ServiceInfo_Url            @"rest/crmServiceInfo"
#define  Login_Path                 @"login"
#define  Register_Path              @"register"
#define  EditPsw_Path               @"editPassWord"
#define  resetPsw_Path              @"resetPassWord"
#define  EditInfo_Path              @"editOwnerInfo"
#define  CustomProperty_Path        @"customProperty"
#define  CodeLogin_Path             @"registerOwnerByOpenid"
#define  BindTel_Path               @"bindingPhoneAndWeixin"
#define  IsPhoneLogined_Path        @"isPhoneFirstLogin"

//版本检测
#define  VersionInfo_Url            @"rest/versionInfo"
#define  VersionInfo_Path           @"getVersionInfo"

//搜索地址
#define SearchAddress               @"getHouserInfoByParam"

//获取首页广告图片
#define SlideList_Url               @"rest/goodsSlideInfo"
#define SlideList_Path              @"slideList"
#define MallSlideList_Path          @"getSlideListByType"
//获取替换内容路径
#define ReplaceContent_Path         @"getSlideListByWork"

//终端意见反馈
#define FeedInfo_Url                @"rest/goodsfeedInfo"
#define FeedInfo_Path               @"feedInfo"

//终端附件上传
#define FeedInfoUploadFiles_Url     @"rest/crmServiceInfo"
#define FeedInfoUploadFiles_Path    @"uploadCrmFiles"

//管家获取广告图片
#define HouseKeep_Url               @"rest/projectSettingInfo"
#define HouseKeep_Path              @"projectSettingList"

//我的收藏夹
#define MyFav_Url                   @"rest/goodsModuleInfo"
#define MyFav_Path                  @"getFavoritesByType"

//省份获取path
#define  DistinctInfo_Url           @"rest/cityInfo"
#define  DistinctInfo_Path          @"cityList"
//商品order path
#define  Commodity_OrderInfo_Url    @"rest/goodsModuleInfo"
#define  Commodity_OrderList_Path   @"getOrderList"
#define  Commodity_OrderDetail_Path @"getOrderDetail"
#define  Commodity_ServiceOrderList_Path @"getServiceOrderList"
#define  Commodity_OrderConfirm_Path     @"confirmOrder"
//服务 order path
#define  Service_OrderInfo_Url    @"rest/crmServiceInfo"
#define  Service_OrderList_Path   @"crmOrderList"
#define  Service_OrderDetail_Path @"crmOrderDetail"
//
//取消订单Path
#define CancelOrder_Path            @"cancelOrder"
//跟踪订单Path
#define Commodity_OrderTrack_Path   @"getOrderTrack"
#define Service_OrderTrack_Path     @"crmOrderTrack"
//工程报修-选择分类Path
#define SelectCategory_Url          @"rest/crmFeedBackInfo"
#define SelectCategory_Path         @"serviceTypeList"
#define Get_MyPostRepair_Path       @"feedBackOrderList"
#define MyPostRepair_Follow_Detail  @"feedBackTrack"
#define MyPostRepairDetail_Path     @"feedBackOrderDetail"
#define MyPostRepairUpload_Path     @"uploadFeedBackOrder"
#define MyPostRepairUploadFiles_Path     @"uploadCrmFiles"

//商品分类Path
#define GoodsCategory_Url           @"rest/goodsModuleInfo"
#define GoodsCategory_Path          @"getGoodsCategoryArrayList"

//二手商品分类Path
#define FleaMarketCategory_Url      @"rest/secondhandTradingInfo"
#define FleaMarketCategory_Path     @"getCategoryArrayList"
#define FleaMarketFiles_Path        @"uploadCrmFiles"

//地址管理分类Path
#define GetRoadAddressList_Path     @"crmBuildLocation"
#define SetDefaultLocation_Path     @"setDefaultLocation"
#define NewAddRoadAddress_path      @"uploadCrmBuildLocation"
#define UpdateRoadAddress_path      @"updateCrmLocation"
#define DeleteRoadAddress_path      @"deleteCrmLocation"
#define DefaultRoadAddress_path     @"crmDefaultLocation"

//选择小区Path
#define SelectNeighBoorHood_Url     @"rest/projectInfo"
//#define SelectNeighBoorHood_Path    @"simpleProjectList"//定位测试
#define SelectNeighBoorHood_Path    @"sortProjectList"

//物业通知列表
#define CommunityMessage_URL        @"rest/goodsModuleInfo"
#define CommunityMessage_Path       @"getMsgPushDetail"

//定位后上传接口
#define LocationNeighBoorHood_Url   @"rest/userProjectHistoryInfo"
#define LocationNeighBoorHood_Path  @"saveUserProjectHistoryInfo"

//埋点日志接口
#define Buriedpoint_Url             @"rest/userInfo"
#define Buriedpoint_Path            @"saveGjzLoginLog"


//常用联系方式path
#define Generul_Concat_Path         @"managePhoneList"

//服务列表Path
#define ServiceList_Url             @"rest/crmServiceInfo"
#define ServiceList_Path            @"serviceTypeList"

//到家服务列表Path
#define DoorToDoorList_Url          @"rest/goodsModuleInfo"
#define DoorToDoorList_Path         @"getServicePm"

//到家服务详情Path
#define DoorToDoorDetail_Url        @"rest/goodsModuleInfo"
#define DoorToDoorDetail_Path       @"getServiceGoodModule"

//商品评价列表Path
#define GoodsCommentList_Url        @"rest/goodsModuleInfo"
#define GoodsCommentList_Path       @"getEvaluations"
#define GoodsCommentSave_Path       @"saveEvaluations"
//终端上传商品评价
#define GoodsCommentFile_Url        @"rest/goodsOrderInfo"
#define GoodsCommentFile_Path       @"uploadGoodsRemoteFile"

//终端上传接口
#define UploadCrmFiles_Url           @"rest/crmServiceInfo"
#define UploadCrmFiles_Path          @"uploadCrmFiles"

//服务详情Path
#define ServiceDetail_Url           @"rest/crmServiceInfo"
#define ServiceDetail_Path          @"serviceTypeDetail"

//商品列表Path
#define WaresList_Url               @"rest/crmServiceInfo"
#define WaresList_Path              @"serviceGoodsList"

//推荐商品列表Path
#define RecommendGoodsList_Url      @"rest/goodsModuleInfo"
#define RecommendGoodsList_Path     @"getGoodsBySeller"

//分类型获取商品列表Path
#define WaresListByModule_Url       @"rest/goodsModuleInfo"
#define WaresListByModule_Path      @"getGoodsByCategoryRec"

//获取指定类别商品列表Path
#define GoodsListByCategory_Url     @"rest/goodsModuleInfo"
#define GoodsListByCategory_Path    @"getGoodsByCategory"

//根据搜素条件获取商品列表Path
#define GoodsListBySearch_Url       @"rest/goodsModuleInfo"
#define GoodsListBySearch_Path      @"getGoodsByCategoryAndSort"

//提交服务Path
#define SubmitServiceOrder_Url      @"rest/crmServiceInfo"
#define SubmitServiceOrder_Path     @"uploadCrmOrder"

//商品详细Path
#define WaresDetail_Url             @"rest/crmServiceInfo"
#define WaresDetail_Path            @"serviceGoodsDetail"

//分类型获取商品详情Path
#define WaresDetailByModule_Url     @"rest/goodsModuleInfo"
#define WaresDetailByModule_Path    @"getGoodsDetail"

//获取团购详情Path
#define GroupBuyDetail_Url          @"rest/goodsModuleInfo"
#define GroupBuyDetail_Path         @"getGbDetail"

//获取团购券适用商家Path
#define GrouponShopList_Url         @"rest/goodsModuleInfo"
#define GrouponShopList_Path        @"getGbShops"

//单个商品收藏
#define GoodsFavorite_Url           @"rest/goodsModuleInfo"
#define GoodsFavorite_Path          @"saveOrDelFavorites"
#define GetGoodsFavoriteInfo_Path   @"getFavoritesByGoodsId"

// 单个商品收藏状态下载接口
#define GetFavoritesByGoodsId_Url   @"rest/goodsModuleInfo"
#define GetFavoritesByGoodsId_Path  @"getFavoritesByGoodsId"

//问卷调查
#define QuestionnaireSurveyList_Path    @"sync_SyncQuestionnaire_getAllQuestionnaireListTI.do"
#define QuestionnaireSurveyDetail_Path  @"sync_SyncQuestionnaire_getQuestionnaireDetailTI.do"
#define QuestionnaireSurveySave_Path  @"sync_SyncQuestionnaire_saveQuestionnaireAnswerTI.do"

//提交订单Path
#define SubmitOrder_Url             @"rest/goodsModuleInfo"
#define SubmitOrder_Path            @"uploadGoodsOrder"
#define ServiceSubmit_Path          @"uploadServiceOrders"
#define SubmitOrder_NewPath         @"uploadOrderDetailForGoodsModel"
#define PaySuccessServiceOrder_Path @"payOrder"
#define PayOrderSuccess_Path        @"payOrderByOrderNo"

//物业缴费Path
#define CommunityBill_Url           @"rest/chargeRecordInfo"
//获取建筑物信息Path
#define BuildingInfo_Path           @"buildingList"
//获取账户预交、未交信息Path
#define PaymentList_Path            @"paymentList"
//获取账单列表Path
#define BillList_Path               @"billList"
//获取最近12各月的账单列表Path
#define BillCateLogList_Path        @"billCateLogList"

//通行证书
#define VisitPass_Url               @"rest/crmVisitPassInfo"
#define saveVisitPass_Path          @"saveCrmVisitPass"
#define DetailVisitPass_Path        @"crmVisitPassDetail"
#define DownVisitReason_Path        @"downloadCrmVisitPass"

//获取缴费历史Path
#define PaymentHistoryList_Path     @"paymentRecordList"
//预缴费
#define prePaymentBill_Path         @"uploadPaymentRecord"
#define paymentBill_Path            @"pay"

//房屋租售列表
#define HouseInfo_Url               @"rest/houseInfo"
//租房厅室筛选条件Path
#define RoomType_Path               @"roomType"
//下载租房列表Path
#define HouseList_Path              @"houseList"
//下载租房详情信息Path
#define HouseDetail_Path            @"houseDetail"
//房屋信息出售上传Path
#define UploadHouseInfo_Path        @"uploadHouseInfo"
//已发布房源下载Path
#define ReleasedHouseList_Path      @"releasedHouseList"
//发布房源条件Path
#define HouseSelector_Path          @"houseSelector"
//删除发布房源
#define HouseInfoDel_Path           @"deleteRecord"
//楼盘展示列表Path
#define ProjectInfo_Url             @"rest/projectInfo"
//楼盘展示类型筛选条件Path
#define ProjectCategory_Path        @"projectCategory"
//楼盘展示列表Path
#define ProjectShowList_Path        @"projectShowList"
//楼盘详情信息Path
#define ProjectDetail_Path          @"projectShowDetail"
//楼盘筛选条件
#define ProjectSelector_Path        @"projectSelector"

//终端验证优惠券接口
#define VerifiCouponsDetail_Url     @"rest/goodsModuleInfo"
#define VerifiCouponsDetail_Path    @"verifiCouponsDetail"

//获取优惠券列表接口
#define CouponList_Url              @"rest/goodsModuleInfo"
#define CouponList_Path             @"checkCouponsListForUser"

//终端“优惠券确认”接口
#define CheckCouponsForUser_Url     @"rest/goodsModuleInfo"
#define CheckCouponsForUser_Path    @"checkCouponsForUser"
#define ExchangeCodeToCoupon_Path   @"exchangeCodeToCoupon"

//优惠券信息
#define GetCouponsInfo_Url          @"rest/goodsModuleInfo"
#define GetCouponsInfo_Path         @"getCouponsInfoForGoods"

//终端上传售后申请接口
#define SaveTbgAfterSale_Url        @"rest/goodsModuleInfo"
#define SaveTbgAfterSale_Path       @"saveTbgAfterSale"

//终端修改售后申请接口
#define UpdateTbgAfterSale_Url      @"rest/goodsModuleInfo"
#define UpdateTbgAfterSale_Path     @"updateTbgAfterSale"

//终端下载售后原因接口
#define AfterSalesReason_Url        @"rest/goodsModuleInfo"
#define AfterSalesReason_Path       @"downloadAfterSalesReason"

//终端下载售后详情接口
#define TbgAfterSaleDetail_Url      @"rest/goodsModuleInfo"
#define TbgAfterSaleDetail_Path     @"getTbgAfterSaleDetail"

//终端下载售后动作历史接口
#define TbgAfterSaleDealRecordDetail_Url    @"rest/goodsModuleInfo"
#define TbgAfterSaleDealRecordDetail_Path   @"getTbgAfterSaleDealRecordDetail"
#define TbgAfterSaleGrouponDealRecordDetail_Path @"getTbgAfterSaleDealRecordDetailByTicketId"
//终端撤销售后申请接口
#define CancelTbgAfterSaleState_Url     @"rest/goodsModuleInfo"
#define CancelTbgAfterSaleState_Path    @"cancelTbgAfterSaleState"

//终端上传留言接口
#define SaveTbgMessageRecord_Url    @"rest/goodsModuleInfo"
#define SaveTbgMessageRecord_Path   @"saveTbgMessageRecord"

//终端售后服务附件上传
#define UploadAfterSaleFiles_Url    @"rest/goodsModuleInfo"
#define UploadAfterSaleFiles_Path   @"uploadAfterSaleFiles"

//终端留言服务附件上传
#define UploadMessageFiles_Url      @"rest/goodsModuleInfo"
#define UploadMessageFiles_Path     @"uploadMessageFiles"

//终端“团购提交订单”接口
#define UploadGoodsOrderForGroupBuy_Url     @"rest/goodsModuleInfo"
#define UploadGoodsOrderForGroupBuy_Path    @"uploadGoodsOrderForGroupBuy"
#define GetGrouponsAfterPay_Path            @"generateTicketsForGroupBuy"

//终端“我的团购券”接口
#define GetOrderListForGroupBuy_Url     @"rest/goodsModuleInfo"
#define GetOrderListForGroupBuy_Path    @"getOrderListForGroupBuy"

//终端“团购订单详情”接口
#define GetOrderDetailForGroupBuy_Url   @"rest/goodsModuleInfo"
#define GetOrderDetailForGroupBuy_Path  @"getOrderDetailForGroupBuy"

//终端获取团购商品列表接口
#define GetGoodsModuleListForGroupBuy_Url   @"rest/goodsModuleInfo"
#define GetGoodsModuleListForGroupBuy_Path  @"getGoodsModuleListForGroupBuy"

//下载退款原因接口
#define GoodsModuleInfo_Url              @"rest/goodsModuleInfo"

//#define RefundReasonList_Path            @"downloadRefundReason"
#pragma -mark 实物订单－退款－售后原因
#define RefundReasonList_Path            @"downloadAfterSalesReason"
//业主认证
#define Auth_Path                   @"uploadAuthLocation"
//二手市场
#define FleaMarket_Url              @"rest/secondhandTradingInfo"
#define FleaMarketDetail_Path       @"tradingDetail"
#define FleaMarketList_Path         @"tradingList"
#define FleaMarketUpdate_Path       @"uploadTrading"
#define FleaMarketDelegate_Path     @"rest/secondhandTradingInfo/delTrading"

//购物车同步Path
#define ShopCartSync_Url            @"rest/goodsModuleInfo"
#define ShopCartSyncUpload_Path     @"saveShoppingCartOrder"
#define ShopCartSyncDownLoad_Path   @"getShoppingsDetail"

//积分规则
#define IntegralRulesDetail_Url       @"rest/crmServiceInfo"
#define IntegralRulesDetail_Path       @"getIntegralRulesDetail"

//头像上传
#define MyAvatarUpload_Url          @"rest/crmServiceInfo"
#define MyAvatarUpload_Path         @"uploadOwnerFiles"

//获取个人信息Path
#define PersonalInfo_Url            @"rest/projectSettingInfo"
#define PersonalInfo_Path           @"getOwnerList"

//同步小区Path
#define SyncProject_Url             @"rest/crmServiceInfo"
#define SyncProject_Path            @"serviceTypeList"

//获取优惠券支持分类情况Path
#define CouponSupportInfo_Url       @"rest/goodsModuleInfo"
#define CouponSupportInfo_Path      @"getCouponsSupport"

////获取办事通电话
//#define GetCrmManagePhoneList_Url         @"rest/goodsModuleInfo"
//#define GetCrmManagePhoneList_Path        @"getCrmManagePhoneList"
//办事通接口修改“针对亿街区两条数据问题”
//获取办事通电话http://wx.bjyijiequ.com/yjqapp/rest/crmManagePhoneInfo/managePhoneList?phoneCategoryId=&phoneName=&projectId=45
#define GetCrmManagePhoneList_Url         @"rest/crmManagePhoneInfo"
#define GetCrmManagePhoneList_Path        @"managePhoneList"

//快递模块Url
#define ExpressManageModule_Url     @"rest/expressManageInfo"

//快递 获取快递订单Path
#define MyExpressOrder_Path         @"getExpressOrderListByOwnerId"
//快递 获取订单跟踪信息Path
#define ExpressOrderTrackInfo_Path  @"getExpressOrderTrackInfoByExpressId"



#endif

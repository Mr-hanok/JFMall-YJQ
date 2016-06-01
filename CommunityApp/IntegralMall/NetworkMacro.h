
//

#define SERVER_HOST_PRODUCT    @"http://d.bjyijiequ.com/mallyjq/"  // 外网地址
//#define SERVER_HOST_PRODUCT  @"http://10.130.24.155/mallyjq/"  // 测试地址
#define SERVER_FILE_PRODUCT    @""  // 图片服务器地址


#define kDefaultServerErrorString      @"服务器异常，请稍后再试"
#define kDefaultNetWorkErrorString     @"网络连接异常"
#define kDefaultQuitErrorString        @"您的账号已经在别处登录!"
#define kDefaultWebErrorString         @"抱歉,此网页出现了问题"

#pragma mark - 请求地址

#define kRequestDataRows               @"15"

/**设置通用参数3 表示iOS*/
#define JFPub_type                      [self.params setObject:@"3"     forKey:@"pub_type"];

/**登录接口*/
#define LoginAction                    @"m/logina.htm"
#define LoginQuitAction                @""  
/**签到接口*/
#define JFSignInAction                 @"m/signIn.htm"
/**积分商城首页接口*/
#define JFIntegralHomeAction           @"m/index.htm"
/**积分商品详情接口*/
#define JFGoodsDetailAction            @"m/detail.htm"
/**兑换中心接口*/
#define JFConvertCenterAction          @"m/changeCenter.htm"
/**商品库存接口*/
#define JFGoodsInventoryAction         @"m/get_goods_gg.htm"
/**加入购物车接口*/
#define JFGoodsAddShopCarAction        @"wx/add_goods_cart.htm"
/**获取购物车信息接口*/
#define JFShopCarInfoAction            @"m/goods_cart.htm"
/**删除购物车商品接口*/
#define JFShopCarDelGoodsAction        @"m/remove_goods_cart.htm"
/**购物车商品数量加减接口*/
#define JFShopCarGoodsNumAddDelAction  @"m/goods_count_adjust.htm"
/**积分明细接口*/
#define JFIntegralDetailAction         @"m/integralDetail.htm"
/**积分规则接口*/
#define JFIntegralRuleAction           @"m/integralRuleDesc.htm"
/**提交订单页面查询商品信息接口*/
#define JFConfirmationAction           @"m/order_confirmation.htm"
/**提交订单接口*/
#define JFOrderSubmitAction            @"m/order_submit.htm"

/**积分订单列表接口*/
#define JFOrderListAction              @"m/order_list.htm"
/**任务中心接口*/
#define JFTaskCenterAction             @"m/missionCenter.htm"
/**物流跟踪接口*/
#define JFOrderFollowAction            @"m/express_info.htm"
/**取消订单接口*/
#define JFOrderCanCelAction            @"m/order_cancel_save.htm"
/**确认收货接口*/
#define JFOrderConfirmAction           @"m/order_cofirm_save.htm"
/**订单明细接口*/
#define JFOrderDetailAction            @"m/order_detail.htm"
/**删除订单接口*/
#define JFOrderDelAction               @"m/deleteOrder.htm"
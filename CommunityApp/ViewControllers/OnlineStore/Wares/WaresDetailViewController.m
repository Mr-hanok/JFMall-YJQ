 //
//  WaresDetailViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "WaresDetailViewController.h"
#import "WaresDetail.h"
#import "UIImageView+AFNetworking.h"
#import "CartBottomBar.h"
#import "ShoppingCartViewController.h"
#import "DBOperation.h"
#import "AGImagePickerViewController.h"
#import "WaresDetailTableViewCell.h"
#import "GoodsCommentListViewController.h"
#import "LimitBuyViewController.h"
#import "WaresOrderSubmitViewController.h"
#import "WebViewController.h"
#import "RecommendGoods.h"
#import "GoodsForSaleViewController.h"
#import "SDWebImageDownloader.h"
#import "UILabel+Price.h"

#define CELLNIBNAME @"WaresDetailTableViewCell"

@interface WaresDetailViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,KDCycleBannerViewDataource, KDCycleBannerViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *waresImgView;//商品详情广告图片
@property (nonatomic, retain) IBOutlet KDCycleBannerView *cycleBannerView;
@property (nonatomic, retain) NSMutableArray *adImageArray;

@property (retain, nonatomic) IBOutlet UILabel *waresName;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (retain, nonatomic) IBOutlet UIView *saleGroupView;
@property (retain, nonatomic) IBOutlet UILabel *currentPrice;
@property (retain, nonatomic) IBOutlet UILabel *beforePrice;
@property (retain, nonatomic) IBOutlet UIView *serviceGroupView;
@property (retain, nonatomic) IBOutlet UILabel *brandName;
@property (retain, nonatomic) IBOutlet UILabel *styleValue;
@property (retain, nonatomic) IBOutlet UILabel *inventory;
@property (retain, nonatomic) IBOutlet UILabel *contactInformation;
@property (retain, nonatomic) IBOutlet UIView *cartView;
@property (weak, nonatomic) IBOutlet UIView *styleView;
@property (weak, nonatomic) IBOutlet UILabel *remainCountLabel;

@property (weak, nonatomic) IBOutlet UIView *serviceLabelView;
@property (weak, nonatomic) IBOutlet UIView *saleMarkLabelView;
@property (weak, nonatomic) IBOutlet UIView *discountLabelView;
@property (weak, nonatomic) IBOutlet UIView *deliverLabelView;
@property (weak, nonatomic) IBOutlet UIButton *goodsCountInCartBtn;
@property (weak, nonatomic) IBOutlet UILabel *limitBuyTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentPriceLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beforePriceLabelWidth;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *WaresIconHightConstraint;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *WaresBtnHightConstraint;
@property (retain, nonatomic) CartBottomBar     *carBar;        //购物车Bar(编辑/完成)状态不同，内容不同
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) IBOutlet UIView* tableHead;
@property (strong,nonatomic) IBOutlet UIView* tableFooter;
// 商品详细模型
@property (retain, nonatomic) WaresDetail   *waresDetail;

@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIImageView *line3;
@property (weak, nonatomic) IBOutlet UIImageView *line4;
@property (weak, nonatomic) IBOutlet UIImageView *line5;
@property (weak, nonatomic) IBOutlet UIImageView *line6;
@property (weak, nonatomic) IBOutlet UIImageView *line7;
@property (weak, nonatomic) IBOutlet UIImageView *line8;
@property (weak, nonatomic) IBOutlet UIImageView *line9;
@property (weak, nonatomic) IBOutlet UIImageView *line10;
@property (weak, nonatomic) IBOutlet UIImageView *line11;

@property (nonatomic, retain) NSTimer   *timer;
//@property (nonatomic, assign) NSInteger     diffDate;

@property (retain, nonatomic) NSMutableArray           *goodsCommentArray;
@property (retain, nonatomic) NSMutableArray    *recommendGoodsArray;
@property (copy, nonatomic) NSString            *goodsFav;//0.未收藏，1.已收藏
@property (strong,nonatomic) IBOutlet UIButton* favBtn;
@property (strong,nonatomic) IBOutlet UIImageView* commentLine;
@property (weak, nonatomic) IBOutlet UIImageView *storeTopLine;
@property (weak, nonatomic) IBOutlet UILabel *waresCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *waresCountLabel;
@property (nonatomic, strong) NSMutableArray *supportPaymentType;   /**< 支持的付款方式 */
@property (nonatomic, retain) NSArray   *styleBtnArray; // 规格型号按钮数组
@property (nonatomic, retain) NSArray   *remainCountArray; // 规格型号库存数组

@property (weak, nonatomic) IBOutlet UIView *specialBg;
@property(nonatomic,strong) IBOutlet UILabel*specialLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specialBgHeight;

@property (weak, nonatomic) IBOutlet UIView *couponBg;
@property(strong,nonatomic)IBOutlet NSLayoutConstraint* couponBgHeight;
@property (weak, nonatomic) IBOutlet UILabel *supportCouponLabel;//支持优惠券

@end

@implementation WaresDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Store_WaresDetail;
    [self setNavBarLeftItemAsBackArrow];
    
    [Common updateLayout:_line1 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_line2 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_line3 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_line4 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_line5 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_line6 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_line7 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_line8 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_line9 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_line10 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_line11 where:NSLayoutAttributeHeight constant:0.5];
    
    [self initBasicDataInfo];
#pragma -mark 商品详情页的导航栏右上角的‘分享’
    //[self setNavBarItemRightViewForNorImg:@"ShareBtnNor" andPreImg:@"ShareBtnPre"];//商品详情的右上角的分享

    [self.commentLine setHidden:YES];
    [self.table setHidden:YES];
    
    _cycleBannerView.datasource = self;
    _cycleBannerView.delegate = self;
    _cycleBannerView.autoPlayTimeInterval = 1000;
    _cycleBannerView.continuous = NO;
    
    //从服务器上获取商品详情数据
//    [self getWaresDetailFromServer];

    //从服务器上获取收藏信息
    [self getGoodsFavInfoFromServer];
    
//    //从服务器上获取商品评价数据
//    [self getGoodsCommentFromServer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 设置购物车商品数
    [self updateGoodsCountInCart];
    //2016.03.28从服务器上获取商品详情数据
    [self getWaresDetailFromServer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - 更新购物车商品数
- (void)updateGoodsCountInCart
{
    NSInteger count = [[DBOperation Instance] getTotalWaresAndServicesCountInCart];
    if (count  <= 0) {
        [self.goodsCountInCartBtn setHidden:YES];
    }else if (count < 100) {
        [self.goodsCountInCartBtn setTitle:[NSString stringWithFormat:@"%ld", (long)count] forState:UIControlStateNormal];
        [self.goodsCountInCartBtn setHidden:NO];
    }else {
        [self.goodsCountInCartBtn setTitle:@"..."forState:UIControlStateNormal];
        [self.goodsCountInCartBtn setHidden:NO];
    }
}

#pragma mark - 按钮点击事件处理函数
- (IBAction)waresImgBtnClickHandler:(id)sender
{
    //TODO
    NSArray* imgsArray =  [self.waresDetail.goodsUrl componentsSeparatedByString:@","];
    if(imgsArray == nil || imgsArray.count == 0)
    {
        return;
    }
    AGImagePickerViewController* vc = [[AGImagePickerViewController alloc]init];
    vc.imgUrlArray = imgsArray;
    [self.navigationController pushViewController:vc animated:TRUE];
    
}

#pragma mark - 文件域内公共方法


// 初始化基本数据
- (void)initBasicDataInfo
{
    self.goodsCommentArray = [[NSMutableArray alloc] init];
    self.recommendGoodsArray = [[NSMutableArray alloc] init];
    self.adImageArray = [[NSMutableArray alloc] init];
    
    [_table registerNib:[UINib nibWithNibName:CELLNIBNAME bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELLNIBNAME];
   
    _tableHead.frame = CGRectMake(0, 0, Screen_Width, 430 + Screen_Width-50);
    _table.tableHeaderView = _tableHead;
}

- (void)initUIViewStyle {
    if (self.waresDetail != nil && ![self.waresDetail.goodsPrice isEqualToString:@""]) {
        CGFloat curPrice = [self.waresDetail.goodsPrice floatValue];
        CGFloat curPriceLabelWidth = [Common labelDemandWidthWithText:[NSString stringWithFormat:@"¥%.2f", curPrice] font:[UIFont systemFontOfSize:16.0] size:CGSizeMake(100, 50)];
        _currentPriceLabelWidth.constant = curPriceLabelWidth+50;
    }
    
    if (self.waresDetail != nil && ![self.waresDetail.goodsActualPrice isEqualToString:@""]) {
        CGFloat beforePrice = [self.waresDetail.goodsActualPrice floatValue];
        CGFloat beforePriceLabelWidth = [Common labelDemandWidthWithText:[NSString stringWithFormat:@"¥%.2f", beforePrice] font:[UIFont systemFontOfSize:14.0] size:CGSizeMake(100, 50)];
        _beforePriceLabelWidth.constant = beforePriceLabelWidth+50;
        
        // 市场价格中划线
        CALayer *line = [[CALayer alloc] init];
        line.backgroundColor = Color_Gray_RGB.CGColor;
        
        line.frame = CGRectMake(0, self.beforePrice.frame.size.height / 2, beforePriceLabelWidth+10, 1);
        
        [self.beforePrice.layer addSublayer:line];
    }

}

#pragma mark - 从服务器获取数据
// 从服务器上获取商品数据
- (void)getWaresDetailFromServer
{
    // 初始化参数
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSString *userid = [[LoginConfig Instance]userID];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.waresId, projectId,userid] forKeys:@[@"goodsId", @"projectId",@"userId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:WaresDetailByModule_Url path:WaresDetailByModule_Path method:@"GET" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
        for (NSDictionary *dic in result) {
            self.waresDetail = [[WaresDetail alloc] initWithDictionary:dic];//2015.11.12
            YjqLog(@"result========%@",result);
        }
        
#pragma mark-是否为首件特价
        if ([_waresDetail isSpecialOfferGoods]) {
            self.specialBgHeight.constant = 50.0f;
            self.couponBgHeight.constant = 0.0f;
            self.couponBg.hidden = YES;
            self.specialBg.hidden = NO;
            self.table.tableHeaderView = _tableHead;
        }
        else {
            self.specialBgHeight.constant = 0.0f;
            self.couponBgHeight.constant = 50.0f;
            self.couponBg.hidden = NO;
            self.specialBg.hidden = YES;
            self.table.tableHeaderView = _tableHead;
        }
        // 设置商家名称
        [_sellerNameLabel setText:_waresDetail.sellerName];
        // 设置商家电话
        [_contactInformation setText:_waresDetail.sellerPhone];
        [self.waresCountLabel setText:[NSString stringWithFormat:@"(%ld件商品)", (long)_waresDetail.shopGoodsCount]];
        [self.supportPaymentType removeAllObjects];
        NSArray *paymentsStr = [self.waresDetail.paymentType componentsSeparatedByString:@","];
        if ([paymentsStr containsObject:kPaymentTypeOnline]) {
            [self.supportPaymentType addObject:Str_Cart_OnlinePay];
        }
        if ([paymentsStr containsObject:kPaymentTypeOffline]) {
            [self.supportPaymentType addObject:Str_Cart_ArrivePay];
        }
//        [self getRecommendGoodsDataFromServer];
        [self.table setHidden:NO];
        [self displayWaresDetail];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

//从服务器获取收藏
-(void)getGoodsFavInfoFromServer
{
    NSString* userId = [[LoginConfig Instance] userID];
    if(userId == nil|| [userId isEqualToString:@""])
    {
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.waresId, userId] forKeys:@[@"goodsId", @"userId"]];
    
    // 请求服务器获取数据
    [self getStringFromServer:GoodsFavorite_Url path:GetGoodsFavoriteInfo_Path method:@"GET" parameters:dic success:^(NSString *result) {
        _goodsFav = result;
        [self displayFavIcon];
        
    } failure:^(NSError *error) {
//        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
   
}
//从服务器获取商品评价
- (void)getGoodsCommentFromServer
{
    if (_waresDetail != nil && _waresDetail.evaluations != nil &&  _waresDetail.evaluations.length > 0) {
        [self.goodsCommentArray removeAllObjects];
        NSArray *newGoogsCommentArray = [_waresDetail.evaluations componentsSeparatedByString:@"@ebei@"];
        [self.goodsCommentArray addObjectsFromArray:newGoogsCommentArray];
    }
    if(self.goodsCommentArray.count == 0)
    {
        [_commentLine setHidden:NO];
        [_storeTopLine setHidden:YES];
    }else {
        [_commentLine setHidden:YES];
        [_storeTopLine setHidden:NO];
    }
    [self.waresCommentLabel setText:[NSString stringWithFormat:@"商品评价(%ld条)", (long)self.goodsCommentArray.count]];
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.waresId] forKeys:@[@"goodsId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:GoodsCommentList_Url path:GoodsCommentList_Path method:@"GET" parameters:dic xmlParentNode:@"result" success:^(NSMutableArray *result) {
        [self.goodsCommentArray removeAllObjects];
        for (NSDictionary *dic in result) {
            [self.goodsCommentArray addObject:[[GoodsComment alloc] initWithDictionary:dic]];
        }
        if(self.goodsCommentArray.count == 0)
        {
            [_commentLine setHidden:NO];
            [_storeTopLine setHidden:YES];
        }else {
            [_commentLine setHidden:YES];
            [_storeTopLine setHidden:NO];
        }
        [self.waresCommentLabel setText:[NSString stringWithFormat:@"商品评价(%ld条)", (long)self.goodsCommentArray.count]];
    } failure:^(NSError *error) {
//        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark - 从服务器获取推荐商品数据
//- (void)getRecommendGoodsDataFromServer
//{
//    if (_waresDetail == nil || _waresDetail.sellerId == nil  || [_waresDetail.sellerId isEqualToString:@""]) {
//        return;
//    }
//    
//    // 初始化参数
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[_waresDetail.sellerId] forKeys:@[@"sellerId"]];
//    
//    [self getArrayFromServer:RecommendGoodsList_Url path:RecommendGoodsList_Path method:@"GET" parameters:dic xmlParentNode:@"result" success:^(NSMutableArray *result) {
//        if (result.count > 0) {
//            [self.recommendGoodsArray removeAllObjects];
//            for (NSDictionary *dic in result) {
//                [self.recommendGoodsArray addObject:[[RecommendGoods alloc] initWithDictionary:dic]];
//            }
//            [self.waresCountLabel setText:[NSString stringWithFormat:@"(%ld件商品)", (long)self.recommendGoodsArray.count]];
//        }
//    } failure:^(NSError *error) {
//        [Common showBottomToast:Str_Comm_RequestTimeout];
//    }];
//}



-(void)displayFavIcon
{
    if ([_goodsFav isEqualToString:@"0"])//未收藏
    {
        [_favBtn setImage:[UIImage imageNamed:@"WareDetailStart"] forState:UIControlStateNormal];
        [_favBtn setImage:[UIImage imageNamed:@"GrouponFavIconPre"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_favBtn setImage:[UIImage imageNamed:@"WareDetailStart"] forState:UIControlStateHighlighted];
        [_favBtn setImage:[UIImage imageNamed:@"GrouponFavIconPre"] forState:UIControlStateNormal];
    }
}


// 显示商品详细
- (void)displayWaresDetail
{
    // banner
    NSArray* imgsArray = [self.waresDetail.goodsUrl componentsSeparatedByString:@","];
    [self.adImageArray removeAllObjects];
    for (NSString *imgUrl in imgsArray) {
        NSRange rang = [imgUrl rangeOfString:FileManager_Address];
        NSString *iconUrl = rang.length == 0 ? [Common setCorrectURL:imgUrl] : imgUrl;
        [self.adImageArray addObject:iconUrl];
    }
//    _cycleBannerView.continuous = self.adImageArray.count > 1;
    [_cycleBannerView reloadDataWithCompleteBlock:^{
        
    }];
    
    [self initUIViewStyle];
    
    if(self.waresDetail.sellerId !=nil && [self.waresDetail.sellerId isEqualToString:@""] == FALSE)
    {
        _table.tableFooterView = _tableFooter;
    }
    
    [self displayCountDownTimer];
    
    [self.waresName setText:self.waresDetail.goodsName];
    NSString *currentPrice = @"暂无报价";
    self.beforePrice.hidden = YES;
    
    if (!([self.waresDetail.goodsPrice isEqualToString:@""] ||
          self.waresDetail.goodsPrice == nil)) {
#pragma -mark 12-16 商品详情页显示商品特价
        if ([self.waresDetail isSpecialOfferGoods]) {

            [self.currentPrice setSpecialPrice:self.waresDetail.specialOfferPrice OrangPrice:self.waresDetail.goodsPrice];
        }
        else
        {
            if (![self.waresDetail.goodsActualPrice isEqualToString:@""]) {

                [self.currentPrice setNewPrice:self.waresDetail.goodsPrice oldPrice:self.waresDetail.goodsActualPrice];
            }
            else
            {
                [self.currentPrice setText:[NSString stringWithFormat:@"￥%@",self.waresDetail.goodsPrice]];
            }
        }
    }
    else {
        [self.currentPrice setText:[NSString stringWithFormat:@"￥%@",currentPrice]];
    }
    
    [self.brandName setText:self.waresDetail.sgBrand];
    NSArray *strings = [self.waresDetail.standardModel componentsSeparatedByString:@","];
    NSMutableArray *mstrings = [[NSMutableArray alloc] initWithArray:strings];
    NSString *lastString = [mstrings lastObject];
    if ([lastString isEqualToString:@""]) {
        [mstrings removeLastObject];
    }
    
    self.remainCountArray = [self.waresDetail.remainCount componentsSeparatedByString:@","];
    
    self.styleBtnArray = [Common insertButtonForStrings:mstrings toView:self.styleView andViewHeight:33.0 andMaxWidth:(Screen_Width-103.0) andButtonHeight:27.0 andButtonMargin:6.0 andAddtionalWidth:8.0 andFont:[UIFont systemFontOfSize:12.0] andBorderColor:Color_Gray_RGB.CGColor andTextColor:COLOR_RGB(57, 57, 57)];
    
    BOOL isDefaultSelected = NO;
    for (UIButton *btn in self.styleBtnArray) {
        NSUInteger index = btn.tag;
        NSString *remainCount = [self.remainCountArray objectAtIndex:index];
#pragma -mark 修改对应规格的库存量以及默认选中
        if (remainCount == nil || [@"null" isEqualToString:remainCount]) {
            remainCount = @"0";
        }
        
        if ([remainCount compare:@"1"] == NSOrderedAscending) {
            [btn setEnabled:false];
        } else {
            if (!isDefaultSelected) {
                //添加默认值
                UIButton *styleBtn;
                if (!(remainCount == nil || [@"null" isEqualToString:remainCount])) {
                    styleBtn = btn;
                }
                //UIButton *styleBtn = [self.styleBtnArray firstObject];

                styleBtn.layer.borderColor = Color_Orange_RGB.CGColor;
                UIButton* selectedBtn = [self.styleBtnArray objectAtIndex:index];
                self.waresDetail.selectedStyle = selectedBtn.titleLabel.text;
                [self.remainCountLabel setText:[self.remainCountArray objectAtIndex:index]];
                
                isDefaultSelected = YES;
            }
        }
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(styleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    // 如果规格没有默认值，就显示0
    if (!isDefaultSelected) {
        [self.remainCountLabel setText:@"0"];
    }
    
    [self.inventory setText:self.waresDetail.totalNumber];
    
    // 添加 商品标签
    if (self.waresDetail.label != nil && ![self.waresDetail.label isEqualToString:@""]) {
        NSArray *serviceStrings = [self.waresDetail.label componentsSeparatedByString:@"|"];
        [Common insertLabelForStrings:serviceStrings toView:self.serviceLabelView andViewHeight:30.0 andMaxWidth:(Screen_Width-156) andLabelHeight:18.0 andLabelMargin:6 andAddtionalWidth:6 andFont:[UIFont systemFontOfSize:12.0] andBorderColor:Color_Gray_RGB.CGColor andTextColor:COLOR_RGB(120, 120, 120)];
    }
    
    // 添加促销和新品图标
    [self addSaleAndPromotionIcon];
    
    // 支持优惠 标签添加
    if (self.waresDetail.supportCoupons != nil && ![self.waresDetail.supportCoupons isEqualToString:@""]) {
        //    NSArray *discountStrings = @[@"现金券", @"折扣券"];
        NSArray *strings = [self.waresDetail.supportCoupons componentsSeparatedByString:@","];
        NSMutableArray *discountStrings = [[NSMutableArray alloc] init];
        for (NSString *str in strings) {
            NSInteger val = [str integerValue];
            switch (val) {
                case 1:
                    [discountStrings addObject:Str_Coupon_Type_Cash];
                    break;
                case 2:
                    [discountStrings addObject:Str_Coupon_Type_Discount];
                    break;
                case 3:
                    [discountStrings addObject:Str_Coupon_Type_Full];
                    break;
                case 4:
                    [discountStrings addObject:Str_Coupon_Type_Gift];
                    break;
                case 5:
                    [discountStrings addObject:Str_Coupon_Type_Benifit];
                    break;
                default:
                    break;
            }
        }
        [Common insertLabelForStrings:discountStrings toView:self.discountLabelView andViewHeight:50.0 andMaxWidth:(Screen_Width-101) andLabelHeight:28.0 andLabelMargin:6.0 andAddtionalWidth:6.0 andFont:[UIFont systemFontOfSize:13.0] andBorderColor:COLOR_RGB(245, 164, 37).CGColor andTextColor:COLOR_RGB(245, 164, 37)];
    }

    // 支持配送 标签添加
    if (self.waresDetail.deliveryType != nil && ![self.waresDetail.deliveryType isEqualToString:@""]) {
        //    NSArray *deliverStrings = @[@"物业配送", @"普通快递"];
        NSArray *deliverStrings = [self.waresDetail.deliveryType componentsSeparatedByString:@","];
        NSMutableArray *delivers = [[NSMutableArray alloc] init];
        for (NSString *strDelivers in deliverStrings) {
            NSArray *deliverArray = [strDelivers componentsSeparatedByString:@"@ebei@"];
            if (deliverArray.count > 2) {
                [delivers addObject:[deliverArray objectAtIndex:1]];
            }
        }
        [Common insertLabelForStrings:delivers toView:self.deliverLabelView andViewHeight:50.0 andMaxWidth:(Screen_Width-101) andLabelHeight:28.0 andLabelMargin:6.0 andAddtionalWidth:6.0 andFont:[UIFont systemFontOfSize:13.0] andBorderColor:COLOR_RGB(245, 164, 37).CGColor andTextColor:COLOR_RGB(245, 164, 37)];
    }
    
    [self.table reloadData];
}


// 限时抢商品时 倒计时显示
- (void)displayCountDownTimer
{
    if (_waresDetail.limitStartTime == nil || [_waresDetail.limitStartTime isEqualToString:@""]
     || _waresDetail.limitEndTime == nil || [_waresDetail.limitEndTime isEqualToString:@""]) {
        return;
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *strNow = [formatter stringFromDate:now];
    [_timer invalidate];
    _timer =nil;
    NSDate *startTime = [formatter dateFromString:_waresDetail.limitStartTime];
    NSDate *endTime = [formatter dateFromString:_waresDetail.limitEndTime];
    if ([now compare:endTime] == NSOrderedDescending) {
        [self.limitBuyTimeLabel setText:@"已结束"];
    }else if ([now compare:startTime] == NSOrderedAscending) {
        if (_waresDetail.limitStartTime.length == 19) {
            NSString *strNowYear = [strNow substringToIndex:4];
            NSString *strStartYear = [_waresDetail.limitStartTime substringToIndex:4];
            NSInteger nowYear = [strNowYear integerValue];
            NSInteger startYear = [strStartYear integerValue];
            
            NSString *strNowMonth = [strNow substringWithRange:NSMakeRange(5, 2)];
            NSString *strStartMonth = [_waresDetail.limitStartTime substringWithRange:NSMakeRange(5, 2)];
            NSInteger nowMonth = [strNowMonth integerValue];
            NSInteger startMonth = [strStartMonth integerValue];
            
            NSString *strStartDay = [_waresDetail.limitStartTime substringWithRange:NSMakeRange(8, 2)];
            
            if (startYear > nowYear) {
                [self.limitBuyTimeLabel setText:[NSString stringWithFormat:@"%@年%@月开始", strStartYear, strStartMonth]];
            }else if (startMonth > nowMonth) {
                [self.limitBuyTimeLabel setText:[NSString stringWithFormat:@"%@月%@日开始", strStartMonth, strStartDay]];
            }else {
                NSTimeInterval timerInterval = [startTime timeIntervalSinceDate:now];
                NSInteger _diffDate = (NSInteger)timerInterval;
                NSInteger day = _diffDate / (60*60*24) ;
                NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
                NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
                NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
                [self.limitBuyTimeLabel setText:[NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒后开始", (long)day, (long)hour, (long)minute, (long)second]];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayCountDownTimer) userInfo:nil repeats:NO];
            }
        }
    }else{
        if (_waresDetail.limitEndTime.length == 19) {
            NSString *strNowYear = [strNow substringToIndex:4];
            NSString *strEndYear = [_waresDetail.limitEndTime substringToIndex:4];
            NSInteger nowYear = [strNowYear integerValue];
            NSInteger endYear = [strEndYear integerValue];
            
            NSString *strNowMonth = [strNow substringWithRange:NSMakeRange(5, 2)];
            NSString *strEndMonth = [_waresDetail.limitEndTime substringWithRange:NSMakeRange(5, 2)];
            NSInteger nowMonth = [strNowMonth integerValue];
            NSInteger endMonth = [strEndMonth integerValue];
            NSString *strEndDay = [_waresDetail.limitEndTime substringWithRange:NSMakeRange(8, 2)];
            
            if (endYear > nowYear) {
                [self.limitBuyTimeLabel setText:[NSString stringWithFormat:@"截止时间:%@年%@月", strEndYear, strEndMonth]];
            }else if (endMonth > nowMonth) {
                [self.limitBuyTimeLabel setText:[NSString stringWithFormat:@"截止时间:%@月%@日", strEndMonth, strEndDay]];
            }else {
                NSTimeInterval timerInterval = [endTime timeIntervalSinceDate:now];
                NSInteger _diffDate = (NSInteger)timerInterval;
                NSInteger day = _diffDate / (60*60*24) ;
                NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
                NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
                NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
                [self.limitBuyTimeLabel setText:[NSString stringWithFormat:@"剩余%ld天%ld时%ld分%ld秒", (long)day, (long)hour, (long)minute, (long)second]];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayCountDownTimer) userInfo:nil repeats:NO];
            }
        }
    }

}

//#pragma mark - 更新倒计时时间
//- (void)updateDispTime
//{
//    _diffDate--;
//    if (_diffDate > 0) {
//        NSInteger day = _diffDate / (60*60*24) ;
//        NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
//        NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
//        NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
//        if (day > 0) {
//            [self.limitBuyTimeLabel setText:[NSString stringWithFormat:@"剩余%ld天%ld时", (long)day, (long)hour]];
//        }else if (hour > 0) {
//            [self.limitBuyTimeLabel setText:[NSString stringWithFormat:@"剩余%ld时%ld分", (long)hour, (long)minute]];
//        }else if (minute > 0) {
//            [self.limitBuyTimeLabel setText:[NSString stringWithFormat:@"剩余%ld分%ld秒", (long)minute, (long)second]];
//        }else {
//            [self.limitBuyTimeLabel setText:[NSString stringWithFormat:@"剩余%ld秒", (long)second]];
//        }
//    }else {
//        [self.limitBuyTimeLabel setText:@"已结束"];
//        [_timer invalidate];
//        _timer = nil;
//    }
//}



// 规格型号按钮点击事件处理函数
- (void)styleBtnClick:(UIButton *)selectedBtn
{
    for (UIButton *btn in self.styleBtnArray) {
        if (btn == selectedBtn) {
            selectedBtn.layer.borderColor = Color_Orange_RGB.CGColor;
            self.waresDetail.selectedStyle = selectedBtn.titleLabel.text;
            
            // 设置新的库存
            NSUInteger index = selectedBtn.tag;
            [self.remainCountLabel setText:[self.remainCountArray objectAtIndex:index]];
        } else {
            btn.layer.borderColor = Color_Gray_RGB.CGColor;
        }
    }
}



// 添加 新 和 促 图标
- (void)addSaleAndPromotionIcon
{
    NSInteger isNew = [self.waresDetail.isNewGoods integerValue];
    NSInteger isSale = [self.waresDetail.salesGoods integerValue];
    
    if (isNew==1 && isSale==1) {
        UIImageView *saleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 5, 20, 20)];
        [saleImgView setImage:[UIImage imageNamed:@"PromotionIconImg"]];
        
        UIImageView *newImgView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 5, 20, 20)];
        [newImgView setImage:[UIImage imageNamed:@"NewIcon"]];
        
        [self.saleMarkLabelView addSubview:saleImgView];
        [self.saleMarkLabelView addSubview:newImgView];
        
    }
    else if (isNew==1){
        UIImageView *newImgView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 5, 20, 20)];
        [newImgView setImage:[UIImage imageNamed:@"NewIcon"]];
        [self.saleMarkLabelView addSubview:newImgView];
    }
    else if (isSale==1){
        UIImageView *saleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 5, 20, 20)];
        [saleImgView setImage:[UIImage imageNamed:@"PromotionIconImg"]];
        [self.saleMarkLabelView addSubview:saleImgView];
    }
    else{
        // nothing to do
    }
}

#pragma mark - TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    
    if (self.goodsCommentArray.count > 2) {
        num = 2;
    }else {
        num = self.goodsCommentArray.count;
    }
    
    return num;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaresDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLNIBNAME forIndexPath:indexPath];
    
    [cell loadCellData:[self.goodsCommentArray objectAtIndex:indexPath.row]];
    
    return cell;
}
#pragma mark - 商品图文详情
- (IBAction)goodsPicInfoBtnClickHandler:(id)sender
{
    WebViewController *vc = (WebViewController*)[[WebViewController alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@",Service_Address, self.waresDetail.goodsDescription];
    YjqLog(@"%@",self.waresDetail.goodsDescription);
    vc.navTitle = Str_Comm_PicDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 商品评价按钮点击事件
- (IBAction)goodsCommentBtnClickHandler:(id)sender
{
    if(self.goodsCommentArray.count==0){
        [Common showBottomToast:@"暂无评价"];
    }
    if (self.goodsCommentArray.count > 0) {
        GoodsCommentListViewController *vc = [[GoodsCommentListViewController alloc] init];
        vc.waresId = self.waresDetail.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 商家按钮点击事件处理函数
- (IBAction)storeBtnClickHandler:(id)sender
{
    GoodsForSaleViewController *vc = [[GoodsForSaleViewController alloc] init];
    vc.sellerName = _waresDetail.sellerName;
    vc.sellerId = _waresDetail.sellerId;
    vc.moduleType = _waresDetail.moduleType;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 电话号码按钮点击事件处理函数
- (IBAction)clickToDialUp:(id)sender
{
    if (_waresDetail == nil || [_waresDetail.sellerPhone isEqualToString:@""]) {
        return;
    }
    
    NSString *dialTel = [NSString stringWithFormat:@"tel://%@", _waresDetail.sellerPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialTel]];
}
#pragma mark - 购物车按钮点击事件处理函数
- (IBAction)cartBtnClickHandler:(id)sender
{
    if ([self isGoToLogin]) {
        ShoppingCartViewController *vc = [[ShoppingCartViewController alloc] init];
        vc.eFromType = E_CartViewFromType_Push;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 收藏按钮点击事件处理函数
- (IBAction)favoriteBtnClickHandler:(id)sender
{
    // 提交商品收藏到服务器
    if(![self isGoToLogin])
    {
        return;
    }
    
    LoginConfig *login = [LoginConfig Instance];
    NSString *userId = [login userID];
    if (userId!=nil) {
        [self uploadGoodsFavoriteStatusToServer:userId];
    }else {
        [Common showBottomToast:@"该用户不存在"];
    }
}

// 收藏商品上传
- (void)uploadGoodsFavoriteStatusToServer:(NSString *)userId
{
    if(!self.waresDetail || !_goodsFav){
        [Common showBottomToast:Str_Comm_RequestTimeout];
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[userId, self.waresDetail.goodsId, [_goodsFav isEqualToString:@"0"]?@"1":@"2"] forKeys:@[@"userId", @"goodsId", @"type"]];
    
    [self getStringFromServer:GoodsFavorite_Url path:GoodsFavorite_Path method:@"GET" parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"1"]) {
            if([_goodsFav isEqualToString:@"0"])
                [Common showBottomToast:@"收藏成功"];
            else
                [Common showBottomToast:@"取消收藏成功"];
            _goodsFav =  [_goodsFav isEqualToString:@"0"]?@"1":@"0";
            [self displayFavIcon];
        }else{
            [Common showBottomToast:@"收藏失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

- (BOOL)checkData {
    if (![Common checkNetworkStatus]) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        return NO;
    }
    if (![self.waresDetail.isPutGoods isEqualToString:@"1"]) {
        [Common showBottomToast:@"商品已下架, 不能加入购物车"];
        return NO;
    }
    if ([self.limitBuyTimeLabel.text isEqualToString:@"已结束"]) {
        [Common showBottomToast:@"商品已过期, 不能加入购物车"];
        return NO;
    }
    if ([self.limitBuyTimeLabel.text rangeOfString:@"开始"].length > 0) {
        [Common showBottomToast:@"商品未开始售卖, 不能加入购物车"];
        return NO;
    }
    if ([self.remainCountLabel.text integerValue] < 1) {
        [Common showBottomToast:@"库存不足"];
        return NO;
    }
    return YES;
}


#pragma mark - 加入购物车按钮点击事件处理函数
- (IBAction)addIntoCartBtnClickHandler:(id)sender
{
    if ([self isGoToLogin]) {
        if (![self checkData]) {
            return;
        }
        
        // 向购物车中插入数据
        if(self.waresDetail.selectedStyle==nil)
        {
            self.waresDetail.selectedStyle = @"";
        }
        [[DBOperation Instance] insertWaresData:self.waresDetail];
        [self updateCartInfoToServerSuccess:^(NSString *result) {
            YjqLog(@"result====%@",result);
            // 更新购物车商品数
            [self updateGoodsCountInCart];
            [[NSNotificationCenter defaultCenter] postNotificationName:ShoppingCartChangedNotification object:nil];
#pragma mark-想购物车里面添加商品的时候，库存量要减少
            self.remainCountLabel.text=[NSString stringWithFormat:@"%ld",[self.remainCountLabel.text integerValue]-1];
            [Common showBottomToast:@"已添加到购物车"];
        } failure:^(NSError *error) {
        }];
    }
}
#pragma mark - 立即购买按钮点击事件处理函数
- (IBAction)buyNowBtnClickHandler:(id)sender
{
    if (![self checkData]) {
        return;
    }
    
#pragma -mark 立即购买页添加判断(是特价且非首次购买)
    
    NSLog(@"_waresDetail.specialOfferBuy==%@",_waresDetail.specialOfferBuy);
    if ([_waresDetail isSpecialOfferNoRight]) {
        NSString*str=[NSString stringWithFormat:@"每个用户限购1件特惠商品，超出部分按照%@元进行计算，请仔细核对。",_waresDetail.goodsPrice];
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    else
    {
        WaresOrderSubmitViewController* vc = [[WaresOrderSubmitViewController alloc]init];
        vc .waresDetail = _waresDetail;
        vc.paymentTypes = self.supportPaymentType;
        vc.remainCount = self.remainCountLabel.text;
        [self.navigationController pushViewController:vc animated:TRUE];
    }
}

//提示框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //🍎
    if (buttonIndex == 0)
    {
        return;
    }
    else
    {
        WaresOrderSubmitViewController* vc = [[WaresOrderSubmitViewController alloc]init];
        vc .waresDetail = _waresDetail;
        vc.paymentTypes = self.supportPaymentType;
        vc.remainCount = self.remainCountLabel.text;
        [self.navigationController pushViewController:vc animated:TRUE];
    }
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---导航栏右边按钮事件－分享12-08暂时屏蔽
//-(void)navBarRightItemClick
//{
//    if ((_waresDetail.goodsDescription == nil) || [_waresDetail.goodsDescription isEqualToString:@""]) {
//        return;
//    }
//    NSArray *shareList = [ShareSDK customShareListWithType:
//                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
//                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
//                          nil];
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@",Service_Address, _waresDetail.goodsDescription];
//    
//    id<ISSCAttachment> shareImage = nil;
//    SSPublishContentMediaType shareType = SSPublishContentMediaTypeText;
// 
//    shareType = SSPublishContentMediaTypeNews;
//    
//    id<ISSContent> publishContent=[ShareSDK content:@"我在亿街区发现了一个“亿”想不到的商品，赶快来看看吧" defaultContent:@"商品分享" image:nil title:_waresDetail.goodsName url:url description:nil mediaType:shareType];
//    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
//    NSArray* picArray = [_waresDetail.goodsUrl componentsSeparatedByString:@","];
//    NSString* picUrl ;
//    if (picArray.count>0) {
//        NSString* pic =  [picArray objectAtIndex:0];
//        if([pic isEqualToString:@""]==FALSE)
//            picUrl = [Common setCorrectURL:pic];
//    }
//    //定制微信好友信息
//    if(picUrl==nil )
//    {
//        [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
//                                             content:INHERIT_VALUE
//                                               title:INHERIT_VALUE
//                                                 url:INHERIT_VALUE
//                                          thumbImage:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"WaresDetailDefaultImg"]]
//                                               image:INHERIT_VALUE
//                                        musicFileUrl:nil
//                                             extInfo:nil
//                                            fileData:nil
//                                        emoticonData:nil];
//    }
//    else
//    {
//      [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
//                                           content:INHERIT_VALUE
//                                             title:INHERIT_VALUE
//                                               url:INHERIT_VALUE
//                                        thumbImage:[ShareSDK imageWithUrl:picUrl]
//                                             image:INHERIT_VALUE
//                                      musicFileUrl:nil
//                                           extInfo:nil
//                                          fileData:nil
//                                      emoticonData:nil];
//    }
//    
//    if(picUrl==nil)
//    {
//        [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
//                                             content:INHERIT_VALUE
//                                               title:INHERIT_VALUE
//                                                 url:INHERIT_VALUE
//                                          thumbImage:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"WaresDetailDefaultImg"]]
//                                               image:INHERIT_VALUE
//                                        musicFileUrl:nil
//                                             extInfo:nil
//                                            fileData:nil
//                                        emoticonData:nil];
//    }
//    else
//    {
//        [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
//                                             content:INHERIT_VALUE
//                                               title:INHERIT_VALUE
//                                                 url:INHERIT_VALUE
//                                          thumbImage:[ShareSDK imageWithUrl:picUrl]
//                                               image:INHERIT_VALUE
//                                        musicFileUrl:nil
//                                             extInfo:nil
//                                            fileData:nil
//                                        emoticonData:nil];
//    }
//
//  
//    
////    // 定制QQ
////    [publishContent addQQUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeNews]
////                              content:INHERIT_VALUE
////                                title:INHERIT_VALUE
////                                  url:INHERIT_VALUE
////                                image:INHERIT_VALUE];
//    
//  //  [publishContent addSMSUnitWithContent:INHERIT_VALUE subject:INHERIT_VALUE attachments:INHERIT_VALUE to:INHERIT_VALUE];
//    
//    //结束定制信息
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
//    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:NO
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:[Common appDelegate]];
//    
//    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
//    
//    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
//                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                               qqButtonHidden:YES
//                                                        wxSessionButtonHidden:YES
//                                                       wxTimelineButtonHidden:YES
//                                                         showKeyboardOnAppear:NO
//                                                            shareViewDelegate:[Common appDelegate]
//                                                          friendsViewDelegate:[Common appDelegate]
//                                                        picViewerViewDelegate:nil];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:authOptions
//                      shareOptions:shareOptions
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                }
//                            }];
//
//}

     
- (NSMutableArray *)supportPaymentType
{
    if (!_supportPaymentType) {
        _supportPaymentType = [[NSMutableArray alloc] init];
    }
    return _supportPaymentType;
}

#pragma mark - KDCycleBannerViewDataSource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView {
    
    return self.adImageArray;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleToFill;
}

- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageNamed:@"AdSlideDefaultImg"];
}

- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index {
    return [UIImage imageNamed:@"AdSlideDefaultImg"];
}

#pragma mark - KDCycleBannerViewDelegate
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
    [self waresImgBtnClickHandler:nil];
}
     
@end

//
//  GrouponDetailViewController.m
//  CommunityApp
//
//  Created by issuser on 15/7/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponDetailViewController.h"
#import "GrouponOrderSubmitViewController.h"
#import "GrouponShopListViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AGImagePickerViewController.h"
#import "GroupBuyDetail.h"
#import "WebViewController.h"

@interface GrouponDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *labelView;
// ImageView
@property (weak, nonatomic) IBOutlet UIImageView *grouponPicImageView;

// Button
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;
@property (weak, nonatomic) IBOutlet UIView *allView;

// Label
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsActualPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupBuyDetailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsPicViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *groupBuyDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopAddrLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeight;
@property (weak, nonatomic) IBOutlet UIImageView *hLine1;
@property (weak, nonatomic) IBOutlet UIImageView *hLine2;
@property (weak, nonatomic) IBOutlet UIImageView *hLine3;
@property (weak, nonatomic) IBOutlet UIImageView *hLine4;
@property (weak, nonatomic) IBOutlet UIImageView *hLine5;
@property (weak, nonatomic) IBOutlet UIImageView *hLine6;
@property (weak, nonatomic) IBOutlet UIImageView *hLine7;
@property (weak, nonatomic) IBOutlet UIImageView *hLine8;
@property (weak, nonatomic) IBOutlet UIImageView *hLine9;
@property (weak, nonatomic) IBOutlet UIImageView *hLine10;
@property (weak, nonatomic) IBOutlet UIImageView *hLine11;

@property (weak, nonatomic) IBOutlet UILabel *countDownTimeLabel;
@property (nonatomic, assign) NSInteger     allSeconds;
@property (nonatomic, retain) NSTimer       *timer;
@property (weak, nonatomic) IBOutlet UILabel *shopTelLabel;

// Constraint
@property (strong,nonatomic) IBOutlet NSLayoutConstraint* grouponPicHeight;
@property (nonatomic, copy) NSString *shopTel;
@property (copy, nonatomic) NSString *favType;

@property (retain, nonatomic) GroupBuyDetail  *groupBuyDetail;

@end

@implementation GrouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Groupon_Detail_Title;
    [self setNavBarItemRightViewForNorImg:@"ShareBtnNor" andPreImg:@"ShareBtnPre"];
    
    [self.allView setHidden:YES];

    [self initBasicData];
    
    self.grouponPicHeight.constant = Screen_Width * 2.0 / 5.0;
}

- (void)initUIViewStyle {
    [self fitUIImageView];
    
    _buyNowBtn.layer.masksToBounds = YES;
    _buyNowBtn.layer.cornerRadius = 5;
    
    [Common updateLayout:_hLine1 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine2 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine3 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine4 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine5 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine6 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine7 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine8 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine9 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine10 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine11 where:NSLayoutAttributeHeight constant:0.5];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [_timer invalidate];
    _timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initBasicData {
    [self getGoodsFavInfoFromServer];
    [self getGrouponDetailFromServer];
}

- (void)fitUIImageView {
    if (self.groupBuyDetail == nil || self.groupBuyDetail.goodsUrl == nil || self.groupBuyDetail.goodsUrl.length <= 0) {
        return;
    }
    NSArray* imgsArray =  [self.groupBuyDetail.goodsUrl componentsSeparatedByString:@","];
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:self.groupBuyDetail.goodsUrl]];
    if (imgsArray.count > 0) {
        iconUrl = [NSURL URLWithString:[Common setCorrectURL:[imgsArray objectAtIndex:0]]];
    }
    
//    NSData *data = [NSData dataWithContentsOfURL:iconUrl];
//    UIImage *grouponImg = [UIImage imageWithData:data];
//    
//    if (iconUrl == nil) {
//        self.grouponPicHeight.constant = 170;
//    }
//    
//    UIImage *scaledImg = [Common imageCompressForWidth:grouponImg targetWidth:Screen_Width];
//
//    self.grouponPicHeight.constant = scaledImg.size.height;
    [_grouponPicImageView setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    self.viewHeight.constant = self.viewHeight.constant + (self.grouponPicHeight.constant - 170) + 20;
}

- (void)loadViewDate {
    NSArray* imgsArray =  [self.groupBuyDetail.goodsUrl componentsSeparatedByString:@","];
    if (imgsArray.count > 0) {
        NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:[imgsArray objectAtIndex:0]]];
        [_grouponPicImageView setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    }

    [_goodsNameLabel setText:self.groupBuyDetail.goodsName];
    [_goodsLabel setText:self.groupBuyDetail.label];
    
    [self displayCountDownTimer];
    
    [self updateFavState];
    
    NSString *supportStrings = @"";
    if ([self.groupBuyDetail.supportBack isEqualToString:@"1"]) {
        supportStrings = @"支持随时退  ";
    }else if ([self.groupBuyDetail.supportBack isEqualToString:@"2"]) {
        supportStrings = @"支持过期退  ";
    }else if ([self.groupBuyDetail.supportBack isEqualToString:@"3"]) {
        supportStrings = @"支持随时退  支持过期退  ";
    }
    if ([self.groupBuyDetail.needAppointment isEqualToString:@"0"]) {
        supportStrings = [supportStrings stringByAppendingString:@"免预约"];
    }else if ([self.groupBuyDetail.needAppointment isEqualToString:@"1"]) {
        supportStrings = [supportStrings stringByAppendingString:@"支持预约"];
    }
    [self.supportBackLabel setText:supportStrings];
    
    NSArray *shopInfo = [self.groupBuyDetail.shopName componentsSeparatedByString:@","];
    if (shopInfo.count >= 1) {
        [self.shopNameLabel setText:[shopInfo objectAtIndex:0]];
    }
    if (shopInfo.count >= 2) {
        [self.shopAddrLabel setText:[shopInfo objectAtIndex:1]];
    }
    if (shopInfo.count >= 3) {
        self.shopTel = [shopInfo objectAtIndex:2];
        [self.shopTelLabel setText:self.shopTel];
    }
    
    [_groupBuyDescLabel setText:self.groupBuyDetail.goodsDescription];
    [_groupBuyDetailLabel setText:self.groupBuyDetail.groupBuyDetail];
    
    CGFloat height = [Common labelDemandHeightWithText:self.groupBuyDetail.goodsDescription font:[UIFont systemFontOfSize:15.0] size:CGSizeMake(Screen_Width-30, CGFLOAT_MAX)];
    if (height > 20) {
        self.descViewHeight.constant += height - 20;
    }
    self.viewHeight.constant += height - 20;
    
    height = [Common labelDemandHeightWithText:self.groupBuyDetail.groupBuyDetail font:[UIFont systemFontOfSize:15.0] size:CGSizeMake(Screen_Width-30, CGFLOAT_MAX)];
    if (height > 20) {
        self.detailViewHeight.constant += height - 20 + 10;
        self.detailLabelHeight.constant = height + 10;
    }
    self.viewHeight.constant += height - 20 + 10;
    
    [_goodsActualPriceLabel setText:[NSString stringWithFormat:@"￥%@",self.groupBuyDetail.goodsActualPrice]];

    // 定义标签数组
    NSArray *strings = @[@"折扣券", @"现金券", @"满减券"];
    [Common insertLabelForStrings:strings toView:self.labelView andViewHeight:23.0 andMaxWidth:(Screen_Width-30) andLabelHeight:20 andLabelMargin:8 andAddtionalWidth:3 andFont:[UIFont systemFontOfSize:13.0] andBorderColor:Color_Coupon_Label_Border.CGColor andTextColor:Color_Coupon_Label_Border];
}


- (void)displayCountDownTimer {
    if (self.groupBuyDetail == nil || self.groupBuyDetail.groupBuyStartTime == nil || [self.groupBuyDetail.groupBuyStartTime isEqualToString:@""] || self.groupBuyDetail.groupBuyEndTime == nil || [self.groupBuyDetail.groupBuyEndTime  isEqualToString:@""]) {
        return;
    }
    
    [self countGroupBuyTime];
    
//    NSString *dateString = self.groupBuyDetail.groupBuyEndTime ;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:dateString];
    
//    date.dateFormatter.HH;
//    date.dateFormatter.HH;
//    
//    [_timer invalidate];
//    _timer = nil;
//    if (afterTimes.count == 4) {
//        NSString *strDays = [afterTimes objectAtIndex:0];
//        NSString *strHours = [afterTimes objectAtIndex:1];
//        NSString *strMinutes = [afterTimes objectAtIndex:2];
//        NSString *strSeconds = [afterTimes objectAtIndex:3];
//        [self.countDownTimeLabel setText:[NSString stringWithFormat:@"还剩%@天%@小时%@分%@秒", strDays, strHours, strMinutes, strSeconds]];
//        
//        NSInteger days = [strDays integerValue];
//        NSInteger hours = [strHours integerValue];
//        NSInteger minutes = [strMinutes integerValue];
//        NSInteger seconds = [strSeconds integerValue];
//        _allSeconds = 24*60*60*days + 60*60*hours + 60*minutes + seconds;
//        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDispTime) userInfo:nil repeats:YES];
}


- (void)countGroupBuyTime
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *strNow = [formatter stringFromDate:now];
    NSDate *startTime = [formatter dateFromString:_groupBuyDetail.groupBuyStartTime];
    NSDate *endTime = [formatter dateFromString:_groupBuyDetail.groupBuyEndTime];
    if ([now compare:endTime] == NSOrderedDescending) {
        [self.countDownTimeLabel setText:@"该团购已结束"];
        [self.buyNowBtn setHidden:YES];
    }else if ([now compare:startTime] == NSOrderedAscending) {
        [self.buyNowBtn setHidden:YES];
        if (_groupBuyDetail.groupBuyStartTime.length == 19) {
            NSString *strNowYear = [strNow substringToIndex:4];
            NSString *strStartYear = [_groupBuyDetail.groupBuyStartTime substringToIndex:4];
            NSInteger nowYear = [strNowYear integerValue];
            NSInteger startYear = [strStartYear integerValue];
            
            NSString *strNowMonth = [strNow substringWithRange:NSMakeRange(5, 2)];
            NSString *strStartMonth = [_groupBuyDetail.groupBuyStartTime substringWithRange:NSMakeRange(5, 2)];
            NSInteger nowMonth = [strNowMonth integerValue];
            NSInteger startMonth = [strStartMonth integerValue];
            
            NSString *strStartDay = [_groupBuyDetail.groupBuyStartTime substringWithRange:NSMakeRange(8, 2)];
            
            if (startYear > nowYear) {
                [self.countDownTimeLabel setText:[NSString stringWithFormat:@"%@年%@月开始", strStartYear, strStartMonth]];
            }else if (startMonth > nowMonth) {
                [self.countDownTimeLabel setText:[NSString stringWithFormat:@"%@月%@日开始", strStartMonth, strStartDay]];
            }else {
                NSTimeInterval timerInterval = [startTime timeIntervalSinceDate:now];
                NSInteger _diffDate = (NSInteger)timerInterval;
                NSInteger day = _diffDate / (60*60*24) ;
                NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
                NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
                NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
                [self.countDownTimeLabel setText:[NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒后开始", (long)day, (long)hour, (long)minute, (long)second]];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countGroupBuyTime) userInfo:nil repeats:NO];
            }
        }
    }else{
        [self.buyNowBtn setHidden:NO];
        if (_groupBuyDetail.groupBuyEndTime.length == 19) {
            NSString *strNowYear = [strNow substringToIndex:4];
            NSString *strEndYear = [_groupBuyDetail.groupBuyEndTime substringToIndex:4];
            NSInteger nowYear = [strNowYear integerValue];
            NSInteger endYear = [strEndYear integerValue];
            
            NSString *strNowMonth = [strNow substringWithRange:NSMakeRange(5, 2)];
            NSString *strEndMonth = [_groupBuyDetail.groupBuyEndTime substringWithRange:NSMakeRange(5, 2)];
            NSInteger nowMonth = [strNowMonth integerValue];
            NSInteger endMonth = [strEndMonth integerValue];
            NSString *strEndDay = [_groupBuyDetail.groupBuyEndTime substringWithRange:NSMakeRange(8, 2)];
            
            if (endYear > nowYear) {
                [self.countDownTimeLabel setText:[NSString stringWithFormat:@"截止时间:%@年%@月", strEndYear, strEndMonth]];
            }else if (endMonth > nowMonth) {
                [self.countDownTimeLabel setText:[NSString stringWithFormat:@"截止时间:%@月%@日", strEndMonth, strEndDay]];
            }else {
                NSTimeInterval timerInterval = [endTime timeIntervalSinceDate:now];
                NSInteger _diffDate = (NSInteger)timerInterval;
                NSInteger day = _diffDate / (60*60*24) ;
                NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
                NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
                NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
                [self.countDownTimeLabel setText:[NSString stringWithFormat:@"剩余%ld天%ld时%ld分%ld秒", (long)day, (long)hour, (long)minute, (long)second]];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countGroupBuyTime) userInfo:nil repeats:NO];
            }
        }
    }

}




// 更新倒计时时间
- (void)updateDispTime {
//    NSLog(@"%ld", (long)_allSeconds);
    _allSeconds--;
    if (_allSeconds > 0) {
        NSInteger days = _allSeconds / (24*60*60);
        NSInteger hours = (_allSeconds - days*24*60*60) / (60*60);
        NSInteger minutes = (_allSeconds - days*24*60*60 - hours*60*60) / 60;
        NSInteger seconds = _allSeconds - days*24*60*60 - hours*60*60 - minutes*60;
        [self.countDownTimeLabel setText:[NSString stringWithFormat:@"还剩%ld天%ld小时%ld分%ld秒", (long)days, (long)hours, (long)minutes, (long)seconds]];
    }else {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 适用商家按钮点击事件处理函数
- (IBAction)grouponShopBtnClickHandler:(id)sender {
    GrouponShopListViewController *vc = [[GrouponShopListViewController alloc] init];
    vc.goodsId = _grouponId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--- IBAction
-(IBAction)clickBuy:(id)sender {
    GrouponOrderSubmitViewController *vc = [[GrouponOrderSubmitViewController alloc]init];
    vc.gpOrder = [self createGrouponOrder:self.grouponId];
    vc.groupBuyListVC = self.groupBuyListVC;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 团购名称点击事件处理函数-->图文详情
- (IBAction)goodsNameBtnClickHandler:(id)sender {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@",Service_Address, self.groupBuyDetail.details];
    vc.navTitle = Str_Comm_PicDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

- (GrouponOrder *)createGrouponOrder:(NSString *) grouponId {
    GrouponOrder *gpOrder = [[GrouponOrder alloc]init];
    LoginConfig *login = [LoginConfig Instance];
    
    gpOrder.goodsName = self.groupBuyDetail.goodsName;  //团购名称
    gpOrder.creator = login.userName;   //下单人姓名
    gpOrder.linkName = login.userName;  //联系人
    gpOrder.linkTel = [login getOwnerPhone];  //联系电话
    gpOrder.goodsIds = self.grouponId;  //（商品Id：团购单价：团购数量）
    gpOrder.ownerid = [login userID];   //下单人ID
    gpOrder.sellerId = self.groupBuyDetail.sellerId;             //商家ID
    gpOrder.totalMoney = self.groupBuyDetail.goodsActualPrice;  //团购金额
    gpOrder.groupBuyEndTime = self.groupBuyDetail.groupBuyEndTime;  //团购结束时间
    return gpOrder;
}

- (void)updateFavState {
    if ([self.favType isEqualToString:@"0"]) {
        _favoriteBtn.selected = NO;
    }
    else if ([self.favType isEqualToString:@"1"])
    {
        _favoriteBtn.selected = YES;
    }
}

- (IBAction)favoriteBtnClickHandler:(id)sender
{
    LoginConfig *login = [LoginConfig Instance];
    if ([self isGoToLogin]) {
        NSString *userId = [login userID];
        [self uploadGoodsFavoriteStatusToServer:userId];
    }
}

-(IBAction)clickImageDetail:(id)sender
{
    NSArray* imgsArray =  [self.groupBuyDetail.goodsUrl componentsSeparatedByString:@","];
    if(imgsArray == nil || imgsArray.count == 0)
    {
        return;
    }
    AGImagePickerViewController* vc = [[AGImagePickerViewController alloc]init];
    vc.imgUrlArray = imgsArray;
    [self.navigationController pushViewController:vc animated:TRUE];
}

#pragma mark - 终端“团购详情”接口
- (void)getGrouponDetailFromServer {

//    NSString *goodsId = @"";
//    if (self.groupon !=nil && ![self.groupon.goodsId isEqualToString:@""]) {
//        goodsId = self.groupon.goodsId;
//    }else if (![self.grouponGoodsId isEqualToString:@""]) {
//        goodsId = self.grouponGoodsId;
//    }else {
//        return;
//    }
//
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[goodsId] forKeys:@[@"goodsId"]];
 
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.grouponId] forKeys:@[@"goodsId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:GroupBuyDetail_Url path:GroupBuyDetail_Path method:@"GET" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
        for (NSDictionary *dic in result) {
            self.groupBuyDetail = [[GroupBuyDetail alloc] initWithDictionary:dic];
        }
        [self initUIViewStyle];
        [self loadViewDate];
        [self.allView setHidden:NO];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark - 从服务器获取收藏
-(void)getGoodsFavInfoFromServer {
    NSString* userId = [[LoginConfig Instance] userID];
    if(userId == nil || [userId isEqualToString:@""])
    {
        self.favType = @"0";
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.grouponId, userId] forKeys:@[@"goodsId", @"userId"]];
    
    // 请求服务器获取数据
    [self getStringFromServer:GoodsFavorite_Url path:GetGoodsFavoriteInfo_Path method:@"GET" parameters:dic success:^(NSString *result) {
        self.favType = result;
        [self updateFavState];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark - 上传/下载 收藏接口
- (void)uploadGoodsFavoriteStatusToServer:(NSString *)userId {
    NSString *curFavType = @"1";
    if ([self.favType isEqualToString:@"0"])
    {
        curFavType = @"1";
    }
    else if ([self.favType isEqualToString:@"1"])
    {
        curFavType = @"2";
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[userId, self.grouponId, curFavType] forKeys:@[@"userId", @"goodsId", @"type"]];
    
    [self getStringFromServer:GoodsFavorite_Url path:GoodsFavorite_Path method:@"GET" parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"1"]) {
            if ([curFavType isEqualToString:@"1"]) {
                self.favType = @"1";
                [Common showBottomToast:@"收藏成功"];
            }
            else if ([curFavType isEqualToString:@"2"])
            {
                self.favType = @"0";
                [Common showBottomToast:@"取消收藏成功"];
            }
            [self updateFavState];
        }else{
            [Common showBottomToast:@"操作失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark - 导航栏右边按钮事件
-(void)navBarRightItemClick {
//    NSArray *shareList = [ShareSDK customShareListWithType:
//                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
//                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
//                          nil];
//    id<ISSCAttachment> shareImage = nil;
//    SSPublishContentMediaType shareType = SSPublishContentMediaTypeText;
// 
//    NSString *url = [NSString stringWithFormat:@"%@%@",Service_Address, _groupBuyDetail.goodsDescription];
//
//    shareType = SSPublishContentMediaTypeNews;
//    
//    id<ISSContent> publishContent=[ShareSDK content:@"我在亿街区发现了一个“亿”想不到的商品，赶快来看看吧" defaultContent:@"商品分享" image:nil title:_groupBuyDetail.goodsName url:url description:nil mediaType:shareType];
//    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
//    NSArray* picArray = [_groupBuyDetail.goodsUrl componentsSeparatedByString:@","];
//    NSString* picUrl ;
//    if (picArray.count>0) {
//        NSString* pic =  [picArray objectAtIndex:0];
//        if([pic isEqualToString:@""]==FALSE)
//        picUrl = [Common setCorrectURL:pic];
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
//        [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
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
//    if(picUrl==nil)
//    {
//        [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
//                                              content:INHERIT_VALUE
//                                                title:INHERIT_VALUE
//                                                  url:INHERIT_VALUE
//                                           thumbImage:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"WaresDetailDefaultImg"]]
//                                                image:INHERIT_VALUE
//                                         musicFileUrl:nil
//                                              extInfo:nil
//                                             fileData:nil
//                                         emoticonData:nil];
//    }
//    else
//    {
//        [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
//                                              content:INHERIT_VALUE
//                                                title:INHERIT_VALUE
//                                                  url:INHERIT_VALUE
//                                           thumbImage:[ShareSDK imageWithUrl:picUrl]
//                                                image:INHERIT_VALUE
//                                         musicFileUrl:nil
//                                              extInfo:nil
//                                             fileData:nil
//                                         emoticonData:nil];
//    }
//
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
    
}

// 拨打商家电话按钮点击事件处理函数
- (IBAction)shopTelBtnClickHandler:(id)sender {
    NSString *dialTel = [NSString stringWithFormat:@"tel://%@", self.shopTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialTel]];
}
@end

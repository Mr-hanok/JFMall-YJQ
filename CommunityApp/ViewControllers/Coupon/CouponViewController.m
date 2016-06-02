//
//  CouponViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponTableViewCell.h"
#import "CouponVerifyViewController.h"
#import "UIImageView+AFNetworking.h"
#import "BarCodeScanViewController.h"
#import "Coupon.h"
#import "MJRefresh.h"
#import "CouponSupportInfo.h"

#define CouponTableViewCellNibName @"CouponTableViewCell"

#define PageSize    (10)

typedef enum{
    CashCoupon = 1, // 1.现金券,
    DiscountCoupon, // 2:折扣券,
    FullCoupon,     // 3:满减券,
    GiftCoupon,     // 4:买赠券
    BenifitCoupon   // 5:福利券
}CouponType;

@interface CouponViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIScrollViewDelegate>
// View
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIView *popUpBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *couponLogo;
@property (strong, nonatomic) IBOutlet UILabel *markLabel;

// NSLayoutConstraint
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *markLabelConstraint;


// Button
@property (weak, nonatomic) IBOutlet UIButton *stateUseful; //待使用
@property (weak, nonatomic) IBOutlet UIButton *stateUsed;   //已使用
@property (weak, nonatomic) IBOutlet UIButton *stateExpired;//已过期

// popupView
@property (weak, nonatomic) IBOutlet UIImageView *popUpViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *popUpViewSellerName;
@property (weak, nonatomic) IBOutlet UILabel *popUpViewTicketsTypeName;
@property (weak, nonatomic) IBOutlet UILabel *popUpViewEndDate;
@property (weak, nonatomic) IBOutlet UILabel *popUpViewTicketAmount;

@property (nonatomic, copy) NSString     *couponUseState;     //优惠券状态类型1.未使用，2.已使用，3.已过期
@property (assign, nonatomic) NSInteger pageNum;
@property (nonatomic, retain) NSMutableArray    *couponDataArray;
@property (nonatomic, copy) NSString     *couponCode;
@property (nonatomic,retain) Coupon* checkCouponData;

@property (nonatomic, retain) CouponSupportInfo *couponSupportInfo;


@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];    
    self.navigationItem.title = Str_My_Coupon_Title;
     [self setNavBarRightItemTitle:@"添加" andNorBgImgName:nil andPreBgImgName:nil];
    
    self.couponDataArray = [[NSMutableArray alloc] init];
    
    // 注册cell
    UINib *nibForCouponViewService = [UINib nibWithNibName:CouponTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForCouponViewService forCellReuseIdentifier:CouponTableViewCellNibName];

    NSURL *url = nil;
    [_couponLogo setImageWithURL:url placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    
    [self initUIViewStyle];
    [self initPopUpViewStyle];
    
    // 添加下拉/上滑刷新更多
    self.pageNum = 1;
    
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getCouponDataFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.couponDataArray.count == self.pageNum*PageSize) {
            self.pageNum++;
            [self getCouponDataFromServer];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
    self.tableView.footer = footer;
    self.tableView.delegate = self;
    [self.tableView reloadData];//刷新数据
    self.hidesBottomBarWhenPushed = NO;
    
    //添加点击重置弹框手势
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenPopupView)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

    self.pageNum = 1;
    // 从服务器获取优惠券数据
    [self getCouponDataFromServer];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

#pragma mark - 重写导航栏右侧按钮点击事件处理函数
- (void)navBarRightItemClick {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"扫描二维码", @"输入验证码", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        BarCodeScanViewController* vc = [[BarCodeScanViewController alloc]init];
        [vc setScanCode:^(NSString *code) {
            _couponCode = code;
            [self checkCoupon];
        }
        ];
        [self.navigationController pushViewController:vc animated:TRUE];
    }
    else if (buttonIndex == 1) {
        CouponVerifyViewController *vc = [[CouponVerifyViewController alloc]init];
        [vc setCouponCode:^(NSString *code) {
            _couponCode = code;
            [self checkCoupon];
        }
        ];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)checkCoupon {
    char lastChar = [_couponCode characterAtIndex:_couponCode.length-1];
    if (lastChar == '#') {
        [self getNewCouponVerifyDataFromServer:_couponCode];
    }
    else {
        [self getCouponVerifyDataFromServer:_couponCode];
    }
    
    
}

- (void)hiddenPopupView {
    _popUpView.hidden = YES;
}

- (void)initUIViewStyle {
    [Common setRoundBorder:_headerView borderWidth:0.5 cornerRadius:5 borderColor:Color_Coupon_Border];

    [Common setRoundBorder:_popUpBgView borderWidth:0.5 cornerRadius:5 borderColor:Color_Coupon_Border];
    
    [Common setRoundBorder:_couponLogo borderWidth:2 cornerRadius:(_couponLogo.layer.frame.size.height / 2.0) borderColor:Color_White_RGB];
    
    self.couponUseState = @"1";
    _stateUseful.selected = YES;
    [self setUIBtnClickState];
}

- (void)initPopUpViewStyle {
    _popUpViewIcon.layer.cornerRadius = 5;
    _popUpViewIcon.layer.borderWidth = _popUpViewIcon.frame.size.height / 2.0;
    _popUpViewIcon.layer.masksToBounds = YES;
    _popUpViewIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSString *ticketsType = @"";
    switch (_checkCouponData.ticketstype.intValue) {
        case CashCoupon:
            ticketsType = Str_Coupon_Type_Cash;
            break;
        case DiscountCoupon:
            ticketsType = Str_Coupon_Type_Discount;
            break;
        case FullCoupon:
            ticketsType = Str_Coupon_Type_Full;
            break;
        case GiftCoupon:
            ticketsType = Str_Coupon_Type_Gift;
            break;
        case BenifitCoupon:
            ticketsType = Str_Coupon_Type_Benifit;
            break;
        default:
            break;
    }
    [_popUpViewTicketsTypeName setText:ticketsType];
    [_popUpViewEndDate setText:[NSString stringWithFormat:@"有效期至：%@",[_checkCouponData.endDate substringToIndex:10]]];
    [_popUpViewTicketAmount setText:[NSString stringWithFormat:@"优惠金额：￥%@",_checkCouponData.preferentialPrice]];
}

#pragma mark - 检测滚动方向
//- (void)scrollViewWillEndDragging:
- (void)scrollViewWillEndDragging:(UIScrollView *)tableView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if(velocity.y < 0) {
        [self setMarkLabelAppear:YES];
    }
    else {
        [self setMarkLabelAppear:NO];
    }
}

#pragma mark - 设置markLabel隐藏
- (void)setMarkLabelAppear:(BOOL)isAppear {
    NSInteger height = 0;
    if (isAppear) {
        height = 20;
    }
    self.markLabelConstraint.constant = height;
    self.markLabel.hidden = !isAppear;
    
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CouponTableViewCellNibName forIndexPath:indexPath];
    [cell loadCellData:[self.couponDataArray objectAtIndex:indexPath.row] withIsSelectCoupon:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(self.selectCoupon){
//        CouponsDetail *model = [[CouponsDetail alloc]init];
//        self.selectCoupon(model);
//    }
    Coupon *coupon = [self.couponDataArray objectAtIndex:indexPath.row];
    [self getCouponSupportInfoFromServer:coupon.cpNo];
}

#pragma mark - 获取优惠券支持分类情况
- (void)getCouponSupportInfoFromServer:(NSString *)cpNo
{
    if (cpNo == nil || cpNo.length <= 0) {
        [Common showBottomToast:@"优惠券信息异常"];
        return;
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[cpNo] forKeys:@[@"cpNo"]];
    [self getArrayFromServer:CouponSupportInfo_Url path:CouponSupportInfo_Path method:@"GET" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        for (NSDictionary *dic in result) {
            _couponSupportInfo = [[CouponSupportInfo alloc] initWithDictionary:dic];
        }
        [self showCouponSupportInfoDialog];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


- (void)showCouponSupportInfoDialog
{
    NSString *message = @"";
    
    if (_couponSupportInfo.spSupport.length > 0) {
        message = [message stringByAppendingString:_couponSupportInfo.spSupport];
    }
    if (message.length > 0) {
        if (_couponSupportInfo.fwSupport.length > 0) {
            message = [message stringByAppendingString:[NSString stringWithFormat:@"\n%@", _couponSupportInfo.fwSupport]];
        }
    }else {
        if (_couponSupportInfo.fwSupport.length > 0) {
            message = [message stringByAppendingString:_couponSupportInfo.fwSupport];
        }
    }
    
    if (message.length > 0) {
        if (_couponSupportInfo.tgSupport.length > 0) {
            message = [message stringByAppendingString:[NSString stringWithFormat:@"\n%@", _couponSupportInfo.tgSupport]];
        }
    }else {
        if (_couponSupportInfo.tgSupport.length > 0) {
            message = [message stringByAppendingString:_couponSupportInfo.tgSupport];
        }
    }
    
    if (message.length <= 0) {
        message = @"无";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支持分类详情" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - 从服务器取得数据
- (void)getCouponDataFromServer {
    NSString *userId = [[LoginConfig Instance] userID];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.couponUseState, userId, [NSString stringWithFormat:@"%ld", _pageNum], [NSString stringWithFormat:@"%ld", (long)PageSize]] forKeys:@[@"type", @"userId", @"pageNum", @"perSize"]];
    
    [self getArrayFromServer:CouponList_Url path:CouponList_Path method:@"GET" parameters:dic xmlParentNode:@"result" success:^(NSMutableArray *result) {
        if (_pageNum == 1) {
            [self.couponDataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in result) {
            [self.couponDataArray addObject:[[Coupon alloc] initWithDictionary:dic]];
        }
        [self.tableView reloadData];
        if (_couponDataArray.count == 0) {
            [Common showBottomToast:@"暂无数据"];
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (_couponDataArray.count < _pageNum*PageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - 终端“优惠券确认”接口
- (void)getCouponVerifyDataFromServer:(NSString*)code {
    if (code == nil || code.length == 0) {
        return;
    }
    NSString *userId = [[LoginConfig Instance] userID];
    NSString *couponsCode = code;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[couponsCode, userId] forKeys:@[@"couponsCode", @"userId"]];
    
    [self getArrayFromServer:CheckCouponsForUser_Url path:CheckCouponsForUser_Path method:@"GET" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        if (result && result.count > 0) {
            for (NSDictionary *dic in result) {
                _checkCouponData = [[Coupon alloc] initWithDictionary:dic];
            }
            [self displayCouponInfo:couponsCode];
        }
        else {
            [Common showBottomToast:@"优惠券信息有误！"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

- (void)getNewCouponVerifyDataFromServer:(NSString*)code {
    if (code == nil || code.length == 0) {
        return;
    }
    NSString *userId = [[LoginConfig Instance] userID];
    NSString *couponsCode = code;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[couponsCode, userId] forKeys:@[@"couponCode", @"userId"]];
    
    [self requestFromServer:CheckCouponsForUser_Url path:ExchangeCodeToCoupon_Path parameters:dic  success:^(NSDictionary *result) {
        if (result) {
            NSInteger code = [result[@"code"] intValue];
            NSString *message = result[@"message"];
            if (code == 0) {
                [Common showBottomToast:message];
                self.pageNum = 1;
                [self getCouponDataFromServer];
            }
            else {
                [Common showBottomToast:message];
            }
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

- (void)displayCouponInfo:(NSString *)code {
    if([_checkCouponData.result isEqualToString:@"0"])
    {
        [Common showBottomToast:@"该优惠券无效或已被使用"];
        return;
    }
    if ([code rangeOfString:@"@"].length != 0 && [_checkCouponData.result isEqualToString:@"1"]) {
        [Common showBottomToast:@"礼包兑换成功"];
    }else if ([code rangeOfString:@"@"].length != 0 && [_checkCouponData.result isEqualToString:@"2"]) {
        [Common showBottomToast:@"礼包已被兑换"];
        return;
    }
    else {
        [self loadPopUpViewData];
        _popUpView.hidden = NO;
    }
    
    self.pageNum = 1;
    [self getCouponDataFromServer];
}

- (void)loadPopUpViewData {
    switch (_checkCouponData.ticketstype.intValue) {
        case CashCoupon:
            [_popUpViewTicketsTypeName setText:Str_Coupon_Type_Cash];
            break;
        case DiscountCoupon:
            [_popUpViewTicketsTypeName setText:Str_Coupon_Type_Discount];
            break;
        case FullCoupon:
            [_popUpViewTicketsTypeName setText:Str_Coupon_Type_Full];
            break;
        case GiftCoupon:
            [_popUpViewTicketsTypeName setText:Str_Coupon_Type_Gift];
            break;
        case BenifitCoupon:
            [_popUpViewTicketsTypeName setText:Str_Coupon_Type_Benifit];
            break;
        default:
            break;
    }
    
    //NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:coupon.picUrl]];
    NSURL *iconUrl = nil;
    [_popUpViewIcon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    
    [_popUpViewSellerName setText:_checkCouponData.cpNo];
    [_popUpViewEndDate setText:[NSString stringWithFormat:@"有效期至:%@",[_checkCouponData.endDate substringToIndex:10]]];
    [_popUpViewTicketAmount setText:[NSString stringWithFormat:@"￥%@", _checkCouponData.preferentialPrice]];
}

- (IBAction)clickUsefulBtn:(id)sender {
    _stateUseful.selected = YES;
    _stateUsed.selected = NO;
    _stateExpired.selected = NO;
    [self setUIBtnClickState];
    self.pageNum = 1;
    [self getCouponDataFromServer];
}

- (IBAction)clickUsedBtn:(id)sender {
    _stateUseful.selected = NO;
    _stateUsed.selected = YES;
    _stateExpired.selected = NO;
    [self setUIBtnClickState];
    self.pageNum = 1;
    [self getCouponDataFromServer];
}

- (IBAction)clickExpiredBtn:(id)sender {
    _stateUseful.selected = NO;
    _stateUsed.selected = NO;
    _stateExpired.selected = YES;
    [self setUIBtnClickState];
    self.pageNum = 1;
    [self getCouponDataFromServer];
}

- (IBAction)clickGetNewCoupon:(id)sender {
    _popUpView.hidden = YES;
}

- (void)setUIBtnClickState {
    _stateUseful.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _stateUsed.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _stateExpired.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    if (_stateUseful.selected){
        _stateUseful.layer.backgroundColor = Color_Button_Selected.CGColor;
        self.couponUseState = @"1";
    }
    else if (_stateUsed.selected){
        _stateUsed.layer.backgroundColor = Color_Button_Selected.CGColor;
        self.couponUseState = @"2";
    }
    else if (_stateExpired.selected){
        _stateExpired.layer.backgroundColor = Color_Button_Selected.CGColor;
        self.couponUseState = @"3";
    }
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navBarLeftItemBackBtnClick
{
    if (self.leftBtnBackToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

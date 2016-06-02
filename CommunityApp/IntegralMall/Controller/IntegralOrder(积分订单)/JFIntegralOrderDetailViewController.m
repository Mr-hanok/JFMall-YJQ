//
//  JFIntegralOrderDetailViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/5/18.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFIntegralOrderDetailViewController.h"
#import "JFGoodsInfoModel.h"
#import "JFStoreInfoMode.h"
#import "JFOrderInfoCell.h"
#import "JFOrderFooterView.h"
#import "JFOrderHeadView.h"
#import "APIOrderDetailRequest.h"
#import "JFOrderDetailModel.h"
#import "APIOrderDelRequest.h"
#import "JFAlterView.h"
#import "APIOrderCancalRequest.h"
#import "APIOrderConfirmRequest.h"

@interface JFIntegralOrderDetailViewController ()<APIRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *tableHeader;
/**收货人*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**收货人电话*/
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**收货地址*/
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *OrderNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderFollowBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderIntegralBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderDelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderDelBtnWith;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) APIOrderDetailRequest *apiOrderDetail;//订单详情
@property (nonatomic, strong) APIOrderDelRequest *apiOrderDel;//删除订单
@property (nonatomic, strong) APIOrderCancalRequest *apiOrderCancel;//取消订单
@property (nonatomic, strong) APIOrderConfirmRequest *apiOrderConfirm;//确认收货
@property (nonatomic, strong) JFOrderDetailModel *model;

@end

@implementation JFIntegralOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.array = [NSMutableArray array];
    self.tableHeader.backgroundColor = self.view.backgroundColor;
    CGRect newFrame = self.tableHeader.frame;
    newFrame.size.height = 125.f;
    self.tableHeader.frame = newFrame;
    self.tableview.tableHeaderView = self.tableHeader;
    self.tableview.tableFooterView = [[UIView alloc]init];
    //收货人信息
    self.nameLabel.text = @"请选择收货人";
    self.phoneLabel.text = @"";
    self.addressLabel.text = @"请选择收货人地址";
    
    // SectionHeaderNib
    UINib *headerNib = [UINib nibWithNibName:@"JFOrderHeadView" bundle:[NSBundle mainBundle]];
    [self.tableview registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"JFOrderHeadView"];
    
    // SectionFooterNib
    UINib *footerNib = [UINib nibWithNibName:@"JFOrderFooterView" bundle:[NSBundle mainBundle]];
    [self.tableview registerNib:footerNib forHeaderFooterViewReuseIdentifier:@"JFOrderFooterView"];
    //初始化订单请求
    self.apiOrderCancel = [[APIOrderCancalRequest alloc]initWithDelegate:self];
    self.apiOrderConfirm = [[APIOrderConfirmRequest alloc]initWithDelegate:self];
    self.apiOrderDel = [[APIOrderDelRequest alloc]initWithDelegate:self];
    
    [HUDManager showLoadingHUDView:kWindow];
    self.apiOrderDetail = [[APIOrderDetailRequest alloc]initWithDelegate:self];
    [self.apiOrderDetail setApiParamsWithOrderId:self.oid];
    [APIClient execute:self.apiOrderDetail];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
#pragma mark -  APIRequestDelegate

- (void)serverApi_RequestFailed:(APIRequest *)api error:(NSError *)error {
    
    [HUDManager hideHUDView];
    [HUDManager showWarningWithText:kDefaultNetWorkErrorString];
}

- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr {
    
    [HUDManager hideHUDView];
    
    if (sr.dic == nil || [sr.dic isKindOfClass:[NSNull class]]) {
        return;
    }
    if (api == self.apiOrderDetail) {//订单详情
        [self initUIWithDic:sr.dic];
    }
    if (api == self.apiOrderDel) {//删除
        [HUDManager showWarningWithText:sr.msg];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (api == self.apiOrderCancel) {//取消
        [HUDManager showWarningWithText:sr.msg];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (api == self.apiOrderConfirm) {//确认收货
        
    }
    
}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) {
        message = kDefaultServerErrorString;
    }
    [HUDManager showWarningWithText:message];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.gcs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JFOrderInfoCell *cell = [JFOrderInfoCell tableView:self.tableview cellForRowInTableViewIndexPath:indexPath];
    JFOrderDetailGoodsModel *model = self.model.gcs[indexPath.row];
    [cell configCellWithOrderGoodsModel:model];
    return cell;
    
}

#pragma mark - UITableViewDelegate

/**
 *  设置cell高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
// Section Header高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34.f;
}

// Section Footer高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 34.f;
}

// Section Header View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JFOrderHeadView *header = (JFOrderHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JFOrderHeadView"];
    [header configSectionHeadViewWithStoreName:self.model.store_name];
    return header;
}

// Section Footer View
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    JFOrderFooterView *footer = (JFOrderFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JFOrderFooterView"];
    [footer configSectionFooterViewWithOrderDetaliModel:self.model];
    return footer;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - event 
/**物流跟踪*/
- (IBAction)followBtnClick:(UIButton *)sender {
    [self pushWithVCClassName:@"JFOrderFollowViewController" properties:@{@"title":@"物流跟踪",@"oid":self.oid}];
}
/**删除订单 取消订单 确认收货*/
- (IBAction)cancelOrDelBtnClick:(UIButton *)sender {
    JFAlterView *alterview = [[[NSBundle mainBundle]loadNibNamed:@"JFAlterView" owner:nil options:0] firstObject];
    __weak typeof(alterview) weakAlter = alterview;
    
    if ([sender.titleLabel.text isEqualToString:@"删除订单"]) {
        [alterview configAlterViewWithmessage:[NSString stringWithFormat:@"您确定要删除订单吗"] title:@"删除订单"];
        alterview.btnClickCallBack = ^(NSInteger tag){
            if (tag == 102) {//确定
                //删除请求
                [self.apiOrderDel setApiParamsWithOrderId:self.oid];
                [APIClient execute:self.apiOrderDel];
            }
            [weakAlter removeFromSuperview];
        };


    }
    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        [alterview configAlterViewWithmessage:[NSString stringWithFormat:@"您确定要取消订单吗"] title:@"取消订单"];
        alterview.btnClickCallBack = ^(NSInteger tag){
            if (tag == 102) {//确定
                //取消请求
                [self.apiOrderCancel setApiParamsWithOrderId:self.oid];
                [APIClient execute:self.apiOrderCancel];
            }
            [weakAlter removeFromSuperview];
        };


    }
    if ([sender.titleLabel.text isEqualToString:@"确认收货"]) {
        [alterview configAlterViewWithmessage:[NSString stringWithFormat:@"请您确保已收到货物"] title:@"确认收货"];
        alterview.btnClickCallBack = ^(NSInteger tag){
            if (tag == 102) {//确定
                //确认收货请求
                [self.apiOrderConfirm setApiParamsWithOrderId:self.oid];
                [APIClient execute:self.apiOrderConfirm];
            }
            [weakAlter removeFromSuperview];
        };

    }
    
    alterview.frame =[UIApplication sharedApplication].keyWindow.frame;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:alterview];

}

#pragma mark - private methods

-(void)initUIWithDic:(NSDictionary *)dic{
    self.model = [JFOrderDetailModel yy_modelWithDictionary:dic];
    //收货人信息
    self.nameLabel.text = self.model.ship_name;
    self.phoneLabel.text = self.model.ship_phone;
    self.addressLabel.text = self.model.ship_address;
    self.OrderNumLabel.text = self.model.order_id;

    [self.orderIntegralBtn setTitle:[NSString stringWithFormat:@"合计:%@积分",self.model.total_price]  forState:UIControlStateNormal];
    
    NSString *state = self.model.order_status;
    if ([state isEqualToString:@"20"]) {
        self.orderStateLabel.text = @"待发货";
        self.orderFollowBtn.hidden = YES;
        [self.orderDelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    }else if ([state isEqualToString:@"30"]){
        self.orderStateLabel.text = @"待收货";
        self.orderFollowBtn.hidden = NO;
        [self.orderDelBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        
    }else if ([state isEqualToString:@"40"]){
        self.orderStateLabel.text = @"已完成";
        self.orderFollowBtn.hidden = YES;
        [self.orderDelBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        
    }else if([state isEqualToString:@"0"]){
        self.orderStateLabel.text = @"已取消";
        self.orderFollowBtn.hidden = YES;
        [self.orderDelBtn setTitle:@"删除订单" forState:UIControlStateNormal];    }
    
    [self.tableview reloadData];

}

@end

//
//  JFIntegralOrderViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/5/3.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFIntegralOrderViewController.h"
#import "JFIntegralOrderCell.h"
#import "JFOrderFollowViewController.h"
#import "JFIntegralOrderDetailViewController.h"
#import "APIIntegralOrderRequest.h"
#import "PageManager.h"
#import "JFOrderModel.h"
#import "JFAlterView.h"
#import "APIOrderCancalRequest.h"
#import "APIOrderConfirmRequest.h"
#import "APIOrderDelRequest.h"

@interface JFIntegralOrderViewController ()<UITableViewDataSource,UITableViewDelegate,JFIntegralOrderCellDelegate,APIRequestDelegate,PageManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitReceiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitSendBtn;
@property (weak, nonatomic) IBOutlet UIButton *CompleteBtn;
@property (weak, nonatomic) IBOutlet UIView *slideView;
@property (nonatomic, assign) OrderSlideType type;
@property (nonatomic, strong) PageManager *pageManager;
@property (nonatomic, strong) APIIntegralOrderRequest *apiOrderList;
@property (nonatomic, strong) APIOrderCancalRequest *apiOrderCancel;
@property (nonatomic, strong) APIOrderConfirmRequest *apiOrderConfirm;
@property (nonatomic, strong) APIOrderDelRequest *apiOrderDel;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, copy) NSString *OrderType;
@property (nonatomic, strong) NSIndexPath *cancelIndexPath;
@property (nonatomic, strong) NSIndexPath *confiemIndexPath;
@property (nonatomic, strong) NSIndexPath *delIndexPath;

@end

@implementation JFIntegralOrderViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.array = [NSMutableArray array];
    self.OrderType = @"all";
    
    self.tableview.backgroundColor =self.headView.backgroundColor= self.view.backgroundColor;
    CGRect newFrame = self.headView.frame;
    newFrame.size.height = 50.f;
    self.headView.frame = newFrame;
    self.tableview.tableHeaderView = self.headView;
    self.tableview.tableFooterView = [[UIView alloc]init];

    
    [self.allBtn setTitleColor:HEXCOLOR(0x434751) forState:UIControlStateNormal];
    [self.allBtn setTitleColor:HEXCOLOR(0xE87F30) forState:UIControlStateSelected];
    [self.waitSendBtn setTitleColor:HEXCOLOR(0x434751) forState:UIControlStateNormal];
    [self.waitSendBtn setTitleColor:HEXCOLOR(0xE87F30) forState:UIControlStateSelected];
    [self.waitReceiveBtn setTitleColor:HEXCOLOR(0x434751) forState:UIControlStateNormal];
    [self.waitReceiveBtn setTitleColor:HEXCOLOR(0xE87F30) forState:UIControlStateSelected];
    [self.CompleteBtn setTitleColor:HEXCOLOR(0x434751) forState:UIControlStateNormal];
    [self.CompleteBtn setTitleColor:HEXCOLOR(0xE87F30) forState:UIControlStateSelected];
    self.allBtn.selected = YES;
    self.type = OrderSlideTypeAll;
    
    //初始化订单请求
    self.apiOrderList = [[APIIntegralOrderRequest alloc]initWithDelegate:self];
    self.pageManager = [PageManager handlerWithDelegate:self TableView:self.tableview];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HUDManager showLoadingHUDView:kWindow];
    [self headerRefreshing];
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
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    [HUDManager hideHUDView];
    [HUDManager showWarningWithText:kDefaultNetWorkErrorString];
}

- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr {
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    [HUDManager hideHUDView];
    
    if (sr.dic == nil || [sr.dic isKindOfClass:[NSNull class]]) {
        return;
    }
    if (api == self.apiOrderList) {//积分订单列表请求
        if (self.apiOrderList.requestCurrentPage == 1)[self.array removeAllObjects];
        api.requestCurrentPage ++;
        NSArray *orders = [sr.dic objectForKey:@"orders"];
        for (NSDictionary *dic in orders) {
            JFOrderModel *model = [JFOrderModel yy_modelWithDictionary:dic];
            [self.array addObject:model];
        }
        if (self.array.count ==0){
            double delayInSeconds = .2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [HUDManager showWarningWithText:@"没有订单哦~"];
            });
        }
        [self.tableview reloadData];
    }
    if (api == self.apiOrderCancel) {//取消订单
        
        JFOrderModel *m = self.array[self.cancelIndexPath.row];
        m.order_status = @"0";
        [self.tableview reloadData];
    }
    if (api== self.apiOrderConfirm) {//确认收货
        JFOrderModel *m = self.array[self.confiemIndexPath.row];
        m.order_status = @"40";
        [self.tableview reloadData];
    }
    if (api == self.apiOrderDel) {//删除订单
        [self.array removeObjectAtIndex:self.delIndexPath.row];
        [self.tableview reloadData];
    }
    
}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) {
        message = kDefaultServerErrorString;
    }
    [HUDManager showWarningWithText:message];
}

#pragma mark - PageManagerDelegate
- (void)headerRefreshing {
    self.apiOrderList.requestCurrentPage = 1;
    [self.apiOrderList setApiParamsWithType:self.OrderType];
    [APIClient execute:self.apiOrderList];
}
- (void)footerRereshing {
    [self.apiOrderList setApiParamsWithType:self.OrderType];
    [APIClient execute:self.apiOrderList];
}

#pragma mark - JFIntegralOrderCellDelegate
/**订单有多个商品 点击商品*/
-(void)integralOrderCell:(JFIntegralOrderCell *)cell numberOfItemsInTableViewIndexPath:(NSIndexPath *)indexpath{
    
    JFOrderModel *model = self.array[indexpath.row];
    [self pushWithVCClass:[JFIntegralOrderDetailViewController class] properties:@{@"title":@"订单详情",@"oid":model.oid}];

}
/**物流跟踪*/
-(void)integralOrderCell:(JFIntegralOrderCell *)cell OrderFollowIndexPath:(NSIndexPath *)indexpath{
    JFOrderModel *model = self.array [indexpath.row];
    [self pushWithVCClassName:@"JFOrderFollowViewController" properties:@{@"title":@"物流跟踪",@"oid":model.oid}];
}
/**取消订单*/
-(void)integralOrderCell:(JFIntegralOrderCell *)cell cancalOrderIndexPath:(NSIndexPath *)indexpath{
    self.cancelIndexPath = indexpath;
    JFOrderModel *model = self.array [indexpath.row];
    
    JFAlterView *alterview = [[[NSBundle mainBundle]loadNibNamed:@"JFAlterView" owner:nil options:0] firstObject];
    [alterview configAlterViewWithmessage:[NSString stringWithFormat:@"您确定要取消订单吗"] title:@"取消订单"];
    alterview.frame =[UIApplication sharedApplication].keyWindow.frame;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:alterview];
    
    __weak typeof(alterview) weakAlter = alterview;
    alterview.btnClickCallBack = ^(NSInteger tag){
        switch (tag) {
            case 102://确定
                [HUDManager showLoadingHUDView:self.view];
                self.apiOrderCancel = [[APIOrderCancalRequest alloc]initWithDelegate:self];
                [self.apiOrderCancel setApiParamsWithOrderId:model.oid];
                [APIClient execute:self.apiOrderCancel];
                break;
        }
        [weakAlter removeFromSuperview];
    };

}
//**确认收货*/
-(void)integralOrderCell:(JFIntegralOrderCell *)cell confirmOrderIndexPath:(NSIndexPath *)indexpath{
    self.confiemIndexPath = indexpath;
    JFOrderModel *model = self.array [indexpath.row];
    
    JFAlterView *alterview = [[[NSBundle mainBundle]loadNibNamed:@"JFAlterView" owner:nil options:0] firstObject];
    [alterview configAlterViewWithmessage:[NSString stringWithFormat:@"请您确保已收到货物"] title:@"确认收货"];
    alterview.frame =[UIApplication sharedApplication].keyWindow.frame;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:alterview];
    
    __weak typeof(alterview) weakAlter = alterview;
    alterview.btnClickCallBack = ^(NSInteger tag){
        switch (tag) {
            case 102://确定
                [HUDManager showLoadingHUDView:self.view];
                self.apiOrderConfirm = [[APIOrderConfirmRequest alloc]initWithDelegate:self];
                [self.apiOrderConfirm setApiParamsWithOrderId:model.oid];
                [APIClient execute:self.apiOrderConfirm];
                break;
        }
        [weakAlter removeFromSuperview];
    };

}
-(void)integralOrderCell:(JFIntegralOrderCell *)cell delOrderIndexPath:(NSIndexPath *)indexpath{
    self.delIndexPath = indexpath;
    JFOrderModel *model = self.array [indexpath.row];
    
    JFAlterView *alterview = [[[NSBundle mainBundle]loadNibNamed:@"JFAlterView" owner:nil options:0] firstObject];
    [alterview configAlterViewWithmessage:[NSString stringWithFormat:@"确定要删除订单吗?"] title:@"确认删除"];
    alterview.frame =[UIApplication sharedApplication].keyWindow.frame;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:alterview];
    
    __weak typeof(alterview) weakAlter = alterview;
    alterview.btnClickCallBack = ^(NSInteger tag){
        switch (tag) {
            case 102://确定
                [HUDManager showLoadingHUDView:self.view];
                self.apiOrderDel = [[APIOrderDelRequest alloc]initWithDelegate:self];
                [self.apiOrderDel setApiParamsWithOrderId:model.oid];
                [APIClient execute:self.apiOrderDel];
                break;
        }
        [weakAlter removeFromSuperview];
    };

}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JFIntegralOrderCell *cell = [JFIntegralOrderCell tableView:self.tableview cellForRowInTableViewIndexPath:indexPath delegate:self];
    JFOrderModel *model = self.array[indexPath.row];
    [cell configCellWithOrderModel:model];
    return cell;
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

#pragma mark - UITableViewDelegate
/**设置cell高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 215;
}
#pragma mark - event response
- (IBAction)slideBtnClick:(UIButton *)sender {
        sender.selected = !sender.selected;
        [UIView animateWithDuration:0.25f animations:^{
            self.slideView.center = CGPointMake(sender.center.x, self.slideView.center.y);
        }];
        self.type = sender.tag;
        switch (sender.tag) {
            case OrderSlideTypeAll://全部记录
                self.waitReceiveBtn.selected =self.waitSendBtn.selected = self.CompleteBtn.selected = NO;
                self.OrderType = @"all";
                break;
                
            case OrderSlideTypeSend://待发货
                self.waitReceiveBtn.selected = self.allBtn.selected = self.CompleteBtn.selected = NO;
                self.OrderType = @"20";
                break;
                
            case OrderSlideTypeReceive://待收货
                self.allBtn.selected = self.waitSendBtn.selected = self.CompleteBtn.selected = NO;
                self.OrderType = @"30";
                break;
                
            case OrderSlideTypeComplete://完成
                self.waitReceiveBtn.selected = self.waitSendBtn.selected = self.allBtn.selected = NO;
                self.OrderType =@"40";

                break;
        }
    [HUDManager showLoadingHUDView:self.view];
    [self headerRefreshing];
    [self.tableview reloadData];
}

#pragma mark - private methods

@end

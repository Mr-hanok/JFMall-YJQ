//
//  MyGrouponViewController.m
//  CommunityApp
//
//  Created by iss on 7/20/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "MyCouponsViewController.h"
#import "MyCouponsTableViewCell.h"
#import "MyCouponsHeaderView.h"
#import "GrouponTicket.h"
#import "PersonalCenterMyOrderDetailViewController.h"
#import <MJRefresh.h>

#define cellNibName @"MyCouponsTableViewCell"
#define cellHeadNibName @"MyCouponsHeaderView"

@interface MyCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) NSMutableArray* couponsList;
@property (weak, nonatomic) IBOutlet UIView *headerSelectorView;
@property (weak, nonatomic) IBOutlet UIButton *payedBtn;
@property (weak, nonatomic) IBOutlet UIButton *unpayBtn;

@property (nonatomic, copy)     NSString    *payStatus;     //0：未付款； 1：已付款
@property (nonatomic, assign)   NSInteger   pageNum;        //当前页码
@property (nonatomic, assign)   NSInteger   perSize;        //每页大小

@end

#pragma mark - 宏定义区
#define GrouponOrderPageSize        (10)

@implementation MyCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     // 初始化导航栏样式
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_MyCoupons_Title;
    
    // 初始化header
    [Common setRoundBorder:_headerSelectorView borderWidth:0.5 cornerRadius:5 borderColor:Color_Gray_RGB];
    
    _payStatus = @"1";
    [_payedBtn setSelected:YES];
    [_unpayBtn setSelected:NO];
    _unpayBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _payedBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
    
    [_table registerNib:[UINib nibWithNibName:cellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellNibName];
    [_table registerNib:[UINib nibWithNibName:cellHeadNibName bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:cellHeadNibName];
    _couponsList = [[NSMutableArray alloc]init];
    
    _pageNum = 1;
    _perSize = 10;
    
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self getCouponsFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.couponsList.count == _pageNum*_perSize) {
            _pageNum++;
            [self getCouponsFromServer];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.table.header = header;
    self.table.footer = footer;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCouponsFromServer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyCouponsHeaderView* head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellHeadNibName];
    GrouponTicket* ticket = [_couponsList objectAtIndex:section];
    [head loadCellData:ticket.gbTitle andValidity:ticket.expDate andOrderNo:ticket.orderNum andOrderState:ticket.orderStatus];
    
    [head setSectionHeaderClickBlock:^{
        GrouponTicket* gbTicket = [_couponsList objectAtIndex:section];
        if(gbTicket==nil)
            return;
        PersonalCenterMyOrderDetailViewController* vc = [[PersonalCenterMyOrderDetailViewController alloc]init];
        [vc setOrderId:gbTicket.orderId orderType:OrderType_Coupon];
        [self.navigationController pushViewController:vc animated:TRUE];
    }];
    
    return head;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCouponsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellNibName];
    GrouponTicket* ticket = [_couponsList objectAtIndex:indexPath.section];
    
   [cell loadCellData:[ticket.ticketsList objectAtIndex:indexPath.row] atIndex:indexPath.row+1 isButtom:indexPath.row == ticket.ticketsList.count-1?TRUE:FALSE];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GrouponTicket* ticket = [_couponsList objectAtIndex:section];
    if(ticket == nil)
        return 0;
    
    return ticket.ticketsList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _couponsList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GrouponTicket* gbTicket = [_couponsList objectAtIndex:indexPath.section];
    if(gbTicket==nil)
        return;
    PersonalCenterMyOrderDetailViewController* vc = [[PersonalCenterMyOrderDetailViewController alloc]init];
    [vc setOrderId:gbTicket.orderId orderType:OrderType_Coupon];
    [self.navigationController pushViewController:vc animated:TRUE];
}

#pragma mark--- 从服务器得到团购券数据
-(void)getCouponsFromServer
{
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:[[LoginConfig Instance]userID],@"userId",_payStatus, @"payStatus", [NSString stringWithFormat:@"%ld", (long)_pageNum], @"pageNum", [NSString stringWithFormat:@"%ld", (long)_perSize], @"perSize", nil];
    
    [self getArrayFromServer:GetOrderListForGroupBuy_Url path:GetOrderListForGroupBuy_Path method:@"GET" parameters:dic xmlParentNode:@"groupBuyOrder" success:^(NSMutableArray *result) {
        if (_pageNum == 1) {
            [_couponsList removeAllObjects];
        }
        
        for ( NSDictionary * ticket in result) {
            [_couponsList addObject:[[GrouponTicket alloc]initWithDictionary:ticket]];
        }
        [_table reloadData];
        [_table.header endRefreshing];
        [_table.footer endRefreshing];
        if (_couponsList.count < _pageNum*_perSize) {
            [_table.footer noticeNoMoreData];
        }
        if (_couponsList.count == 0) {
            [Common showBottomToast:@"暂无数据"];
        }
    } failure:^(NSError *error) {
         [Common showBottomToast:Str_Comm_RequestTimeout];
        [_table reloadData];
        [_table.header endRefreshing];
        [_table.footer endRefreshing];
    }];
}


#pragma mark - Header按钮点击处理函数
- (IBAction)payBtnClickHandler:(UIButton *)sender {
    [sender setSelected:YES];
    if (sender == _payedBtn) {
        [_unpayBtn setSelected:NO];
        _unpayBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _payedBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
        _payStatus = @"1";
    }else {
        [_payedBtn setSelected:NO];
        _payedBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _unpayBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
        _payStatus = @"0";
    }
    [_couponsList removeAllObjects];
    [self getCouponsFromServer];
}


@end
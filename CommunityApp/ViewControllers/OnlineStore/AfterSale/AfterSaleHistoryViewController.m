//
//  AfterSaleHistoryViewController.m
//  CommunityApp
//
//  Created by issuser on 15/7/24.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AfterSaleHistoryViewController.h"
#import "AfterSaleDealRecordDetail.h"
#import <MJRefresh.h>
#import "AfterSaleHistoryTableViewCell.h"
#define CELLNIBNAME @"AfterSaleHistoryTableViewCell"
#define AfterSaleHistoryPageSize (10)

@interface AfterSaleHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *dealRecordDetailArray;
@property (assign,nonatomic) NSInteger pageNum;
@end

@implementation AfterSaleHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_AfterSale_History_Title;
    _dealRecordDetailArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
    [_tableView registerNib:[UINib nibWithNibName:CELLNIBNAME bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELLNIBNAME];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_afterSalesId)
        [self getTbgAfterSaleDealRecordDetail:_afterSalesId];
    else if(_ticketId)
        [self getTbgAfterSaleGroponDealRecordDetail:_ticketId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 终端下载售后动作历史接口
- (void)getTbgAfterSaleDealRecordDetail:(NSString *)afterSalesId {
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[afterSalesId] forKeys:@[@"afterSalesId"]];
    
    [self getArrayFromServer:TbgAfterSaleDealRecordDetail_Url path:TbgAfterSaleDealRecordDetail_Path method:@"GET" parameters:dic xmlParentNode:@"tbgAfterSaleDealRecord" success:^(NSMutableArray *result) {
        [self.dealRecordDetailArray removeAllObjects];
        for(NSDictionary *dic in result){
            [self.dealRecordDetailArray addObject:[[AfterSaleDealRecordDetail alloc] initWithDictionary:dic]];
        }
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (self.dealRecordDetailArray.count < self.pageNum*AfterSaleHistoryPageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    }];
    
    // dealRecordDetailArray
}
- (void)getTbgAfterSaleGroponDealRecordDetail:(NSString *)ticketId {
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[ticketId] forKeys:@[@"ticketId"]];
    
    [self getArrayFromServer:TbgAfterSaleDealRecordDetail_Url path:TbgAfterSaleGrouponDealRecordDetail_Path method:@"GET" parameters:dic xmlParentNode:@"tbgAfterSaleDealRecord" success:^(NSMutableArray *result) {
        [self.dealRecordDetailArray removeAllObjects];
        for(NSDictionary *dic in result){
            [self.dealRecordDetailArray addObject:[[AfterSaleDealRecordDetail alloc] initWithDictionary:dic]];
        }
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (self.dealRecordDetailArray.count < self.pageNum*AfterSaleHistoryPageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    }];
    
    // dealRecordDetailArray
}

#pragma mark---UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dealRecordDetailArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AfterSaleHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLNIBNAME];
    AfterSaleDealRecordDetail* detail = [_dealRecordDetailArray objectAtIndex:indexPath.row];
    [cell loadCellData:detail];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AfterSaleDealRecordDetail* cellData  = [_dealRecordDetailArray objectAtIndex:indexPath.row];
    CGFloat footerHeight = FOOTVIEWHEIGHT;
    if (cellData.attachment == nil || [cellData.attachment isEqualToString:@""]) {
        footerHeight = 0.f;
    }
 
    CGFloat contectHeight = [Common labelDemandHeightWithText:cellData.content font:[UIFont systemFontOfSize:14] size:CGSizeMake(Screen_Width-30, MAXFLOAT)];
   
    return BGVIEWHEIGHT + (footerHeight - FOOTVIEWHEIGHT) + (contectHeight- CONTENTVIEWHEIGHT);
}
@end

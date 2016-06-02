//
//  GrouponListViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponListViewController.h"
#import "GrouponListTableViewCell.h"
#import "GrouponDetailViewController.h"
#import "GrouponOrderSubmitViewController.h"
#import "GrouponList.h"
#import "GrouponOrder.h"
#import <MJRefresh.h>

#define GrouponListPageSize (10)
#define GrouponListTableViewCellNibName @"GrouponListTableViewCell"

@interface GrouponListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (assign, nonatomic) NSInteger pageNum;
@property (retain, nonatomic) NSMutableArray *grouponListArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray* timerArray;
@end

@implementation GrouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Groupon_List_Title;
    
    [self initUIViewData];
    
    // 添加下拉/上滑刷新更多
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getGrouponListDataFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.grouponListArray.count == self.pageNum*GrouponListPageSize) {
            self.pageNum++;
            [self getGrouponListDataFromServer];
        }
    }];
    self.timerArray = [[NSMutableArray alloc]init];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
    self.tableView.footer = footer;
    
//    self.pageNum = 1;
//    [self getGrouponListDataFromServer];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pageNum = 1;
    [self getGrouponListDataFromServer];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self clearTimers];
}
-(void)clearTimers
{
    for (int i=0; i<self.timerArray.count; i++) {
        NSTimer* timer = [self.timerArray objectAtIndex:i];
        [timer invalidate];
        timer = nil;
    }
    [self.timerArray removeAllObjects];
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.grouponListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GrouponListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GrouponListTableViewCellNibName forIndexPath:indexPath];

    if(cell.timer)
        [_timerArray removeObject:cell.timer];
    [cell setClearTimer:^(NSTimer *timer) {
        [self.timerArray removeObject:timer];
    }];
    [cell loadCellData:[self.grouponListArray objectAtIndex:indexPath.row]];
    if (cell.timer) {
        [_timerArray addObject:cell.timer];
    }
    [cell setDialBuyNowBlock:^{
        if ([self isGoToLogin]) {
            GrouponOrderSubmitViewController *vc = [[GrouponOrderSubmitViewController alloc]init];
            GrouponList *groupon = [self.grouponListArray objectAtIndex:indexPath.row];
            vc.gpOrder = [self createGrouponOrder:groupon];
            vc.groupBuyListVC = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];

    return cell;
}

- (GrouponOrder *)createGrouponOrder:(GrouponList *)gpList{
    GrouponOrder *gpOrder = [[GrouponOrder alloc]init];
    LoginConfig *login = [LoginConfig Instance];
    
    gpOrder.goodsName = gpList.goodsName;//团购名称
    gpOrder.creator = login.userName; ////下单人姓名
    gpOrder.linkName = login.userName; //联系人
    gpOrder.linkTel = [login userAccount];  //联系电话
    gpOrder.goodsIds = gpList.goodsId; //（商品Id：团购单价：团购数量）
    gpOrder.ownerid = [login userID];  //下单人ID
    gpOrder.sellerId = gpList.sellerId; //商家ID
    gpOrder.totalMoney = gpList.goodsActualPrice;   //团购金额
    gpOrder.groupBuyEndTime = gpList.groupBuyEndTime;  //团购结束时间
    gpOrder.sellerId = gpList.sellerId;
    return gpOrder;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GrouponDetailViewController *vc = [[GrouponDetailViewController alloc]init];
    GrouponList *groupon = [self.grouponListArray objectAtIndex:indexPath.row];
    vc.grouponId = groupon.goodsId;
    vc.groupBuyListVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initUIViewData {
    self.grouponListArray = [[NSMutableArray alloc]init];

    //注册cell
    UINib *nibForGrouponListViewService = [UINib nibWithNibName:GrouponListTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForGrouponListViewService forCellReuseIdentifier:GrouponListTableViewCellNibName];
}

#pragma mark - 从服务器获取数据
- (void)getGrouponListDataFromServer {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[projectId, @"", [NSString stringWithFormat:@"%ld", (long)self.pageNum],[NSString stringWithFormat:@"%ld",(long)GrouponListPageSize]] forKeys:@[@"projectId", @"goodsName", @"pageNum", @"perSize"]];
    
    [self getArrayFromServer:GetGoodsModuleListForGroupBuy_Url path:GetGoodsModuleListForGroupBuy_Path method:@"GET" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
        if(self.pageNum == 1)
        {
            [self.grouponListArray removeAllObjects];
            [self clearTimers];
        }
        
        for(NSDictionary *dic in result){
            [self.grouponListArray addObject:[[GrouponList alloc] initWithDictionary:dic]];
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (self.grouponListArray.count < self.pageNum*GrouponListPageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        if (self.grouponListArray.count == 0) {
            [Common showBottomToast:@"暂无团购商品"];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    }];
}

@end

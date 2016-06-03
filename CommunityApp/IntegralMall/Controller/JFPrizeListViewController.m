//
//  JFPrizeListViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/6/2.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFPrizeListViewController.h"
#import "JFPrizeCell.h"
#import "JFPrizeModel.h"
#import "APIPrizeListRequest.h"
#import "APIAceptPrizeRequest.h"
#import "ApiAddToShopCarRequest.h"
#import "APIPrizeMsgReuqest.h"
#import <MJRefresh.h>

@interface JFPrizeListViewController ()<UITableViewDataSource,UITableViewDelegate,APIRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) APIPrizeListRequest *apiPrizeList;
@property (nonatomic, strong) APIAceptPrizeRequest *apiAceptPrize;
@property (nonatomic, strong) APIPrizeMsgReuqest *apiPrizeMsg;
@property (nonatomic, strong) ApiAddToShopCarRequest *apiAddShopCar;

@property (nonatomic, strong) NSIndexPath *indexpath;
@property (nonatomic, copy) NSString *logid;

@end

@implementation JFPrizeListViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.array = [NSMutableArray array];
    self.tableview.backgroundColor = self.view.backgroundColor;
    self.tableview.tableFooterView = [[UIView alloc]init];
    self.apiAceptPrize = [[APIAceptPrizeRequest alloc]initWithDelegate:self];
    
    self.apiPrizeList = [[APIPrizeListRequest alloc]initWithDelegate:self];
    [self.apiPrizeList setApiParamsWithActivity_type:self.active_type];
    
    // 添加下拉刷新、下拉加载更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //发送请求数据
        [APIClient execute:self.apiPrizeList];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableview.mj_header = header;
    [self.tableview.mj_header beginRefreshing];
    
}
//设置分割线距离0
-(void)viewDidLayoutSubviews
{
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) [self.tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])  [self.tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
}

#pragma mark - 协议名
#pragma mark -  APIRequestDelegate

- (void)serverApi_RequestFailed:(APIRequest *)api error:(NSError *)error {
    [self.tableview.mj_header endRefreshing];
    [HUDManager hideHUDView];
    [HUDManager showWarningWithText:kDefaultNetWorkErrorString];
}

- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr {
    [self.tableview.mj_header endRefreshing];
    [HUDManager hideHUDView];
    
    if (sr.dic == nil || [sr.dic isKindOfClass:[NSNull class]]) {
        return;
    }
    if (api == self.apiPrizeList) {//中奖列表
        [self.array removeAllObjects];
        NSArray *myWinList = [sr.dic objectForKey:@"myWinList"];
        for (NSDictionary *dic in myWinList) {
            JFPrizeModel *model = [JFPrizeModel yy_modelWithDictionary:dic];
            [self.array addObject:model];
        }
        
        [self.tableview reloadData];
    }
    if (api == self.apiAceptPrize) {//接受奖品
        JFPrizeModel *model = self.array[self.indexpath.row];
        model.award_status = @"1";
        [self.tableview reloadRowsAtIndexPaths:@[self.indexpath] withRowAnimation:UITableViewRowAnimationNone];
    }
    if (api == self.apiPrizeMsg) {//查询奖品信息->加入购物车
        [self addToShopCarWithResult:sr];
    }
    if (api == self.apiAddShopCar) {//加入购物测
        NSString *gc_id = [ValueUtils stringFromObject:[sr.dic objectForKey:@"gc_id"]];
        [self pushWithVCClassName:@"JFCommitOrderViewController" properties:@{@"title":@"提交订单",
                       @"goodsId":gc_id,
                       @"isPrize":@YES,
                        @"log_id":self.logid,
                    @"order_flag":@"1"}];
    }

}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    [self.tableview.mj_header endRefreshing];
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) {
        message = kDefaultServerErrorString;
    }
    [HUDManager showWarningWithText:message];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFPrizeModel *model = self.array[indexPath.row];
    JFPrizeCell *cell = [JFPrizeCell tableView:self.tableview cellForRowInTableViewIndexPath:indexPath prize_type:model.prize_type];
    [cell configCellWithModel:model];
    cell.callBackPrize = ^(NSString *pid,NSString *type){
        [HUDManager showLoadingHUDView:self.view];
        if ([type isEqualToString:@"1"]) {//实物奖品
            self.logid = model.pid;
            //查询商品信息-》加入购物车-》跳转页面
            self.apiPrizeMsg = [[APIPrizeMsgReuqest alloc]initWithDelegate:self];
            [self.apiPrizeMsg setApiParamsWithLog_id:model.pid];
            [APIClient execute:self.apiPrizeMsg];
        }
        if ([type isEqualToString:@"2"]) {//积分奖品
            self.indexpath = indexPath;
            [self.apiAceptPrize setApiParamsWithLog_id:model.pid];
            [APIClient execute:self.apiAceptPrize];
        }
    };
    return cell;
}
//设置分割线距离0
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])  [cell setLayoutMargins:UIEdgeInsetsZero];
    
}
#pragma mark - UITableViewDelegate
/**设置cell高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [JFPrizeCell cellHeigthWithModel:self.array[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - event response

#pragma mark - private methods
- (void)addToShopCarWithResult:(APIResult *)sr{
    
    NSString *goodsId = [ValueUtils stringFromObject:[sr.dic objectForKey:@"goodsid"]];
    NSString *goodsPrice = [ValueUtils stringFromObject:[sr.dic objectForKey:@"price"]];
    NSString *goodsCount = [ValueUtils stringFromObject:[sr.dic objectForKey:@"count"]];
    NSString *goodsSkuid = [ValueUtils stringFromObject:[sr.dic objectForKey:@"skuid"]];
    NSString *goodsGsp = [ValueUtils stringFromObject:[sr.dic objectForKey:@"gsp"]];
    
    self.apiAddShopCar = [[ApiAddToShopCarRequest alloc]initWithDelegate:self];
    [self.apiAddShopCar setApiParamsWithGoodsId:goodsId
                                          count:goodsCount
                                       integral:goodsPrice
                                         sku_id:goodsSkuid
                                          gspid:goodsGsp];
    [APIClient execute:self.apiAddShopCar];
    
}

@end

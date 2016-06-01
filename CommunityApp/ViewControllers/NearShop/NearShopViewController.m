//
//  NearShopViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/29.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "NearShopViewController.h"
#import "EverydayDiscountTableViewCell.h"
#import "LifeSupermarketTableViewCell.h"
#import "SurroundChoiceTableViewCell.h"
#import "BusinessDetailViewController.h"
#import "WaresDetailViewController.h"
#import <MJRefresh.h>
#import "DBOperation.h"
#import "ShoppingCartViewController.h"

#pragma mark -- 宏定义区
#define NearShopPageSize (10)
#define EverydayDiscountTableViewCellNibName          @"EverydayDiscountTableViewCell"
#define LifeSupermarketTableViewCellNibName           @"LifeSupermarketTableViewCell"
#define SurroundChoiceTableViewCellNibName            @"SurroundChoiceTableViewCell"

#pragma mark -- 接口定义区
@interface NearShopViewController ()<UITableViewDelegate,UITableViewDataSource,marketCellDelegate>

    @property (retain,nonatomic) IBOutlet UITableView *tableView;

    // 页面顶部标签按钮
    @property (retain,nonatomic) IBOutlet UIButton *everydayDisCount;
    @property (retain,nonatomic) IBOutlet UIButton *lifeSupermarket;
    @property (retain,nonatomic) IBOutlet UIButton *nearbyChoice;

    // table view分页显示（页数）
    @property (assign,nonatomic) NSInteger pageNum;

    @property (retain,nonatomic) NSMutableArray *everydayDiscountArray; // 天天特价数组
    @property (retain,nonatomic) NSMutableArray *lifeSupermarketArray;  // 生活超市数组
    // @property (retain,nonatomic) NSMutableArray *surroundBusinessArray; // 周边精选数组
    @property (retain,nonatomic) NSMutableArray *surroundChoiceArray; // 周边精选数组

@end

@implementation NearShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarLeftItemAsBackArrow];
    [self initNearShopInfo];
    [self registNibForCollectionView];
    
    self.navigationItem.title = Str_Near_Shop_Title;

    self.everydayDiscountArray = [[NSMutableArray alloc] init];
    self.surroundChoiceArray = [[NSMutableArray alloc] init];
    self.lifeSupermarketArray = [[NSMutableArray alloc] init];
    
    // 添加下拉/上滑刷新更多
    self.pageNum = 1;
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getEverydayDisCountDataFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.everydayDiscountArray.count == self.pageNum*NearShopPageSize) {
            self.pageNum++;
            [self getEverydayDisCountDataFromServer];
        }
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
    self.tableView.footer = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_everydayDisCount.selected){
        return self.everydayDiscountArray.count;
    }else if (_lifeSupermarket.selected){
        return self.lifeSupermarketArray.count;
    }else if (_nearbyChoice.selected){
        return self.surroundChoiceArray.count;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_everydayDisCount.selected){
        return 135;
    }else if (_lifeSupermarket.selected){
        return 85;
    }else{
        return 77;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_everydayDisCount.selected){
        EverydayDiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EverydayDiscountTableViewCellNibName forIndexPath:indexPath];
         [cell loadCellData: [self.everydayDiscountArray objectAtIndex:indexPath.row]];
         [cell setBuyNowBtnClickBlock:^{
             if ([[LoginConfig Instance] userLogged]) {
                 WaresList *wares = [self.everydayDiscountArray objectAtIndex:indexPath.row];
                 WaresDetail *detail = [[WaresDetail alloc] initWithWaresList:wares];
                 [[DBOperation Instance] insertWaresData:detail];
                 [self updateCartInfoToServerSuccess:^(NSString *result) {
                     ShoppingCartViewController *vc = [[ShoppingCartViewController alloc] init];
                     vc.eFromType = E_CartViewFromType_Push;
                     [self.navigationController pushViewController:vc animated:YES];
                 } failure:^(NSError *error) {
                 }];
             }
         }];
        return cell;
    }else if(_lifeSupermarket.selected){
        LifeSupermarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeSupermarketTableViewCellNibName forIndexPath:indexPath];
         [cell loadCellData:[self.lifeSupermarketArray objectAtIndex:indexPath.row]];
         cell.delegate = self;
        return cell;
    }else if(_nearbyChoice.selected){
        SurroundChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SurroundChoiceTableViewCellNibName forIndexPath:indexPath];
        [cell loadCellData:[self.surroundChoiceArray objectAtIndex:indexPath.row]];
        [cell setDialHotLineBlock:^{
            SurroundBusinessModel *model = [self.surroundChoiceArray objectAtIndex:indexPath.row];
            NSString *dialTel = [NSString stringWithFormat:@"tel://%@", model.phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialTel]];
        }];
        return cell;
    }else{
        return nil;
    }
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_lifeSupermarket.selected){
        BusinessDetailViewController *vc = [[BusinessDetailViewController alloc] init];
        vc.businessModel = [self.lifeSupermarketArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(_nearbyChoice.selected) {
        BusinessDetailViewController *vc = [[BusinessDetailViewController alloc] init];
        vc.businessModel = [self.surroundChoiceArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(_everydayDisCount.selected){
        WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
        WaresList *wares = [self.everydayDiscountArray objectAtIndex:indexPath.row];
        vc.waresId = wares.goodsId;
        vc.efromType = E_FromViewType_WareList;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getEverydayDisCountDataFromServer];
    [self getSurroundBusinessDataFromServer];
    [self getLifeSupermarketDataFromServer];
}

- (IBAction)clickEverydayDiscount:(id)sender {
    _everydayDisCount.selected = TRUE;
    _lifeSupermarket.selected = FALSE;
    _nearbyChoice.selected = FALSE;
    [self.tableView reloadData];
}

- (IBAction)clickLifeSupermarket:(id)sender {
    _everydayDisCount.selected = FALSE;
    _lifeSupermarket.selected = TRUE;
    _nearbyChoice.selected = FALSE;
    [self.tableView reloadData];
}

- (IBAction)clickNearbyChoice:(id)sender {
    _everydayDisCount.selected = FALSE;
    _lifeSupermarket.selected = FALSE;
    _nearbyChoice.selected = TRUE;
    [self.tableView reloadData];
}

// 注册CollectionView的Cell Nib
- (void)registNibForCollectionView {
    // 天天特价
    UINib *nibForEverydayDiscountService = [UINib nibWithNibName:EverydayDiscountTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForEverydayDiscountService forCellReuseIdentifier:EverydayDiscountTableViewCellNibName];
    // 生活超市
    UINib *nibForLifeSupermarketService = [UINib nibWithNibName:LifeSupermarketTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForLifeSupermarketService forCellReuseIdentifier:LifeSupermarketTableViewCellNibName];
    // 周边精选
    UINib *nibForSurroundChoiceService = [UINib nibWithNibName:SurroundChoiceTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForSurroundChoiceService forCellReuseIdentifier:SurroundChoiceTableViewCellNibName];
}

- (void)initNearShopInfo {
    _everydayDisCount.selected = TRUE;
}

#pragma mark -- 从服务器取得数据
// 从服务器取得天天特价数据
- (void)getEverydayDisCountDataFromServer
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.projectId = [userDefault objectForKey:KEY_PROJECTID];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.projectId, @"1", [NSString stringWithFormat:@"%ld", (long)self.pageNum],[NSString stringWithFormat:@"%ld",(long)NearShopPageSize]] forKeys:@[@"projectId", @"moduleType", @"pageNum", @"perSize"]];
    
    [self getArrayFromServer:WaresListByModule_Url path:WaresListByModule_Path method:@"GET" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
        if(self.pageNum == 1)
        {
            [self.everydayDiscountArray removeAllObjects];

        }
        for(NSDictionary *dic in result){
            [self.everydayDiscountArray addObject:[[WaresList alloc] initWithDictionary:dic]];
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (self.everydayDiscountArray.count < self.pageNum*NearShopPageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableView reloadData];
    }failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    }];
}

// 从服务器取得生活超市数据
- (void)getLifeSupermarketDataFromServer
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.projectId, @"1", [NSString stringWithFormat:@"%ld", (long)self.pageNum],[NSString stringWithFormat:@"%ld",(long)NearShopPageSize]] forKeys:@[@"projectId", @"isSupermarket", @"pageNum", @"perSize"]];
    
    [self getArrayFromServer:SurroundBusiness_Url path:SurroundBusiness_Path method:@"GET" parameters:dic xmlParentNode:@"crmManageSeller" success:^(NSMutableArray *result) {
        [self.lifeSupermarketArray removeAllObjects];
        for(NSDictionary *dic in result){
            [self.lifeSupermarketArray addObject:[[SurroundBusinessModel alloc] initWithDictionary:dic]];
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (self.everydayDiscountArray.count < self.pageNum*NearShopPageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    }];
}

// 从服务器取得周边精选数据
- (void)getSurroundBusinessDataFromServer
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.projectId] forKeys:@[@"projectId"]];
    [self getArrayFromServer:SurroundBusiness_Url path:SurroundBusiness_Path method:@"GET" parameters:dic xmlParentNode:@"crmManageSeller" success:^(NSMutableArray *result) {
        [self.surroundChoiceArray removeAllObjects];
        for (NSDictionary *dic in result) {
            [self.surroundChoiceArray addObject:[[SurroundBusinessModel alloc] initWithDictionary:dic]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark -- marketCellDelegate
- (void)marketCell:(LifeSupermarketTableViewCell *)cell
{
    NSIndexPath* index = [_tableView indexPathForCell:cell];
    SurroundBusinessModel *model = [_lifeSupermarketArray objectAtIndex:index.row];
    NSString *tel = [NSString stringWithFormat:@"tel://%@" ,model.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}
@end

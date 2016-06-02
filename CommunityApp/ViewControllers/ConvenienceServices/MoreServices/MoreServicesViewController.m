//
//  MoreServicesViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "MoreServicesViewController.h"
#import "ConvenienceServiceCollectionViewCell.h"
#import "DetailServiceViewController.h"
#import "ServiceList.h"
#import "MJRefresh.h"

#pragma mark - 宏定义区
#define ConvenienceServiceCollectionCellNibName     @"ConvenienceServiceCollectionViewCell"


@interface MoreServicesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;


@end

@implementation MoreServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = @"更多服务";
    [self setNavBarLeftItemAsBackArrow];
    
    // 初始化基础数据
    [self initBasicDataInfo];
    
    // 添加下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getConvenienceServiceDataFromService];    // 获取便民服务数据
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.header = header;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getConvenienceServiceDataFromService];    // 获取便民服务数据
}


#pragma mark - CollectionDataSource代理
// 设计该CollectionView的Section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 设计每个section的Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.serviceArray.count;
}


// 加载CollectionViewCell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ConvenienceServiceCollectionViewCell *cell = (ConvenienceServiceCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ConvenienceServiceCollectionCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.serviceArray objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - CollectionView代理
// CollectionView元素选择事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailServiceViewController *vc = [[DetailServiceViewController alloc] init];
    ServiceList *service = [self.serviceArray objectAtIndex:indexPath.row];
    // vc.serviceId = service.serviceId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.collectionView.frame.size.width/4.0;
    CGFloat height = width;
    
    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}


#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.serviceArray = [[NSMutableArray alloc] init];
    
    // 注册CollectionViewCell Nib
    UINib *nibForService = [UINib nibWithNibName:ConvenienceServiceCollectionCellNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForService forCellWithReuseIdentifier:ConvenienceServiceCollectionCellNibName];
}

// 从服务器上获取便民服务列表数据
- (void)getConvenienceServiceDataFromService
{
    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[self.projectId,@"-1"] forKeys:@[@"projectId",@"serviceType"]];
    if ([[LoginConfig Instance] userLogged]) {
        [dic setObject:[[LoginConfig Instance] userID] forKey:@"userId"];
    }
    // 请求服务器获取数据
    [self getArrayFromServer:ServiceList_Url path:ServiceList_Path method:@"GET" parameters:dic xmlParentNode:@"serviceType" success:^(NSMutableArray *result) {
        [self.serviceArray removeAllObjects];
        for (NSDictionary *dic in result) {
            [self.serviceArray addObject: [[ServiceList alloc] initWithDictionary:dic]];
        }
        
        [self addDefaultServices];
        
        [self.collectionView.header endRefreshing];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        if (self.serviceArray.count == 0) {
            [self addDefaultServices];
        }
        [self.collectionView.header endRefreshing];
    }];
}


#pragma mark - 追加默认便民服务
- (void)addDefaultServices
{
    ServiceList *houseRepair = [[ServiceList alloc] init];
    houseRepair.serviceId = ServiceID_HouseRepair;
    [self.serviceArray addObject:houseRepair];
    
    ServiceList *pipeClean = [[ServiceList alloc] init];
    pipeClean.serviceId = ServiceID_PipeClean;
    [self.serviceArray addObject:pipeClean];
    
    ServiceList *waterElectricRepair = [[ServiceList alloc] init];
    waterElectricRepair.serviceId = ServiceID_WaterElectricRepair;
    [self.serviceArray addObject:waterElectricRepair];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

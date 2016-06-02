//
//  WaresListViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "WaresListViewController.h"
#import "StoreCollectionViewCell.h"
#import "WaresDetailViewController.h"
#import "FilterViewController.h"
#import "ShoppingCartViewController.h"
#import <MJRefresh.h>

#pragma mark - 宏定义区
#define StoreCollectionCellNibName                  @"StoreCollectionViewCell"

#define WaresListPageSize           (18)

@interface WaresListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FilterViewDelegate, UITextFieldDelegate>
@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *rightNavView;

@property (retain, nonatomic) IBOutlet UIView *searchBorderView;
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;

// 商品信息数组
@property (nonatomic, retain) NSMutableArray    *waresArray;

@property (nonatomic, retain) NSString      *filters;

@property (nonatomic, assign) NSInteger     pageNum;

@end

@implementation WaresListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化导航栏信息
    self.navigationItem.title = Str_Store_WaresList;
    [self setNavBarLeftItemAsBackArrow];
    self.rightNavView.frame = Rect_WaresList_NavBarRightItem;
    [self setNavBarItemRightView:self.rightNavView];
    
    [self initBasicDataInfo];
    self.searchBorderView.layer.borderColor = COLOR_RGB(200, 200, 200).CGColor;
    self.searchBorderView.layer.borderWidth = 1.0;
    self.searchBorderView.layer.cornerRadius = 4.0;
 
    self.collectionView.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
    self.collectionView.layer.borderWidth = 1.0;
    self.collectionView.layer.cornerRadius = 2.0;
    
    
    // 添加下拉刷新、下拉加载更多
    self.pageNum = 1;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getWaresDataFromService];
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.waresArray.count == self.pageNum*WaresListPageSize) {
            self.pageNum++;
            [self getWaresDataFromService];
        }
    }];

    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.header = header;
    self.collectionView.footer = footer;
    
    // 设置搜索框代理
    self.searchTextField.delegate = self;
    
    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pageNum = 1;
    [self getWaresDataFromService];
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
    return self.waresArray.count;
}


// 加载CollectionViewCell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCollectionViewCell *cell = (StoreCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:StoreCollectionCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.waresArray objectAtIndex:indexPath.row] byIsHomeView:NO forCellId:indexPath.row andTotalCount:self.waresArray.count];
    
    return cell;
}


#pragma mark - CollectionView代理
// CollectionView元素选择事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
    WaresList *model = (WaresList *)[self.waresArray objectAtIndex:indexPath.row];
    vc.waresId = model.goodsId;
    vc.efromType = E_FromViewType_WareList;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (Screen_Width-20)/3.0 - 0.1;
    CGFloat height = 150.0/102.0 * width;

    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}


#pragma mark - SearchTextField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getWaresDataFromService];
    return YES;
}



#pragma mark - 按钮点击事件
// 搜索按钮点击事件处理函数
// 搜索按钮点击事件处理函数
- (IBAction)searchBtnClickHandler:(id)sender
{
    [self getWaresDataFromService];
}

// 购物车按钮点击事件处理函数
- (IBAction)cartBtnClickHandler:(id)sender
{
    ShoppingCartViewController *vc = [[ShoppingCartViewController alloc] init];
    vc.eFromType = E_CartViewFromType_Push;
    [self.navigationController pushViewController:vc animated:YES];
}

// 类别筛选按钮点击事件处理函数
- (IBAction)catagoryBtnClickHandler:(id)sender
{
    FilterViewController *vc = [[FilterViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.waresArray = [[NSMutableArray alloc] init];
    
    // 注册CollectionViewCell Nib
    UINib *nibForWares = [UINib nibWithNibName:StoreCollectionCellNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForWares forCellWithReuseIdentifier:StoreCollectionCellNibName];
}


// 从服务器上获取商品数据
- (void)getWaresDataFromService
{
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.projectId, @"2", [NSString stringWithFormat:@"%ld", (long)self.pageNum], [NSString stringWithFormat:@"%ld",(long)WaresListPageSize], self.searchTextField.text] forKeys:@[@"projectId", @"moduleType", @"pageNum", @"perSize", @"goodsName"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:WaresListByModule_Url path:WaresListByModule_Path method:@"GET" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
        if (self.pageNum == 1) {
            [self.waresArray removeAllObjects];
        }
        
        for (NSDictionary *dic in result) {
            [self.waresArray addObject: [[WaresList alloc] initWithDictionary:dic]];
        }
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        if (self.waresArray.count < self.pageNum*WaresListPageSize) {
            [self.collectionView.footer noticeNoMoreData];
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        [self.collectionView reloadData];
    }];
}


// 手势隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma mark - FilterViewDelegate
- (void)setFileterData:(NSString *)filters
{
    self.filters = filters;
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

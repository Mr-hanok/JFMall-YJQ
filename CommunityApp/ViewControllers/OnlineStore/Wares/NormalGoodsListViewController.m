//
//  NormalGoodsListViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "NormalGoodsListViewController.h"
#import "GoodsCollectionViewCell.h"
#import "ShoppingCartViewController.h"
#import "WaresDetailViewController.h"
#import <MJRefresh.h>
#import "DBOperation.h"
#import "FilterCell.h"

#pragma mark - 宏定义区
#define GoodsCollectionViewCellNibName  @"GoodsCollectionViewCell"
#define FilterCellNibName      @"FilterCell"

#define WaresListPageSize                   (10)

@interface NormalGoodsListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITextFieldDelegate, UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchBorderView;
@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
@property (strong, nonatomic) IBOutlet UIView *rightNavView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *filterGroupView;
@property (weak, nonatomic) IBOutlet UIButton *goodsCountInCart;

@property (weak, nonatomic) IBOutlet UIView *searchTypeBgView;
@property (weak, nonatomic) IBOutlet UIView *searchTypeView;
@property (weak, nonatomic) IBOutlet UILabel *searchTypeLabel;
@property (nonatomic, assign) NSInteger     searchType; //（0、商品；1、商家；2、分类）

@property (nonatomic, retain) NSMutableArray    *goodsArray;    // 商品信息数组
@property (nonatomic, assign) NSInteger         pageNum;        // 当前页码

@property (nonatomic, copy) NSString    *sortType;      // 排序类型

// Filter 排序
@property (weak, nonatomic) IBOutlet UIView *filterBgView;
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterTvConstraint;
@property (retain, nonatomic) NSArray *filterTvMultiArray;
@property (retain, nonatomic) NSArray *filterTvPriceArray;
@property (copy, nonatomic) NSString *filterTvMultiCounter;
@property (copy, nonatomic) NSString *filterTvPriceCounter;
@property (copy, nonatomic) NSString *filterTvCurrentCounter;
@end

@implementation NormalGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化导航栏信息
    self.navigationItem.title = Str_Store_WaresList;
    [self setNavBarLeftItemAsBackArrow];
    self.rightNavView.frame = Rect_LimitBuy_NavBarRightItem;
    [self setNavBarItemRightView:self.rightNavView];

    // 初始化搜索框Border
    self.searchBorderView.layer.borderColor = COLOR_RGB(200, 200, 200).CGColor;
    self.searchBorderView.layer.borderWidth = 1.0;
    self.searchBorderView.layer.cornerRadius = 4.0;

    // 初始化基本信息
    [self initBasicDataInfo];

    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

    // 添加下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getGoodsDataFromServerBySearchContent];
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNum++;
        [self getGoodsDataFromServerBySearchContent];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.goodsCollectionView.header = header;
    self.goodsCollectionView.footer = footer;

    self.pageNum = 1;
    [self getGoodsDataFromServerBySearchContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateGoodsCountInCart];
}

- (void)initFilter {
    _filterTvConstraint.constant = (Screen_Height - (Navigation_Bar_Height + 50 + 45)) / 2.0;
    _filterBgView.backgroundColor = COLOR_RGBA(49,49,49,0.5);
    
    // 综合排序 数组
    self.filterTvMultiArray = [[NSArray alloc]initWithObjects:@"综合",@"新品",@"促销", nil];
    
    // 价格排序 数组
    self.filterTvPriceArray = [[NSArray alloc]initWithObjects:@"价格从高到低", @"价格从低到高", nil];
}

#pragma mark - Filter 获取当前列表数组数据
- (NSArray *)filterTvCurrentArray {
    NSArray *array = nil;
    UIButton *multiBtn = (UIButton *)[self.filterGroupView viewWithTag:1];
    UIButton *priceBtn = (UIButton *)[self.filterGroupView viewWithTag:4];
    
    if (multiBtn.selected) {
        array = self.filterTvMultiArray;
        self.filterTvCurrentCounter = self.filterTvMultiCounter;
    }
    else if (priceBtn.selected) {
        array = self.filterTvPriceArray;
        self.filterTvCurrentCounter = self.filterTvPriceCounter;
    }
    
    return array;
}


#pragma mark - 是否显示FilterView
- (void)isShowFilterView:(BOOL)isShow {
    isShow ? (_filterBgView.hidden = NO) : (_filterBgView.hidden = YES);
}

#pragma mark - Filter tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self filterTvCurrentArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterCell *cell = [self.filterTableView dequeueReusableCellWithIdentifier:FilterCellNibName forIndexPath:indexPath];
    
    if(self.filterTvCurrentCounter.intValue == indexPath.row) {
        [cell loadCellData:[[self filterTvCurrentArray]objectAtIndex:indexPath.row] isSelected:YES];
    }
    else {
        [cell loadCellData:[[self filterTvCurrentArray]objectAtIndex:indexPath.row] isSelected:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIButton *multiBtn = (UIButton *)[self.filterGroupView viewWithTag:1];
    UIButton *priceBtn = (UIButton *)[self.filterGroupView viewWithTag:4];
    
    if (multiBtn.selected) {
        self.filterTvMultiCounter = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        self.sortType = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    else if (priceBtn.selected) {
        self.filterTvPriceCounter = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        self.sortType = [NSString stringWithFormat:@"%ld", (indexPath.row + 4)];
    }
    [self getGoodsDataFromServerBySearchContent];
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.goodsArray = [[NSMutableArray alloc] init];
    
    self.sortType = @"0";
    self.filterTvMultiCounter = @"0";
    self.filterTvPriceCounter = @"0";
    self.searchType = 0;
    
    [_searchTypeBgView setHidden:YES];
    [_searchTypeView setHidden:YES];
    
    [self initFilter];
    // 注册CollectionViewCell Nib
    // 商品
    UINib *nibForGoods = [UINib nibWithNibName:GoodsCollectionViewCellNibName bundle:[NSBundle mainBundle]];
    [self.goodsCollectionView registerNib:nibForGoods forCellWithReuseIdentifier:GoodsCollectionViewCellNibName];
    
    // Filter 注册
    UINib *nibForFilterCellNibName = [UINib nibWithNibName:FilterCellNibName bundle:[NSBundle mainBundle]];
    [self.filterTableView registerNib:nibForFilterCellNibName forCellReuseIdentifier:FilterCellNibName];
    
    [self.searchTextField setText:self.searchContent];
}

#pragma mark - 更新购物车商品数
- (void)updateGoodsCountInCart
{
    NSInteger count = [[DBOperation Instance] getTotalWaresAndServicesCountInCart];
    if (count  <= 0) {
        [self.goodsCountInCart setHidden:YES];
    }else if (count < 10) {
        [self.goodsCountInCart setTitle:[NSString stringWithFormat:@"%ld", (long)count] forState:UIControlStateNormal];
        [self.goodsCountInCart setHidden:NO];
    }else {
        [self.goodsCountInCart setTitle:@""forState:UIControlStateNormal];
        [self.goodsCountInCart setHidden:NO];
    }
}


#pragma mark - CollectionDataSource代理
// 设计该CollectionView的Section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger nums = 1;
    
    return nums;
}

// 设计每个section的Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}


// 加载CollectionViewCell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCollectionViewCell *cell = (GoodsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollectionViewCellNibName forIndexPath:indexPath];
    [cell loadCellData:[self.goodsArray objectAtIndex:indexPath.row]];
    
    // 商品图片点击事件Block
    [cell setGoodsImgBtnClickBlock:^{
        WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
        WaresList *wares = [self.goodsArray objectAtIndex:indexPath.row];
        vc.waresId = wares.goodsId;
        vc.efromType = E_FromViewType_WareList;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // 购物车图标点击事件Block
    [cell setCartBtnClickBlock:^{
        if ([self isGoToLogin]) {
            // 向购物车中插入数据
            WaresList *wares = [self.goodsArray objectAtIndex:indexPath.row];
            WaresDetail *detail = [[WaresDetail alloc] initWithWaresList:wares];
            [[DBOperation Instance] insertWaresData:detail];
            [self updateCartInfoToServerSuccess:^(NSString *result) {
                // 更新购物车商品数
                [self updateGoodsCountInCart];
            } failure:^(NSError *error) {
            }];
        }
    }];
    
    return cell;
}


#pragma mark - CollectionView代理
// CollectionView元素选择事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
    WaresList *wares = [self.goodsArray objectAtIndex:indexPath.row];
    vc.waresId = wares.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (Screen_Width)/2.0;
    CGFloat height = width + 50.0;
    
    return CGSizeMake(width, height);
}


#pragma mark - 从服务器端获取数据
// 根据查询和排序条件从服务器获取商品数据
- (void)getGoodsDataFromServerBySearchContent
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString  *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[projectId, [NSString stringWithFormat:@"%ld",(long)WaresListPageSize], [NSString stringWithFormat:@"%ld", (long)self.pageNum], self.sortType, self.searchTextField.text, [NSString stringWithFormat:@"%ld", (long)_searchType], @"7"] forKeys:@[@"projectId", @"perSize", @"pageNum", @"type", @"searchField", @"searchType", @"moduleType"]];
    
    if (self.eSearchGoodsType == E_SearchGoodsType_Category) {
        if (self.goodsCategory != nil) {
            [dic setObject:self.goodsCategory.categoryId forKey:@"categoryId"];
            if ([self.goodsCategory.categoryFlag isEqualToString:@"0"]) {
                [dic setObject:@"1" forKey:@"categoryFlag"];
            }else {
                [dic setObject:@"2" forKey:@"categoryFlag"];
            }
        }
    }else {
        [dic setObject:@"" forKey:@"categoryId"];
        [dic setObject:@"0"forKey:@"categoryFlag"];
    }
    
    // 请求服务器获取数据
  //  [self getArrayFromServer:SurroundBusiness_Url path:SurroundBusiness_Path method:@"POST" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
    [self getArrayFromServer:GoodsListBySearch_Url path:GoodsListBySearch_Path method:@"POST" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
        if (self.pageNum == 1) {
            [self.goodsArray removeAllObjects];
        }
        for (NSDictionary *dic in result) {
            [self.goodsArray addObject: [[WaresList alloc] initWithDictionary:dic]];
        }
        
        [self.goodsCollectionView.header endRefreshing];
        [self.goodsCollectionView.footer endRefreshing];
        if (self.goodsArray.count < self.pageNum*WaresListPageSize) {
            [self.goodsCollectionView.footer noticeNoMoreData];
        }
        [self.goodsCollectionView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.goodsCollectionView.header endRefreshing];
        [self.goodsCollectionView.footer endRefreshing];
    }];
}



#pragma mark - SearchTextField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.pageNum = 1;
    [self getGoodsDataFromServerBySearchContent];
    return YES;
}



#pragma mark - 按钮点击事件
// 搜索按钮点击事件处理函数
- (IBAction)searchBtnClickHandler:(id)sender
{
    self.pageNum = 1;
    [self getGoodsDataFromServerBySearchContent];
}

// 购物车按钮点击事件处理函数
- (IBAction)cartBtnClickHandler:(id)sender
{
    ShoppingCartViewController *vc = [[ShoppingCartViewController alloc] init];
    vc.eFromType = E_CartViewFromType_Push;
    [self.navigationController pushViewController:vc animated:YES];
}

// 筛选按钮点击事件处理函数
- (IBAction)FilterBtnClickHandler:(UIButton *)sender
{
    self.pageNum = 1;
    
    for (int i=1; i<5; i++) {
        if (i != sender.tag) {
            UIButton *btn = (UIButton *)[self.filterGroupView viewWithTag:i];
            [btn setSelected:NO];
        }
    }
    [sender setSelected:YES];
    
    switch (sender.tag) {
        // 筛选
        case 1:
            {
               [self.filterTableView reloadData];
                _filterBgView.hidden ? [self isShowFilterView:YES] : [self isShowFilterView:NO];
            }
            break;
        
        // 综合
        case 2:
            {
                _filterBgView.hidden ? nil : [self isShowFilterView:NO];
                self.sortType = @"0";
                [self getGoodsDataFromServerBySearchContent];
            }
            
            break;
        
        // 销量
        case 3:
            {
                 _filterBgView.hidden ? nil : [self isShowFilterView:NO];
                self.sortType = @"3";
                [self getGoodsDataFromServerBySearchContent];
            }
            break;
            
        // 价格
        case 4:
            {
                [self.filterTableView reloadData];
                _filterBgView.hidden ? [self isShowFilterView:YES] : [self isShowFilterView:NO];
            }
            break;
        default:
            break;
    }
}


#pragma mark - 选择搜索类型按钮点击事件处理函数
- (IBAction)searchTypeBtnClickHandler:(id)sender
{
    [_searchTypeBgView setHidden:!_searchTypeBgView.isHidden];
    [_searchTypeView setHidden:!_searchTypeView.isHidden];
}

#pragma mark - 下拉框搜索类型选择
- (IBAction)searchTypeSelect:(UIButton *)sender
{
    switch (sender.tag) {
            // 商品
        case 1001:
            _searchType = 0;
            [_searchTypeLabel setText:@"商品"];
            _searchTextField.placeholder = @"搜索商品";
            break;
            
            // 商家
        case 1002:
            _searchType = 1;
            [_searchTypeLabel setText:@"商家"];
            _searchTextField.placeholder = @"搜索商家";
            break;
            
            // 分类
        case 1003:
            _searchType = 2;
            [_searchTypeLabel setText:@"分类"];
            _searchTextField.placeholder = @"搜索分类";
            break;
            
        default:
            break;
    }
    
    [_searchTypeBgView setHidden:YES];
    [_searchTypeView setHidden:YES];
}



#pragma mark - 手势隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    _filterBgView.hidden ? nil : [self isShowFilterView:NO];
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

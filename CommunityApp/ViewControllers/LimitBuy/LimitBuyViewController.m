//
//  LimitBuyViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "LimitBuyViewController.h"
#import "LimitBuyCollectionViewCell.h"
#import "LimitBuySelectorTableViewCell.h"
#import "ShoppingCartViewController.h"
#import "WaresDetailViewController.h"
#import <MJRefresh.h>
#import "DBOperation.h"
#import "LimitBuySelector.h"

#pragma mark - 宏定义区
#define LimitBuyCollectionViewCellNibName           @"LimitBuyCollectionViewCell"
#define LimitBuySelectorTableViewCellNibName        @"LimitBuySelectorTableViewCell"

#define WaresListPageSize                   (10)

@interface LimitBuyViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchBorderView;
@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
@property (strong, nonatomic) IBOutlet UIView *rightNavView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *filterGroupView;
@property (weak, nonatomic) IBOutlet UIButton *goodsCountInCart;
@property (weak, nonatomic) IBOutlet UIImageView *topLine;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;

// 下拉选框
@property (weak, nonatomic) IBOutlet UIView *goodsSelectorView;
@property (weak, nonatomic) IBOutlet UITableView *goodsSelectorTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsSelectorConstraint;

//按钮
@property (weak, nonatomic) IBOutlet UIButton *selectorFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectorPriceBtn;

//变量
@property (nonatomic, retain) NSMutableArray    *goodsArray;    // 商品信息数组
@property (nonatomic, assign) NSInteger         pageNum;        // 当前页码

// line
@property (weak, nonatomic) IBOutlet UIImageView *vLine1;
@property (weak, nonatomic) IBOutlet UIImageView *vLine2;
@property (weak, nonatomic) IBOutlet UIImageView *vLine3;
@property (weak, nonatomic) IBOutlet UIImageView *vLine4;

@property (weak, nonatomic) IBOutlet UIView *searchTypeBgView;
@property (weak, nonatomic) IBOutlet UIView *searchTypeView;
@property (weak, nonatomic) IBOutlet UILabel *searchTypeLabel;
@property (nonatomic, assign) NSInteger     searchType; //（0、商品；1、商家；2、分类）


@property (nonatomic, copy) NSString *sortType;     // 排序类型

@property (strong,nonatomic) NSMutableArray *timerArray;
@property (retain,nonatomic) NSMutableArray *filterSelectorArray;
@property (retain,nonatomic) NSMutableArray *priceSelectorArray;


@end

@implementation LimitBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Comm_LimitBuy;
    
    [self setNavBarLeftItemAsBackArrow];
    self.rightNavView.frame = Rect_LimitBuy_NavBarRightItem;
    [self setNavBarItemRightView:self.rightNavView];
    
    // 初始化搜索框Border
    self.searchBorderView.layer.borderColor = COLOR_RGB(211, 200, 210).CGColor;
    self.searchBorderView.layer.borderWidth = 0.5;
    self.searchBorderView.layer.cornerRadius = 4.0;

    [Common updateLayout:_vLine1 where:NSLayoutAttributeWidth constant:0.5];
    [Common updateLayout:_vLine2 where:NSLayoutAttributeWidth constant:0.5];
    [Common updateLayout:_vLine3 where:NSLayoutAttributeWidth constant:0.5];
    [Common updateLayout:_topLine where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
    
    // 初始化基本信息
    [self initBasicDataInfo];
    
    [self initGoodsSelector];
    
    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    // 添加下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getGoodsDataFromService];
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.goodsArray.count == self.pageNum*WaresListPageSize) {
            self.pageNum++;
            [self getGoodsDataFromService];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.goodsCollectionView.header = header;
    self.goodsCollectionView.footer = footer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pageNum = 1;
    [self getGoodsDataFromService];
    
    [self updateGoodsCountInCart];
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

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.goodsArray = [[NSMutableArray alloc]init];
    self.timerArray = [[NSMutableArray alloc]init];
    
    [self initFilterSelectorArray];
    [self initPriceSelectorArray];
//    （0、没有条件；1、请求新品；2、请求促销商品；3、按销量从高到底；4、按价格从高到低；5、按价格从低到高）
    self.sortType = @"0";
    
    // 注册CollectionViewCell Nib
    UINib *nibForGoods = [UINib nibWithNibName:LimitBuyCollectionViewCellNibName bundle:[NSBundle mainBundle]];
    [self.goodsCollectionView registerNib:nibForGoods forCellWithReuseIdentifier:LimitBuyCollectionViewCellNibName];
    
    // 注册LimitBuySelector Nib
    UINib *nibForSelector = [UINib nibWithNibName:LimitBuySelectorTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.goodsSelectorTableView registerNib:nibForSelector forCellReuseIdentifier:LimitBuySelectorTableViewCellNibName];
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

#pragma mark - 初始化商品选择下拉菜单
- (void)initGoodsSelector {
    _goodsSelectorConstraint.constant = (Screen_Height - (Navigation_Bar_Height + 50 + 45)) / 2.0;
    _goodsSelectorView.backgroundColor = COLOR_RGBA(49,49,49,0.5);
}

- (void)initFilterSelectorArray {
    self.filterSelectorArray = [[NSMutableArray alloc]init];
    NSDictionary *dic1 = [[NSDictionary alloc]initWithObjects:@[@"0", @"综合", @"1"] forKeys:@[@"categoryId", @"categoryName", @"isSelected"]];
    NSDictionary *dic2 = [[NSDictionary alloc]initWithObjects:@[@"1", @"新品", @"0"] forKeys:@[@"categoryId", @"categoryName", @"isSelected"]];
    NSDictionary *dic3 = [[NSDictionary alloc]initWithObjects:@[@"2", @"促销", @"0"] forKeys:@[@"categoryId", @"categoryName", @"isSelected"]];
    [self.filterSelectorArray addObject: [[LimitBuySelector alloc] initWithDictionary:dic1]];
    [self.filterSelectorArray addObject: [[LimitBuySelector alloc] initWithDictionary:dic2]];
    [self.filterSelectorArray addObject: [[LimitBuySelector alloc] initWithDictionary:dic3]];
}

- (void)initPriceSelectorArray {
    self.priceSelectorArray = [[NSMutableArray alloc]init];
    NSDictionary *dic1 = [[NSDictionary alloc]initWithObjects:@[@"4", @"价格从高到低", @"1"] forKeys:@[@"categoryId", @"categoryName", @"isSelected"]];
    NSDictionary *dic2 = [[NSDictionary alloc]initWithObjects:@[@"5", @"价格从低到高", @"0"] forKeys:@[@"categoryId", @"categoryName", @"isSelected"]];
    [self.priceSelectorArray addObject: [[LimitBuySelector alloc] initWithDictionary:dic1]];
    [self.priceSelectorArray addObject: [[LimitBuySelector alloc] initWithDictionary:dic2]];
}

// 设置cell被选中的类型
- (void)setCategorySelectedCellEnum:(NSInteger)indexRow {
    NSInteger count;
    NSInteger max =  [self currentSelectorArray].count;
    for(count = 0; count < max; count++){
        if (count == indexRow) {
            LimitBuySelector *selector = [[self currentSelectorArray]objectAtIndex:count];
            selector.isSelected = @"1";
        }
        else
        {
            LimitBuySelector *selector = [[self currentSelectorArray]objectAtIndex:count];
            selector.isSelected = @"0";
        }
    }
}

#pragma mark - TableViewDataSource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self currentSelectorArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LimitBuySelectorTableViewCell *cell = [_goodsSelectorTableView dequeueReusableCellWithIdentifier:LimitBuySelectorTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[[self currentSelectorArray]objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setCategorySelectedCellEnum:indexPath.row];
    [_goodsSelectorView setHidden:YES];
    LimitBuySelector *selector = [[self currentSelectorArray]objectAtIndex:indexPath.row];
    self.sortType = selector.categoryId;
    [self getGoodsDataFromService];
}

-(NSArray *)currentSelectorArray
{
    NSArray* array = nil;
    if(_selectorFilterBtn.selected)
    {
        array = self.filterSelectorArray;
    }
    else if(_selectorPriceBtn.selected)
    {
        array = self.priceSelectorArray;
    }
    return array;
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
    LimitBuyCollectionViewCell *cell = (LimitBuyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:LimitBuyCollectionViewCellNibName forIndexPath:indexPath];
    if (cell.timer) {
        [self.timerArray removeObject:cell.timer];
    }
    [cell setClearTimer:^(NSTimer *timer) {
        [self.timerArray removeObject:timer];
    }];
    [cell loadCellData:[self.goodsArray objectAtIndex:indexPath.row]];
    if (cell.timer) {
        [self.timerArray addObject:cell.timer];
    }
    // 购物车图标点击事件Block
    [cell setCartBtnClickBlock:^{
        if ([self isGoToLogin]) {
            // 向购物车中插入数据
            WaresList *wares = [self.goodsArray objectAtIndex:indexPath.row];
            
            NSDate *now = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *startTime = [formatter dateFromString:wares.limitStartTime];
            NSDate *endTime = [formatter dateFromString:wares.limitEndTime];
            if ([now compare:endTime] == NSOrderedDescending || wares.limitStartTime.length <= 0 || wares.limitEndTime.length <= 0) {
                [Common showBottomToast:@"商品已过期, 不能加入购物车"];
            }else if ([now compare:startTime] == NSOrderedAscending) {
                [Common showBottomToast:@"商品未开始售卖, 不能加入购物车"];
            }else {
                WaresDetail *detail = [[WaresDetail alloc] initWithWaresList:wares];
                [[DBOperation Instance] insertWaresData:detail];
                [self updateCartInfoToServerSuccess:^(NSString *result) {
                    // 更新购物车商品数
                    [self updateGoodsCountInCart];
                } failure:^(NSError *error) {
                }];
            }
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
    vc.sellerId = wares.sellerId;
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
// 从服务器上获取商品数据
- (void)getGoodsDataFromService
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString  *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[projectId, [NSString stringWithFormat:@"%ld",(long)WaresListPageSize], [NSString stringWithFormat:@"%ld", (long)self.pageNum], self.sortType, self.searchTextField.text, [NSString stringWithFormat:@"%ld", (long)_searchType], @"3", @"", @"0"] forKeys:@[@"projectId", @"perSize", @"pageNum", @"type", @"searchField", @"searchType", @"moduleType", @"categoryId", @"categoryFlag"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:GoodsListBySearch_Url path:GoodsListBySearch_Path method:@"POST" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
        if (self.pageNum == 1) {
            [self.goodsArray removeAllObjects];
            [self clearTimers];
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
    [self getGoodsDataFromService];
    return YES;
}

#pragma mark - 按钮点击事件
// 搜索按钮点击事件处理函数
- (IBAction)searchBtnClickHandler:(id)sender
{
    self.pageNum = 1;
    [self getGoodsDataFromService];
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
                [_goodsSelectorTableView reloadData];
                _goodsSelectorView.hidden ? [_goodsSelectorView setHidden:NO] : [_goodsSelectorView setHidden:YES];
            }
            break;
            
        // 综合
        case 2:
            {
                self.sortType = @"0";
                _goodsSelectorView.hidden ? nil:[_goodsSelectorView setHidden:YES];
                [self getGoodsDataFromService];
            }
            
            break;
            
        // 销量
        case 3:
            {
                self.sortType = @"3";
                _goodsSelectorView.hidden ? nil :[_goodsSelectorView setHidden:YES];
                [self getGoodsDataFromService];
            }
            break;
            
        // 价格
        case 4:
            {
                [_goodsSelectorTableView reloadData];
                _goodsSelectorView.hidden ? [_goodsSelectorView setHidden:NO] : [_goodsSelectorView setHidden:YES];
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
    [_goodsSelectorView setHidden:YES];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

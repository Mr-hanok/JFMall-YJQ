//
//  ShoppingCartViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "SubmitOrderViewController.h"
#import "ShoppingCartTableViewCell.h"
#import "ShoppingCartServiceTableViewCell.h"
#import "CartBottomBar.h"
#import "WaresDetailViewController.h"
#import "DetailServiceViewController.h"
#import "DBOperation.h"
#import "ShoppingCartHeaderView.h"
#import "ShoppingCartFooterView.h"
#import "ShoppingCartCollectionViewCell.h"
#import "GoodsListViewController.h"
#import "ConfirmOrderViewController.h"
#import "GoodsForSaleViewController.h"


#pragma mark - 宏定义区
#define ShoppingCartTableViewCellNibName            @"ShoppingCartTableViewCell"
#define ShoppingCartServiceTableViewCellNibName     @"ShoppingCartServiceTableViewCell"
#define ShoppingCartHeaderViewNibName               @"ShoppingCartHeaderView"
#define ShoppingCartFooterViewNibName               @"ShoppingCartFooterView"
#define ShoppingCartCollectionViewCellNibName       @"ShoppingCartCollectionViewCell"


@interface ShoppingCartViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *cartBottomView;      //购物车底栏视图
@property (retain, nonatomic) IBOutlet UIButton *allCheckBox;       //导航栏下边的全选按钮
@property (strong, nonatomic) IBOutlet UIView *tableFooter;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine2;
@property (weak, nonatomic) IBOutlet UIImageView *topLine;
@property (weak, nonatomic) IBOutlet UIView *allCheckBoxView;

@property (nonatomic, retain) UIView  *navRightItem;

@property (retain, nonatomic) UIButton          *rightBarTitle;     //导航栏右侧<编辑/完成>按钮
@property (retain, nonatomic) CartBottomBar     *carBar;            //购物车Bar(编辑/完成)状态不同，内容不同
@property (assign, nonatomic) BOOL              isEditting;         //是否是编辑状态

@property (retain, nonatomic) NSMutableArray    *cartWaresArray;    //商品数组
@property (retain, nonatomic) NSMutableArray    *cartServiceArray;  //服务数组

@property (assign, nonatomic) CGFloat           totalVal;           //购物车合计

@property (assign, nonatomic) NSInteger         selectedCount;      //已选择的购物车货物条目数(checkbox数)

@property (nonatomic, retain) NSMutableArray    *cartGoodsArray;    //购物车数据数组 根据商家ID区分

@property (nonatomic, retain) NSMutableArray    *selectedCountInSection;    //已选择的货物数InSection

@property (nonatomic, retain) NSMutableArray    *recommendGoodsArray;       //推荐商品数据数组

@property (nonatomic, strong) NSMutableDictionary    *supportPaymentType;        /**< 支持的支付方式 */

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavBar];          // 初始化导航栏
    
    [Common updateLayout:_topLine where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_bottomLine2 where:NSLayoutAttributeHeight constant:0.5];
    
    [self initBasicDataInfo];   // 初始化基本数据
    
    self.isEditting = NO;
    
    self.selectedCount = 0;
    self.totalVal = 0;
    
    [self initCartBottomView];// 初始化购物车底栏视图
    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self initCartView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadCartInfoFromServer) name:ShoppingCartChangedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ShoppingCartChangedNotification object:nil];
}

//// 重载viewWillAppear
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [self initCartView];
//}

- (void)initCartView {
    if (self.eFromType != E_CartViewFromType_Push) {
        self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.frame = CGRectMake(0, Screen_Height-BottomBar_Height, Screen_Width, BottomBar_Height);
    }
    
    [self downLoadCartInfoFromServer];
    
//    self.totalVal = 0.0;
//    self.allCheckBox.selected = NO;
//    self.selectedCount = 0;
    
//    [self initCartBottomView];  // 初始化购物车底栏视图
    
//    [self.tableView reloadData];
}

// 重载viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.rightBarTitle setSelected:NO];    // 重置导航栏右侧BarItem状态
}

#pragma mark - 更新购物车信息到本地
- (void)downLoadCartInfoFromServer
{
    self.selectedCount = 0;
    self.totalVal = 0;
    
    if(self.cartWaresArray.count>0){
        [self updateCartWaresAndServiceArray];
        [self updateCarBarDispInfo];
        [self getRecommendGoodsDataFromServer]; // 获取推荐商品
        [self.tableView reloadData];
    }else{
        //    return;
        NSString *userId = [[LoginConfig Instance] userID];
        
        //初始化参数
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[userId] forKeys:@[@"userId"]];
        
        [self getArrayFromServer:ShopCartSync_Url path:ShopCartSyncDownLoad_Path method:@"GET" parameters:dic xmlParentNode:@"goods" success:^(NSMutableArray *result) {
            [[DBOperation Instance] deleteCartAllData];
            for (NSDictionary *dic in result) {
                ShopCartModel *model = [[ShopCartModel alloc] initWithDictionary:dic];
                
                [[DBOperation Instance] syncWaresDataFromServer:model];
            }
            [self updateCartWaresAndServiceArray];
            [self updateCarBarDispInfo];
            [self getRecommendGoodsDataFromServer]; // 获取推荐商品
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
            NSLog(@"更新购物车失败");
        }];
    }
}




#pragma mark - 键盘显示、隐藏事件处理函数重写
- (void)keyboardDidShow:(NSNotification *)notification
{
    [super keyboardDidShow:notification];
    //    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+(self.keyboardHeight-99));
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+(self.keyboardHeight));
}

- (void)keyboardDidHide
{
    //    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height-(self.keyboardHeight-99));
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height-(self.keyboardHeight));
    [super keyboardDidHide];
}


#pragma mark - tableview datasource代理
// 设置Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 90.0;
    NSArray *sectionArray = [self.cartGoodsArray objectAtIndex:indexPath.section];
    ShopCartModel *model = [sectionArray objectAtIndex:indexPath.row];
    if (model.type == 1) {
        height = 60.0;
    }
    return height;
}

// 设置Section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cartGoodsArray.count;
}

// 设置section内Cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 0;
    NSArray *sectionArray = [self.cartGoodsArray objectAtIndex:section];
    rowNum = sectionArray.count;
    
    return rowNum;
}

// 加载Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = [self.cartGoodsArray objectAtIndex:indexPath.section];
    ShopCartModel * model = [sectionArray objectAtIndex:indexPath.row];
    if (model.type == 0) {
        ShoppingCartTableViewCell *cell = (ShoppingCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ShoppingCartTableViewCellNibName forIndexPath:indexPath];
        [cell loadCellData:model];
        if (self.allCheckBox.isSelected) {
            [cell setCheckBoxSelectStatus:YES];
        }else {
            [cell setCheckBoxSelectStatus:model.isSelected];
        }
        
        __weak ShoppingCartTableViewCell *weakSelf = cell;
        [cell.countBtn setCartCountChangeBlock:^(NSInteger count) {
            [[DBOperation Instance] updateWaresData:model.wsId withWaresStyle:model.waresStyle andCount:count];
            [self updateCartInfoToServerSuccess:^(NSString *result) {
                self.carBar.totalCount += count - model.count;
                model.count = count;
                [self updateCarBarDispInfo];
                
                [weakSelf resetShowPrice:model];
            } failure:^(NSError *error) {
            }];
            
        }];
        [cell setCheckBoxStatusChangeBlock:^(BOOL isSelected) {
            model.isSelected = isSelected;
            [self checkBoxChangeHandlerForStatus:isSelected andModel:model andIndexPath:indexPath];
            
            [ShopCartModel resetSpecialOfferUseRight:self.cartWaresArray];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:NO];
        }];
        return cell;
    }
    else{
        ShoppingCartServiceTableViewCell *cell = (ShoppingCartServiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ShoppingCartServiceTableViewCellNibName forIndexPath:indexPath];
        [cell loadCellData:model];
        [cell setCheckBoxSelectStatus:self.allCheckBox.selected];
        [cell setCheckBoxStatusChangeBlock:^(BOOL isSelected) {
            [self checkBoxChangeHandlerForStatus:isSelected andModel:model andIndexPath:indexPath];
            model.isSelected = isSelected;
        }];
        return cell;
    }
    
    return nil;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.keyboardIsVisible) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
    else {
        NSArray *sectionArray = [self.cartGoodsArray objectAtIndex:indexPath.section];
        ShopCartModel * model = [sectionArray objectAtIndex:indexPath.row];
        if (model.type == 0) {
            WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
            vc.waresId = model.wsId;
            vc.efromType = E_FromViewType_CartView;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            DetailServiceViewController *vc = [[DetailServiceViewController alloc] init];
            vc.serviceId = model.wsId;
            if (model.wsId != nil) {
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}


#pragma mark - Section Header&&Footer 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}


#pragma mark - Section Header&&Footer View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShoppingCartHeaderView *header = (ShoppingCartHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ShoppingCartHeaderViewNibName];
    NSArray *sectionArray = [self.cartGoodsArray objectAtIndex:section];
    if (sectionArray.count > 0) {
        ShopCartModel *model = [sectionArray objectAtIndex:0];
        if (model.sellerName != nil && ![model.sellerName isEqualToString:@""]) {
            [header.shopName setText:model.sellerName];
        }else {
            [header.shopName setText:@"社区自营"];
        }
        [header setStoreBtnBlock:^(ShoppingCartHeaderView *sectionHeader) {
            GoodsForSaleViewController *vc = [[GoodsForSaleViewController alloc] init];
                    vc.sellerName = model.sellerName;
                    vc.sellerId = model.sellerId;
                    vc.moduleType = model.moduleType;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    NSString *selCountInSection = [self.selectedCountInSection objectAtIndex:section];
    NSInteger selCount = [selCountInSection integerValue];
    [header.sectionCheckBox setSelected:selCount == sectionArray.count];
    
    
    [header setSectionCheckBoxClickBlock:^(ShoppingCartHeaderView *sectionHeader) {
        [sectionHeader.sectionCheckBox setSelected:!sectionHeader.sectionCheckBox.selected];
        
        NSString *selCountInSection = [NSString stringWithFormat:@"%zd", sectionArray.count];
        if (sectionHeader.sectionCheckBox.selected) {
            [self.selectedCountInSection setObject:selCountInSection atIndexedSubscript:section];
        }else {
            [self.selectedCountInSection setObject:@"0" atIndexedSubscript:section];
        }
        
        for (int i=0; i<sectionArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            ShoppingCartServiceTableViewCell *cell = (ShoppingCartServiceTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell setCheckBoxSelectStatus:sectionHeader.sectionCheckBox.selected];
            ShopCartModel *model = [sectionArray objectAtIndex:i];
            if (sectionHeader.sectionCheckBox.selected) {
                if (!model.isSelected) {
                    model.isSelected = YES;
                    self.selectedCount++;
                }
                
            }else{
                if (model.isSelected) {
                    model.isSelected = NO;
                    self.selectedCount--;
                }
            }
        }
        
        if (self.selectedCount == (self.cartWaresArray.count+self.cartServiceArray.count)) {
            self.allCheckBox.selected = YES;
        }else{
            self.allCheckBox.selected = NO;
        }
        
        [self updateCarBarDispInfo];
        
        [ShopCartModel resetSpecialOfferUseRight:self.cartWaresArray];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:NO];
    }];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ShoppingCartFooterView *footer = (ShoppingCartFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ShoppingCartFooterViewNibName];
    return footer;
}


#pragma mark - CollectionViewDataSource
// Collection Cell 数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.recommendGoodsArray.count;
}

// 装载Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartCollectionViewCell *cell = (ShoppingCartCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ShoppingCartCollectionViewCellNibName forIndexPath:indexPath];
    [cell loadCellData:[self.recommendGoodsArray objectAtIndex:indexPath.row]];
    return cell;
}

// Collection Cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
    RecommendGoods *goods = [self.recommendGoodsArray objectAtIndex:indexPath.row];
    vc.waresId = goods.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 从服务器获取推荐商品数据
- (void)getRecommendGoodsDataFromServer
{
    if (self.cartGoodsArray.count == 0) {
        [self.recommendGoodsArray removeAllObjects];
        //        [self.collectionView reloadData];
        //        self.tableFooter.frame = CGRectMake(0, 0, Screen_Width, 0);
        [self.allCheckBoxView setHidden:YES];
        [self.cartBottomView setHidden:YES];
        [self.navRightItem setHidden:YES];
        [Common showBottomToast:@"赶紧添加商品进购物车吧!"];
        self.tableView.tableFooterView = nil;
        return;
    }
    [self.allCheckBoxView setHidden:NO];
    [self.cartBottomView setHidden:NO];
    [self.navRightItem setHidden:NO];
    
    NSArray *sectionArray = [self.cartGoodsArray objectAtIndex:0];
    ShopCartModel * model = [sectionArray objectAtIndex:0];
    
    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[model.sellerId] forKeys:@[@"sellerId"]];
    
    [self getArrayFromServer:RecommendGoodsList_Url path:RecommendGoodsList_Path method:@"GET" parameters:dic xmlParentNode:@"result" success:^(NSMutableArray *result) {
        if (result.count > 0) {
            [self.recommendGoodsArray removeAllObjects];
            for (NSDictionary *dic in result) {
                [self.recommendGoodsArray addObject:[[RecommendGoods alloc] initWithDictionary:dic]];
            }
            [self.collectionView reloadData];
            self.tableFooter.frame = CGRectMake(0, 0, Screen_Width, 170);
            self.tableView.tableFooterView = self.tableFooter;
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


#pragma mark - 按钮点击事件处理函数
// 全选按钮点击事件处理函数
- (IBAction)allCheckBtnClickHandler:(id)sender
{
    [self.allCheckBox setSelected:!self.allCheckBox.selected];
    if (self.allCheckBox.selected) {
        self.selectedCount = self.cartWaresArray.count;
        for (ShopCartModel *model in self.cartWaresArray) {
            model.isSelected = YES;
        }
        
        for (int i = 0; i < self.selectedCountInSection.count; i++) {
            NSArray *sectionArray = [self.cartGoodsArray objectAtIndex:i];
            [self.selectedCountInSection setObject:[NSString stringWithFormat:@"%zd", sectionArray.count] atIndexedSubscript:i];
        }
    }else {
        self.selectedCount = 0;
        for (ShopCartModel *model in self.cartWaresArray) {
            model.isSelected = NO;
        }
        
        for (int i = 0; i < self.selectedCountInSection.count; i++) {
            [self.selectedCountInSection setObject:@"0" atIndexedSubscript:i];
        }
    }
    [self updateCarBarDispInfo];
    [ShopCartModel resetSpecialOfferUseRight:self.cartWaresArray];
    [self.tableView reloadData];
}


// 导航栏右侧BarItem点击事件处理函数
- (void)rightBarButtonItemClickHandler:(UIButton *)barBtn
{
    barBtn.selected = !barBtn.selected;
    self.isEditting = barBtn.selected;
    [self updateCarBarDispInfo];
}


// 推荐商品按钮点击事件处理函数
- (IBAction)recommendGoodsBtnClickHandler:(id)sender
{
    GoodsListViewController *vc = [[GoodsListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 文件域内公共方法
// 初始化导航栏
- (void)initNavBar
{
    // 初始化导航栏信息
    self.title = Str_Comm_Cart;
    
    _navRightItem = [[UIView alloc] init];
    _navRightItem.frame = Rect_Comm_NavBarRightItem;
    _navRightItem.backgroundColor = [UIColor clearColor];
    self.rightBarTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBarTitle.frame = CGRectMake(0, 0, 60, 30);
    [self.rightBarTitle setTitleColor:COLOR_RGB(87, 87, 87) forState:UIControlStateNormal];
    [self.rightBarTitle setTitle:Str_Cart_Edit forState:UIControlStateNormal];
    [self.rightBarTitle setTitle:Str_Cart_Complete forState:UIControlStateSelected];
    [self.rightBarTitle addTarget:self action:@selector(rightBarButtonItemClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_navRightItem addSubview:self.rightBarTitle];
    [self setNavBarItemRightView:_navRightItem];
    
    if (self.eFromType == E_CartViewFromType_Push) {
        [self setNavBarLeftItemAsBackArrow];
    }
    
    self.hidesBottomBarWhenPushed = NO;    // Push的时候隐藏TabBar
}

// 初始化基本数据
- (void)initBasicDataInfo
{
    self.cartWaresArray = [[NSMutableArray alloc] init];
    self.cartServiceArray = [[NSMutableArray alloc] init];
    self.cartGoodsArray = [[NSMutableArray alloc] init];
    self.selectedCountInSection = [[NSMutableArray alloc] init];
    self.recommendGoodsArray = [[NSMutableArray alloc] init];
    
    // 注册TableViewCell Nib
    // 商品用CellNib
    UINib *nibForWares = [UINib nibWithNibName:ShoppingCartTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForWares forCellReuseIdentifier:ShoppingCartTableViewCellNibName];
    
    // 服务用CellNib
    UINib *nibForService = [UINib nibWithNibName:ShoppingCartServiceTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForService forCellReuseIdentifier:ShoppingCartServiceTableViewCellNibName];
    
    // SectionHeaderNib
    UINib *headerNib = [UINib nibWithNibName:ShoppingCartHeaderViewNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:ShoppingCartHeaderViewNibName];
    
    // SectionFooterNib
    UINib *footerNib = [UINib nibWithNibName:ShoppingCartFooterViewNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:footerNib forHeaderFooterViewReuseIdentifier:ShoppingCartFooterViewNibName];
    
    // 推荐商品CellNib
    UINib *nibForRecommend = [UINib nibWithNibName:ShoppingCartCollectionViewCellNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForRecommend forCellWithReuseIdentifier:ShoppingCartCollectionViewCellNibName];
    
    // 同步购物车
    //    [self downLoadCartInfoFromServer];
}

// 初始化购物车底栏视图
- (void)initCartBottomView
{
    CGFloat tabViewHeight = Screen_Height-99-108;
    if (self.eFromType == E_CartViewFromType_Push) {
        tabViewHeight = Screen_Height-50-108;
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:tabViewHeight];
    [self.view addConstraint:constraint];
    
    self.carBar = [CartBottomBar instanceCartBottomBar];
    self.carBar.frame = CGRectMake(0, 0, self.cartBottomView.frame.size.width, self.cartBottomView.frame.size.height);
    [self.carBar setCartBottomType:E_CartBottomType_Normal];
    [self.carBar.rightBtn setTitle:@"立即结算" forState:UIControlStateNormal];
    [self.cartBottomView addSubview:self.carBar];
    __weak typeof(self) weakSelf = self;
    // 购物车底栏视图 右侧按钮点击事件Block函数
    [self.carBar setRightBtnClickBlock:^{
        if (weakSelf.isEditting) {
            // 点击删除按钮 处理内容
            if (weakSelf.selectedCount <= 0)
            {
                [Common showBottomToast:@"请选择商品"];
                return;
            }
            
            // 提示是否确认删除购物车中的商品
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除选中的商品吗？" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }else {
            if (self.selectedCount > 0) {
                if (![weakSelf checkPaymentType]) {
                    return;
                }
                
                BOOL isNoRight = NO;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected==YES and type==0"];
                for (NSArray *storeGoodsArray in weakSelf.cartGoodsArray) {
                    NSArray *selectGoodsArray = [storeGoodsArray filteredArrayUsingPredicate:predicate];
                    isNoRight = [ShopCartModel isSpecialOfferNoRight:selectGoodsArray];
                    if (isNoRight) {
                        break;
                    }
                }
                if (isNoRight) {
                    UIAlertView*aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已成功购买1件特价商品，如再次购买按原价进行计算，请仔细核对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [aler show];
                }
                
                ConfirmOrderViewController *vc = [[ConfirmOrderViewController alloc] init];
                vc.cartGoodsArray = [[NSMutableArray alloc] initWithArray:weakSelf.cartGoodsArray];
                NSMutableArray *cartDataArray = [[NSMutableArray alloc] initWithArray:weakSelf.cartWaresArray];
                [cartDataArray addObjectsFromArray:weakSelf.cartServiceArray];
                vc.cartArray = cartDataArray;
                vc.totalVal = weakSelf.totalVal;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            else {
                [Common showBottomToast:@"请选择商品"];
            }
        }
    }];
    
    [self.carBar setTotalCountChangeBlock:^(NSInteger count) {
        weakSelf.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count];
        if (count == 0) {
            weakSelf.tabBarItem.badgeValue = nil;
        }
    }];
}

- (BOOL)checkPaymentType
{
    BOOL result = YES;
    for (NSInteger i = 0; i < self.cartGoodsArray.count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected==YES and type==0"];
        NSArray *storeGoodsArray = self.cartGoodsArray[i];
        NSArray *selectGoodsArray = [storeGoodsArray filteredArrayUsingPredicate:predicate];
        for (ShopCartModel *model in selectGoodsArray) {
            if (![model.isPutGoods isEqualToString:@"1"]) {
                [Common showBottomToast:[NSString stringWithFormat:@"%@已下架", model.wsName]];
                return NO;
            }
            if ([model.storeRemainCount integerValue] < model.count) {
                [Common showBottomToast:[NSString stringWithFormat:@"%@库存不足", model.wsName]];
                return NO;
            }
            
        }
//        if (selectGoodsArray.count > 0) {
//            predicate = [NSPredicate predicateWithFormat:@"paymentType contains[cd] '1'"];
//            NSArray *online = [selectGoodsArray filteredArrayUsingPredicate:predicate];
//            predicate = [NSPredicate predicateWithFormat:@"paymentType contains[cd] '2'"];
//            NSArray *offline = [selectGoodsArray filteredArrayUsingPredicate:predicate];
//            if (!(online.count == selectGoodsArray.count || offline.count == selectGoodsArray.count)) {
//                [Common showBottomToast:@"不同支付方式的商品不能同时下单"];
//                result = NO;
//                break;
//            }
//        }
    }
    return result;
}

// 更新购物车内商品和服务
- (void)updateCartWaresAndServiceArray
{
    [self.cartWaresArray removeAllObjects];
    [self.cartWaresArray addObjectsFromArray:[[DBOperation Instance] getAllWaresOrServiceDataInCartByType:0]];
    
    [self.cartGoodsArray removeAllObjects];
    [self.selectedCountInSection removeAllObjects];
    
    if (self.cartWaresArray.count == 0) {
        // nothing to do
    }else if (self.cartWaresArray.count == 1) {
        [self.cartGoodsArray addObject:self.cartWaresArray];
        [self.selectedCountInSection addObject:@"0"];
    }else {
        for (int i=0; i<self.cartWaresArray.count; i++) {
            NSMutableArray  *row = [[NSMutableArray alloc] init];
            ShopCartModel *iModel = [self.cartWaresArray objectAtIndex:i];
            [row addObject:iModel];
            BOOL isContinue = YES;
            for (int m=0; m<i; m++) {
                ShopCartModel *mModel = [self.cartWaresArray objectAtIndex:m];
                if ([mModel.sellerId isEqualToString:iModel.sellerId]) {
                    isContinue = NO;
                    break;
                }
            }
            if (isContinue) {
                for (int j=i+1; j<self.cartWaresArray.count; j++) {
                    ShopCartModel *jModel = [self.cartWaresArray objectAtIndex:j];
                    if ([jModel.sellerId isEqualToString:iModel.sellerId]) {
                        [row addObject:jModel];
                    }
                }
                [self.cartGoodsArray addObject:row];
                [self.selectedCountInSection addObject:@"0"];
            }
        }
    }
    
    [self.cartServiceArray removeAllObjects];
    [self.cartServiceArray addObjectsFromArray:[[DBOperation Instance] getAllWaresOrServiceDataInCartByType:1]];
    if (self.cartServiceArray.count > 0) {
        [self.cartGoodsArray addObject:self.cartServiceArray];
        [self.selectedCountInSection addObject:@"0"];
    }
}


// 购物车CheckBox选择变更处理函数
- (void)checkBoxChangeHandlerForStatus:(BOOL)isSelected andModel:(ShopCartModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    if (isSelected) {
        self.selectedCount++;
        if (self.selectedCount == (self.cartWaresArray.count+self.cartServiceArray.count)) {
            self.allCheckBox.selected = YES;
        }
        
        NSString *selCountInSection = [self.selectedCountInSection objectAtIndex:indexPath.section];
        NSInteger selCount = [selCountInSection integerValue];
        selCount++;
        selCountInSection = [NSString stringWithFormat:@"%zd", selCount];
        [self.selectedCountInSection setObject:selCountInSection atIndexedSubscript:indexPath.section];
    }else {
        self.selectedCount--;
        self.allCheckBox.selected = NO;
        
        NSString *selCountInSection = [self.selectedCountInSection objectAtIndex:indexPath.section];
        NSInteger selCount = [selCountInSection integerValue];
        selCount--;
        selCountInSection = [NSString stringWithFormat:@"%zd", selCount];
        [self.selectedCountInSection setObject:selCountInSection atIndexedSubscript:indexPath.section];
    }
    
    [self updateCarBarDispInfo];
}

// 更新购物车底栏显示信息
- (void)updateCarBarDispInfo
{
    if (self.isEditting) {
        [self.carBar.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.carBar.leftLabel setText:[NSString stringWithFormat:@"已选%ld件", (unsigned long)self.selectedCount]];
    }else {
        // 以前的self.totalVal逻辑混乱，这里每次都重新计算所有已选商品价格
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected==YES"];
        NSArray *selectWaresArray = [self.cartWaresArray filteredArrayUsingPredicate:predicate];
        self.totalVal = [ShopCartModel calculationPrice:selectWaresArray];
        
        [self.carBar.rightBtn setTitle:@"立即结算" forState:UIControlStateNormal];
        [self.carBar.leftLabel setText:[NSString stringWithFormat:@"合计:￥%.2f", self.totalVal]];
    }
}

#pragma mark - 删除购物车商品警告Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if (![Common checkNetworkStatus]) {
            [Common showBottomToast:@"网络无连接！"];
            return;
        }
        
        NSInteger count = 0;
        if (self.allCheckBox.selected) {
            [[DBOperation Instance] deleteCartAllData];
            for (ShopCartModel *model in self.cartWaresArray) {
                [self deleteCartInfoToServerByShopCartModel:model];
            }
            count = 0;
        }else {
            for (ShopCartModel *model in self.cartWaresArray) {
                if (model.isSelected) {
                    [[DBOperation Instance] deleteWaresDataFromCart:model.wsId withWaresStyle:model.waresStyle];
                    [self deleteCartInfoToServerByShopCartModel:model];
                }else {
                    count += model.count;
                }
            }
            for (ShopCartModel *model in self.cartServiceArray) {
                if (model.isSelected) {
                    [[DBOperation Instance] deleteWaresDataFromCart:model.wsId withWaresStyle:@""];
                    [self deleteCartInfoToServerByShopCartModel:model];
                }else {
                    count += model.count;
                }
            }
        }
        self.selectedCount = 0;
        [self updateCartWaresAndServiceArray];
        [self updateCarBarDispInfo];
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd", count];
        if (count == 0) {
            self.tabBarItem.badgeValue = nil;
        }
        [self.tableView reloadData];
        [self getRecommendGoodsDataFromServer];
        
    }
}


#pragma mark - 手势隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)supportPaymentType
{
    if (!_supportPaymentType) {
        _supportPaymentType = [[NSMutableDictionary alloc] init];
    }
    return _supportPaymentType;
}

@end

//
//  GoodsForSaleViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GoodsForSaleViewController.h"
#import "GoodsForSaleTableViewCell.h"
#import "RecommendGoods.h"
#import "WaresDetailViewController.h"
#import "GoodsCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "ShoppingCartViewController.h"

#define GoodsForSaleTableViewCellNibName @"GoodsForSaleTableViewCell"

@interface GoodsForSaleViewController()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (retain, nonatomic) NSMutableArray *goodsForSaleArray;
@end

@implementation GoodsForSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = @"店铺商品列表";
    [self.view addSubview:self.collectionView];
    [self initBasicData];
    
    // 注册cell
    UINib *nibForGoodsSaleViewService = [UINib nibWithNibName:GoodsForSaleTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForGoodsSaleViewService forCellReuseIdentifier:GoodsForSaleTableViewCellNibName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getGoodsForSaleDataFromServer];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsForSaleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsForSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsForSaleTableViewCellNibName forIndexPath:indexPath];
    [cell loadCellData:[self.goodsForSaleArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
    RecommendGoods *goods = [self.goodsForSaleArray objectAtIndex:indexPath.row];
    vc.waresId = goods.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initBasicData {
    self.goodsForSaleArray = [[NSMutableArray alloc]init];
}


#pragma mark - 从服务器获取商家在售商品列表数据
- (void)getGoodsForSaleDataFromServer
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:projectId forKey:@"projectId"];
    [params setValue:@"0" forKey:@"type"];
    [params setValue:@"" forKey:@"categoryId"];
    [params setValue:@"" forKey:@"categoryFlag"];
    [params setValue:@"1" forKey:@"pageNum"];
    [params setValue:self.sellerName forKey:@"searchField"];
    [params setValue:@"1" forKey:@"searchType"];
    [params setValue:self.moduleType forKey:@"moduleType"];
    NSString *pageCount = [NSString stringWithFormat:@"%li", (unsigned long)INT_MAX];
    [params setValue:pageCount forKey:@"perSize"];
    [self getArrayFromServer:GoodsListBySearch_Url path:GoodsListBySearch_Path method:@"POST" parameters:params xmlParentNode:@"goods" success:^(NSMutableArray *result) {
        [self.goodsForSaleArray removeAllObjects];
        for (NSDictionary *dic in result) {
            [self.goodsForSaleArray addObject:[[WaresList alloc] initWithDictionary:dic]];
        }
        [self.tableView reloadData];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
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
    return self.goodsForSaleArray.count;
}


// 加载CollectionViewCell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCollectionViewCell *cell = (GoodsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCollectionViewCell" forIndexPath:indexPath];
    [cell loadCellData:[self.goodsForSaleArray objectAtIndex:indexPath.row]];
    
    // 商品图片点击事件Block
    [cell setGoodsImgBtnClickBlock:^{
        WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
        WaresList *wares = [self.goodsForSaleArray objectAtIndex:indexPath.row];
        vc.waresId = wares.goodsId;
        vc.efromType = E_FromViewType_WareList;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // 购物车图标点击事件Block
    [cell setCartBtnClickBlock:^{
        if ([self isGoToLogin]) {
            // 向购物车中插入数据
            WaresList *wares = [self.goodsForSaleArray objectAtIndex:indexPath.row];
            WaresDetail *detail = [[WaresDetail alloc] initWithWaresList:wares];
            [[DBOperation Instance] insertWaresData:detail];
            [self updateCartInfoToServerSuccess:^(NSString *result) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ShoppingCartChangedNotification object:nil];
                [Common showBottomToast:@"添加购物车成功"];
            } failure:^(NSError *error) {
                [Common showBottomToast:@"添加购物车失败"];
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
    WaresList *wares = [self.goodsForSaleArray objectAtIndex:indexPath.row];
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

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(Screen_Width / 3.0, Screen_Width / 4.0)];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [layout setMinimumInteritemSpacing:0.0];
        [layout setMinimumLineSpacing:0.0];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        UINib *nibForGoods = [UINib nibWithNibName:@"GoodsCollectionViewCell" bundle:[NSBundle mainBundle]];
        [_collectionView registerNib:nibForGoods forCellWithReuseIdentifier:@"GoodsCollectionViewCell"];
    }
    return _collectionView;
}

@end

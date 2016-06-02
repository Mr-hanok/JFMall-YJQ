//
//  StoreListViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "StoreListViewController.h"
#import "StoreListCollectionViewCell.h"
#import "WaresListViewController.h"


#pragma mark - 宏定义区
#define StoreListCollectionCellNibName          @"StoreListCollectionViewCell"


@interface StoreListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;

@property (retain, nonatomic) IBOutlet UIView *searchBorderView;
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;

// 商店信息数组
@property (nonatomic, retain) NSMutableArray    *storeArray;


@end

@implementation StoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Store_Store;
    [self setNavBarLeftItemAsBackArrow];
    
    [self initBasicDataInfo];
    
    self.searchBorderView.layer.borderColor = COLOR_RGB(200, 200, 200).CGColor;
    self.searchBorderView.layer.borderWidth = 1.0;
    self.searchBorderView.layer.cornerRadius = 4.0;
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
    return self.storeArray.count;
}


// 加载CollectionViewCell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreListCollectionViewCell *cell = (StoreListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:StoreListCollectionCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.storeArray objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - CollectionView代理
// CollectionView元素选择事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转到商品列表画面
    WaresListViewController *vc = [[WaresListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.collectionView.frame.size.width/3.0;
    CGFloat height = 150.0/102.0 * width;
    
    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}


#pragma mark - 按钮点击事件
// 搜索按钮点击事件处理函数
- (IBAction)searchBtnClickHandler:(id)sender
{

}



#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    // 测试数据 TODO
    NSArray *stores = @[@[@"StoreGoodsImg", @"五金城", @"020-88562918"],
                        @[@"StoreGoodsImg", @"五金城", @"020-88562918"],
                        @[@"StoreGoodsImg", @"五金城", @"020-88562918"],
                        @[@"StoreGoodsImg", @"五金城", @"020-88562918"],
                        @[@"StoreGoodsImg", @"五金城", @"020-88562918"],
                        @[@"StoreGoodsImg", @"五金城", @"020-88562918"],
                        @[@"StoreGoodsImg", @"五金城", @"020-88562918"],
                        @[@"StoreGoodsImg", @"五金城", @"020-88562918"]];
    self.storeArray = [[NSMutableArray alloc] initWithArray:stores];
    
    // 注册CollectionViewCell Nib
    UINib *nibForStore = [UINib nibWithNibName:StoreListCollectionCellNibName bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForStore forCellWithReuseIdentifier:StoreListCollectionCellNibName];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

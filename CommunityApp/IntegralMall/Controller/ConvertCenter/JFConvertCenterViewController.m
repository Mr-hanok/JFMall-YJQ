//
//  ConvertCenterViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/4/22.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFConvertCenterViewController.h"
#import <MJRefresh.h>
#import "JFHomeGoodsCell.h"
#import "JFConvertCenterHeadView.h"
#import "JFCategorysModel.h"
#import "APIConvertCenterRequest.h"
#import "JFBannerModel.h"

@interface JFConvertCenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,APIRequestDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectview;
@property (strong, nonatomic) IBOutlet UIView *rightNaviView;
@property (weak, nonatomic) IBOutlet UIButton *shopCarNumBtn;//购物车角标按钮
@property (nonatomic, strong) NSMutableArray *categorysArray;//分类model数组 数据源
@property (nonatomic, strong) NSMutableArray *bannerArray;//轮播图model数组
@property (nonatomic, strong) NSMutableArray *bannerUrlArray;//轮播图url数组

@property (nonatomic, strong) APIConvertCenterRequest *apiConvert;
@end

@implementation JFConvertCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.categorysArray = [NSMutableArray array];
    self.bannerArray = [NSMutableArray array];
    self.bannerUrlArray = [NSMutableArray array];
    self.collectview.backgroundColor = [UIColor whiteColor];
    self.rightNaviView.frame = CGRectMake((Screen_Width-60), 7, 60, 30);
    [self.shopCarNumBtn setTitle:@"0" forState:UIControlStateNormal];
    [self setNavBarItemRightView:self.rightNaviView];

    
    [self.collectview registerNib:[UINib nibWithNibName:@"JFHomeGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"JFHomeGoodsCell"];
    UINib *nibForFirstHeader = [UINib nibWithNibName:@"JFConvertCenterHeadView" bundle:[NSBundle mainBundle]];
    [self.collectview registerNib:nibForFirstHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JFConvertCenterHeadView"];

    
    // 添加下拉刷新、下拉加载更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //数据请求
        self.apiConvert = [[APIConvertCenterRequest alloc]initWithDelegate:self];
        [APIClient execute:self.apiConvert];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectview.mj_header = header;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectview.mj_header beginRefreshing];
}
#pragma mark -  APIRequestDelegate

- (void)serverApi_RequestFailed:(APIRequest *)api error:(NSError *)error {
    
    [HUDManager hideHUDView];
    [self.collectview.mj_header endRefreshing];
    [HUDManager showWarningWithText:kDefaultNetWorkErrorString];
    
}

- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr {
    [self.collectview.mj_header endRefreshing];
    [HUDManager hideHUDView];
    
    if (sr.dic == nil || [sr.dic isKindOfClass:[NSNull class]]) {
        return;
    }
    if (api == self.apiConvert){
        [self.categorysArray removeAllObjects];
        [self.bannerUrlArray removeAllObjects];
        
        NSArray *categorys = [sr.dic objectForKey:@"categorys"];
        if (categorys.count==0) {
            JFCategorysModel *model = [[JFCategorysModel alloc]init];
            [self.categorysArray addObject:model];
        }
        if (categorys.count>0) {//分组商品数据
            for (NSDictionary *cateDic in categorys) {
                JFCategorysModel *model = [JFCategorysModel initJFCategorysModelWith:cateDic];
                [self.categorysArray addObject:model];
            }
        }
        NSArray *banner = [sr.dic objectForKey:@"banner"];
        if (banner.count == 0){
            JFBannerModel *model = [[JFBannerModel alloc]init];
            [self.bannerArray addObject:model];
        }
        if (banner.count>0) {//轮播图数据
            [self.bannerUrlArray removeAllObjects];
            for (NSDictionary *bannDic in banner) {
                JFBannerModel *model = [JFBannerModel initModelWith:bannDic];
                [self.bannerUrlArray addObject:model.pic_path];
                [self.bannerArray addObject:model];
            }
        }
        [self.shopCarNumBtn setTitle:[ValueUtils stringFromObject:[sr.dic objectForKey:@"goods_count"]] forState:UIControlStateNormal];
        [self.collectview reloadData];
    }

}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    [self.collectview.mj_header endRefreshing];
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) {
        message = kDefaultServerErrorString;
    }
    [HUDManager showWarningWithText:message];
}


#pragma mark - CollectionDataSource代理
//CollectionView的Section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.categorysArray.count;
}
// 设计每个section的Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    JFCategorysModel *model = self.categorysArray[section];
    return model.goodsList.count;
}
// 加载CollectionViewCell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JFHomeGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JFHomeGoodsCell" forIndexPath:indexPath];
    JFCategorysModel *model = self.categorysArray[indexPath.section];
    JFHomeGoodsModel *goods = model.goodsList[indexPath.row];
    [cell configGoodsCellWithGoodsModel:goods];
    return cell;
}

#pragma mark - CollectionView代理
// CollectionView元素选择事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JFCategorysModel *model = self.categorysArray[indexPath.section];
    JFHomeGoodsModel *goods = model.goodsList[indexPath.row];
    [self pushWithVCClassName:@"JFGoodsDetailViewController" properties:@{@"title":@"商品详情",@"goodsId":goods.goodsId}];}

#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = APP_SCREEN_WIDTH/2-10;
    CGFloat height = width+65;
    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);//上 左 下 右
}

// 设置Sectionheader大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize ;
    if (section == 0) {
        itemSize=CGSizeMake(APP_SCREEN_WIDTH, 164);
    }else{
        itemSize=CGSizeMake(APP_SCREEN_WIDTH, 35);
    }
    return itemSize;
}

// 设置SectionFooter大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeMake(0, 0);
    return itemSize;
}

//设置Header和FooterView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    JFCategorysModel *model = self.categorysArray[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader) {
        JFConvertCenterHeadView *view = (JFConvertCenterHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"JFConvertCenterHeadView" forIndexPath:indexPath];
        [view inistallAdViewWithUrlArray:self.bannerUrlArray section:indexPath.section title:model.title];
        view.adImagecallBack = ^(NSInteger index,NSString * imageURL)
        {
            JFBannerModel *m = self.bannerArray[index];
            [self pushWithVCClassName:@"JFWebViewController" properties:@{@"bannerModel":m}];
        };

        return view;
    }
   
    return nil;
}

#pragma mark - event response
/**导航栏右侧按钮点击*/
- (IBAction)naviRightItemClick:(UIButton *)sender {
    [self pushWithVCClassName:@"JFShoppingCarViewController" properties:@{@"title":@"购物车"}];
}

#pragma mark - private methods
- (void)getdata{
    [self.collectview.mj_header endRefreshing];
}


@end

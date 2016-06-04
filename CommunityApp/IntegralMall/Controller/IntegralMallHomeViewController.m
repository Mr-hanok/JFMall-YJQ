//
//  IntegralMallHomeViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/4/18.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "IntegralMallHomeViewController.h"
#import <MJRefresh.h>
#import "JFHomeGoodsCell.h"
#import "JFHomeHeadView.h"
#import "AdView.h"
#import "JFShoppingCarViewController.h"
#import "JFConvertCenterViewController.h"
#import "JFIntegralDetailViewController.h"
#import "JFTaskCenterViewController.h"
#import "JFGoodsDetailViewController.h"
#import "APIIntegralHomeRequest.h"
#import "JFGoodsInfoModel.h"
#import "JFCategorysModel.h"
#import "JFBannerModel.h"
#import "JFConvertCenterHeadView.h"
#import "APISignRequest.h"

@interface IntegralMallHomeViewController ()<JFHomeHeadViewDelegate,APIRequestDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *categorysArray;//分类model数组 数据源
@property (nonatomic, strong) NSMutableArray *bannerArray;//轮播图model数组
@property (nonatomic, strong) NSMutableArray *bannerUrlArray;//轮播图url数组
@property (nonatomic, copy) NSString *signDays;//签到天数
@property (nonatomic, copy) NSString *signintegral;//签到积分
@property (nonatomic, copy) NSString *integral;//用户积分

@property (nonatomic, strong) APIIntegralHomeRequest *apiHomeRequest;
@property (nonatomic, strong) APISignRequest *apiSign;
@end

@implementation IntegralMallHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
//    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.categorysArray = [NSMutableArray array];
    self.bannerArray = [NSMutableArray array];
    self.bannerUrlArray = [NSMutableArray array];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JFHomeGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([JFHomeGoodsCell class])];
    
    UINib *nibForFirstHeader = [UINib nibWithNibName:NSStringFromClass([JFHomeHeadView class]) bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForFirstHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JFHomeHeadView class])];
    
    UINib *nibForSectionHeader = [UINib nibWithNibName:NSStringFromClass([JFConvertCenterHeadView class]) bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForSectionHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JFConvertCenterHeadView class])];
    //初始化请求
    self.apiHomeRequest = [[APIIntegralHomeRequest alloc]initWithDelegate:self];
    self.apiSign = [[APISignRequest alloc]initWithDelegate:self];
    
    // 添加下拉刷新、下拉加载更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //发送请求数据
        [APIClient execute:self.apiHomeRequest];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark -  APIRequestDelegate

- (void)serverApi_RequestFailed:(APIRequest *)api error:(NSError *)error {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [HUDManager hideHUDView];
    [HUDManager showWarningWithText:kDefaultNetWorkErrorString];
    
}

- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [HUDManager hideHUDView];
    if (sr.dic == nil || [sr.dic isKindOfClass:[NSNull class]]) {
        return;
    }
    if (api == self.apiLogin) {
        [APIClient execute:self.apiHomeRequest];
    }
    if (api == self.apiHomeRequest){
        [self.categorysArray removeAllObjects];
        [self.bannerUrlArray removeAllObjects];

        NSArray *categorys = [sr.dic objectForKey:@"categorys"];
        if (categorys.count == 0) {
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
            [self.bannerArray removeAllObjects];
            for (NSDictionary *bannDic in banner) {
                JFBannerModel *model = [JFBannerModel initModelWith:bannDic];
                [self.bannerUrlArray addObject:model.pic_path];
                [self.bannerArray addObject:model];
            }
        }
        //记录 积分 签到天数 签到积分
        self.signDays = [ValueUtils stringFromObject:[sr.dic objectForKey:@"signdays"]];
        self.signintegral = [ValueUtils stringFromObject:[sr.dic objectForKey:@"signintegral"]];
        NSDictionary *userDic = [sr.dic objectForKey:@"user"];
        self.integral = [ValueUtils stringFromObject:[userDic objectForKey:@"integral"]];
        
        [self.collectionView reloadData];
    }
    if (api == self.apiSign) {//签到请求
        self.signDays = [ValueUtils stringFromObject:[sr.dic objectForKey:@"signdays"]];
        self.signintegral = [ValueUtils stringFromObject:[sr.dic objectForKey:@"signintegral"]];
        self.integral = [ValueUtils stringFromObject:[sr.dic objectForKey:@"integral"]];
        [HUDManager showWarningWithText:sr.msg];
        [self.collectionView reloadData];
    }
}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    if (sr.status == 302) {//登陆失效 重新登陆
        self.apiLogin = [[ApiLoginRequest alloc]initWithDelegate:self];
        [self.apiLogin setApiParams];
        [APIClient execute:self.apiLogin];
        return;
    }
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
    JFHomeGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JFHomeGoodsCell class]) forIndexPath:indexPath];
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
    [self pushWithVCClassName:@"JFGoodsDetailViewController" properties:@{@"title":@"商品详情",@"goodsId":goods.goodsId}];
}

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
    if (section==0) {
        CGSize itemSize =CGSizeMake(APP_SCREEN_WIDTH, 382);
        JFCategorysModel *model = self.categorysArray[section];
        if (model.goodsList.count == 0) {
            return CGSizeMake(APP_SCREEN_WIDTH, 348);
        }
        return itemSize;
    }else{
        CGSize itemSize =CGSizeMake(APP_SCREEN_WIDTH, 34);
        return itemSize;
    }
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
        if (indexPath.section == 0) {
            JFHomeHeadView *view = (JFHomeHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"JFHomeHeadView" forIndexPath:indexPath];
            view.delegate = self;
            [view loadAdDateWithImageUrlArray:self.bannerUrlArray
                                     signDays:self.signDays
                                 signIntegral:self.signintegral integral:self.integral
                                 sectionTitle:model.title];
            view.adImagecallBack = ^(NSInteger index,NSString * imageURL)
            {   //轮播图点击事件
                JFBannerModel *m = self.bannerArray[index];
                [self pushWithVCClassName:@"JFWebViewController" properties:@{@"bannerModel":m}];
            };
            
            return view;
        }else{
            JFConvertCenterHeadView *view = (JFConvertCenterHeadView*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"JFConvertCenterHeadView" forIndexPath:indexPath];
            [view inistallAdViewWithUrlArray:self.bannerUrlArray section:indexPath.section title:model.title];
            return view;
        }
        
    }
    return nil;
}
#pragma mark - JFHomeHeadViewdelegate
-(void)jfHomeHeadView:(JFHomeHeadView *)headView buttonType:(UIButton *)btn{
    
    switch (btn.tag) {
        case 101://任务中心
            [self pushWithVCClassName:@"JFTaskCenterViewController" properties:@{@"title":@"任务中心"}];
            break;
        case 102://积分明细
            [self pushWithVCClassName:@"JFIntegralDetailViewController" properties:@{@"title":@"积分明细"}];
            break;
        case 103://兑换中心
            [self pushWithVCClassName:@"JFConvertCenterViewController" properties:@{@"title":@"兑换中心"}];
            break;
        case 104://签到按钮
            [self signBtnClick:btn];
            break;
    }
}
#pragma mark - event response

#pragma mark - private methods
- (void)signBtnClick:(UIButton*)btn{
    
    [APIClient execute:self.apiSign];
    
//    UILabel *l =[[UILabel alloc]initWithFrame:CGRectMake(btn.origin.x+btn.width-15,btn.origin.y ,15 ,15 )];
//    l.text = self.signintegral;
//    l.font = [UIFont systemFontOfSize:14.f];
//    l.textColor = HEXCOLOR(0xFFA819);
//    [self.view addSubview:l];
//    [UIView animateWithDuration:1.f animations:^{
//        l.frame = CGRectMake(l.origin.x+25, l.origin.y-25, 10, 10);
//        l.alpha = 0.5f;
//    } completion:^(BOOL finished) {
//        [l removeFromSuperview];
//    }];
}


@end

//
//  GoodsListViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GoodsListViewController.h"
#import "FilterViewController.h"
#import "ShoppingCartViewController.h"
#import "CatagoryCollectionViewCell.h"
#import "GoodsCollectionViewCell.h"
#import "FirstSectionHeaderCollectionReusableView.h"
#import "HeaderCollectionReusableView.h"
#import "CatagoryFooterCollectionReusableView.h"
#import "WaresList.h"
#import "CartBottomBar.h"
#import "DBOperation.h"
#import <MJRefresh.h>

#import "GoodsCatagoryViewController.h"
#import "LimitBuyViewController.h"
#import "NormalGoodsListViewController.h"

#import "AdImgSlideInfo.h"
#import "FirstHeaderView.h"
#import "WaresDetailViewController.h"
#import "GrouponDetailViewController.h"
#import "MessageViewController.h"
#import "WebViewController.h"
#import "SurveyAndVoteViewController.h"

#pragma mark - 宏定义区
#define FirstHeaderViewNibName          @"FirstHeaderView"
#define CatagoryCollectionViewCellNibName                  @"CatagoryCollectionViewCell"
#define GoodsCollectionViewCellNibName                     @"GoodsCollectionViewCell"
#define FirstSectionHeaderCollectionReusableViewNibName    @"FirstSectionHeaderCollectionReusableView"
#define HeaderCollectionReusableViewNibName                @"HeaderCollectionReusableView"
#define CatagoryFooterCollectionReusableViewNibName        @"CatagoryFooterCollectionReusableView"

#define GoodsListPageSize           (18)
#define MallSlideSection 0
#define SkipMallSlideSection 1
@interface GoodsListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FilterViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchBorderView;
@property (weak, nonatomic) IBOutlet UICollectionView *catagoryCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
@property (strong, nonatomic) IBOutlet UIView *rightNavView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *countInCart;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;

@property (weak, nonatomic) IBOutlet UIView *searchTypeBgView;
@property (weak, nonatomic) IBOutlet UIView *searchTypeView;
@property (weak, nonatomic) IBOutlet UILabel *searchTypeLabel;

@property (weak, nonatomic) IBOutlet UIView *cartView;


@property (nonatomic, retain) NSMutableArray    *goodsArray;    // 商品信息数组
@property (nonatomic, retain) NSString          *filters;       // 筛选条件
@property (nonatomic, assign) NSInteger         pageNum;        // 当前页码
@property (nonatomic, assign) NSInteger         curSelectedCatagoryNo;    // 当前选中的商品类别
@property (retain, nonatomic) CartBottomBar     *carBar;        //购物车Bar(编辑/完成)状态不同，内容不同
@property (retain, nonatomic) NSMutableArray*   slideInfoArray;
@property (retain, nonatomic) NSMutableArray*   adImgArray;
@property (nonatomic, assign) NSInteger     searchType; //（0、商品；1、商家；2、分类）

@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Selected_Goods_Title;
    [self setNavBarLeftItemAsBackArrow];
    self.rightNavView.frame = Rect_WaresList_NavBarRightItem;
    [self setNavBarItemRightView:self.rightNavView];
    
    // 初始化搜索框Border
    self.searchBorderView.layer.borderColor = COLOR_RGB(211, 209, 210).CGColor;
    self.searchBorderView.layer.borderWidth = 0.5;
    self.searchBorderView.layer.cornerRadius = 4.0;
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
    
    [self.catagoryCollectionView setHidden:YES];
    [self.goodsCollectionView setHidden:YES];
    
    // 初始化本地信息
    [self initBasicDataInfo];
    
    // 添加下拉刷新、下拉加载更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getGoodsDataFromService];
    }];

    header.lastUpdatedTimeLabel.hidden = YES;
    self.goodsCollectionView.header = header;

    
    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self getGoodsDataFromService];
    [self getMallSlideList];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateGoodsCountInCart];
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.pageNum = 1;
    self.curSelectedCatagoryNo = 0;
    self.searchType = 0;
    
    [_searchTypeBgView setHidden:YES];
    [_searchTypeView setHidden:YES];
    
    self.goodsArray = [[NSMutableArray alloc] init];
    self.slideInfoArray =[[NSMutableArray alloc] init];
    self.adImgArray = [[NSMutableArray alloc]init];
    // 注册CollectionViewCell Nib
    // 商品类别
    UINib *nibForCatagory = [UINib nibWithNibName:CatagoryCollectionViewCellNibName bundle:[NSBundle mainBundle]];
    [self.catagoryCollectionView registerNib:nibForCatagory forCellWithReuseIdentifier:CatagoryCollectionViewCellNibName];

    // 商品
    UINib *nibForGoods = [UINib nibWithNibName:GoodsCollectionViewCellNibName bundle:[NSBundle mainBundle]];
    [self.goodsCollectionView registerNib:nibForGoods forCellWithReuseIdentifier:GoodsCollectionViewCellNibName];
    
    UINib *nibForFooterHeader = [UINib nibWithNibName:FirstHeaderViewNibName bundle:[NSBundle mainBundle]];
    [self.goodsCollectionView registerNib:nibForFooterHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FirstHeaderViewNibName];
    
    // 商品 FirstHeaderView
    UINib *nibForFirstHeader = [UINib nibWithNibName:FirstSectionHeaderCollectionReusableViewNibName bundle:[NSBundle mainBundle]];
    [self.goodsCollectionView registerNib:nibForFirstHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FirstSectionHeaderCollectionReusableViewNibName];
    
    // 商品 HeaderView
    UINib *nibForHeader = [UINib nibWithNibName:HeaderCollectionReusableViewNibName bundle:[NSBundle mainBundle]];
    [self.goodsCollectionView registerNib:nibForHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCollectionReusableViewNibName];

    // 类别 FooterView
    UINib *nibForCatagoryFooter = [UINib nibWithNibName:CatagoryFooterCollectionReusableViewNibName bundle:[NSBundle mainBundle]];
    [self.goodsCollectionView registerNib:nibForCatagoryFooter forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CatagoryFooterCollectionReusableViewNibName];
    
}

-(void)getMallSlideList
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[projectId] forKeys:@[@"projectId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:SlideList_Url path:MallSlideList_Path method:@"GET" parameters:dic xmlParentNode:@"slide" success:^(NSMutableArray *result) {
        [self.adImgArray removeAllObjects];
        for (NSDictionary *dic in result) {
            AdImgSlideInfo *slideInfo = [[AdImgSlideInfo alloc] initWithDictionary:dic];
            [self.slideInfoArray addObject:slideInfo];
            
            NSString *imgUrl = slideInfo.picPath;
            [self.adImgArray addObject:imgUrl];
        }
        [self.goodsCollectionView.header endRefreshing];
        [self.goodsCollectionView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.goodsCollectionView.header endRefreshing];
        [self.goodsCollectionView reloadData];
    }];
}

#pragma mark - 更新购物车商品数
- (void)updateGoodsCountInCart
{
    NSInteger count = [[DBOperation Instance] getTotalWaresAndServicesCountInCart];
    if (count  <= 0) {
        [self.countInCart setHidden:YES];
    }else {
        [self.countInCart setTitle:[NSString stringWithFormat:@"%ld", (long)count] forState:UIControlStateNormal];
        [self.countInCart setHidden:NO];
    }
}

#pragma mark - CollectionDataSource代理
// 设计该CollectionView的Section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger nums = 1;
    
    if (collectionView == self.goodsCollectionView) {
        nums = self.goodsArray.count+SkipMallSlideSection;//add Mall Slide Section
    }
    
    return nums;
}

// 设计每个section的Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger nums = 0;
    
    if (collectionView == self.catagoryCollectionView) {
        nums = self.goodsArray.count;
    }else {
        if(section  !=  MallSlideSection)
        {
            GoodWaresList *wares = [self.goodsArray objectAtIndex:section-1];
            nums = wares.goodsList.count;
            if (nums > 8) {
                nums = 8;
            }
        }
    }
    
    return nums;
}


// 加载CollectionViewCell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.catagoryCollectionView) {
        CatagoryCollectionViewCell *cell = (CatagoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CatagoryCollectionViewCellNibName forIndexPath:indexPath];
        if (indexPath.row == self.curSelectedCatagoryNo) {
            [cell setSelected:YES];
        }else {
            [cell setSelected:NO];
        }
        [cell loadCellData:[self.goodsArray objectAtIndex:indexPath.row]];
        return cell;
    }else {
        GoodsCollectionViewCell *cell = (GoodsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollectionViewCellNibName forIndexPath:indexPath];
        GoodWaresList *wares = [self.goodsArray objectAtIndex:indexPath.section-SkipMallSlideSection];
        [cell loadCellData:[wares.goodsList objectAtIndex:indexPath.row]];
        // 商品图片点击事件Block 
        [cell setGoodsImgBtnClickBlock:^{
            WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
            GoodWaresList *waresList = [self.goodsArray objectAtIndex:indexPath.section-SkipMallSlideSection];
            WaresList *wares = [waresList.goodsList objectAtIndex:indexPath.row];
            vc.waresId = wares.goodsId;
            vc.efromType = E_FromViewType_WareList;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        // 购物车图标点击事件Block
        [cell setCartBtnClickBlock:^{
            if ([self isGoToLogin]) {
                if (![Common checkNetworkStatus]) {
                    [Common showBottomToast:@"抱歉，网络异常！"];
                    return;
                }
                // 向购物车中插入数据
                GoodWaresList *waresList = [self.goodsArray objectAtIndex:indexPath.section-SkipMallSlideSection];
                WaresList *wares = [waresList.goodsList objectAtIndex:indexPath.row];
                WaresDetail *detail = [[WaresDetail alloc] initWithWaresList:wares];
                [[DBOperation Instance] insertWaresData:detail];
                [self updateCartInfoToServerSuccess:^(NSString *result) {
                    // 更新购物车商品数
                    [self updateGoodsCountInCart];
                    [Common showBottomToast:@"添加购物车成功"];
                } failure:^(NSError *error) {
                    [Common showBottomToast:@"添加购物车失败"];
                }];
            }
        }];
        
        return cell;
    }
}


#pragma mark - CollectionView代理
// CollectionView元素选择事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.catagoryCollectionView) {
        //选择分类
        // 清空之前的选中状态
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.curSelectedCatagoryNo inSection:0];
        CatagoryCollectionViewCell *cell = (CatagoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:index];
        [cell setSelected:NO];
        
        // 设置当前的选中状态
        cell = (CatagoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setSelected:YES];
        
        // 自动移动到对应楼层
        [self autoMoveFloorByGoodsCategory:indexPath];
        
        // 设置当前选中的分类序号
        self.curSelectedCatagoryNo = indexPath.row;
    }else {
        //选择商品
    }
}
//ios 9问题改
// 根据选择的分类自动移动到对应商品楼层
- (void)autoMoveFloorByGoodsCategory:(NSIndexPath *)indexPath
{
//    CGFloat posY = 0.0;
//    if (indexPath.row == 0) {
//        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
//        FirstSectionHeaderCollectionReusableView *view = (FirstSectionHeaderCollectionReusableView *)[self.goodsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FirstSectionHeaderCollectionReusableViewNibName forIndexPath:index];
//        posY = view.frame.origin.y;
//    }else {
//        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:indexPath.row+SkipMallSlideSection];
//        HeaderCollectionReusableView *view = (HeaderCollectionReusableView *)[self.goodsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCollectionReusableViewNibName forIndexPath:index];
//        posY = view.frame.origin.y;
//    }
//    self.goodsCollectionView.contentOffset = CGPointMake(0, posY);

    CGFloat posY = 0.0;
    //    if (indexPath.row == 0) {
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:indexPath.row + 1];
    UICollectionViewCell *cell = [self collectionView:self.goodsCollectionView cellForItemAtIndexPath:index];
    posY = cell.frame.origin.y - 50;
    //    }else {
    //        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:indexPath.row+SkipMallSlideSection];
    //        HeaderCollectionReusableView *view = (HeaderCollectionReusableView *)[self.goodsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCollectionReusableViewNibName forIndexPath:index];
    //        posY = view.frame.origin.y;
    //    }
    self.goodsCollectionView.contentOffset = CGPointMake(0, posY);

}

#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (collectionView == self.catagoryCollectionView) {
//        width = 100.0;
//        if ((self.goodsArray.count * width)<Screen_Width) {
//            width = (CGFloat)Screen_Width/self.goodsArray.count;
//        }
//        height = 100.0;
        width = Screen_Width / 4.0;
        height = 70;
    }else {
        width = (Screen_Width)/2.0;
        height = width + 50.0;
    }
    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}


// 设置Sectionheader大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeMake(0, 0);
    if (collectionView == self.goodsCollectionView) {
        if (section == MallSlideSection) {
            itemSize = CGSizeMake(Screen_Width, (Screen_Width / 3.0));
        }else {
            itemSize = CGSizeMake(Screen_Width, 70);
        }
    }
    
    return itemSize;
}

// 设置SectionFooter大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeMake(0, 0);
    
    return itemSize;
}



// 设置Header和FooterView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == MallSlideSection) {
//            FirstSectionHeaderCollectionReusableView *view = (FirstSectionHeaderCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FirstSectionHeaderCollectionReusableViewNibName forIndexPath:indexPath];
//            GoodWaresList *wares = [self.goodsArray objectAtIndex:indexPath.section];
//            NSString *floorName = [NSString stringWithFormat:@"F%ld %@",(long)(indexPath.section+1), wares.gcName];
//            [view.categoryName setText:floorName];
//            [view setHeaderClickBlock:^{
//                NormalGoodsListViewController *vc = [[NormalGoodsListViewController alloc] init];
//                vc.eSearchGoodsType = E_SearchGoodsType_Category;
//                vc.goodsCategory = [[GoodsCategoryModel alloc] init];
//                vc.goodsCategory.categoryId = wares.gcId;
//                vc.goodsCategory.categoryName = wares.gcName;
//                vc.goodsCategory.categoryFlag = wares.clientShow;
//                [self.navigationController pushViewController:vc animated:YES];
//            }];
//            return view;
            FirstHeaderView *view = (FirstHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FirstHeaderViewNibName forIndexPath:indexPath];
            [view setDefaultImgName:@"AdImg"];
            [view loadHeaderData:self.adImgArray];
            [view setAdImgClickBlock:^(NSUInteger index) {
                AdImgSlideInfo *slideInfo = [self.slideInfoArray objectAtIndex:index];
                switch ([slideInfo.relatetype integerValue]) {
                    case 3: // 限时抢
                    case 7: // 普通商品
                    {
                        WaresDetailViewController *vc = [[WaresDetailViewController alloc] init];
                        vc.waresId = slideInfo.gmId;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    case 4: // 团购
                    {
                        GrouponDetailViewController *vc = [[GrouponDetailViewController alloc] init];
                        vc.grouponId = slideInfo.gmId;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    case 8: // 物业通知
                    {
                        MessageViewController *vc = [[MessageViewController alloc] init];
//                        vc.messageType = MessageTypeAll;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    case 9: // 外部链接
                    {
#pragma -mark 2016.02.26 精品推荐页轮播图外部链接
                        SurveyAndVoteViewController*vc=[[SurveyAndVoteViewController alloc]init];
                        vc.title=slideInfo.title;
                         NSLog(@"¥¥¥¥¥¥¥¥%@",slideInfo.url);
#pragma -mark 12-23 网络连接判断
                        BOOL netWorking = [Common checkNetworkStatus];
                        if (netWorking) {
                            vc.url=slideInfo.url;
                        }
                        else
                        {
                            [Common showBottomToast:Str_Comm_RequestTimeout];
                            return;
                        }

                        [self.navigationController pushViewController:vc animated:YES];

//                        WebViewController *vc = [[WebViewController alloc] init];
//                        vc.url = [NSString stringWithFormat:@"http://%@",slideInfo.url];
//                        vc.navTitle = Str_Comm_WebPage;
//                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }];
            return view;
        }else {
            HeaderCollectionReusableView *view = (HeaderCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderCollectionReusableViewNibName forIndexPath:indexPath];
            GoodWaresList *wares = [self.goodsArray objectAtIndex:indexPath.section-SkipMallSlideSection];
            
            [view setTitle:wares.gcName atIndex:indexPath.section-1];
            [view setHeaderClickBlock:^{
                NormalGoodsListViewController *vc = [[NormalGoodsListViewController alloc] init];
                vc.eSearchGoodsType = E_SearchGoodsType_Category;
                vc.goodsCategory = [[GoodsCategoryModel alloc] init];
                vc.goodsCategory.categoryId = wares.gcId;
                vc.goodsCategory.categoryName = wares.gcName;
                vc.goodsCategory.categoryFlag = wares.clientShow;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            return view;
        }
    }
    else{
        CatagoryFooterCollectionReusableView *view = (CatagoryFooterCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CatagoryFooterCollectionReusableViewNibName forIndexPath:indexPath];
        return view;
    }
}


#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat offsetY = self.goodsCollectionView.contentOffset.y;
//    for (int i=0; i<self.goodsArray.count; i++) {
//        GoodWaresList *wares = [self.goodsArray objectAtIndex:i];
//        if (i == 0) {
//            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:i];
//            FirstSectionHeaderCollectionReusableView *view = (FirstSectionHeaderCollectionReusableView *)[self.goodsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FirstSectionHeaderCollectionReusableViewNibName forIndexPath:index];
//            if ([self isUpdateCurrentSelectedCategory:i forView:view withOffset:offsetY]) {
//                break;
//            }
//        }else {
//            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:i];
//            HeaderCollectionReusableView *view = (HeaderCollectionReusableView *)[self.goodsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCollectionReusableViewNibName forIndexPath:index];
//            if ([self isUpdateCurrentSelectedCategory:i forView:view withOffset:offsetY]) {
//                break;
//            }
//        }
//    }
    //iOS 9问题改
    CGFloat offsetY = self.goodsCollectionView.contentOffset.y;
    for (int i=0; i<self.goodsArray.count; i++) {
        UICollectionViewCell *cell = [self collectionView:self.goodsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i + 1]];
        //        if (i == 0) {
        //            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:i];
        //            FirstSectionHeaderCollectionReusableView *view = (FirstSectionHeaderCollectionReusableView *)[self.goodsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FirstSectionHeaderCollectionReusableViewNibName forIndexPath:index];
        //            if ([self isUpdateCurrentSelectedCategory:i forView:view withOffset:offsetY]) {
        //                break;
        //            }
        //        }else {
        //            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:i];
        //            HeaderCollectionReusableView *view = (HeaderCollectionReusableView *)[self.goodsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCollectionReusableViewNibName forIndexPath:index];
        //            if ([self isUpdateCurrentSelectedCategory:i forView:view withOffset:offsetY]) {
        //                break;
        //            }
        //        }
        if ([self isUpdateCurrentSelectedCategory:i forView:cell withOffset:offsetY]) {
            break;
        }
    }
}

// 判断是否更新选中类别
- (BOOL)isUpdateCurrentSelectedCategory:(NSInteger)row forView:(UICollectionReusableView *)view withOffset:(CGFloat)offsetY
{
    BOOL rst = NO;
    CGFloat posY = view.frame.origin.y;
    CGFloat height = view.frame.size.height;

    if ((offsetY > posY) && (offsetY < (posY+height))) {
        // 清空之前的选中状态
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.curSelectedCatagoryNo inSection:0];
        CatagoryCollectionViewCell *cell = (CatagoryCollectionViewCell *)[self.catagoryCollectionView cellForItemAtIndexPath:indexPath];
        [cell setSelected:NO];
        
        // 设置当前的选中状态
        indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        cell = (CatagoryCollectionViewCell *)[self.catagoryCollectionView cellForItemAtIndexPath:indexPath];
        self.curSelectedCatagoryNo = row;
        [cell setSelected:YES];
        
        if ((cell.frame.origin.x + cell.frame.size.width) - Screen_Width > 0) {
            self.catagoryCollectionView.contentOffset = CGPointMake(cell.frame.origin.x, 0);
        }else {
            self.catagoryCollectionView.contentOffset = CGPointMake(0, 0);
        }
        
        rst = YES;
    }
    
    return rst;
}



// 从服务器上获取商品数据
- (void)getGoodsDataFromService
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[projectId, @"4"] forKeys:@[@"projectId", @"recType"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:WaresListByModule_Url path:WaresListByModule_Path method:@"GET" parameters:dic xmlParentNode:@"result" success:^(NSMutableArray *result) {
        [self.goodsArray removeAllObjects];
        YjqLog(@"result;%@",result);

        for (NSDictionary *dic in result) {
            [self.goodsArray addObject: [[GoodWaresList alloc] initWithDictionary:dic]];
        }
        if (self.goodsArray.count == 0) {
            self.categoryCollectionViewHeight.constant = 0;
            [Common showBottomToast:@"暂无精品推荐商品"];
        }else{
            self.categoryCollectionViewHeight.constant = 70;
            [self.catagoryCollectionView setHidden:NO];
            [self.goodsCollectionView setHidden:NO];
        }
        [self.goodsCollectionView.header endRefreshing];
        [self.goodsCollectionView reloadData];
        [self.catagoryCollectionView reloadData];

    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.goodsCollectionView.header endRefreshing];
        [self.goodsCollectionView reloadData];
        [self.catagoryCollectionView reloadData];
    }];
}

#pragma mark - SearchTextField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NormalGoodsListViewController *vc = [[NormalGoodsListViewController alloc] init];
    vc.eSearchGoodsType = E_SearchGoodsType_All;
    vc.searchContent = self.searchTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NormalGoodsListViewController *vc = [[NormalGoodsListViewController alloc] init];
    vc.eSearchGoodsType = E_SearchGoodsType_All;
    vc.searchContent = self.searchTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

#pragma mark - 按钮点击事件
// 搜索按钮点击事件处理函数
- (IBAction)searchBtnClickHandler:(id)sender
{
    NormalGoodsListViewController *vc = [[NormalGoodsListViewController alloc] init];
    vc.eSearchGoodsType = E_SearchGoodsType_All;
    vc.searchContent = self.searchTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

// 购物车按钮点击事件处理函数
- (IBAction)cartBtnClickHandler:(id)sender
{
    if ([self isGoToLogin]) {
        ShoppingCartViewController *vc = [[ShoppingCartViewController alloc] init];
        vc.eFromType = E_CartViewFromType_Push;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 类别筛选按钮点击事件处理函数
- (IBAction)catagoryBtnClickHandler:(id)sender
{
    GoodsCatagoryViewController *vc = [[GoodsCatagoryViewController alloc] init];
    vc.eGoodsCategoryModule = E_GoodsCategoryModule_Normal;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 选择搜索类型按钮点击事件处理函数
- (IBAction)searchTypeBtnClickHandler:(id)sender
{
    [_searchTypeBgView setHidden:NO];
    [_searchTypeView setHidden:NO];
}

#pragma mark - 下拉框搜索类型选择
- (IBAction)searchTypeSelect:(UIButton *)sender
{
    switch (sender.tag) {
        // 商品
        case 1001:
            _searchType = 0;
            [_searchTypeLabel setText:@"商品"];
            break;
        
        // 商家
        case 1002:
            _searchType = 1;
            [_searchTypeLabel setText:@"商家"];
            break;
        
        // 分类
        case 1003:
            _searchType = 2;
            [_searchTypeLabel setText:@"分类"];
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

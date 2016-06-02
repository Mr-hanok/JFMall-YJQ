//
//  JFGoodsDetailViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/5/3.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFGoodsDetailViewController.h"
#import "AdView.h"
#import <MJRefresh.h>
#import "APIGoodsDetailRequest.h"
#import "JFGoodsDetailModel.h"
#import "JFGoodsSpecsView.h"
#import "ApiAddToShopCarRequest.h"
#import "ApiGoodsInventoryRequest.h"
#import "JFInventoryModel.h"

@interface JFGoodsDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate,APIRequestDelegate,JFGoodsSpecsViewDelegate>{
    AdView *ad;
    int _lastPosition;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *goodsImageView;//商品图片view
@property (weak, nonatomic) IBOutlet UILabel *goodsTaglabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsIntegralLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsStockLabel;
@property (weak, nonatomic) IBOutlet UIView *goodsSpecsView; //规格型号view
@property (weak, nonatomic) IBOutlet UIButton *shopCarNumBtn;//购物车角标
@property (weak, nonatomic) IBOutlet UIButton *shopCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webview;//图文webview

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specsViewHeightConstraint;

@property (nonatomic, copy) NSString *shopCarNum;//购物车数量

/**商品详情请求*/
@property (nonatomic, strong) APIGoodsDetailRequest *apiDetail;
/**加入购物车请求*/
@property (nonatomic, strong) ApiAddToShopCarRequest *apiAddShopCar;
/**库存信息请求*/
@property (nonatomic, strong) ApiGoodsInventoryRequest *apiInverntory;
/**商品详情model*/
@property (nonatomic, strong) JFGoodsDetailModel *goodsModel;
/**库存模型*/
@property (nonatomic, strong) JFInventoryModel *inventoryModel;
/**记录商品规格id 以,分隔 拼接字符串*/
@property (nonatomic, copy) NSString *goodsGspId;
@property (nonatomic, assign) BOOL isCommit;
@property (nonatomic, assign) NSInteger specUnSelCount;
@end

@implementation JFGoodsDetailViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;

    //上拉 下拉
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.scrollview.contentOffset.y>APP_SCREEN_WIDTH+44*5+self.specsViewHeightConstraint.constant +50) {
            [self.scrollview.mj_footer endRefreshing];
            return ;
        }
        self.scrollview.contentSize = CGSizeMake(APP_SCREEN_WIDTH, APP_SCREEN_WIDTH+APP_SCREEN_HEIGHT +44*5+self.specsViewHeightConstraint.constant-50);
        self.contentViewHeightConstraint.constant = APP_SCREEN_WIDTH+APP_SCREEN_HEIGHT +44*5+self.specsViewHeightConstraint.constant-50;
        self.webViewHeightConstraint.constant = APP_SCREEN_HEIGHT-50;
        self.scrollview.contentOffset = CGPointMake(0, APP_SCREEN_WIDTH+44*5+self.specsViewHeightConstraint.constant);
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsModel.goods_url]]];
        [self.scrollview.mj_footer endRefreshing];
        self.scrollview.scrollEnabled = NO;
    }];
    self.scrollview.mj_footer = footer;
    
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
        self.scrollview.contentOffset = CGPointMake(0, 0);
        self.scrollview.scrollEnabled =YES;
        self.scrollview.contentSize = CGSizeMake(APP_SCREEN_WIDTH, APP_SCREEN_WIDTH+44*5+self.specsViewHeightConstraint.constant);
        self.contentViewHeightConstraint.constant = APP_SCREEN_WIDTH+44*5+self.specsViewHeightConstraint.constant;
        self.webViewHeightConstraint.constant = 0;
        [self.webview.scrollView.mj_header endRefreshing];
    }];
    self.webview.scrollView.mj_header = header;
    
    //初始化请求
    self.apiAddShopCar = [[ApiAddToShopCarRequest alloc]initWithDelegate:self];
    self.apiInverntory = [[ApiGoodsInventoryRequest alloc]initWithDelegate:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.specUnSelCount = 0;
    [HUDManager  showLoadingHUDView:kWindow];
    self.apiDetail = [[APIGoodsDetailRequest alloc]initWithDelegate:self];
    [self.apiDetail setApiParamsWithGoodsId:self.goodsId];
    [APIClient execute:self.apiDetail];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
#pragma mark -  UIScrollView
#pragma mark -  APIRequestDelegate

- (void)serverApi_RequestFailed:(APIRequest *)api error:(NSError *)error {
    
    [HUDManager hideHUDView];
    [HUDManager showWarningWithText:kDefaultNetWorkErrorString];
}

- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr {
    
    [HUDManager hideHUDView];
    
    if (sr.dic == nil || [sr.dic isKindOfClass:[NSNull class]]) {
        return;
    }
    if (api == self.apiDetail) {//商品详情数据
        NSDictionary *dic = [sr.dic objectForKey:@"goods"];
        self.goodsModel = [JFGoodsDetailModel initJFGoodsDetailModellWith:dic];
        self.shopCarNum  =[ValueUtils stringFromObject:[sr.dic objectForKey:@"goods_count"]];
        [self installUIWithModel:self.goodsModel];
    }
    if (api == self.apiInverntory) {//库存信息
        self.inventoryModel = [JFInventoryModel yy_modelWithDictionary:sr.dic];
        if ([[ValueUtils stringFromObject:self.inventoryModel.store_price]isEqualToString:@""] ) {
            self.inventoryModel.store_price = @"0";
        }
        [self initSubUIWithModel:self.inventoryModel];
    }
    if (api == self.apiAddShopCar) {//加入购物车
        if (self.isCommit) {//点立即兑换
            NSString *gc_id = [ValueUtils stringFromObject:[sr.dic objectForKey:@"gc_id"]];
            [self pushWithVCClassName:@"JFCommitOrderViewController" properties:@{@"title":@"提交订单",@"goodsId":gc_id}];
        }else{//加入购入车
            [self.shopCarNumBtn setTitle:[ValueUtils stringFromObject:[sr.dic objectForKey:@"count"] ] forState:UIControlStateNormal];
            [HUDManager showWarningWithText:sr.msg];
        }

    }
}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) {
        message = kDefaultServerErrorString;
    }
    [HUDManager showWarningWithText:message];
}


#pragma mark - uiwebviewdelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.scrollview.mj_footer endRefreshing];
}
#pragma mark - JFGoodsSpecsViewDelegate
/**选中当前规格某种规格*/
-(void)goodsSpecs:(JFGoodsSpecsView *)item spec:(JFGoodsSpec *)spec gsp:(JFGoodsGsp *)gsp{
    if (self.specUnSelCount>0) {
        self.specUnSelCount--;
    }
    NSArray *ggs = [self.goodsGspId componentsSeparatedByString:@","];
    self.goodsGspId = @"";
    if (ggs.count>0) {
        for (int i=0; i<ggs.count; i++) {
            NSString *gg = ggs[i];
            if (i==item.tag ) gg=gsp.gspId;
            
            if (i==0) self.goodsGspId = gg;
            else      self.goodsGspId = [NSString stringWithFormat:@"%@,%@",self.goodsGspId,gg];
        }
    }else if (ggs.count==0){
        self.goodsGspId = gsp.gspId;
    }
    
    [self.apiInverntory setApiParamsWithGoodId:self.goodsId goodsSpec:self.goodsGspId];
    [APIClient execute:self.apiInverntory];

}
/**没有选中当前某种规格*/
-(void)goodsSpecSelectNone:(JFGoodsSpecsView *)item{
    self.specUnSelCount ++;
}
#pragma mark - event response

/**购物车按钮*/
- (IBAction)shopCarBtnClick:(UIButton *)sender {
    [self pushWithVCClassName:@"JFShoppingCarViewController" properties:@{@"title":@"购物车"}];
}
/**加入购物车*/
- (IBAction)joinShopCarBtnClick:(UIButton *)sender {
    if ([self dataCheck]) {
        [self.apiAddShopCar setApiParamsWithGoodsId:self.goodsId
                                              count:@"1"
                                           integral:self.inventoryModel.goods_price
                                             sku_id:self.inventoryModel.ids
                                              gspid:self.goodsGspId];
        [APIClient execute:self.apiAddShopCar];
        self.isCommit = NO;
    }
}
/**立即兑换*/
- (IBAction)convertBtnClick:(UIButton *)sender {
    if ([self dataCheck]) {
        [self.apiAddShopCar setApiParamsWithGoodsId:self.goodsId
                                              count:@"1"
                                           integral:self.inventoryModel.goods_price
                                             sku_id:self.inventoryModel.ids
                                              gspid:self.goodsGspId];
        [APIClient execute:self.apiAddShopCar];
        self.isCommit = YES;
    }
}

#pragma mark - private methods
- (void)installUIWithModel:(JFGoodsDetailModel *)model{
    
    self.goodsTaglabel.text = [NSString stringWithFormat:@"%@",@""];
    self.goodsNamelabel.text = model.goods_name;
    self.goodsIntegralLabel.text = [NSString stringWithFormat:@"%@积分",model.goods_price];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.store_price];
    if ([[ValueUtils stringFromObject:model.goods_brand] isEqualToString:@""]) {
        self.goodsBrandLabel.text = @"无";
    }else{
        self.goodsBrandLabel.text = [ValueUtils stringFromObject:model.goods_brand];
    }
    self.goodsStockLabel.text = [ValueUtils stringFromObject:model.goods_inventory];
    
    //轮播图设置
    [ad removeFromSuperview];
    ad = [AdView adScrollViewWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH) imageLinkURL:model.goods_photos placeHoderImageName:@"ShopCartWaresDefaultImg" pageControlShowStyle:UIPageControlShowStyleNone];
    NSMutableArray *titleArray = [NSMutableArray array];
    for (int i=0; i<model.goods_photos.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%d/%d",i+1,(int)model.goods_photos.count];
        [titleArray addObject:str];
    }
    [ad setAdTitleArray:titleArray withShowStyle:AdTitleShowStyleRight];
    //    __weak typeof(self) weakself = self;
    ad.callBack = ^(NSInteger index,NSString * imageURL)
    {
        
    };
    [self.goodsImageView addSubview:ad];
    
    //规格型号初始化    
    self.specsViewHeightConstraint.constant = 0.f;
    for (int i = 0; i<model.goods_specs.count;i++) {
        JFGoodsSpec *spec = model.goods_specs[i];
        JFGoodsGsp *gsp = spec.gsps[0];
        spec.checked = gsp.gspId;
        JFGoodsSpecsView *sv = [[JFGoodsSpecsView alloc]initWithFrame:CGRectMake(0, 44*i, APP_SCREEN_WIDTH, 44)];
        sv.delegate = self;
        sv.tag = i;
        sv.itemDict = spec;
        sv.checked = spec.checked;
        [self.goodsSpecsView addSubview:sv];
        
        self.specsViewHeightConstraint.constant =self.specsViewHeightConstraint.constant + sv.height;
        //默认记录为第一个规格id
        if (i==0) {
            self.goodsGspId = [spec.gsps[0] gspId];
        }else{
            self.goodsGspId =[NSString stringWithFormat:@"%@,%@",self.goodsGspId,[spec.gsps[0] gspId]] ;
        }
        if (model.goods_specs.count>0 && i<model.goods_specs.count-1    ) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, sv.origin.y+sv.height, sv.width, 0.5)];
            line.backgroundColor = HEXCOLOR(0xF5F5F5);
            [self.goodsSpecsView addSubview:line];
        }
    }
    if (APP_SCREEN_WIDTH + 44*5+self.specsViewHeightConstraint.constant>APP_SCREEN_HEIGHT-50) {
        self.contentViewHeightConstraint.constant = APP_SCREEN_WIDTH + 44*5+self.specsViewHeightConstraint.constant;
    }else{
        self.contentViewHeightConstraint.constant = APP_SCREEN_HEIGHT-50;
    }
    
    //默认选中一个 发送库存请求
    [self.apiInverntory setApiParamsWithGoodId:self.goodsId goodsSpec:self.goodsGspId];
    [APIClient execute:self.apiInverntory];

    //购物车角标
    [self.shopCarNumBtn setTitle:self.shopCarNum forState:UIControlStateNormal];
}
- (void)initSubUIWithModel:(JFInventoryModel *)model{
    self.goodsIntegralLabel.text = [NSString stringWithFormat:@"%@积分",model.goods_price];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.store_price];
    self.goodsStockLabel.text = model.kcnum;
}


- (BOOL)dataCheck{
    if ([self.goodsStockLabel.text isEqualToString:@"0"]) {//商品数量等于0 不能点击提交
        [HUDManager showWarningWithText:@"库存不足,请选择其他商品"];
        return NO;
    }
    if (self.specUnSelCount>0) {
        [HUDManager showWarningWithText:@"请选择规格型号!"];
        return NO;
    }

    return YES;
}
@end

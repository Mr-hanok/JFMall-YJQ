//
//  ShoppingCarViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/4/19.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFShoppingCarViewController.h"
#import "JFShoppingCarCell.h"
#import "JFGoodsInfoModel.h"
#import "JFStoreInfoMode.h"
#import "JFCommitOrderViewController.h"
#import "JFShoppingCarHeadView.h"
#import "HUDManager.h"
#import "ApiShopCarInfoRequest.h"
#import "ApiAddGoodsNumInShopCar.h"
#import "ApiDeleGoodsInShopCar.h"

@interface JFShoppingCarViewController ()<UITableViewDataSource,UITableViewDelegate,JFShoppingCarCellDelegate,JFShoppingCarHeadViewDelegate,APIRequestDelegate>
@property (retain, nonatomic) UIButton          *rightBarTitle;     //导航栏右侧<编辑/完成>按钮
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (nonatomic, retain) UIView  *navRightItem;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *allSelBtn;
@property (nonatomic, strong) NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UIButton *totalIntegralBtn;
@property (weak, nonatomic) IBOutlet UIButton *jieSuanBtn;
@property (nonatomic) int totalIntegral;//总积分
@property (nonatomic, assign) BOOL isEdite;//编辑、完成
@property (nonatomic, strong) ApiShopCarInfoRequest   *apiShopCarInfo;
@property (nonatomic, strong) ApiAddGoodsNumInShopCar *apiAddNum;
@property (nonatomic, strong) ApiDeleGoodsInShopCar   *apiDel;
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation JFShoppingCarViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviBar];
    self.array = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    self.tableview.tableFooterView = [[UIView alloc]init];
    //初始化加减 删除请求
    self.apiAddNum = [[ApiAddGoodsNumInShopCar alloc]initWithDelegate:self];
    self.apiDel    = [[ApiDeleGoodsInShopCar alloc]initWithDelegate:self];
    //购物车请求
    self.apiShopCarInfo = [[ApiShopCarInfoRequest alloc]initWithDelegate:self];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HUDManager showLoadingHUDView:kWindow];
    [APIClient execute:self.apiShopCarInfo];

}
//设置分割线距离0
-(void)viewDidLayoutSubviews
{
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) [self.tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])  [self.tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
}
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
    if (api == self.apiShopCarInfo) {//购物车信息
        [self.array removeAllObjects];
        NSArray *stores = [sr.dic objectForKey:@"carts"];
        for (NSDictionary *store in stores) {
            JFStoreInfoMode *storeModel = [JFStoreInfoMode initModelWithDic:store isEdite:self.isEdite];
            [self.array addObject:storeModel];
        }
        if (self.array.count == 0) {
            self.rightBarTitle.hidden =YES;
            self.tableview.hidden = YES;
            self.totalIntegralBtn.hidden =YES;
            self.jieSuanBtn.hidden =YES;
            [HUDManager showWarningWithText:@"购物车为空!快快添加商品去吧~"];
        }
        self.integralLabel.text = [ValueUtils stringFromObject:[sr.dic objectForKey:@"integral"]];
        
        [self.tableview reloadData];
        [self instalTotalPrice];
    }
    if (api == self.apiDel) {//购物车商品删除
        [HUDManager showLoadingHUDView:self.view];
        [APIClient execute:self.apiShopCarInfo];
    }
}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) message = kDefaultServerErrorString;
    [HUDManager showWarningWithText:message];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JFStoreInfoMode *model = self.array[section];
    return model.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JFShoppingCarCell *cell = [JFShoppingCarCell tableView:self.tableview cellForRowInTableViewIndexPath:indexPath delegate:self];
    JFStoreInfoMode *model = self.array[indexPath.section];
    [cell instalTheValue:model.goodsArray[indexPath.row]];
    
    return cell;
}
#pragma mark - UITableViewDelegate
/**设置cell高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
//设置分割线距离0
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])  [cell setLayoutMargins:UIEdgeInsetsZero];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.f;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 5.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    JFStoreInfoMode *store = self.array[section];
    JFShoppingCarHeadView *header = (JFShoppingCarHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JFShoppingCarHeadView"];
    [header instHeadviewWithSection:section storeModel:store];
    header.delegate = self;
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 5)];
    view.backgroundColor = self.view.backgroundColor;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 0.5)];
    line.backgroundColor = HEXCOLOR(0xd9d9d9);
    [view addSubview:line];
    return view;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JFStoreInfoMode *store = self.array[indexPath.section];
    JFGoodsInfoModel *model = store.goodsArray[indexPath.row];
    model.isSelect = model.isSelect ? NO:YES;
    //section 选择按钮设置
    BOOL isSectionsel = YES;
    for (JFGoodsInfoModel *m in store.goodsArray) isSectionsel = isSectionsel && m.isSelect;
    store.isSelect = isSectionsel;
    //全选按钮设置
    BOOL isallSel = YES;
    for (JFStoreInfoMode *st in self.array) isallSel = isallSel && st.isSelect ;
    self.allSelBtn.selected = isallSel;

    [self.tableview reloadData];
    //计算总积分
    [self instalTotalPrice];
    
}
#pragma mark -JFShoppingCarHeadViewDelegate
//section商店名称点击
-(void)shoppingCarHeadView:(JFShoppingCarHeadView *)headview shopNameBtn:(UIButton *)btn{
    
}
//section 选择按钮
-(void)shoppingCarHeadView:(JFShoppingCarHeadView *)headview selectBtn:(UIButton *)btn{
    
    JFStoreInfoMode *store = self.array[btn.tag];
    if (btn.selected) {
        store.isSelect = YES;
        for (JFGoodsInfoModel *model in store.goodsArray) model.isSelect = YES;
    }else{
        store.isSelect = NO;
        for (JFGoodsInfoModel *model in store.goodsArray) model.isSelect = NO;
    }
    BOOL isallSel = YES;
    for (JFStoreInfoMode *st in self.array) isallSel = isallSel && st.isSelect ;
    self.allSelBtn.selected = isallSel;
    [self instalTotalPrice];
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - JFShoppingCarCellDelegate
/*加减按钮*/
-(void)shoppingCarCell:(JFShoppingCarCell *)cell andFlag:(int)flag{
    NSIndexPath *index = [self.tableview indexPathForCell:cell];
    //先获取到当期行数据源内容，改变数据源内容，刷新表格
    JFStoreInfoMode *store = self.array[index.section];
    JFGoodsInfoModel *model = store.goodsArray[index.row];
    if (flag == 101) {
        //减数量
        if (model.goodsNum == 1) {
            [HUDManager showWarningWithText:@"商品数量不能再减少了~"];
            return;
        }
        if (model.goodsNum > 1) model.goodsNum --;
    }
        //加数量
    if (flag == 102) model.goodsNum ++;
    //发送加减数量请求
    [HUDManager showLoadingHUDView:self.view];
    NSInteger a = model.goodsNum;
    [self.apiAddNum setApiParamsWithGoodsInfoId:model.goodsId count:[NSString stringWithFormat:@"%ld",a]];
    [APIClient execute:self.apiAddNum];
    
    [self.tableview reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    //计算总价
    [self instalTotalPrice];
}
/**cell删除按钮*/
-(void)shoppingCarCell:(JFShoppingCarCell *)cell andDelBtn:(UIButton *)delBtn{
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    // 发送请求 在数据中删除当前对象
    JFStoreInfoMode *store = self.array[indexpath.section];
    JFGoodsInfoModel *model = store.goodsArray[indexpath.row];
    [HUDManager showLoadingHUDView:self.view];
    [self.apiDel setApiParamsWithStoreId:store.storeid goodsInfoId:model.goodsId];
    [APIClient execute:self.apiDel];
}
/**cell选择按钮*/
-(void)shoppingCarCell:(JFShoppingCarCell *)cell andSelectBtn:(UIButton *)selBtn model:(JFGoodsInfoModel *)model{
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    JFStoreInfoMode *store = self.array[indexpath.section];
    
    //分组全选按钮设置
    int couss = 0;
    for (int i =0; i<store.goodsArray.count; i++) {
        JFGoodsInfoModel *m = store.goodsArray[i];
        if (i== indexpath.row) model.isSelect = selBtn.selected;
        if (m.isSelect) couss ++;
    }
    store.isSelect = couss == store.goodsArray.count ? YES :NO;
    
    //全选按钮设置
    BOOL isallSel = YES;
    for (JFStoreInfoMode *st in self.array)  isallSel = isallSel && st.isSelect ;
    self.allSelBtn.selected = isallSel;
    
    [self instalTotalPrice];
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - event response
/**全选按钮*/
- (IBAction)allSecectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        for (JFStoreInfoMode *model in self.array) {
            model.isSelect = YES;
            for (JFGoodsInfoModel *m in model.goodsArray) m.isSelect = YES;
        }
    }else{
        for (JFStoreInfoMode *model in self.array) {
            model.isSelect = NO;
            for (JFGoodsInfoModel *m in model.goodsArray) m.isSelect = NO;
        }
    }
    [self.tableview reloadData];
    [self instalTotalPrice];

}
/**  结算or删除 按钮*/
- (IBAction)jieSuanBtnClick:(UIButton *)sender {
    
    [self.selectArray removeAllObjects];
    for ( int i =0; i<self.array.count; i++)
    {
        JFStoreInfoMode *store = [self.array objectAtIndex:i];
        JFStoreInfoMode *selStore = [[JFStoreInfoMode alloc]init];
        selStore.storeid = store.storeid;
        selStore.storeName = store.storeName;
        selStore.goodsNum = 0;
        for (int f =0; f<store.goodsArray.count; f++) {
            JFGoodsInfoModel *model = store.goodsArray[f];
            if (model.isSelect) {
                selStore.goodsNum = model.goodsNum +selStore.goodsNum;
                [selStore.goodsArray addObject:model];
            }
        }
        if (selStore.goodsArray.count > 0 ) [self.selectArray addObject:selStore];
    }
    
    if ([sender.titleLabel.text isEqualToString:@"删除"]) {//删除
        if (self.selectArray.count ==0) {
            [HUDManager showWarningWithText:@"请选择要删除的商品~"];
            return;
        }
        [HUDManager showLoadingHUDView:self.view];
        for (JFStoreInfoMode *store in self.selectArray) {
            for (JFGoodsInfoModel *model in store.goodsArray) {
                [self.apiDel setApiParamsWithStoreId:store.storeid goodsInfoId:model.goodsId];
                [APIClient execute:self.apiDel];
            }
        }
        
    }else{//结算
        if (self.selectArray.count ==0) {
            [HUDManager showWarningWithText:@"请选择要结算的商品~"];
            return;
        }
        NSString *goodsIds = nil;
        for (int i=0;i<self.selectArray.count;i++) {
            JFStoreInfoMode *store= self.selectArray[i];
            for (int k=0;k<store.goodsArray.count;k++) {
                JFGoodsInfoModel *model = store.goodsArray[k];
                if (i==0 && k==0) goodsIds = model.goodsId;
                else goodsIds = [NSString stringWithFormat:@"%@,%@",goodsIds,model.goodsId];
            }
        }
        [self pushWithVCClassName:@"JFCommitOrderViewController" properties:@{@"title":@"提交订单",@"goodsId":goodsIds}];
    }
}
#pragma mark - private methods
- (void)initNaviBar{
    [self setNavBarLeftItemAsBackArrow];
    self.array = [NSMutableArray array];
    self.totalIntegral = 0;
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
    self.tableview.tableFooterView = [[UIView alloc]init];
    CGRect newFrame = self.headView.frame;
    newFrame.size.height = 90.f;
    self.headView.frame = newFrame;
    self.tableview.tableHeaderView = self.headView;
    
    // SectionHeaderNib
    UINib *headerNib = [UINib nibWithNibName:@"JFShoppingCarHeadView" bundle:[NSBundle mainBundle]];
    [self.tableview registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"JFShoppingCarHeadView"];

}
/**计算总价*/
- (void)instalTotalPrice{
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格（单价 * 商品数量）记录个数
    NSInteger selGoodsNum = 0;
    for ( int i =0; i<self.array.count; i++)
    {
        JFStoreInfoMode *store = [self.array objectAtIndex:i];
        for (JFGoodsInfoModel *model in store.goodsArray) {
            if (model.isSelect)
            {
                selGoodsNum = model.goodsNum+selGoodsNum;
                self.totalIntegral = self.totalIntegral + model.goodsNum *[model.goodsIntegral intValue];
            }
        }
    }
    //给总价文本赋值
    if (self.isEdite) {
        [self.totalIntegralBtn setTitle:[NSString stringWithFormat:@"已选择%ld个",selGoodsNum] forState:UIControlStateNormal];
    }else{
        [self.totalIntegralBtn setTitle:[NSString stringWithFormat:@"合计:%d积分",self.totalIntegral] forState:UIControlStateNormal];
    }
    self.totalIntegral = 0;
}
#pragma mark - 重写导航栏右侧按钮点击事件处理函数
// 导航栏右侧BarItem点击事件处理函数
- (void)rightBarButtonItemClickHandler:(UIButton *)barBtn
{
    barBtn.selected = !barBtn.selected;
    self.isEdite = barBtn.selected;
    if (self.isEdite) {//编辑状态
        [self setIntegralBtnTitle:[NSString stringWithFormat:@"已选择%d个",self.totalIntegral] jieSuanBtnTitle:@"删除" isEdite:self.isEdite];
    }else{//非编辑状态
        [self setIntegralBtnTitle:[NSString stringWithFormat:@"合计:%d积分",self.totalIntegral] jieSuanBtnTitle:@"去结算" isEdite:self.isEdite];
    }
    [self instalTotalPrice];
    [self.tableview reloadData];
}
- (void)setIntegralBtnTitle:(NSString *)title jieSuanBtnTitle:(NSString *)jsTitle isEdite:(BOOL)isEdite{
    [self.totalIntegralBtn setTitle:title forState:UIControlStateNormal];
    ;
    [self.jieSuanBtn setTitle:jsTitle forState:UIControlStateNormal];
    ;
    for (JFStoreInfoMode *store in self.array) {
        store.isEdite = isEdite;
        for (JFGoodsInfoModel *model in store.goodsArray) model.isEdite = isEdite;
    }
}
@end

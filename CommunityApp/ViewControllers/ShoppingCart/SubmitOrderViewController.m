//
//  SubmitOrderViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "SubmitOrderViewController.h"
#import "SubmitOrderTableViewCell.h"
#import "RoadAddressManageViewController.h"
#import "ContactSelect.h"
#import "ShopCartModel.h"
#import "DBOperation.h"
#import "CartBottomBar.h"
#import "RoadData.h"
#import "CommitResultViewController.h"
#import "CouponViewController.h"
#import "CouponsDetail.h"

#pragma mark - 宏定义区
#define SubmitOrderTableViewCellNibName         @"SubmitOrderTableViewCell"

@interface SubmitOrderViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIActionSheetDelegate, ContactSelectDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UITextView *remarkTextView;
@property (retain, nonatomic) IBOutlet UIView *remarkBgView;
@property (retain, nonatomic) IBOutlet UILabel *waresMoneyLabel;
@property (retain, nonatomic) IBOutlet UILabel *dispatchMoneyLabel;
@property (retain, nonatomic) IBOutlet UILabel *discountMoneyLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@property (retain, nonatomic) CartBottomBar     *carBar;        //购物车Bar(编辑/完成)状态不同，内容不同

// 提交订单信息数组
@property (nonatomic, retain) NSMutableArray    *submitDataArray;

@property (nonatomic, copy) NSString    *addr;          // 收货地址
@property (nonatomic, copy) NSString    *projectId;     // 项目(小区)Id
@property (nonatomic, copy) NSString    *buildingId;    // 楼址Id
@property (nonatomic, copy) NSString    *contact;       // 联系人
@property (nonatomic, copy) NSString    *name;          // 联系人姓名
@property (nonatomic, copy) NSString    *telno;         // 联系电话
@property (nonatomic, copy) NSString    *payMethod;     // 支付方式

@property (nonatomic, assign) CGFloat    remarkTextHeight;

@property (nonatomic, retain) RoadData  *roadData;

@property (nonatomic, copy) CouponsDetail* couponsDetail;

@property (nonatomic, assign) NSInteger     shouldSubmitCount;      // 应提交数
@property (nonatomic, assign) NSInteger     hasSubmittedCount;      // 已提交数
@property (nonatomic, assign) NSInteger     hasReturnResultCount;   // 已返回结果数

@end

@implementation SubmitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Cart_SubmitOrder;
    [self setNavBarLeftItemAsBackArrow];
    
    [self initBasicDataInfo];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];
    
    [self.waresMoneyLabel setText:[NSString stringWithFormat:@"%.2f", self.totalVal]];
    [self.totalMoneyLabel setText:[NSString stringWithFormat:@"%.2f", self.totalVal]];
    
    self.carBar = [CartBottomBar instanceCartBottomBar];
    
    
    self.hasSubmittedCount = 0;
    self.shouldSubmitCount = 0;
    
    // 计算应该提交申请的次数
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected==YES and type==0"];
    NSArray *waresArray = [self.cartArray filteredArrayUsingPredicate:predicate];
    if (waresArray.count > 0) {
        self.shouldSubmitCount++;
    }
    predicate = [NSPredicate predicateWithFormat:@"isSelected==YES and type==1"];
    NSArray *serviceArray = [self.cartArray filteredArrayUsingPredicate:predicate];
    self.shouldSubmitCount += serviceArray.count;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshTableView];
}


#pragma mark - 键盘显示、隐藏事件处理函数重写
- (void)keyboardDidShow:(NSNotification *)notification
{
    [super keyboardDidShow:notification];
    self.tableView.contentOffset = CGPointMake(0, self.keyboardHeight);
}

- (void)keyboardDidHide
{
    self.tableView.contentOffset = CGPointMake(0, 0);
    [super keyboardDidHide];
}


#pragma mark - tableview datasource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.submitDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubmitOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubmitOrderTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.submitDataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {   //选择地址
        RoadAddressManageViewController *vc = [[RoadAddressManageViewController alloc] init];
        vc.isAddressSel = addressSel_Default;
        [vc setSelectAddressProjectIdAndBuildingId:^(NSString *addr, NSString *projectId, NSString *buildingId) {
            self.addr = addr;
            self.projectId = projectId;
            self.buildingId = buildingId;
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) { //选择联系人
        ContactSelect *vc = [[ContactSelect alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2) { //选择支付方式
        UIActionSheet   *sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_Cart_ArrivePay,Str_Cart_OnlinePay, nil];
        [sheet showInView:self.view];
    }
    else if (indexPath.row == 3) { //选择优惠券
        CouponViewController *vc = [[CouponViewController alloc]init];
        vc.leftBtnBackToRoot = NO;
        [vc setSelectCoupon:^(CouponsDetail* detail){
            self.couponsDetail = detail;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - TextView delegate
// 文本编辑开始
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:Str_Cart_Remark] == TRUE) {
        textView.text = @"";
    }
    
    return TRUE;
}

// 文本内容改变
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 更新footerView高度
    [self autoUpdateFooterViewHeight];
    return TRUE;
}


- (void)setSelectedContactName:(NSString *)name andTelno:(NSString *)telno
{
    self.contact = [NSString stringWithFormat:@"%@   %@",name,telno];
    self.name = name;
    self.telno = telno;
}


#pragma mark -ActionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.payMethod = Str_Cart_ArrivePay;
    }
    else if (buttonIndex == 1)
    {
        self.payMethod = Str_Cart_OnlinePay;
    }
    [self refreshTableView];
}


#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.name = [[LoginConfig Instance] userName];
    self.telno = [[LoginConfig Instance] userAccount];
    self.contact = [NSString stringWithFormat:@"%@   %@",self.name, self.telno];
    
    self.payMethod = Str_Cart_ArrivePay;
    self.addr = Str_Cart_RecvAddr;
    
    [self getDefaultRoadDataFromServer];
    
    self.submitDataArray = [[NSMutableArray alloc] init];
    
    // 注册TableViewCell Nib
    UINib *nibForSubmit = [UINib nibWithNibName:SubmitOrderTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForSubmit forCellReuseIdentifier:SubmitOrderTableViewCellNibName];
    
    self.remarkTextView.delegate = self;
    self.remarkTextView.textColor = COLOR_RGB(57, 57, 57);
    self.headerView.frame = CGRectMake(0, 0, Screen_Width, 195);
    self.tableView.tableHeaderView = self.headerView;
    
    self.footerView.frame = CGRectMake(0, 0, Screen_Width, 134);
    self.tableView.tableFooterView = self.footerView;
    
    self.remarkTextHeight = 33.0;
}


// 自动更新FooterView高度
- (void)autoUpdateFooterViewHeight
{
    CGFloat height = self.remarkTextHeight;
    if (IOS7) {
        CGRect textFrame=[[self.remarkTextView layoutManager]usedRectForTextContainer:[self.remarkTextView textContainer]];
        height = textFrame.size.height;
        
    }else {
        
        height = self.remarkTextView.contentSize.height;
    }
    
    if (height != self.remarkTextHeight) {
        self.remarkTextHeight = height;
        if (self.remarkTextHeight < 33.0) {
            self.remarkTextHeight = 33.0;
        }
        self.footerView.frame = CGRectMake(0, 0, Screen_Width, 132+(self.remarkTextHeight-33.0)+5.0);
        self.tableView.tableFooterView = self.footerView;
        [self.tableView.tableFooterView reloadInputViews];

        self.tableView.contentOffset = CGPointMake(0, self.keyboardHeight+(self.remarkTextHeight-33.0)+5.0);
    }

}

#pragma mark - 更新TableView
- (void)refreshTableView
{
    NSArray *submitData = @[@[Img_Comm_Addr, self.addr],
                            @[Img_Comm_Time, self.contact],
                            @[Img_Comm_Money, self.payMethod],
                            @[Img_Comm_CouponIcon, @"优惠券"]];
    [self.submitDataArray removeAllObjects];
    [self.submitDataArray addObjectsFromArray:submitData];
    [self.tableView reloadData];
}



#pragma mark - 按钮点击事件处理函数
- (IBAction)submitBtnClickHandler:(id)sender
{
    if ([self.addr isEqualToString:@""] || [self.addr isEqualToString:Str_Cart_RecvAddr]) {
        [Common showBottomToast:Str_Cart_RecvAddr];
    }else if ([self.contact isEqualToString:@""]) {
        [Common showBottomToast:Str_Cart_Contact];
    }else if ([self.payMethod isEqualToString:@""]){
        [Common showBottomToast:Str_Cart_PayMethod];
    }else {
        [self submitWaresDataToServer];
    }
}


#pragma mark - 服务器获取数据
- (void)getDefaultRoadDataFromServer
{
    NSString *userId = [[LoginConfig Instance] userID];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: userId,@"userId",nil];
    
    [self getArrayFromServer:ServiceInfo_Url path:DefaultRoadAddress_path method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result)
     {
         for (NSDictionary *dicResult in result)
         {
             if (dicResult) {
                 self.roadData = [[RoadData alloc] initWithDictionary:dicResult];
             }
         }
         if (self.roadData != nil) {
             self.addr = [NSString stringWithFormat:@"%@  %@",self.roadData.projectName, self.roadData.address];
             self.projectId = self.roadData.projectId;
             self.buildingId = self.roadData.buildingId;
         }
         [self refreshTableView];
     }
     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}

#pragma mark - 判断请求是否已经全部返回结果
- (void)judgeIsHasAllReturnResult
{
    self.hasReturnResultCount++;
    if (self.hasReturnResultCount == self.shouldSubmitCount
     && self.hasSubmittedCount != self.shouldSubmitCount) {
        [self.waresMoneyLabel setText:[NSString stringWithFormat:@"%.2f", self.totalVal]];
        [self.totalMoneyLabel setText:[NSString stringWithFormat:@"%.2f", self.totalVal]];
    }
}


#pragma mark - 判断是否已经全部提交成功
- (void)judgeIsHasSubmitSuccess:(eCartViewFromViewID) submitType
{
    self.hasSubmittedCount++;
    if (self.hasSubmittedCount == self.shouldSubmitCount) {
        CommitResultViewController *vc = [[CommitResultViewController alloc] init];
        vc.resultDesc = @"您选择的商品已经提交成功";
        vc.eFromViewID = submitType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 向服务器提交订单
- (void)submitWaresDataToServer
{
    self.payMethod = Str_Cart_OnlinePay;/////////////只可在线支付
    NSString *orderId = [Common getUUIDString];
    NSString *userId = [[LoginConfig Instance] userID];
    
    NSMutableString *goodsIds = [[NSMutableString alloc] initWithString:@""];
    
    NSString *payment = @"1";
    if ([self.payMethod isEqualToString:Str_Cart_OnlinePay]) {
        payment = @"0";
    }
    
    /*-----------------提交商品----------------*/
    /*---------------------------------------*/
    {
        CGFloat totalMoney = 0.0;
        for (ShopCartModel *model in self.cartArray) {
            if (model.isSelected && model.type==0) {
                [goodsIds appendString:[NSString stringWithFormat:@"%@:%@:%ld,",model.wsId, model.currentPrice, (long)model.count]];
                totalMoney += [model.currentPrice floatValue]*model.count;
            }
        }
        if (goodsIds.length > 0) {
            NSRange range = NSMakeRange((goodsIds.length-1),1);
            [goodsIds deleteCharactersInRange:range];
            
            // 初始化参数
            NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[orderId, userId, self.addr, payment, self.name, self.telno, @"2", self.remarkTextView.text, goodsIds, [NSString stringWithFormat:@"%.2f", totalMoney]/*,@"",@"",@""*/] forKeys:@[@"orderId", @"ownerid", @"address", @"payment", @"linkName", @"linkTel", @"moduleType", @"remarks", @"goodsIds", @"totalMoney"/*,@"sellerId",@"couponsId",@"couponsMoney"*/]];
            
            // 请求服务器提交数据
            [self getStringFromServer:SubmitOrder_Url path:SubmitOrder_Path method:@"POST" parameters:dic success:^(NSString *result) {
                if ([result isEqualToString:@"1"]) {
                    [self judgeIsHasSubmitSuccess:E_ResultViewFromViewID_SubmitCommodityOrder];
                    NSMutableArray *indexs = [[NSMutableArray alloc] init];
                    NSInteger   index = 0;
                    for (ShopCartModel *model in self.cartArray) {
                        index++;
                        if (model.isSelected && model.type==0) {
                            [[DBOperation Instance] deleteWaresDataFromCart:model.wsId withWaresStyle:model.waresStyle];
                            [self deleteCartInfoToServerByShopCartModel:model];
                            self.carBar.totalCount -= model.count;
                            self.totalVal -= [model.currentPrice floatValue] * model.count;
                            [indexs addObject:[NSNumber numberWithInteger:index]];
                        }
                    }
                    for (NSNumber *number in indexs) {
                        index = [number integerValue];
                        [self.cartArray removeObjectAtIndex:index];
                    }
                    
                    UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
                    
                    if (self.carBar.totalCount > 0) {
                        tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)self.carBar.totalCount];
                    }
                    else {
                        tabBarItem.badgeValue = nil;
                    }
                }
                else {
                    [Common showBottomToast:@"订单提交失败"];
                }
                [self judgeIsHasAllReturnResult];
            } failure:^(NSError *error) {
                [Common showBottomToast:Str_Comm_RequestTimeout];
                [self judgeIsHasAllReturnResult];
            }];
        }
    }
    
    
    /*-----------------提交服务----------------*/
    /*---------------------------------------*/
    {
        for (ShopCartModel *model in self.cartArray) {
            if (model.isSelected && model.type==1) {
                NSString *serviceTime = @"";
                if (model.appointmentType == 2) {
                    serviceTime = model.serviceTime;
                }
                // 初始化参数
                NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[orderId, userId, self.projectId, self.addr, self.buildingId, self.name, self.telno, model.wsId, [NSString stringWithFormat:@"%ld",(long)model.appointmentType], serviceTime, self.remarkTextView.text, @"", payment, @"0", model.currentPrice] forKeys:@[@"orderId", @"userId", @"projectId", @"address", @"buildingId", @"linkName", @"linkTel", @"serviceId", @"type", @"appointmenTime", @"remarks", @"materials", @"payment", @"ifPay", @"money"]];
                
                YjqLog(@"model.currentPrice==========%@",model.currentPrice);
                // 请求服务器提交数据
                [self getStringFromServer:SubmitServiceOrder_Url path:SubmitServiceOrder_Path method:@"POST" parameters:dic success:^(NSString *result) {
                    if ([result isEqualToString:@"1"]) {
                        [self judgeIsHasSubmitSuccess:E_ResultViewFromViewID_SubmitServiceOrder];
                        
                        [[DBOperation Instance] deleteWaresDataFromCart:model.wsId withWaresStyle:model.waresStyle];
                        [self deleteCartInfoToServerByShopCartModel:model];
                        self.carBar.totalCount -= model.count;
                        self.totalVal -= [model.currentPrice floatValue] * model.count;
                        [self.cartArray removeObject:model];
                        UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
                        
                        if (self.carBar.totalCount > 0) {
                            tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)self.carBar.totalCount];
                        }
                        else {
                            tabBarItem.badgeValue = nil;
                        }
                    }
                    else {
                        [Common showBottomToast:@"订单提交失败"];
                    }
                    [self judgeIsHasAllReturnResult];
                } failure:^(NSError *error) {
                    [Common showBottomToast:Str_Comm_RequestTimeout];
                    [self judgeIsHasAllReturnResult];
                }];
            }
        }
    }
    
}




// 手势隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [self.remarkTextView resignFirstResponder];
}

// Scroll拖动时隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.remarkTextView resignFirstResponder];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

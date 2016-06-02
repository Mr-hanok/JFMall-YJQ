//
//  PropertyBillViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PropertyBillViewController.h"
#import "PropertyBillTableViewCell.h"
#import "BillHistoryViewController.h"
#import "PayBillViewController.h"
#import "PrepayBillViewController.h"
#import "BillDetailViewController.h"
#import "BuildingListModel.h"
#import "BillGeneralInfoModel.h"
#import "BillListModel.h"
#import "PropertyBillBuildingSelectViewController.h"
#import "RoadData.h"
#import "RoadAddressManageViewController.h"

#pragma mark - 宏定义区
#define PropertyBillTableViewCellNibName            @"PropertyBillTableViewCell"


@interface PropertyBillViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UIView *headerBgView;
@property (weak, nonatomic) IBOutlet UIView *billTypeBgView;
@property (retain, nonatomic) IBOutlet UIButton *allBillBtn;
@property (retain, nonatomic) IBOutlet UIButton *unpayBillBtn;
@property (retain, nonatomic) IBOutlet UIImageView *selBuildImg;
@property (retain, nonatomic) IBOutlet UILabel *userNameTelnoLabel; // 业主名和电话
@property (retain, nonatomic) IBOutlet UILabel *buildInfoLabel;     // 业主楼址信息
@property (retain, nonatomic) IBOutlet UILabel *prepayMoneyLabel;   // 预交金额合计
@property (retain, nonatomic) IBOutlet UILabel *unpayMoneyLabel;    // 未交金额合计
@property (copy, nonatomic) NSString* prepayMoney;    // 未交金额合计
@property (copy, nonatomic) NSString* unpayMoney;    // 未交金额合计
// 物业缴费数据数组
@property (nonatomic, retain) NSMutableArray        *billArray;

@property (nonatomic, retain) NSMutableArray        *buildingListArray;
@property (nonatomic, retain) BillGeneralInfoModel  *billGeneralInfoModel;
@property (nonatomic, retain) NSMutableArray        *billListArray;
@property (nonatomic, assign) NSInteger             selBuildingIndex;
@property (strong,nonatomic) RoadData* roadData;

@end

@implementation PropertyBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Comm_PropertyBill;
    [self setNavBarLeftItemAsBackArrow];
    [self setNavBarItemRightViewForNorImg:Img_PropBill_NavHistoryNor andPreImg:Img_PropBill_NavHistoryPre];
    [self initBasicDataInfo];
    [self getDefaultRoad];
}
 
-(void)viewWillAppear:(BOOL)animated
{
    [Common setRoundBorder:_billTypeBgView borderWidth:0.5 cornerRadius:5 borderColor:Color_Gray_RGB];
    [super viewWillAppear:animated];
    [_allBillBtn setSelected:TRUE];
    [_unpayBillBtn setSelected:FALSE];
    [self postAllBillRequest];
    [self setUIBtnClickState];
}

#pragma mark - tableview datasource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#if 0
    return self.billArray.count;
#else
  
    return self.billListArray.count;
    
    
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropertyBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PropertyBillTableViewCellNibName forIndexPath:indexPath];
#if 0
    if (indexPath.row == 0) {
        [cell loadCellData:[self.billArray objectAtIndex:indexPath.row] byCellType:E_Cell_First];
    }
    else if (indexPath.row == (self.billArray.count-1)){
        [cell loadCellData:[self.billArray objectAtIndex:indexPath.row] byCellType:E_Cell_Last];
    }
    else{
        [cell loadCellData:[self.billArray objectAtIndex:indexPath.row] byCellType:E_Cell_Middle];
    }
#else
    NSArray* bill;
   
    bill =  self.billListArray;
    
    if (indexPath.row == 0) {
        [cell loadCellModelData:[bill objectAtIndex:indexPath.row] byCellType:E_Cell_First];
    }
    else if (indexPath.row == (bill.count-1)){
        [cell loadCellModelData:[bill objectAtIndex:indexPath.row] byCellType:E_Cell_Last];
    }
    else{
        [cell loadCellModelData:[bill objectAtIndex:indexPath.row] byCellType:E_Cell_Middle];
    }
#endif
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BillDetailViewController *vc = [[BillDetailViewController alloc] init];
//    BuildingListModel* build = [self.buildingListArray objectAtIndex:_selBuildingIndex];
//    vc.buildingId = build.buildingId;
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 按钮事件处理函数
// 全部账单
- (IBAction)allBillBtnClickHandler:(id)sender
{
    self.allBillBtn.selected = YES;
    self.unpayBillBtn.selected = NO;
#if 0
    NSArray *bills = @[@[@"StoreGoodsImg", @"123", @"020-88562918", @"200m"],
                       @[@"StoreGoodsImg", @"123", @"020-88562918", @"200m"],
                       @[@"StoreGoodsImg", @"123", @"020-88562918", @"200m"],
                       @[@"StoreGoodsImg", @"456", @"020-88562918", @"200m"],
                       @[@"StoreGoodsImg", @"456", @"020-88562918", @"200m"],
                       @[@"StoreGoodsImg", @"456", @"020-88562918", @"200m"],
                       @[@"StoreGoodsImg", @"789", @"020-88562918", @"200m"],
                       @[@"StoreGoodsImg", @"789", @"020-88562918", @"200m"]];
    [self.billArray removeAllObjects];
    [self.billArray addObjectsFromArray:bills];
    [self.tableView reloadData];
#endif
    //获取账单列表
    [self postAllBillRequest];
    [self setUIBtnClickState];
  
}

-(void)getBillPreview
{
//    if(self.buildingListArray.count == 0)
//    {
//        return;
//    }
//    BuildingListModel* build = [self.buildingListArray objectAtIndex:_selBuildingIndex];
    if (_roadData != nil && _roadData.buildingId != nil && _roadData.buildingId.length > 0) {
        [self getBillGeneralInfoFromServerForBuildingId:_roadData.buildingId];
    }
}
-(void) postAllBillRequest
{
//    if(self.buildingListArray.count == 0)
//    {
//        return;
//    }
//    BuildingListModel* build = [self.buildingListArray objectAtIndex:_selBuildingIndex];
    if (_roadData != nil && _roadData.buildingId != nil && _roadData.buildingId.length > 0) {
        [self getBillListInfoFromServerForBuildingId:_roadData.buildingId byType:@"1" ];
    }
    
}

// 未交账单
- (IBAction)unpayBillBtnClickHandler:(id)sender
{
    self.allBillBtn.selected = NO;
    self.unpayBillBtn.selected = YES;
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height-49);
//    if(self.buildingListArray.count == 0)
//    {
//        return;
//    }
//    BuildingListModel* build = [self.buildingListArray objectAtIndex:_selBuildingIndex];
    if (_roadData != nil && _roadData.buildingId != nil && _roadData.buildingId.length > 0) {
        [self getBillListInfoFromServerForBuildingId:_roadData.buildingId byType:@"0" ];
    }
    [self setUIBtnClickState];
}

// 预交费用
- (IBAction)prepayBillBtnClickHandler:(id)sender
{
    PrepayBillViewController *vc = [[PrepayBillViewController alloc] init];
    if(self.buildingListArray.count == 0)
    {
        return;
    }
    BuildingListModel* build = [self.buildingListArray objectAtIndex:_selBuildingIndex];
    vc.buildingId = build.buildingId;   
    [self.navigationController pushViewController:vc animated:YES];
}

// 缴纳费用
- (IBAction)payBillBtnClickHandler:(id)sender
{
//    if(self.buildingListArray.count == 0)
//    {
//        return;
//    }
    if (_roadData != nil && _roadData.buildingId != nil && _roadData.buildingId.length > 0) {
        PayBillViewController *vc = [[PayBillViewController alloc] init];
        vc.buildingId = _roadData.buildingId;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    PayBillViewController *vc = [[PayBillViewController alloc] init];
//    BuildingListModel* build = [self.buildingListArray objectAtIndex:_selBuildingIndex];
//    vc.buildingId = build.buildingId;
//    [self.navigationController pushViewController:vc animated:YES];
}

//地址认证
- (IBAction)buildingBtnClickHandler:(id)sender
{
//    if(_buildingListArray.count == 0)
//        return;
//    PropertyBillBuildingSelectViewController* vc = [[PropertyBillBuildingSelectViewController alloc]init];
//    vc.buildingList = _buildingListArray;
//    vc.selectBuilding = ^(NSInteger index)
//    {
//        _selBuildingIndex = index;
//    };
//    BuildingListModel* model = [_buildingListArray objectAtIndex:_selBuildingIndex];
//    [_buildInfoLabel setText:model.address];
//    [self.navigationController pushViewController:vc animated:TRUE];
    
    RoadAddressManageViewController *next = [[RoadAddressManageViewController alloc] init];
    next.isAddressSel = addressSel_Default;
    next.showType = ShowDataTypeAuth;
    [next setSelectRoadData:^(RoadData *data) {
        if (![data.authen isEqualToString:@"1"]) {
            [self showAdressNotAuthAlert];
            return;
        }
        if (data != nil) {
            _roadData = data;
            if (data.address != nil) {
                [_buildInfoLabel setText:data.address];
                [_userNameTelnoLabel setText:[NSString stringWithFormat:@"%@  %@", data.contactName, data.contactTel]];
            }
//            [self postAllBillRequest];
            [self getBillPreview];
        }

    }];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    _selBuildingIndex = 0;
    // 获取用户信息
    LoginConfig *login = [LoginConfig Instance];
    NSString *userName = [login userName];
    NSString *userPhone = [login getOwnerPhone];
    NSMutableString* userInfo = [[NSMutableString alloc]init];
    if (userName.length <= 0 && userPhone.length <= 0) {
        [userInfo appendString:@"用户名  联系电话"];
        [Common showBottomToast:@"尚未登记个人信息"];
    }else{
        if(userName.length > 0){
            [userInfo appendString:userName];
        }
        if (userPhone.length > 0) {
            [userInfo appendString:[NSString stringWithFormat:@"  %@", userPhone]];
        }
    }
    [self.userNameTelnoLabel setText:userInfo];

    // 测试数据 TODO
    NSArray *bills = @[@[@"StoreGoodsImg", @"123", @"020-88562918", @"200m"],
                            @[@"StoreGoodsImg", @"123", @"020-88562918", @"200m"],
                            @[@"StoreGoodsImg", @"123", @"020-88562918", @"200m"],
                            @[@"StoreGoodsImg", @"456", @"020-88562918", @"200m"],
                            @[@"StoreGoodsImg", @"456", @"020-88562918", @"200m"],
                            @[@"StoreGoodsImg", @"456", @"020-88562918", @"200m"],
                            @[@"StoreGoodsImg", @"789", @"020-88562918", @"200m"],
                            @[@"StoreGoodsImg", @"789", @"020-88562918", @"200m"]];
    self.billArray = [[NSMutableArray alloc] initWithArray:bills];

    self.billListArray = [[NSMutableArray alloc]init];

    self.buildingListArray = [[NSMutableArray alloc] init];
    // 注册TableViewCell Nib
    UINib *nibForBill = [UINib nibWithNibName:PropertyBillTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForBill forCellReuseIdentifier:PropertyBillTableViewCellNibName];

    self.headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 212);
    self.tableView.tableHeaderView = self.headerView;
}


#pragma mark - 从服务器获取数据
// 从服务器获取楼址信息
- (void)getBuildingInfoFromServerForUser:(NSString *)userAccount
{
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[userAccount] forKeys:@[@"ownerId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:CommunityBill_Url  path:BuildingInfo_Path method:@"GET" parameters:dic xmlParentNode:@"building" success:^(NSMutableArray *result)
    {
        _selBuildingIndex = 0;
        for (NSDictionary *dicResult in result)
        {
            [self.buildingListArray addObject:[[BuildingListModel alloc] initWithDictionary:dicResult]];
        }
        if (self.buildingListArray.count>0) {  // 暂定，后面根据具体样式再调整
            BuildingListModel *model = (BuildingListModel *)[self.buildingListArray objectAtIndex:_selBuildingIndex];
            [self.buildInfoLabel setText:model.address];
            [_selBuildImg setHidden:FALSE];
        }
        [self.tableView reloadData];
        [self postAllBillRequest];
        [self getBillPreview];
    }
    failure:^(NSError *error)
    {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

// 从服务器获取预交金额和未交金额信息  该接口暂不能用
-(void)getBillGeneralInfoFromServerForBuildingId:(NSString *)buildingId
{
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[buildingId] forKeys:@[@"buildingId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:CommunityBill_Url  path:PaymentList_Path method:@"GET" parameters:dic xmlParentNode:@"payment" success:^(NSMutableArray *result)
    {
        NSDictionary* dic = [result objectAtIndex:0];
        _prepayMoney = [dic objectForKey:@"prepaidAmount"];
        if(_prepayMoney == nil || [_prepayMoney isEqualToString:@""])
            _prepayMoney = @"0.0";
        [_prepayMoneyLabel setText:[NSString stringWithFormat:@"￥%@",_prepayMoney]];
        _unpayMoney =  [dic objectForKey:@"unpaidAmount"];
        if(_unpayMoney == nil || [_unpayMoney isEqualToString:@""])
            _unpayMoney = @"0.0";
        [_unpayMoneyLabel setText:[NSString stringWithFormat:@"￥%@",_unpayMoney]];
    }
    failure:^(NSError *error)
    {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

// 从服务器获取账单列表信息 billType:账单类型（1-全部，0-未交）
-(void)getBillListInfoFromServerForBuildingId:(NSString *)buildingId byType:(NSString *)billType
{
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[buildingId,billType] forKeys:@[@"buildingId", @"billType"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:CommunityBill_Url  path:BillCateLogList_Path method:@"GET" parameters:dic xmlParentNode:@"billCateLog" success:^(NSMutableArray *result)
    {
        [_billListArray removeAllObjects];
        for (NSDictionary *dicResult in result)
        {
            [self.billListArray addObject:[[BillListModel alloc] initWithDictionary:dicResult]];
        }
       
        [self.tableView reloadData];
      
    }
    failure:^(NSError *error)
    {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

- (void)setUIBtnClickState {
    _allBillBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _unpayBillBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    if (_allBillBtn.selected){
        _allBillBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
    }
    else if (_unpayBillBtn.selected){
        _unpayBillBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
    }
}

#pragma mark - 重写导航栏右侧按钮点击事件处理函数
// 右侧按钮视图点击事件处理函数
- (void)navBarRightItemClick
{
    NSLog(@"物业缴费->缴费历史");
//    if (_buildingListArray.count == 0) {
//        return;
//    }
//    BillHistoryViewController *vc = [[BillHistoryViewController alloc] init];
//    BuildingListModel* build = [_buildingListArray objectAtIndex:_selBuildingIndex];
//    if(build)
//    {
//      vc.buildingId = build.buildingId;
//    }
    if (_roadData != nil && _roadData.buildingId != nil && _roadData.buildingId.length > 0) {
        BillHistoryViewController *vc = [[BillHistoryViewController alloc] init];
        vc.buildingId = _roadData.buildingId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)getDefaultRoad
{
    NSString *userId = [[LoginConfig Instance] userID];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: userId,@"userId",nil];
    
    [self getArrayFromServer:ServiceInfo_Url path:DefaultRoadAddress_path method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result){
        for (NSDictionary *dicResult in result)
        {
            if (dicResult.count > 0) {
                self.roadData = [[RoadData alloc] initWithDictionary:dicResult];
            }
        }
        
        if (self.roadData == nil) {
            // 楼栋地址获取
            [self getBuildingInfoFromServerForUser: [[LoginConfig Instance] userAccount]];
        }else if (![self.roadData.authen isEqualToString:@"1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该地址未认证,请选择认证地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
        }
        if ([self.roadData.authen isEqualToString:@"1"]) {
            [_buildInfoLabel setText:self.roadData.address];
            [_userNameTelnoLabel setText:[NSString stringWithFormat:@"%@  %@", self.roadData.contactName, self.roadData.contactTel]];
            [self postAllBillRequest];
            [self getBillPreview];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    
}
#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        RoadAddressManageViewController* vc = [[RoadAddressManageViewController alloc]init];
//        vc.isAddressSel = addressSel_Default;
//        [vc setSelectRoadData:^(RoadData *roadData) {
//            _roadData = roadData;
//            if (![self.roadData.authen isEqualToString:@"1"]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该地址未认证,请选择认证地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                [alert show];
//            }else {
//                [self getBillGeneralInfoFromServerForBuildingId:roadData.buildingId];
//            }
//        }];
//        [self.navigationController pushViewController:vc animated:TRUE];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:TRUE];
//    }
//}

- (void)showAdressNotAuthAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该地址未认证，请选择认证的地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新选择", nil];
    alertView.cancelButtonIndex = 1;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self buildingBtnClickHandler:nil];
    }
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

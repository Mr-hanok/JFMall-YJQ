//
//  GrouponOrderListViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/18.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponOrderListViewController.h"
#import "GrouponOrderListTableViewCell.h"
#import "GrouponOrderSectionHeaderView.h"
#import "GrouponOrderSectionFooterView.h"

#define GrouponOrderListTableViewCellNibName    @"GrouponOrderListTableViewCell"
#define GrouponOrderSectionHeaderViewNibName    @"GrouponOrderSectionHeaderView"
#define GrouponOrderSectionFooterViewNibName    @"GrouponOrderSectionFooterView"

@interface GrouponOrderListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *grouponOrderHeaderBgView;
@property (weak, nonatomic) IBOutlet UIButton *grouponOrderUnFinishedBtn;
@property (weak, nonatomic) IBOutlet UIButton *grouponOrderFinishedBtn;
@property (copy,nonatomic) NSMutableArray *grouponOrderArray;


@end

@implementation GrouponOrderListViewController

#pragma mark - 重载代码区
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_GrouponOrder;
    [self initUIViewStyle];
    [self initBasicData];
    [self registerNib];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.grouponOrderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GrouponOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GrouponOrderListTableViewCellNibName forIndexPath:indexPath];
    return cell;
}


#pragma mark - Section Header&&Footer 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}


#pragma mark - Section Header&&Footer View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GrouponOrderSectionHeaderView *header = (GrouponOrderSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:GrouponOrderSectionHeaderViewNibName];

    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GrouponOrderSectionFooterView *footer = (GrouponOrderSectionFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:GrouponOrderSectionFooterViewNibName];
    return footer;
}

#pragma mark - 自定义代码区
// 初始化view样式
- (void)initUIViewStyle {
    [Common setRoundBorder:_grouponOrderHeaderBgView borderWidth:0.5 cornerRadius:5 borderColor:Color_Gray_RGB];
}

// 初始化数据
- (void)initBasicData {
    self.grouponOrderArray = [[NSMutableArray alloc]init];
    _grouponOrderUnFinishedBtn.selected = YES;
    _grouponOrderUnFinishedBtn.backgroundColor = Color_Orange_RGB;
}

// 注册Nib
-(void)registerNib
{
    UINib *nibForGrouponOrderList = [UINib nibWithNibName:GrouponOrderListTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForGrouponOrderList forCellReuseIdentifier:GrouponOrderListTableViewCellNibName];
    
    // SectionHeaderNib
    UINib *headerNib = [UINib nibWithNibName:GrouponOrderSectionHeaderViewNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:GrouponOrderSectionHeaderViewNibName];
}

// 切换 完成 / 已完成 团购订单状态
- (IBAction)clickUnFinishedBtn:(id)sender {
    _grouponOrderFinishedBtn.selected = NO;
    _grouponOrderUnFinishedBtn.selected = YES;
    [self changeOrderType];
}

- (IBAction)clickFinishedBtn:(id)sender {
    _grouponOrderFinishedBtn.selected = YES;
    _grouponOrderUnFinishedBtn.selected = NO;
    [self changeOrderType];
}

- (void)changeOrderType {
    if (_grouponOrderUnFinishedBtn.selected) {
        _grouponOrderUnFinishedBtn.backgroundColor = Color_Orange_RGB;
        _grouponOrderFinishedBtn.backgroundColor = Color_White_RGB;
    }
    else if (_grouponOrderFinishedBtn.selected) {
        _grouponOrderUnFinishedBtn.backgroundColor = Color_White_RGB;
        _grouponOrderFinishedBtn.backgroundColor = Color_Orange_RGB;
    }
}

#pragma mark - 从服务器获取取得团购订单数据
- (void)getGrouponOrderDataFromServer {
    NSString *userId = [[LoginConfig Instance] userID];
    
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userId", nil];
    
    [self getArrayFromServer:GetOrderListForGroupBuy_Url path:GetOrderListForGroupBuy_Path method:@"GET" parameters:dic xmlParentNode:@"groupBuyOrder" success:^(NSMutableArray *result) {
        [_grouponOrderArray removeAllObjects];
        for ( NSDictionary * ticket in result) {
            [_grouponOrderArray addObject:[[GrouponTicket alloc]initWithDictionary:ticket]];
        }
        [_tableView reloadData];
        if (_grouponOrderArray.count == 0) {
            [Common showBottomToast:@"暂无数据"];
        }
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

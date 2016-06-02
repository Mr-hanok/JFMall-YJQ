//
//  HousesServicesSentInfoViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "HousesServicesSentInfoViewController.h"
#import "HousesServicesBuildingsTableViewCell.h"
#import "HousesServicesBuildingInfoViewController.h"
#import "HouseListModel.h"
#import "HousesServicesHouseDescViewController.h"
#import "HousesServicesBuildingInfoViewController.h"

#import <MJRefresh.h>

#pragma mark -- 宏定义区
#define SentInfoPageSize (10)
#define BuildingsTableViewCellNibName   @"HousesServicesBuildingsTableViewCell"

@interface HousesServicesSentInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UIButton *longRentBtn;
@property (retain, nonatomic) IBOutlet UIButton *shortRentBtn;
@property (retain, nonatomic) IBOutlet UIButton *sellBtn;
@property (retain, nonatomic) IBOutlet UITableView *sendInfoTableView;

@property (retain,nonatomic) NSMutableArray *curListArray;

@property (assign,nonatomic) NSInteger pageNum;
@end

@implementation HousesServicesSentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_Houses_Info_Title;
    [self setNavBarLeftItemAsBackArrow];
    [self setNavBarItemRightViewForNorImg:Img_HousesServicesAddInfoNor andPreImg:Img_HousesServicesAddInfoPre];
    
    // 添加下拉/上滑刷新更多
    self.pageNum = 1;
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getCurListDataFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.curListArray.count == self.pageNum*SentInfoPageSize) {
            self.pageNum++;
            [self getCurListDataFromServer];
        }
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.sendInfoTableView.header = header;
    self.sendInfoTableView.footer = footer;
    
    [self initHousesSentInfo];
    [self getCurListDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 重写导航栏右侧按钮点击事件处理函数
- (void)navBarRightItemClick
{
    HousesServicesBuildingInfoViewController *vc = [[HousesServicesBuildingInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 标签按钮控制
- (IBAction)clickLongRent:(id)sender {
    _longRentBtn.selected = YES;
    _shortRentBtn.selected = NO;
    _sellBtn.selected = NO;
    [self getCurListDataFromServer];
}

- (IBAction)clickShortRent:(id)sender {
    _longRentBtn.selected = NO;
    _shortRentBtn.selected = YES;
    _sellBtn.selected = NO;
    [self getCurListDataFromServer];
}

- (IBAction)clickSell:(id)sender {
    _longRentBtn.selected = NO;
    _shortRentBtn.selected = NO;
    _sellBtn.selected = YES;
    [self getCurListDataFromServer];
}

- (void)initHousesSentInfo {
    // 设置默认标签焦点
    _longRentBtn.selected = YES;
    
    _curListArray = [[NSMutableArray alloc]init];
    
    //注册cell
    UINib *nibForSentInfoService = [UINib nibWithNibName:BuildingsTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.sendInfoTableView registerNib:nibForSentInfoService forCellReuseIdentifier:BuildingsTableViewCellNibName];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.curListArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell关联table view
    HousesServicesBuildingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BuildingsTableViewCellNibName forIndexPath:indexPath];
    // cell载入数据
    [cell loadCellData:[self.curListArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseListModel* model = [self.curListArray objectAtIndex:indexPath.row];
    if (model == nil) {
        return;
    }
    if([model.state isEqualToString:@"0"])//未审核
    {
        HousesServicesBuildingInfoViewController* vc = [[HousesServicesBuildingInfoViewController alloc]init];
        vc.recordId = model.recordId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    HousesServicesHouseDescViewController* vc = [[HousesServicesHouseDescViewController alloc]init];
    vc.recordId = model.recordId;
    [self.navigationController pushViewController:vc animated:YES];
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setEditing:YES animated:YES];
    //return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self delHouseInfo:indexPath];
    }
}

#pragma mark--- 从服务器操作数据
-(void) delHouseInfo:(NSIndexPath *)indexPath
{
    HouseListModel* model = [_curListArray objectAtIndex:indexPath.row];
    NSDictionary* dic  = [[NSDictionary alloc]initWithObjectsAndKeys:model.recordId,@"recordId", nil];
    [self getStringFromServer:HouseInfo_Url path:HouseInfoDel_Path method:@"" parameters:dic success:^(NSString *result) {
        if([result isEqualToString:@"1"])
        {
            [_curListArray removeObjectAtIndex:indexPath.row];
            [self.sendInfoTableView reloadData];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];

}
- (void)getCurListDataFromServer{
    NSDictionary *dic = nil;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:User_UserId_Key];
    
    if (self.shortRentBtn.selected == YES)
    {
        dic = [[NSDictionary alloc] initWithObjects:@[userId, @"1", [NSString stringWithFormat:@"%ld",(long)SentInfoPageSize], [NSString stringWithFormat:@"%ld",(long)self.pageNum]] forKeys:@[@"userId", @"recordType", @"pageSize", @"pageNum"]];
    }
    else if (self.sellBtn.selected == YES)
    {
        dic = [[NSDictionary alloc] initWithObjects:@[userId, @"2", [NSString stringWithFormat:@"%ld",(long)SentInfoPageSize], [NSString stringWithFormat:@"%ld",(long)self.pageNum]] forKeys:@[@"userId", @"recordType", @"pageSize", @"pageNum"]];
    }
    else
    {
        dic = [[NSDictionary alloc] initWithObjects:@[userId, @"0", [NSString stringWithFormat:@"%ld",(long)SentInfoPageSize], [NSString stringWithFormat:@"%ld",(long)self.pageNum]] forKeys:@[@"userId", @"recordType", @"pageSize", @"pageNum"]];
    }
    
    // 从服务器获取数据
    [self getArrayFromServer:HouseInfo_Url path:ReleasedHouseList_Path method:@"GET" parameters:dic xmlParentNode:@"house" success:^(NSMutableArray *result) {
        if(self.pageNum == 1)
        {
            [self.curListArray removeAllObjects];
        }
        for (NSDictionary *dic in result) {
            [self.curListArray addObject:[[HouseListModel alloc] initWithDictionary:dic]];
        }
        [self.sendInfoTableView.header endRefreshing];
        [self.sendInfoTableView.footer endRefreshing];
        if (self.curListArray.count < self.pageNum*SentInfoPageSize) {
            [self.sendInfoTableView.footer noticeNoMoreData];
        }
        [self.sendInfoTableView reloadData];
    } failure:^(NSError *error) {
        [self.sendInfoTableView.header endRefreshing];
        [self.sendInfoTableView.footer endRefreshing];
        [self.sendInfoTableView reloadData];
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
@end

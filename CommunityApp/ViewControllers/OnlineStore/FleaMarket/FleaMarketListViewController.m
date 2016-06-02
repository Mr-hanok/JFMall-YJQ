//
//  FleaMarketListViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "FleaMarketListViewController.h"
#import "FleaMarketListTableViewCell.h"
#import "FleaMarketDetailViewController.h"
#import "FleaMarketPublishViewController.h"
#import <MJRefresh.h>
#import "GoodsCatagoryViewController.h"

#pragma mark - 宏定义区
#define FleaMarketListTableViewCellNibName              @"FleaMarketListTableViewCell"

#define pageSize 10
@interface FleaMarketListViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchBorderView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *rightNavView;

@property (nonatomic, retain) NSMutableArray    *waresArray;
@property (assign,nonatomic) NSInteger pageNum;

@property (nonatomic, retain) GoodsCategoryModel *selectedGoodsCategory;

@end

@implementation FleaMarketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = @"物品列表";
    [self setNavBarLeftItemAsBackArrow];
    self.rightNavView.frame = Rect_LimitBuy_NavBarRightItem;
    [self setNavBarItemRightView:self.rightNavView];
    
    // 初始化搜索框Border
    self.searchBorderView.layer.borderColor = COLOR_RGB(200, 200, 200).CGColor;
    self.searchBorderView.layer.borderWidth = 1.0;
    self.searchBorderView.layer.cornerRadius = 4.0;
    _pageNum = 1;
    // 初始化本地信息
    [self initBasicDataInfo];
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getWaresDataFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.waresArray.count == self.pageNum*pageSize) {
            self.pageNum++;
            [self getWaresDataFromServer];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
    self.tableView.footer = footer;

    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pageNum = 1;
    //请求服务器获取物品数据
    [self getWaresDataFromServer];
}


#pragma mark - tableview datasource delegate
// 设置Cell数
-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return self.waresArray.count;
}

// 装载Cell元素
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FleaMarketListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FleaMarketListTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.waresArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FleaMarketDetailViewController *vc = [[FleaMarketDetailViewController alloc] init];
    FleaCommodityListModel* listData = [self.waresArray objectAtIndex:indexPath.row];
    vc.orderId = listData.stId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.waresArray = [[NSMutableArray alloc] init];
    
    // 注册TableViewCell Nib
    UINib *nib = [UINib nibWithNibName:FleaMarketListTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:FleaMarketListTableViewCellNibName];
}


#pragma mark - 从服务器获取物品数据
- (void)getWaresDataFromServer
{
//    projectId				  必须	小区Id
//    title 				  可选  搜索字段
//    gcId 				  可选	分类Id 分类名称中最底级的分类ID
//    userId                 可选  用户Id
//    pageNum				  当前页数
//    perSize				  每页显示数目
    NSString *projectId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PROJECTID];
    if(projectId == nil)
    {
        [Common showBottomToast:@"请选择小区"];
        return;
    }
  
    NSMutableDictionary* dic  = [[NSMutableDictionary alloc]init];
    [dic setObject:projectId forKey:@"projectId"];
    if(_searchTextField.text !=nil && [_searchTextField.text isEqualToString:@""]==FALSE)
    {
        [dic setObject:_searchTextField.text forKey:@"title"];
    }
//    if([[LoginConfig Instance] userLogged])
//    {
//        [dic setObject:[[LoginConfig Instance] userID] forKey:@"userId"];
//    }
    
    if (self.selectedGoodsCategory != nil) {
        [dic setObject:self.selectedGoodsCategory.categoryId forKey:@"gcId"];
    }
    
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_pageNum] forKey:@"pageNum"];
    [dic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"perSize"];
    [self getArrayFromServer:FleaMarket_Url path:FleaMarketList_Path method:@"GET" parameters:dic xmlParentNode:@"trading" success:^(NSMutableArray *result) {
        if(_pageNum == 1)
        {
            [_waresArray removeAllObjects];
        }
        for (NSDictionary* dic in result) {
             [_waresArray addObject:[[FleaCommodityListModel alloc] initWithDictionary:dic]];
        }
        
        if (_waresArray.count == 0) {
            [Common showBottomToast:@"暂无跳蚤市场物品"];
        }
        
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (_waresArray.count < _pageNum*pageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
    } failure:^(NSError *error) {
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


#pragma mark - 按钮点击事件处理函数
// 搜索按钮事件
- (IBAction)searchBtnClickHandler:(id)sender
{
    _pageNum = 1;
    [self getWaresDataFromServer];
}

// 筛选按钮事件
- (IBAction)filterBtnClickHandler:(id)sender
{
    GoodsCatagoryViewController *vc = [[GoodsCatagoryViewController alloc] init];
    vc.eGoodsCategoryModule = E_GoodsCategoryModule_FleaMarket;
    [vc setSelectGoodsCategoryBlock:^(GoodsCategoryModel *model) {
        self.selectedGoodsCategory = model;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

// 导航栏发布按钮事件
- (IBAction)publishBtnClickHandler:(id)sender
{
    FleaMarketPublishViewController *vc = [[FleaMarketPublishViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getWaresDataFromServer];
    return TRUE;
}


// 手势隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma -mark 设置返回按钮,防止返回发布页多次发布同一商品
- (void)navBarLeftItemBackBtnClick
{

    [self.navigationController popToRootViewControllerAnimated:YES];
        //        [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

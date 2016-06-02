//
//  MyFleaMarketViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "MyFleaMarketViewController.h"
#import "FleaMarketListTableViewCell.h"
#import "FleaMarketDetailViewController.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#pragma mark - 宏定义区
#define FleaMarketListTableViewCellNibName              @"FleaMarketListTableViewCell"

#define pageSize 10

@interface MyFleaMarketViewController ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSString * stId;
    NSDictionary *dict;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray    *waresArray;
@property (assign,nonatomic) NSInteger pageNum;
@end

@implementation MyFleaMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = @"我的跳蚤市场";
    [self setNavBarLeftItemAsBackArrow];
    
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
#pragma -mark 12-14 cell可编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma -mark 12-14 删除数据库 数据
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除数据库数据
    FleaCommodityListModel* listData = [self.waresArray objectAtIndex:indexPath.row];
    stId = listData.stId;

    //🍎AFNetWorking解析数据
    AFHTTPSessionManager *_manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];


    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:stId,@"stId", nil];//dic是向服务器上传的参数
    YjqLog(@"dic:%@",dic);
    //[NSString stringWithFormat:@"%@%@",Service_Address,FleaMarketDelegate_Path]
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Service_Address,FleaMarketDelegate_Path];
    YjqLog(@"%@",urlStr);
    [_manager POST:urlStr parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {
        //解析数据
        dict=[NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers error:nil];
        YjqLog(@"dict:%@********************",dict);

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        YjqLog(@"%@", error.localizedDescription);
    }];

    [self.waresArray removeObjectAtIndex:indexPath.row];

    //该方法用于删除tableView上的指定行的cell;注意:该方法使用的时候,模型中删除的数据条数必须和deleteRowsAtIndexPaths方法中删除的条数一致,否则报错
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];


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

    if([[LoginConfig Instance] userLogged])
    {
            [dic setObject:[[LoginConfig Instance] userID] forKey:@"userId"];
    }
    
    [dic setObject:[NSString stringWithFormat:@"%ld",_pageNum] forKey:@"pageNum"];
    [dic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"perSize"];
    [self getArrayFromServer:FleaMarket_Url path:FleaMarketList_Path method:@"GET" parameters:dic xmlParentNode:@"trading" success:^(NSMutableArray *result) {
        if(_pageNum == 1)
        {
            [_waresArray removeAllObjects];
        }
        for (NSDictionary* listData in result) {
            [_waresArray addObject:[[FleaCommodityListModel alloc] initWithDictionary:listData]];
        }
        
        if (_waresArray.count == 0) {
            [Common showBottomToast:@"您还未发布过商品"];
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


// 手势隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

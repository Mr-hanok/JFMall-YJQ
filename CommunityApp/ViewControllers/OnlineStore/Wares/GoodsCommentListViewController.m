//
//  GoodsCommentListViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GoodsCommentListViewController.h"
#import "GoodsCommentTableViewCell.h"
#import <MJRefresh.h>
#import "AGImagePickerViewController.h"

#pragma mark - 宏定义区
#define GoodsCommentTableViewCellNibName        @"GoodsCommentTableViewCell"

#define pageSize 10

@interface GoodsCommentListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray    *goodsCommentArray;
@property (assign,nonatomic) NSInteger pageNum;

@end

@implementation GoodsCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = @"用户评价";
    [self setNavBarLeftItemAsBackArrow];
    
    // 初始化基本数据
    [self initBasicDataInfo];
    
    _pageNum = 1;

    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getDataFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.goodsCommentArray.count == self.pageNum*pageSize) {
            self.pageNum++;
            [self getDataFromServer];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
    self.tableView.footer = footer;
    
}

#pragma mark - tableview datasource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsCommentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsCommentTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.goodsCommentArray objectAtIndex:indexPath.row]];
    cell.selectImagesBlock = ^(NSArray *imagesArray){
        AGImagePickerViewController* vc = [[AGImagePickerViewController alloc]init];
        vc.imgUrlArray = imagesArray;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.goodsCommentArray = [[NSMutableArray alloc] init];
    
    // 请求服务器获取周边商家数据
    [self getDataFromServer];
    
    // 注册TableViewCell Nib
    UINib *nib = [UINib nibWithNibName:GoodsCommentTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:GoodsCommentTableViewCellNibName];
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.waresId, [NSString stringWithFormat:@"%ld",(long)_pageNum], [NSString stringWithFormat:@"%ld", (long)pageSize]] forKeys:@[@"goodsId", @"pageNum", @"perSize"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:GoodsCommentList_Url path:GoodsCommentList_Path method:@"GET" parameters:dic xmlParentNode:@"result" success:^(NSMutableArray *result) {
        if (_pageNum == 1) {
            [self.goodsCommentArray removeAllObjects];
        }
        
        for (NSDictionary *dic in result) {
            [self.goodsCommentArray addObject:[[GoodsComment alloc] initWithDictionary:dic]];
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (self.goodsCommentArray.count < _pageNum*pageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

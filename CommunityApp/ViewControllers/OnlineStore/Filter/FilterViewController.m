//
//  FilterViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"

#pragma mark - 宏定义区
#define FilterTableViewCellNibName          @"FilterTableViewCell"

@interface FilterViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 筛选信息数组
@property (nonatomic, retain) NSMutableArray    *filterDataArray;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = @"筛选";
    [self setNavBarLeftItemAsBackArrow];
    
    [self initBasicDataInfo];
}


#pragma mark - tableview datasource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FilterTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[self.filterDataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate setFileterData:[self.filterDataArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    // 测试数据 TODO
    NSArray *filters = @[@"男装", @"女装", @"美容护肤", @"箱包装饰"];
    self.filterDataArray = [[NSMutableArray alloc] initWithArray:filters];
    
    // 注册TableViewCell Nib
    UINib *nibForFilter = [UINib nibWithNibName:FilterTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForFilter forCellReuseIdentifier:FilterTableViewCellNibName];
    
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

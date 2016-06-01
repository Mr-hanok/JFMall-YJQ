//
//  CategorySelectedViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CategorySelectedViewController.h"
#import "SubCategoryTableViewCell.h"
#import "CategoryTableViewCell.h"
#import "PostRepairEditViewController.h"
#import "PostItRepairCategoryModel.h"

#pragma mark - 宏定义区
#define CategoryTableViewCellNibName        @"CategoryTableViewCell"
#define SubCategoryTableViewCellNibName     @"SubCategoryTableViewCell"

@interface CategorySelectedViewController ()
    @property(retain,nonatomic) IBOutlet UITableView *categoryTableView;
    @property(retain,nonatomic) IBOutlet UITableView *subCategoryTableView;

@property(retain, nonatomic) NSMutableArray     *categoryData;          //分类数据
@property(retain, nonatomic) NSMutableArray     *parentCategory;        //一级分类数据
@property(retain, nonatomic) NSMutableArray     *childCategory;         //二级分类数据
@property(assign, nonatomic) NSInteger          selParentTableCellId;   //当前选中的一级分类

@end

@implementation CategorySelectedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_PostIR_SelectCategory;
    [self setNavBarLeftItemAsBackArrow];
    
    [self initBasicDataInfo];
}


#pragma mark - tableview datasource delegate
// 设置Section内的Cell数
-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (tableView == self.categoryTableView) { // 一级分类table
        rows = self.parentCategory.count;
    }
    else { // 二级分类table
        if (self.childCategory.count > 0) {
            NSArray * children = (NSArray *)[self.childCategory objectAtIndex:self.selParentTableCellId];
            rows = children.count;
        }
    }
    return rows;
}

// 加载Cell元数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) { // 一级分类
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryTableViewCellNibName forIndexPath:indexPath];
        [cell loadCellData:(PostItRepairCategoryModel *)[self.parentCategory objectAtIndex:indexPath.row]];
        if (indexPath.row == 0) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        return cell;
    }
    else{   // 二级分类
        SubCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubCategoryTableViewCellNibName forIndexPath:indexPath];
        NSArray *children = (NSArray *)[self.childCategory objectAtIndex:self.selParentTableCellId];
        [cell loadCellData:(PostItRepairCategoryModel *)[children objectAtIndex:indexPath.row]];
        return cell;
    }
    
    return nil;
}

#pragma mark-修改二级分类中的保修地址
#pragma mark - tableView delegate
// tableview选择事件处理函数
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {  // 一级分类
        self.selParentTableCellId = indexPath.row;
        [self.subCategoryTableView reloadData];
    }
    else{   // 二级分类
        if([self isGoToLogin])
        {
            PostRepairEditViewController *next = [[PostRepairEditViewController alloc]init];
            NSArray *children = (NSArray *)[self.childCategory objectAtIndex:self.selParentTableCellId];
            PostItRepairCategoryModel * post =[children objectAtIndex:indexPath.row];
            next.serviceId =  post.serviceId;
            [self.navigationController pushViewController:next animated:YES];
        }

    }
}


#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.categoryData = [[NSMutableArray alloc] init];
    self.parentCategory = [[NSMutableArray alloc] init];
    self.childCategory = [[NSMutableArray alloc] init];
    self.selParentTableCellId = 0;
    
    // 请求服务器获取周边商家数据
    [self getDataFromServer];
    
    // 注册TableViewCell Nib
    UINib *nibForCategory = [UINib nibWithNibName:CategoryTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.categoryTableView registerNib:nibForCategory forCellReuseIdentifier:CategoryTableViewCellNibName];
    
    UINib *nibForSubCategory = [UINib nibWithNibName:SubCategoryTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.subCategoryTableView registerNib:nibForSubCategory forCellReuseIdentifier:SubCategoryTableViewCellNibName];
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    [self.categoryData removeAllObjects];
    [self.parentCategory removeAllObjects];
    [self.childCategory removeAllObjects];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[[userDefault objectForKey:KEY_PROJECTID],@"-1"] forKeys:@[@"projectId",@"serviceType"]];
    
    LoginConfig *config = [LoginConfig Instance];
    if ([config userLogged]) {
        [dic setValue:[config userID]  forKey:@"userId"];
    }
    
    // 请求服务器获取数据
    [self getArrayFromServer:SelectCategory_Url path:SelectCategory_Path method:@"GET" parameters:dic xmlParentNode:@"serviceType" success:^(NSMutableArray *result) {
        for (NSDictionary *dic in result) {
            [self.categoryData addObject:[[PostItRepairCategoryModel alloc] initWithDictionary:dic]];
            // 装载一级分类数组元素
            if ([[dic objectForKey:@"parentId"] isEqualToString:@""]) {
                [self.parentCategory addObject:[[PostItRepairCategoryModel alloc] initWithDictionary:dic]];
            }
        }
        
        // 装载二级分类数组元素
        for (PostItRepairCategoryModel *parentModel in self.parentCategory) {
            NSMutableArray *children = [[NSMutableArray alloc] init];
            for (PostItRepairCategoryModel *childModel in self.categoryData) {
                if ([childModel.parentId isEqualToString: parentModel.serviceId]) {
                    [children addObject:childModel];
                }
            }
            if (children.count > 0) {
                [self.childCategory addObject:children];
            }
        }
        
        [self.categoryTableView reloadData];
        [self.subCategoryTableView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

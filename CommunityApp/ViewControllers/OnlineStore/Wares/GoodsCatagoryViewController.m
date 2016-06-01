//
//  GoodsCatagoryViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GoodsCatagoryViewController.h"
#import "ParentCatagoryTableViewCell.h"
#import "ChildCatagoryTableViewCell.h"
#import "LimitBuyViewController.h"
#import "NormalGoodsListViewController.h"

#pragma mark - 宏定义区
#define ParentCategoryTableViewCellNibName        @"ParentCatagoryTableViewCell"
#define ChildCategoryTableViewCellNibName         @"ChildCatagoryTableViewCell"

@interface GoodsCatagoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *parentTableView;
@property (weak, nonatomic) IBOutlet UITableView *childTableView;
@property (weak, nonatomic) IBOutlet UIImageView *vLineImg;

@property(retain, nonatomic) NSMutableArray     *categoryData;          //分类数据
@property(retain, nonatomic) NSMutableArray     *parentCategory;        //一级分类数据
@property(retain, nonatomic) NSMutableArray     *childCategory;         //二级分类数据
@property(assign, nonatomic) NSInteger          selParentTableCellId;   //当前选中的一级分类

@end

@implementation GoodsCatagoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化导航栏信息
    self.navigationItem.title = @"商品分类";
    [self setNavBarLeftItemAsBackArrow];
    
    [self initBasicDataInfo];
    
    [self.parentTableView setHidden:YES];
    [self.childTableView setHidden:YES];
    [self.vLineImg setHidden:YES];
}


#pragma mark - tableview datasource delegate
// 设置Section内的Cell数
-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (tableView == self.parentTableView) { // 一级分类table
        rows = self.parentCategory.count;
    }
    else { // 二级分类table
        if(self.childCategory.count <= self.selParentTableCellId)
            return rows;
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
    if (tableView == self.parentTableView) { // 一级分类
        ParentCatagoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ParentCategoryTableViewCellNibName forIndexPath:indexPath];
        [cell loadCellData:(GoodsCategoryModel *)[self.parentCategory objectAtIndex:indexPath.row]];
        return cell;
    }
    else{   // 二级分类
        ChildCatagoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChildCategoryTableViewCellNibName forIndexPath:indexPath];
        NSArray *children = (NSArray *)[self.childCategory objectAtIndex:self.selParentTableCellId];
        [cell loadCellData:(GoodsCategoryModel *)[children objectAtIndex:indexPath.row]];
        return cell;
    }
    
    return nil;
}


#pragma mark - tableView delegate
// tableview选择事件处理函数
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.parentTableView) {  // 一级分类
        self.selParentTableCellId = indexPath.row;
        [self.childTableView reloadData];
    }
    else{   // 二级分类
        if(self.childCategory.count <= self.selParentTableCellId)
            return;
        NSArray *children = (NSArray *)[self.childCategory objectAtIndex:self.selParentTableCellId];
        if (self.eGoodsCategoryModule == E_GoodsCategoryModule_FleaMarket) {
            if (self.selectGoodsCategoryBlock) {
                self.selectGoodsCategoryBlock([children objectAtIndex:indexPath.row]);
            }
            [self.navigationController popViewControllerAnimated:TRUE];
            return;
        }
        NormalGoodsListViewController *vc = [[NormalGoodsListViewController alloc] init];
        
        vc.goodsCategory = [children objectAtIndex:indexPath.row];
        vc.eSearchGoodsType = E_SearchGoodsType_Category;
        [self.navigationController pushViewController:vc animated:YES];
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
    UINib *nibForParentCategory = [UINib nibWithNibName:ParentCategoryTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.parentTableView registerNib:nibForParentCategory forCellReuseIdentifier:ParentCategoryTableViewCellNibName];
    
    UINib *nibForChildCategory = [UINib nibWithNibName:ChildCategoryTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.childTableView registerNib:nibForChildCategory forCellReuseIdentifier:ChildCategoryTableViewCellNibName];
}


// 从服务器端获取数据
- (void)getDataFromServer
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSString *moduleType = @"-1";
    
    if (self.eGoodsCategoryModule == E_GoodsCategoryModule_FleaMarket) {
        moduleType = @"5";
    }

    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[moduleType] forKeys:@[@"moduleType"]];
    if (self.eGoodsCategoryModule == E_GoodsCategoryModule_Normal) {
        [dic setObject:projectId forKey:@"projectId"];
    }
    
    NSString *url = GoodsCategory_Url;
    NSString *path = GoodsCategory_Path;
    if (self.eGoodsCategoryModule == E_GoodsCategoryModule_FleaMarket) {
        url = FleaMarketCategory_Url;
        path = FleaMarketCategory_Path;
    }
    
    // 请求服务器获取数据
    [self getArrayFromServer:url path:path method:@"GET" parameters:dic xmlParentNode:@"goodsCategory" success:^(NSMutableArray *result) {
        [self.categoryData removeAllObjects];
        [self.parentCategory removeAllObjects];
        [self.childCategory removeAllObjects];
        for (NSDictionary *dic in result) {
            [self.categoryData addObject:[[GoodsCategoryModel alloc] initWithDictionary:dic]];
            // 装载一级分类数组元素
            if ([[dic objectForKey:@"clientShow"] isEqualToString:@"0"]) {
                [self.parentCategory addObject:[[GoodsCategoryModel alloc] initWithDictionary:dic]];
            }
        }
        
        // 装载二级分类数组元素
        for (GoodsCategoryModel *parentModel in self.parentCategory) {
            NSMutableArray *children = [[NSMutableArray alloc] init];
            for (GoodsCategoryModel *childModel in self.categoryData) {
                if ([childModel.parentId isEqualToString: parentModel.categoryId]) {
                    [children addObject:childModel];
                }
            }
            if (children.count > 0) {
                [self.childCategory addObject:children];
            }
        }
        
        if (self.parentCategory.count == 0) {
            [Common showBottomToast:@"暂无商品分类"];
        }else {
            [self.parentTableView setHidden:NO];
            [self.childTableView setHidden:NO];
            [self.vLineImg setHidden:NO];
        }
        
        [self.parentTableView reloadData];
        [self.childTableView reloadData];
        
        if (self.parentCategory.count > 0) {
            [self.parentTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}




#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

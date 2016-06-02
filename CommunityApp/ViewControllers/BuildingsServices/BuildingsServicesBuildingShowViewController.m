//
//  BuildingsServicesBuildingShowViewController.m
//  CommunityApp
//
//  Created by iss on 15/7/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//
#pragma mark - 引入头文件区域
#import "BuildingsServicesBuildingShowViewController.h"
#import "BuildingsServicesBuildingShowTableViewCell.h"
#import "BuildingsServicesBuildingInfoViewController.h"
#import "CommonFilterDataView.h"
#import "CommonFilterDataTableViewCell.h"
#import "ProjectSelectorModel.h"
#import <MJRefresh.h>

#pragma mark - 宏定义区
#define BuildingShowPageSize (10)
#define BuildingShowTableViewCellNibName @"BuildingsServicesBuildingShowTableViewCell" 

#pragma mark - 接口、变量定义区域
@interface BuildingsServicesBuildingShowViewController ()<UITabBarDelegate,UITableViewDataSource,CommonFilterDataViewDelegate>

@property (strong,nonatomic) IBOutlet UIView* headView;
@property (strong,nonatomic) IBOutlet UIView* filterDataView;
@property (strong,nonatomic) IBOutlet UITableView* buildingShowTableView;
@property (strong,nonatomic) IBOutlet UITableView* filterTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterTableHeightConstraint;
@property (strong,nonatomic) CommonFilterDataView* filterView;

@property(nonatomic, assign) NSInteger  headSelBtnTag;
@property(nonatomic, assign) NSInteger  priceRangeSel;
@property(nonatomic, assign) NSInteger  salesStatusSel;
@property(nonatomic, assign) NSInteger  projectCategorySel;
@property(nonatomic, copy) NSString*    minPrice;
@property(nonatomic, copy) NSString*    maxPrice;
@property(nonatomic, copy) NSString*    projectCategory;
@property(nonatomic, copy) NSString*    salesStatus;

// table view分页显示
@property (assign,nonatomic) NSInteger pageNum;
@property (retain,nonatomic) NSMutableArray* buildingShowListArray;
@property (retain,nonatomic) NSMutableArray* salesStatusArray;
@property (retain,nonatomic) NSMutableArray* projectCategoryArray;
@property (retain,nonatomic) NSMutableArray* filterData1;
@property (retain,nonatomic) NSMutableArray* filterData2;
@property (retain,nonatomic) NSMutableArray* filterData3;

@end

@implementation BuildingsServicesBuildingShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_BuildingsInfo_BuildingTitle;
    [self setNavBarLeftItemAsBackArrow];
    // 初始化 - 基本数据
    [self initBaseData];
    
    self.salesStatusSel = -1;
    self.projectCategorySel =-1;
    self.minPrice = @"0";
    self.maxPrice = [NSString stringWithFormat:@"%ld", (long)LONG_MAX];
    
    UINib *nibForBuildingShowService = [UINib nibWithNibName:BuildingShowTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.buildingShowTableView registerNib:nibForBuildingShowService forCellReuseIdentifier:BuildingShowTableViewCellNibName];

    _priceRangeSel = -1;
    _projectCategorySel = -1;
    
    _filterView = [ [CommonFilterDataView alloc ]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    [_filterView  initFilterTitle:[NSArray arrayWithObjects:@"价格", @"状态", @"类型", nil]];
    _filterView.delegate = self;
    
    self.filterTableHeightConstraint.constant = (Screen_Height - Navigation_Bar_Height - 45)/2.0;
    
    [_headView addSubview:_filterView];


    
    [self initFilterData];
    [_filterDataView setBackgroundColor:[UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:0.8f]];
    
    // [self getBuildingListDataFromServer];
    // 添加下拉/上滑刷新更多
    self.pageNum = 1;
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getBuildingListDataFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.buildingShowListArray.count == self.pageNum*BuildingShowPageSize) {
            self.pageNum++;
            [self getBuildingListDataFromServer];
        }
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.buildingShowTableView.header = header;
    self.buildingShowTableView.footer = footer;
    //添加点击重置Filter手势
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resetFilter)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self getProjectSelectorFromServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getBuildingListDataFromServer];
}

- (void)initBaseData {
    _buildingShowListArray = [[NSMutableArray alloc]init];
    self.filterData1 = [[NSMutableArray alloc]init];
    self.filterData2 = [[NSMutableArray alloc]init];
    self.filterData3 = [[NSMutableArray alloc]init];
    self.salesStatusArray = [[NSMutableArray alloc]init];
    self.projectCategoryArray = [[NSMutableArray alloc]init];
    self.buildingShowListArray = [[NSMutableArray alloc]init];
}

-(void)initFilterData
{
    [self getProjectSelectorFromServer];
    // 从filterArray中读取数据
    [self.filterData1 addObject:@"0-5k"];
    [self.filterData1 addObject:@"5k-10k"];
    [self.filterData1 addObject:@"10k-15k"];
    [self.filterData1 addObject:@"15k-20k"];
    [self.filterData1 addObject:@"20k-25k"];
    [self.filterData1 addObject:@"25k-30k"];
    [self.filterData1 addObject:@"30k以上"];
    [self.filterData1 addObject:@"显示全部"];
}

- (void)resetFilter {
    [_filterDataView setHidden:TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _filterTable)
    {
        return 45.0f;
    }
    return 65.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _filterTable)
    {
        NSArray* data = [self currentFilter];
        return  data.count;
    }
    return _buildingShowListArray.count;
}

-(NSMutableArray*) currentFilter
{
    NSMutableArray* array = nil;
    if(self.headSelBtnTag == 1)
    {
        array = self.filterData1;
    }
    else if(self.headSelBtnTag == 2)
    {
        array = self.filterData2;
    }else if (self.headSelBtnTag == 3)
    {
        array = self.filterData3;
    }
    return array;
}

- (void) getMinMaxPriceByIndexRow:(NSInteger) row{
    switch (row) {
        case 0:
        {
            self.minPrice = @"0";
            self.maxPrice = @"1000";
        }
            break;
        case 1:
        {
            self.minPrice = @"1000";
            self.maxPrice = @"2000";
        }
            break;
        case 2:
        {
            self.minPrice = @"2000";
            self.maxPrice = @"3000";
        }
            break;
        case 3:
        {
            self.minPrice = @"3000";
            self.maxPrice = [NSString stringWithFormat:@"%ld", (long)LONG_MAX];
        }
            break;
        default:
        {
            self.minPrice = @"0";
            self.maxPrice = [NSString stringWithFormat:@"%ld", (long)LONG_MAX];
        }
            break;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _filterTable)
    {
        NSArray* data = [self currentFilter];
        static NSString *identify  = @"CommonFilterDataTableViewCell";
        CommonFilterDataTableViewCell *cell = (CommonFilterDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:identify owner:self options:nil]lastObject];
        }
        [cell loadCellData:[data objectAtIndex:indexPath.row]];
        return cell;
    }
    
    BuildingsServicesBuildingShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BuildingShowTableViewCellNibName forIndexPath:indexPath];
    
    // cell载入数据
    [cell loadCellData:[self.buildingShowListArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _filterTable)
    {
        [_filterDataView setHidden:TRUE];
        [_filterView setFilterTitle:self.headSelBtnTag title:[[self currentFilter] objectAtIndex:indexPath.row]];
        // 价格范围
        if(self.headSelBtnTag == 1)
        {
            self.priceRangeSel =  indexPath.row;
            [self getMinMaxPriceByIndexRow:self.priceRangeSel];
        }
        else if (self.headSelBtnTag == 2)
        {
            self.salesStatusSel = indexPath.row;
        }
        else if (self.headSelBtnTag == 3)
        {
            self.projectCategorySel = indexPath.row;
        }
        [self getBuildingListDataFromServer];
        return;
    }
     BuildingSnapModel*model= [_buildingShowListArray objectAtIndex:indexPath.row];
    if (model==nil) {
        return;
    }
    BuildingsServicesBuildingInfoViewController* next = [[BuildingsServicesBuildingInfoViewController alloc]init];
    next.projectId = model.projectId;;
    [self.navigationController pushViewController:next animated:TRUE];
}

#pragma mark---CommonFilterDataViewDelegate
-(void) FilterTableData:(CommonFilterDataView*) dataView filter:(NSArray*)filter
{
    [_filterDataView setHidden:_filterDataView.hidden?FALSE:TRUE];
    if (_filterDataView.hidden == FALSE) {
        {
            NSString* tagString = [filter objectAtIndex:0];
            self.headSelBtnTag = [tagString integerValue];
            [_filterTable reloadData];
        }
    }
}

// 从服务器获取-楼盘展示类型
- (void) getProjectSelectorFromServer {
    [self getOrignStringFromServer:ProjectInfo_Url path:ProjectSelector_Path method:@"GET" parameters:nil success:^(NSString *string) {
        [self.salesStatusArray removeAllObjects];
        [self.projectCategoryArray removeAllObjects];
        if ([string isEqualToString:@""] == FALSE) {
            NSMutableArray *result = [[NSMutableArray alloc]init];
            // 取得销售状态 分类
            result =  [self getArrayFromXML:string byParentNode:@"salesStatus"];
            for(NSDictionary *dic in result){
                [self.salesStatusArray addObject:[[ProjectSelectorModel alloc] initWithDictionary:dic]];
            }
            [_filterData2 removeAllObjects];
            for (ProjectSelectorModel* model in self.salesStatusArray)
            {
                [_filterData2 addObject:  model.detailName];
            }
            [_filterData2 addObject:  @"显示全部"];
            [self.filterTable reloadData];
            
            // 取得楼盘类别 分类
            result =  [self getArrayFromXML:string byParentNode:@"projectCategory"];
            for(NSDictionary *dic in result){
                [self.projectCategoryArray addObject:[[ProjectSelectorModel alloc] initWithDictionary:dic]];
            }
            [_filterData3 removeAllObjects];
            for (ProjectSelectorModel* model in self.projectCategoryArray)
            {
                [_filterData3 addObject:  model.detailName];
            }
            [_filterData3 addObject:  @"显示全部"];
            [self.filterTable reloadData];
        }
    }
    failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

// 从服务器获取-楼盘展示列表
- (void) getBuildingListDataFromServer {
    // 筛选条件
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[[NSString stringWithFormat:@"%ld", (long)BuildingShowPageSize],[NSString stringWithFormat:@"%ld", (long)self.pageNum]] forKeys:@[@"pageSize", @"pageNum"]];

    if ((self.priceRangeSel != -1)&&(self.priceRangeSel < self.filterData1.count)) {
        [dic setObject:self.minPrice forKey:@"minPrice"];
        [dic setObject:self.maxPrice forKey:@"maxPrice"];
    }
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[[NSString stringWithFormat:@"%ld", (long)BuildingShowPageSize],[NSString stringWithFormat:@"%ld", (long)self.pageNum], self.minPrice, self.maxPrice] forKeys:@[@"pageSize", @"pageNum", @"minPrice", @"maxPrice"]];
//
    if ((self.salesStatusSel != -1)&&(self.salesStatusSel < self.salesStatusArray.count)) {
        ProjectSelectorModel* model = [self.salesStatusArray objectAtIndex:_salesStatusSel];
        [dic setObject:model.detailId forKey:@"salesStatus"];
    }
    
    if ((self.projectCategorySel != -1)&&(self.projectCategorySel < self.projectCategoryArray.count)) {
        ProjectSelectorModel* model = [self.projectCategoryArray objectAtIndex:_projectCategorySel];
        [dic setObject:model.detailId forKey:@"projectCategory"];
    }
    
    [self getArrayFromServer:ProjectInfo_Url path:ProjectShowList_Path method:@"GET" parameters:dic xmlParentNode:@"project" success:^(NSMutableArray *result) {
        
        if(self.pageNum == 1){
            [self.buildingShowListArray removeAllObjects];
        }
        
        for (NSDictionary *dic in result) {
            [self.buildingShowListArray addObject:[[BuildingSnapModel alloc] initWithDictionary:dic]];
        }
        [self.buildingShowTableView.header endRefreshing];
        [self.buildingShowTableView.footer endRefreshing];
        if (self.buildingShowListArray.count < self.pageNum*BuildingShowPageSize) {
            [self.buildingShowTableView.footer noticeNoMoreData];
        }
        [self.buildingShowTableView reloadData];
    } failure:^(NSError *error) {
        [self.buildingShowTableView.header endRefreshing];
        [self.buildingShowTableView.footer endRefreshing];
        [self.buildingShowTableView reloadData];
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    
}
@end

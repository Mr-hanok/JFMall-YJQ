//
//  HousesServicesBuyViewController.m
//  CommunityApp
//
//  Created by iss on 15/7/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//
#define BuyListPageSize (10)
#import "HousesServicesTradeViewController.h"
#import "HousesServicesHouseDescViewController.h"
#import "HouseServiceAgentTableViewCell.h"
#import "CommonFilterDataView.h"
#import "CommonFilterDataTableViewCell.h"
#import "HouseSelectorModel.h"
#import "SelectNeighborhoodViewController.h"
#import "GYZChooseCityController.h"/////选择小区

#import <MJRefresh.h>
#define BuyListTableViewCellNibName          @"HouseServiceAgentTableViewCell"
@interface HousesServicesTradeViewController ()<UITableViewDelegate,UITableViewDataSource,CommonFilterDataViewDelegate,SelectNeighborhoodDelegate>

@property (strong,nonatomic) IBOutlet UIView* headView;
@property (strong,nonatomic) IBOutlet UIView* filterDataView;
@property (strong,nonatomic) IBOutlet UITableView* filterTable;
@property (strong,nonatomic) IBOutlet UITableView* buyListTable;
@property (retain,nonatomic) IBOutlet NSLayoutConstraint *filterTableHeightConstraint;
@property (strong,nonatomic) CommonFilterDataView* filterView;
@property (assign,nonatomic) NSInteger pageNum;
@property (assign,nonatomic) NSInteger headSelBtnTag;
@property (assign,nonatomic) NSInteger selAvgPrice;
@property (assign,nonatomic) NSInteger selRoomType;
@property (strong,nonatomic) NSString* projectId;
@property (strong,nonatomic) NSString* minPrice;
@property (strong,nonatomic) NSString* maxPrice;
@property (strong,nonatomic) NSString* projectName;
@property (strong,nonatomic) NSMutableArray* buyListArray;
@property (strong,nonatomic) NSMutableArray* roomTypeArray;
@property (strong,nonatomic) NSMutableArray* filterData1;
@property (strong,nonatomic) NSMutableArray* filterData2;
@property (strong,nonatomic) NSMutableArray* filterData3;

@end

@implementation HousesServicesTradeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化 - 基本数据部分
    [self initBaseData];
    [self getRoomTypeDataFromServer];
    // 初始化 - Navigation部分
    [self initNavigationItemData];
    [self setNavBarLeftItemAsBackArrow];
    // 初始化 - Filter部分
    [self initFilter];
    // 初始化 - TableView部分
    [self initListViewData];
    
    // 添加下拉/上滑刷新更多
    self.pageNum = 1;
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getBuyListDataFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.buyListArray.count == self.pageNum*BuyListPageSize) {
            self.pageNum++;
            [self getBuyListDataFromServer];
        }
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.buyListTable.header = header;
    self.buyListTable.footer = footer;

}

- (void)initBaseData {
    _buyListArray = [[NSMutableArray alloc]init];
    _roomTypeArray = [[NSMutableArray alloc]init];
    _filterData1 = [[NSMutableArray alloc]init];
    _filterData2 = [[NSMutableArray alloc]init];
    _filterData3 = [[NSMutableArray alloc]init];
}

- (void)initNavigationItemData {
    // 前画面带参数recordType 租房：1、买房：2
    if ([_recordType  isEqual: @"1"])
    {
        // 设置租房标题
        self.navigationItem.title = Str_HouseRent;
        // 初始化租房价格区间数据
        [_filterData2 addObject:@"0-1000"];
        [_filterData2 addObject:@"1000-2000"];
        [_filterData2 addObject:@"2000-3000"];
        [_filterData2 addObject:@"3000以上"];
        [_filterData2 addObject:@"显示全部"];
    }
    else if ([_recordType  isEqual: @"2"])
    {
        // 设置买房标题
        self.navigationItem.title = Str_HouseSell;
        // 初始化买房价格区间数据
        [_filterData2 addObject:@"0-50万"];
        [_filterData2 addObject:@"50-100万"];
        [_filterData2 addObject:@"100-150万"];
        [_filterData2 addObject:@"150-200万"];
        [_filterData2 addObject:@"200万以上"];
        [_filterData2 addObject:@"显示全部"];
    }
}

- (void)initFilter {
    // 从用户登录信息中取得小区ID、小区名
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    _projectId = [userDefault objectForKey:KEY_PROJECTID];
    _projectName = [userDefault objectForKey:KEY_PROJECTNAME];
    // 初始化下拉选框显示数据
    _filterView = [ [CommonFilterDataView alloc ]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    _filterView.delegate = self;
    [_filterView  initFilterTitle:[NSArray arrayWithObjects:_projectName,@"价格",@"厅室", nil]];
    // 增加filterView到headView的子视图列表中
    [_headView addSubview:_filterView];
    // 调整filter下拉菜单高度
    self.filterTableHeightConstraint.constant = (Screen_Height - Navigation_Bar_Height - 45)/2.0;
    // 设置filter样式
    [_filterDataView setBackgroundColor: [UIColor colorWithRed: 57/255.0  green: 57/255.0  blue: 57/255.0  alpha: 0.8f]];
    //添加点击重置Filter手势
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resetFilter)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)initListViewData {
    [_buyListTable registerNib:[UINib nibWithNibName:BuyListTableViewCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BuyListTableViewCellNibName];
    _selRoomType = -1;
    _minPrice = @"0";
    _maxPrice = [NSString stringWithFormat:@"%ld", (long)LONG_MAX];
}

- (void)resetFilter {
    [_filterDataView setHidden:TRUE];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getBuyListDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _filterTable)
    {
        NSArray* data = [self currentFilter];
        return  data.count;
    }
    return _buyListArray.count;
}

-(NSMutableArray*) currentFilter
{
    NSMutableArray* array = nil;
    if(_headSelBtnTag == 1)
    {
        array = _filterData1;
    }
    else if(_headSelBtnTag == 2)
    {
        array = _filterData2;
    }else if(_headSelBtnTag == 3)
    {
        array = _filterData3;
    }
    return array;
}

- (void) getMinMaxPriceByIndexRow:(NSInteger) row {
    switch (row) {
        case 0:
            {
                _minPrice = @"0";
                _maxPrice = @"1000";
            }
            break;
        case 1:
            {
                _minPrice = @"1000";
                _maxPrice = @"2000";
            }
            break;
        case 2:
            {
                _minPrice = @"2000";
                _maxPrice = @"3000";
            }
            break;
        case 3:
            {
                _minPrice = @"3000";
                _maxPrice = [NSString stringWithFormat:@"%ld", (long)LONG_MAX];
            }
            break;
        default:
            {
                _minPrice = @"0";
                _maxPrice = [NSString stringWithFormat:@"%ld", (long)LONG_MAX];
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
    
    HouseServiceAgentTableViewCell *cell = (HouseServiceAgentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BuyListTableViewCellNibName];
    
    [cell loadCellData:[_buyListArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _filterTable)
    {
        [_filterDataView setHidden:TRUE];
        [_filterView setFilterTitle:_headSelBtnTag title:[[self currentFilter] objectAtIndex:indexPath.row]];
        if (_headSelBtnTag == 3) {
            _selRoomType = indexPath.row;
        }
        if (_headSelBtnTag == 2) {
            _selAvgPrice = indexPath.row;
            [self getMinMaxPriceByIndexRow:_selAvgPrice];
        }
        [self getBuyListDataFromServer];
        return;
    }
    HousesServicesHouseDescViewController* next = [[HousesServicesHouseDescViewController alloc]init];
    HouseListModel* model = [_buyListArray objectAtIndex:indexPath.row];
    next.recordId = model.recordId;
    [self.navigationController pushViewController:next animated:TRUE];
    
}

#pragma mark---CommonFilterDataViewDelegate
-(void) FilterTableData:(CommonFilterDataView*) dataView filter:(NSArray*)filter
{
    [_filterDataView setHidden:_filterDataView.hidden?FALSE:TRUE];
    if (_filterDataView.hidden == FALSE) {
        {
            NSString* tagString = [filter objectAtIndex:0];
            _headSelBtnTag = [tagString integerValue];
            
            if (_headSelBtnTag == 1) {
                [_filterDataView setHidden:TRUE];
                SelectNeighborhoodViewController* vc = [[SelectNeighborhoodViewController alloc]init];
//                GYZChooseCityController *vc = [[GYZChooseCityController alloc] init];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:TRUE];
            }
            else
                [_filterTable reloadData];
            
        }
    }
    
}

// 从服务器获取-租房厅室筛选条件
- (void)getRoomTypeDataFromServer
{
    [self getOrignStringFromServer:HouseInfo_Url path:HouseSelector_Path method:@"GET" parameters:nil success:^(NSString *string) {
        [self.roomTypeArray removeAllObjects];
        if ([string isEqualToString:@""] == FALSE) {
            NSMutableArray* result =  [self getArrayFromXML:string byParentNode:@"roomType"];
            for(NSDictionary *dic in result){
            [self.roomTypeArray addObject:[[HouseSelectorModel alloc] initWithDictionary:dic]];
        }
        [_filterData3 removeAllObjects];
        for (HouseSelectorModel* model in self.roomTypeArray)
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

// 从服务器获取-房屋租/售列表
- (void)getBuyListDataFromServer
{
    // 筛选条件
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[_recordType,_projectId,[NSString stringWithFormat:@"%ld", (long)BuyListPageSize],[NSString stringWithFormat:@"%ld", (long)self.pageNum],_minPrice,_maxPrice] forKeys:@[@"recordType",@"projectId", @"pageSize",@"pageNum",@"minPrice",@"maxPrice"]];
    
    if ((_selRoomType != -1)&&(_selRoomType != _roomTypeArray.count)) {
        HouseSelectorModel* model = [_roomTypeArray objectAtIndex:_selRoomType];
        // roomTypeId = model.detailId;
        [dic setObject:model.detailId forKey:@"roomTypeId"];
    }
    
    // 从服务器获取数据
    [self getArrayFromServer:HouseInfo_Url path:HouseList_Path method:@"GET" parameters:dic xmlParentNode:@"house" success:^(NSMutableArray *result) {
        if (self.pageNum == 1) {
            [self.buyListArray removeAllObjects];
        }
        for (NSDictionary *dic in result) {
            [self.buyListArray addObject:[[HouseListModel alloc] initWithDictionary:dic]];
        }
        [self.buyListTable.header endRefreshing];
        [self.buyListTable.footer endRefreshing];
        if (self.buyListArray.count < self.pageNum*BuyListPageSize) {
            [self.buyListTable.footer noticeNoMoreData];
        }
        [self.buyListTable reloadData];
    } failure:^(NSError *error) {
        [self.buyListTable.header endRefreshing];
        [self.buyListTable.footer endRefreshing];
        [self.buyListTable reloadData];
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark---SelectNeighborhoodDelegate
- (void)setSelectedNeighborhoodId:(NSString *)projectId andName:(NSString*)projectName andqrCode:(NSString *)qrCode//🍎
{
    _projectId = projectId;
    _projectName  = projectName;
    _projectId = qrCode;//🍎
    [_filterView setFilterTitle:_headSelBtnTag title:_projectName];
    [self getBuyListDataFromServer];
}
@end

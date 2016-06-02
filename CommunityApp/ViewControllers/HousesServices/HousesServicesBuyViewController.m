//
//  HousesServicesBuyViewController.m
//  CommunityApp
//
//  Created by iss on 15/7/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//
#define BuyListPageSize (10)
#import "HousesServicesBuyViewController.h"
#import "HousesServicesHouseDescViewController.h"
#import "HouseServiceAgentTableViewCell.h"
#import "CommonFilterDataView.h"
#import "CommonFilterDataTableViewCell.h"
#import "HouseSelectorModel.h"
#import "SelectNeighborhoodViewController.h"

#import <MJRefresh.h>
#define BuyListTableViewCellNibName          @"HouseServiceAgentTableViewCell"
@interface HousesServicesBuyViewController ()<UITableViewDelegate,UITableViewDataSource,CommonFilterDataViewDelegate,SelectNeighborhoodDelegate>

{
    NSInteger headSelBtnTag;
    NSMutableArray *filterData1;
    NSMutableArray *filterData2;
    NSMutableArray *filterData3;
}

@property (strong,nonatomic) IBOutlet UIView* headView;
@property (strong,nonatomic) CommonFilterDataView* filterView;
@property (strong,nonatomic) IBOutlet UIView* filterDataView;
@property (strong,nonatomic) IBOutlet UITableView* filterTable;
@property (strong,nonatomic) IBOutlet UITableView* buyListTable;
@property (strong,nonatomic) NSMutableArray* buyListArray;
@property (assign,nonatomic) NSInteger pageNum;
@property (strong,nonatomic) NSMutableArray* roomTypeArray;
@property (strong,nonatomic) NSString* projectId;
@property (strong,nonatomic) NSString* projectName;
@property (assign,nonatomic) NSInteger selRoomType;
@end

@implementation HousesServicesBuyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_HouseSell;
    [self setNavBarLeftItemAsBackArrow];
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    _projectId = [userDefault objectForKey:KEY_PROJECTID];
    _projectName = [userDefault objectForKey:KEY_PROJECTNAME];
    _filterView = [ [CommonFilterDataView alloc ]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    [_filterView  initFilterTitle:[NSArray arrayWithObjects:_projectName,@"价格",@"厅室", nil]];
    _selRoomType = -1;
    _filterView.delegate = self;
    
    [_headView addSubview:_filterView];
    filterData1 = [[NSMutableArray alloc]init];
    filterData2 = [[NSMutableArray alloc]init];
    filterData3 = [[NSMutableArray alloc]init];
    [_buyListTable registerNib:[UINib nibWithNibName:BuyListTableViewCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BuyListTableViewCellNibName];
    [self initFilterData];
    _buyListArray = [[NSMutableArray alloc]init];
    [_filterDataView setBackgroundColor: [UIColor colorWithRed: 57/255.0  green: 57/255.0  blue: 57/255.0  alpha: 0.8f]];
    
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

    [self getRoomTypeDataFromServer];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getBuyListDataFromServer];
}
-(void)initFilterData
{
    [filterData1 addObject:@"越秀区1"];
    [filterData1 addObject:@"越秀区2"];
    [filterData1 addObject:@"越秀区3"];
    [filterData1 addObject:@"越秀区4"];
    [filterData1 addObject:@"越秀区5"];
    
    [filterData2 addObject:@"0-50"];
    [filterData2 addObject:@"51-100"];
    [filterData2 addObject:@"101-150"];
    [filterData2 addObject:@"151-200"];
    
    [filterData3 addObject:@"板块1"];
    [filterData3 addObject:@"板块2"];
    [filterData3 addObject:@"板块3"];
    [filterData3 addObject:@"板块4"];
    [filterData3 addObject:@"板块5"];
    [filterData3 addObject:@"板块6"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(headSelBtnTag == 1)
    {
        array = filterData1;
    }
    else if(headSelBtnTag == 2)
    {
        array = filterData2;
    }else if(headSelBtnTag == 3)
    {
        array = filterData3;
    }
    return array;
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
            //        cell = [nib objectAtIndex:0];
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
        [_filterView setFilterTitle:headSelBtnTag title:[[self currentFilter] objectAtIndex:indexPath.row]];
        if (headSelBtnTag == 3) {
            _selRoomType = indexPath.row;
        }
        [self getBuyListDataFromServer];
        return;
    }
    HousesServicesHouseDescViewController* next = [[HousesServicesHouseDescViewController alloc]init];
    HouseListModel* model = [_buyListArray objectAtIndex:indexPath.row];
    next.recordId = model.recordId;
    [self.navigationController pushViewController:next animated:TRUE];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark---CommonFilterDataViewDelegate
-(void) FilterTableData:(CommonFilterDataView*) dataView filter:(NSArray*)filter
{
    [_filterDataView setHidden:_filterDataView.hidden?FALSE:TRUE];
    if (_filterDataView.hidden == FALSE) {
        {
            NSString* tagString = [filter objectAtIndex:0];
            headSelBtnTag = [tagString integerValue];
            if (headSelBtnTag == 1) {
                SelectNeighborhoodViewController* vc = [[SelectNeighborhoodViewController alloc]init];
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
    _roomTypeArray = [[NSMutableArray alloc]init];
    [self.roomTypeArray removeAllObjects];
    
    [self getOrignStringFromServer:HouseInfo_Url path:HouseSelector_Path method:@"GET" parameters:nil success:^(NSString *string) {
        if ([string isEqualToString:@""] == FALSE) {
            NSMutableArray* result =  [self getArrayFromXML:string byParentNode:@"roomType"];
            for(NSDictionary *dic in result){
            [self.roomTypeArray addObject:[[HouseSelectorModel alloc] initWithDictionary:dic]];
        }
        [filterData3 removeAllObjects];
        for (HouseSelectorModel* model in self.roomTypeArray){
          [filterData3 addObject:  model.detailName];
        }
        [self.filterTable reloadData];
        } }
        failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    
}
// 从服务器获取-买房列表
- (void)getBuyListDataFromServer
{
    // 筛选条件
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@"2"/*,_projectId*/]
                                                      forKeys:@[@"recordType"/*,@"projectId"*/]];
    if (_selRoomType!=-1) {
        HouseSelectorModel* model = [_roomTypeArray objectAtIndex:_selRoomType];
       [ dic setObject:model.detailId forKey:@"roomTypeId"];
    }
    // 从服务器获取数据
    [self getArrayFromServer:HouseInfo_Url path:HouseList_Path method:@"GET" parameters:dic xmlParentNode:@"house" success:^(NSMutableArray *result) {
        [self.buyListArray removeAllObjects];

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
- (void)setSelectedNeighborhoodId:(NSString *)projectId andName:(NSString*)projectName
{
    _projectId = projectId;
    _projectName  = projectName;
    [_filterView setFilterTitle:headSelBtnTag title:_projectName];
    [self getBuyListDataFromServer];
}
@end

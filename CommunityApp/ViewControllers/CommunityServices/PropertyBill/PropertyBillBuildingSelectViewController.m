//
//  PropertyBillBuildingSelectViewController.m
//  CommunityApp
//
//  Created by iss on 7/17/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PropertyBillBuildingSelectViewController.h"
#import "BuildingSelectTableViewCell.h"

#define cellNibName @"BuildingSelectTableViewCell"

@interface PropertyBillBuildingSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView* table;

@property (assign,nonatomic) NSInteger selBuildingindex;
@end

@implementation PropertyBillBuildingSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Bill_BuildingSel_Title;
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-Navigation_Bar_Height)];
    [self.view addSubview:_table];
    _table.dataSource  =self;
    _table.delegate = self;
    [_table registerNib:[UINib nibWithNibName:cellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellNibName];
    [_table setBackgroundColor:[UIColor clearColor]];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table reloadData];
    _selBuildingindex = 0;
     NSIndexPath *ip=[NSIndexPath indexPathForRow:_selBuildingindex inSection:0];
    [_table selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark---UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _buildingList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingSelectTableViewCell* cell = (BuildingSelectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellNibName];
    [cell loadCellData:[_buildingList objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark --- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selBuildingindex = indexPath.row;
    if(self.selectBuilding)
    {
        self.selectBuilding(_selBuildingindex);
    }
}
@end

//
//  PersonalCenterAreaSelectViewController.m
//  CommunityApp
//
//  Created by iss on 7/30/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterAreaSelectViewController.h"
#import "PersonalCenterCustomerClassTableViewCell.h"


@interface PersonalCenterAreaSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray* data;
@property (assign,nonatomic) PersonalCenterSelType selType;
@property (strong,nonatomic) DistinctModel* pro;
@property (strong,nonatomic) DistinctModel* city;
@property (strong,nonatomic) IBOutlet UITableView* table;
@end

@implementation PersonalCenterAreaSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_BaseInfo_ProvineSel;
    _selType = PersonalCenterSel_Pro;
    _data  = [[NSMutableArray alloc]init];
    [self getAreaDataFromServer:_selType];
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
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"PersonalCenterCustomerClassTableViewCell";
    PersonalCenterCustomerClassTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
    }
    DistinctModel* model = [_data objectAtIndex:indexPath.row];
    [cell setText:model.cityName];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
#pragma mark---UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selType == PersonalCenterSel_City)
    {
         _city = (DistinctModel*)[[_data objectAtIndex:indexPath.row] copy];
        if(self.distinctData)
        {
            self.distinctData(_pro,_city);
        }
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    else
    {
        _selType = PersonalCenterSel_City;
        _pro = (DistinctModel*)[[_data objectAtIndex:indexPath.row] copy];
        [self getAreaDataFromServer:_selType];
    }
}

#pragma mark --- 从服务器取数据
-(void)getAreaDataFromServer:(PersonalCenterSelType)type
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if(type == PersonalCenterSel_Pro)
    {
        [dic setObject:@"0" forKey:@"level"];
    }
    else
    {
        [dic setObject:@"1" forKey:@"level"];
        [dic setObject:_pro.cityId forKey:@"parentId"];
    }
    [self getArrayFromServer:DistinctInfo_Url path:DistinctInfo_Path method:@"GET" parameters:dic xmlParentNode:@"city" success:^(NSMutableArray *result){
        self.navigationItem.title = Str_BaseInfo_CitySel;
        [_data removeAllObjects];
        [_table reloadData];
        for (NSDictionary* dicResult in result) {
            [_data addObject:[[DistinctModel alloc] initWithDictionary:dicResult]];
        }
        [_table reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];

    }];
}
@end

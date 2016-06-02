//
//  HousesServicesHouseAgencyViewController.m
//  CommunityApp
//
//  Created by iss on 7/1/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HousesServicesHouseAgencyViewController.h"
#import "HousesServicesTradeViewController.h"
#import "PersonalCenterMeCell.h"
#import "HousesServicesSentInfoViewController.h"

typedef enum {
    Row_Rent,
    Row_Buy,
    Row_Dispatch,
    Row_Count
}RowTypeEnum;
@interface HousesServicesHouseAgencyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* tableData;
}
@property(strong,nonatomic)IBOutlet UIView* tableHead;
@property(strong,nonatomic)IBOutlet UITableView* table;
@end

@implementation HousesServicesHouseAgencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_HouseAgency;
    [self setNavBarLeftItemAsBackArrow];
    tableData = @[@[Img_HouseRent,Str_HouseRent],@[Img_HouseSell,Str_HouseSell],@[Img_HouseDispatch,Str_HouseDispatch]];
    _table.tableHeaderView = _tableHead;
    [_table setScrollEnabled:FALSE];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PersonalCenterMeCell";
    PersonalCenterMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalCenterMeCell" owner:self options:nil] lastObject];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setIconPath:[[tableData objectAtIndex:indexPath.row] objectAtIndex:0]];
    [cell setName:[[tableData objectAtIndex:indexPath.row] objectAtIndex:1] isBottom:indexPath.row == (tableData.count-1)];
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == Row_Dispatch)
    {
        if ([self isGoToLogin]) {
            HousesServicesSentInfoViewController* next = [[HousesServicesSentInfoViewController alloc]init];
            [self.navigationController pushViewController:next animated:TRUE];
        }
    }
    
    if (indexPath.row == Row_Rent || indexPath.row == Row_Buy) {
        HousesServicesTradeViewController* next = [[HousesServicesTradeViewController alloc]init];
        next.recordType = @"1";
        if ( indexPath.row == Row_Buy) {
             next.recordType = @"2";
        }
        [self.navigationController pushViewController:next animated:TRUE];
    }
}
@end

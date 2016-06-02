//
//  PersonalCenterCustomerClassViewController.m
//  CommunityApp
//
//  Created by iss on 6/8/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterCustomerClassViewController.h"
#import "PersonalCenterCustomerClassTableViewCell.h"
#import "CustomPropertyModel.h"

@interface PersonalCenterCustomerClassViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* array;
    NSMutableArray* customProperty;
}
@property(strong,nonatomic)IBOutlet UITableView* table;

@end

@implementation PersonalCenterCustomerClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title=Str_CustomProperty_Title;
    array = @[@"租户",@"住户",@"业主",@"商户"];
    customProperty = [[NSMutableArray alloc]init];
    [self initBasicDataInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    [customProperty removeAllObjects];
    
    // 请求服务器获取周边商家数据
    [self getDataFromServer];
    
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    
    
    // 请求服务器获取数据
    [self getArrayFromServer:ServiceInfo_Url path:CustomProperty_Path method:@"GET" parameters:nil xmlParentNode:@"result" success:^(NSMutableArray *result) {
        for (NSDictionary *dicResult in result)
        {
            
            [customProperty addObject:[[CustomPropertyModel alloc] initWithDictionary:dicResult]];
            
        }
        [_table reloadData];
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark-table view
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"PersonalCenterCustomerClassTableViewCell";
    PersonalCenterCustomerClassTableViewCell* cell;
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:identify owner:self options:nil] lastObject];
    }
    CustomPropertyModel* data = [customProperty objectAtIndex: indexPath.row];
    [cell setText:data.propertyName];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [customProperty count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalCenterCustomerClassTableViewCell* cell= (PersonalCenterCustomerClassTableViewCell*)[_table cellForRowAtIndexPath:indexPath];
    NSString* class = [cell getText];
    if (self.personalCenterResult)
    {
        self.personalCenterResult(class);
    }
    if (self.customPropertyId) {
        CustomPropertyModel* data = [customProperty objectAtIndex:indexPath.row];
        self.customPropertyId(data.propertyId);
    }
     [self.navigationController popViewControllerAnimated:TRUE];
}

@end

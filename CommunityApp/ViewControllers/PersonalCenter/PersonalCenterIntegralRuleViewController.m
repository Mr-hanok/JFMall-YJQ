//
//  PersonalCenterIntegralRuleViewController.m
//  CommunityApp
//
//  Created by iss on 8/26/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterIntegralRuleViewController.h"
#import "integralRulesModel.h"
#import "PersonalCenterIntegralRuleTableViewCell.h"
#define NIBCELLNAME @"PersonalCenterIntegralRuleTableViewCell"

@interface PersonalCenterIntegralRuleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray* integralArray;
@property (strong,nonatomic)IBOutlet UITableView* table;
@end

@implementation PersonalCenterIntegralRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_IntegralRule_Title;
    _integralArray = [[NSMutableArray alloc]init];
    [_table registerNib:[UINib nibWithNibName:NIBCELLNAME bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NIBCELLNAME];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getDataFromServer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataFromServer
{
    [self getArrayFromServer:IntegralRulesDetail_Url path:IntegralRulesDetail_Path method:@"GET" parameters:nil xmlParentNode:@"integralRules" success:^(NSMutableArray *result) {
        for (NSDictionary* dic in result) {
            [_integralArray addObject:[[integralRulesModel alloc] initWithDictionary:dic]];
        }
        [_table reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _integralArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   PersonalCenterIntegralRuleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NIBCELLNAME];
    [cell loadCellData:[_integralArray objectAtIndex:indexPath.row]];
    return cell;
}

@end

//
//  MyCouponsShareViewController.m
//  CommunityApp
//
//  Created by iss on 8/10/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "MyCouponsShareViewController.h"
#import "MyCouponsShareTableViewCell.h"
#define CELLNIBNAME @"MyCouponsShareTableViewCell"

@interface MyCouponsShareViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) IBOutlet UITableView* table;
@end

@implementation MyCouponsShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = @"分享";
    [self setNavBarItemRightViewForNorImg:@"ShareBtnNor" andPreImg:@"ShareBtnPre"];
    [_table registerNib:[UINib nibWithNibName:CELLNIBNAME bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELLNIBNAME];
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
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCouponsShareTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLNIBNAME];
    [cell loadCellData:indexPath.row+1 title:@"测试团购券"];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
@end

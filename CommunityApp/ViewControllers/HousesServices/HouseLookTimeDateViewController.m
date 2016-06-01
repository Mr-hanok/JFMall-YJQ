//
//  HouseLookTimeDateViewController.m
//  CommunityApp
//
//  Created by iss on 7/16/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HouseLookTimeDateViewController.h"
#import "HouseLookTimeDateTableViewCell.h"
#define CellNibName @"HouseLookTimeDateTableViewCell"
@interface HouseLookTimeDateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) NSArray* date;
@property (strong,nonatomic) NSMutableArray* selDateArray;
@end

@implementation HouseLookTimeDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_table registerNib:[UINib nibWithNibName:CellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellNibName];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_BuildingsInfo_SelectDateTitle;
    _date = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    [self setNavBarRightItemTitle:Str_Comm_Ok andNorBgImgName:nil andPreBgImgName:nil];
    _selDateArray = [[NSMutableArray alloc]init];
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
    return 7;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseLookTimeDateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellNibName];
    NSString* text = [NSString stringWithFormat:@"星期%@",[_date objectAtIndex:indexPath.row] ];
    [cell loadCellData:text];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_selDateArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_selDateArray removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
   
}
#pragma mark---navBarRightItemClick
-(void)navBarRightItemClick
{
    NSMutableString* dateString = [[NSMutableString alloc]initWithString:@"星期"];
    for(NSString* date in _selDateArray)
    {
        NSInteger index = [date intValue];
        
        [dateString appendString:[NSString stringWithFormat:@"%@ ",[_date objectAtIndex:index]]];
        
    }
    if([self.delegate respondsToSelector:@selector(selHouseLookTimeDate:)])
    {
        [self.delegate selHouseLookTimeDate:dateString];
    }
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end

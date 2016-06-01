//
//  CSUTUserfulTelNoListViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//  常用电话

#import "UserfulTelNoListViewController.h"
#import "UserfulTelNoCellTableViewCell.h"
#import "MJRefresh.h"

@interface UserfulTelNoListViewController ()<UITableViewDelegate,UITableViewDataSource>
    @property(strong,nonatomic) IBOutlet UITableView *table;
    @property (retain,nonatomic) NSMutableArray *telDataArray;
@end

//定义常用联系方式cell的宏
#define USER_TEL_NO_CELL  @"UserfulTelNoCellTableViewCell"

@implementation UserfulTelNoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _telDataArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = Str_Userful_Tel_Title;

    [self setNavBarLeftItemAsBackArrow];

    [self initBasicDataInfo];
  
    // 添加下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataFromServer];   // 从服务器获取常用联系方式的数据
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.table.header = header;
    [self.table reloadData];
}

/**
 * 获取table view数据个数
 */
-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return self.telDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserfulTelNoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:USER_TEL_NO_CELL forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:USER_TEL_NO_CELL owner:self options:nil]lastObject];
    }
    
    [cell loadCellData:[self.telDataArray objectAtIndex:indexPath.row]];
    [cell setDialCallHotLine:^{
        ConnectMode *model = [self.telDataArray objectAtIndex:indexPath.row];
        NSString *dialTel = [NSString stringWithFormat:@"tel://%@", model.telNo];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialTel]];
    }];
    return cell;
}

/**
 * 数据初始化
 */
-(void) initBasicDataInfo
{
    //注册tabview cell
    UINib *nibForTel =[UINib nibWithNibName: USER_TEL_NO_CELL bundle:[NSBundle mainBundle]];
    [self.table registerNib:nibForTel forCellReuseIdentifier:USER_TEL_NO_CELL];
    
    [self getDataFromServer];

}

/**
 * 从服务器获取常用联系方式的数据
 */
- (void)getDataFromServer
{
    //rest/ CrmManagePhoneInfo/managePhoneList
   
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.projectId] forKeys:@[@"projectId"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:GetCrmManagePhoneList_Url  path:GetCrmManagePhoneList_Path method:@"GET" parameters:dic xmlParentNode:@"crmManagePhone" success:^(NSMutableArray *result)
     {
         [self.telDataArray removeAllObjects];
         for (NSDictionary *dicResult in result)
         {
             [self.telDataArray addObject:[[ConnectMode alloc] initWithDictionary:dicResult]];
         }
         [self.table.header endRefreshing];
         [self.table reloadData];
#pragma mark-添加提醒没有数据
         if ( self.telDataArray.count==0) {
             UIAlertView*ale=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，该社区暂时没有办事电话哦~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
             [ale show];
             //            [Common showBottomToast:@"暂时没有数据"];
         }

     }
     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
         [self.table.header endRefreshing];
     }];
}

/**
 * 内存警告
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

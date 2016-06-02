//
//  CSPRMyPostRepairViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//  我的报事

#import "MyPostRepairViewController.h"
#import "MyPostWorkMode.h"
#import "MyPostRepairCellTableViewCell.h"
#import "MyPostRepairFollowViewController.h"
#import "PostDetailViewController.h"
#import "MyPostRepair.h"
#import "UserModel.h"

@interface MyPostRepairViewController ()
    //定义1个数组获取数据
    @property (retain,nonatomic) NSMutableArray *myPostRepairArrayData;
@end

@implementation MyPostRepairViewController
{
      NSString *orderId;
      NSInteger complateFlag;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//   self.myPostWorkTable.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.myPostWorkTable.backgroundColor = [UIColor clearColor];
    
    self.myPostRepairArrayData = [[NSMutableArray alloc] init];
    self.navigationItem.title = Str_Service_MyReport;
    [self setNavBarLeftItemAsBackArrow];
    
    //未完成
    [self getDataFromServer:@"1"];
    [self.unComplateButton setSelected:TRUE];
    complateFlag = 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.myPostRepairArrayData.count;
}

-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPostRepairCellTableViewCell *cell = (MyPostRepairCellTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdleft=@"MyPostRepairCellTableViewCell";
    
    MyPostRepairCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdleft];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyPostRepairCellTableViewCell" owner:self options:nil] lastObject];
    }
    
    if(complateFlag == 2)
    {
        [cell.cancelButton setHidden:YES];
        [cell.dealButton setHidden:YES];
        [cell.delProgressButtonOfComplatePage setHidden:NO];
    }
    
    else
    {
        [cell.cancelButton setHidden:NO];
        [cell.dealButton setHidden:NO];
        [cell.delProgressButtonOfComplatePage setHidden:YES];
    }
    
    [cell loadCellData:[self.myPostRepairArrayData objectAtIndex:indexPath.section]];
    
    [cell.dealButton setTag:indexPath.section];
    
    [cell.cancelButton setTag:indexPath.section];
    
    [cell.delProgressButtonOfComplatePage setTag:indexPath.section];
    
    [cell addTrackTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell addDelProgressButtonOfComplatePageTarget:self action:@selector(toDelProgressOfComplatePage:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addCancelTrackTarget:self action:@selector(toCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

/**
 * 从服务器获取工程报修数据
 */
-(void) getDataFromServer:(NSString *)status
{
    //清空数据
    
    if ([Common appDelegate].userArray.count==0) {
        return;
    }
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    //封装查询参数
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:status,@"orderType",user.userId,@"userId", nil];
    /*
     -- state;//任务状态 1未处理，2处理中，3处理完成，4已关闭，5已拒单 ,6已取消,7已删除8待单中
     -- 1:(1,2,5);2:(3,4,6)
     */
    
    [self getArrayFromServer:SelectCategory_Url path:Get_MyPostRepair_Path method:@"GET" parameters:dic xmlParentNode:@"crmOrder" success:^(NSMutableArray *result)
     {
         [self.myPostRepairArrayData removeAllObjects];
         for (NSDictionary *dicResult in result)
         {
             [self.myPostRepairArrayData addObject:[[MyPostRepair alloc] initWithDictionary:dicResult]];
         }
         
         [self.myPostWorkTable reloadData];
     }
     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  未选中按钮点击
 */
- (IBAction)unselectButtonClick:(id)sender
{
    [self.unComplateButton setSelected:TRUE];
    [self.complateButton setSelected:FALSE];
    //未完成
    [self getDataFromServer:@"1"];
    complateFlag = 1;
}

/**
 *  选中按钮点击
 */
- (IBAction)selectButtonClick:(id)sender
{
    [self.complateButton setSelected:TRUE];
    [self.unComplateButton setSelected:FALSE];
     //已经完成
    [self getDataFromServer:@"2"];
     complateFlag = 2;
}

/**
 * 跳转到处理进度
 */
-(void)toDetail:(UIButton *)button
{
    MyPostRepair * myPostRepairData = [self.myPostRepairArrayData objectAtIndex:button.tag];
    MyPostRepairFollowViewController* next = [[MyPostRepairFollowViewController alloc]init];
    next.data = myPostRepairData;
    [self.navigationController pushViewController:next animated:YES ];
}

/**
 * 已完成页面跳转到处理进度
 */
-(void)toDelProgressOfComplatePage:(UIButton *)button
{
    MyPostRepair * myPostRepairData = [self.myPostRepairArrayData objectAtIndex:button.tag];
    MyPostRepairFollowViewController* next = [[MyPostRepairFollowViewController alloc]init];
    next.data = myPostRepairData;
    [self.navigationController pushViewController:next animated:YES ];
}

/**
 * item点击事件跳转到详情s
 */
-(void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPostRepair * myPostRepairData = [self.myPostRepairArrayData objectAtIndex:indexPath.section];
    PostDetailViewController *next = [[PostDetailViewController alloc] init];
    next.orderId = myPostRepairData.orderId;
    [self.navigationController pushViewController:next animated:YES];
}

/**
* 取消button
*/
-(void)toCancel:(UIButton *)button
{
    MyPostRepair * myPostRepairData = [self.myPostRepairArrayData objectAtIndex:button.tag];
    orderId =myPostRepairData.orderId;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Str_MyOrder_Prompt message:Str_MyOrder_Message delegate:self cancelButtonTitle:Str_Comm_Ok   otherButtonTitles:Str_Comm_Cancel, nil];
    [alert show];
}

/**
 * 取消按钮
 */
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId,@"orderId",nil];
        
        // 请求服务器获取数据
        [self getStringFromServer:ServiceInfo_Url path:CancelOrder_Path method:@"POST" parameters:dic success:^(NSString* success)
        {
//            UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"取消成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [al show];
            [self getDataFromServer:@"1"];
        }
        failure:^(NSError *error)
        {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
    }
}


#pragma mark - 导航栏返回按键方法重写
- (void)navBarLeftItemBackBtnClick
{
    if(_leftOp == LeftNarvigate_ToRoot)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if(_leftOp == LeftNarvigate_ToPre)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end

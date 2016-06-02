//
//  PostDetailViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//  报事详情

#import "PostDetailViewController.h"
#import "OrderPostRepair.h"
#import "AGImagePickerViewController.h"

@interface PostDetailViewController ()
@property (strong,nonatomic) OrderPostRepair* orderData;
@end

@implementation PostDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = Str_Service_MyReport_DETAIL;
    [self setNavBarLeftItemAsBackArrow];
    
    [self getDataFromServer:self.orderId];
}
#pragma mark-数据解析
- (void)getDataFromServer:(NSString *)orderId
{
    //rest/ CrmManagePhoneInfo/managePhoneList
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId,@"orderId",nil];
    
    // 请求服务器获取数据
    [self getArrayFromServer:SelectCategory_Url  path:MyPostRepairDetail_Path method:@"GET" parameters:dic xmlParentNode:@"crmOrder" success:^(NSMutableArray *result)
     {
         for (NSDictionary *dicResult in result)
         {
             OrderPostRepair *orderPostRepair = [[OrderPostRepair alloc] initWithDictionary:dicResult];
             [self setViewData:orderPostRepair];
             YjqLog(@"%@",dicResult);
         }
     }
     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}

-(void) setViewData:(OrderPostRepair *)orderPostRepair
{
    [self.myLabelOrderId setText:orderPostRepair.orderNum];
    [self.labelState setText: orderPostRepair.statu];
    [self.labelLinkName setText:orderPostRepair.linkName];
    [self.labelLinkTel setText: orderPostRepair.linkTel];
    [self.labelServiceName setText:orderPostRepair.serviceName];
    [self.labelCreateDate setText:orderPostRepair.createDate];
    [self.labelAddress setText:orderPostRepair.address];
    NSLog(@"orderPostRepair.filePath=====%@",orderPostRepair.filePath);
    _orderData = orderPostRepair;
}
#pragma mark-查看图片
#pragma mark--IBAction
-(IBAction)clickImgDetail:(id)sender
{
    if (_orderData.filePath.length==0) {
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有图片可查看哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        return;
    }
    AGImagePickerViewController* vc = [[AGImagePickerViewController alloc]init];
    vc.imgUrlArray = [_orderData.filePath componentsSeparatedByString:@","];
    
    
    [self.navigationController pushViewController:vc animated:TRUE];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

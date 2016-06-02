//
//  MyVisitorViewController.m
//  CommunityApp
//
//  Created by 张艳清 on 15/10/13.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "MyVisitorViewController.h"
#import "MyVisitorTableViewCell.h"//我的访客cell
#import "NewVieitorViewController.h"//新访客
#import "VisitorDetailViewController.h"//访客详情
#import <AFNetworking.h>
#import "Interface.h"
#import "VisityList.h"
#import "visitorsModel.h"

@interface MyVisitorViewController ()
{
    UITableView *tbView;
    NSArray * namearray;
    NSArray * datearray;
    
    NSMutableArray *nameArray;
    NSMutableArray *visitorNumberArray;
    NSMutableArray *visitorAimArray;
    NSMutableArray *carDiveArray;
    NSMutableArray *startTimeArray;
    NSMutableArray *endTimeArray;
    NSMutableArray *keyArray;
    NSMutableArray *keyUrlArray;
    
    NSDictionary *dict;
    
}
@end

@implementation MyVisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_MyVisitor_title;

    [self creatTableView];


}
- (void)creatTableView
{
    //创建表格视图
    tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    //设置代理回调
    tbView.dataSource=self;
    tbView.delegate=self;
    //添加表格试图
    [self.view addSubview:tbView];

    //向表格中注册xib
    UINib *nib=[UINib nibWithNibName:@"MyVisitorTableViewCell" bundle:nil];
    [tbView registerNib:nib forCellReuseIdentifier:@"strIdentifier"];
}

- (NSMutableArray *)dataSouce
{
    if (_dataSouce == nil) {
        _dataSouce = [[NSMutableArray alloc]init];
    }
    return _dataSouce;
}
- (void)visitorList
{
    //🍎AFNetWorking解析数据
    AFHTTPSessionManager  *_manager
    =[AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *userid = [[LoginConfig Instance]userID];//业主ID

    //
    //上传设备信息
    UIDevice *device = [UIDevice currentDevice];
   // NSString *name = device.name;       //获取设备所有者的名称
    NSString *model = device.model;      //获取设备的类别
    NSString *type = device.localizedModel; //获取本地化版本
   // NSString *systemName = device.systemName;   //获取当前运行的系统
    NSString *systemVersion = device.systemVersion;//获取当前系统的版
    NSString *rst = [NSString stringWithFormat:@"%@#@#%@#@#%@",model,type,systemVersion];
    //因为有汉子要utf8编码
    NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //parameters:dic上传给服务器的参数
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:userid,@"ownerId",VersionNumber,@"version",rstt,@"rst", nil];
    NSLog(@"dic:%@",dic);
    
    [_manager POST:VisitorList parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        
        //解析数据
        dict=[NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"dict:%@",dict);
        //声请成功
        if ([dict[@"code"] isEqualToString:@"IOD00000"]) {
//            
            NSArray *visitorsArray = dict[@"visitors"];
            //self.dataSouce = [NSMutableArray arrayWithArray:visitorsArray];
            for (NSDictionary *visitorsDict in visitorsArray)
            {
                visitorsModel *model = [[visitorsModel alloc]init];
                [model setValuesForKeysWithDictionary:visitorsDict];
                [self.dataSouce addObject:model];
                [tbView reloadData];

            }
        }
//
       // [tbView reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    self.HUD.hidden = NO;
//    if (!self.hudHidden)
//    {
//        [self.HUD show:YES];
//        [self.view bringSubviewToFront:self.HUD];
//    }
   // [tbView reloadData];
    _dataSouce = [[NSMutableArray alloc]init];
    [self visitorList];
    [tbView reloadData];
    //self.HUD.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //自定义cell
    MyVisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"strIdentifier"];
    //解析数据源
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    visitorsModel *model = [[visitorsModel alloc]init];
    model = self.dataSouce[indexPath.row];
   
    cell.VisitorName.text = model.visitorName;
    //
    NSDate *  startdate=[NSDate dateWithTimeIntervalSince1970:model.startTime/1000];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *startTime=[dateformatter stringFromDate:startdate];

    cell.startTimeLabel.text =startTime;

    
    NSDate *  enddate=[NSDate dateWithTimeIntervalSince1970:model.endTime/1000];
    NSDateFormatter  *dateformatter2=[[NSDateFormatter alloc] init];
    [dateformatter2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *endTime=[dateformatter stringFromDate:enddate];
    
    cell.endTimeLabel.text =endTime;
    cell.YorNlabel.text = @"有效";
    
    return cell;
}

#pragma -Mark UITableViewDelegate
//设置指定行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//设置表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 48, 320, 80)];
    UIView *grayView=[[UIView alloc]init];
    grayView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    


    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100,35, 200, 50)];
    [btn setTitle:@"+新访客" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.cornerRadius = 28.0;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:btn];
    
    return grayView;
}
- (void)btnClick:(UIButton *)btn
{
    NewVieitorViewController *newVisitorVC = [[NewVieitorViewController alloc] init];
    newVisitorVC.title = @"新访客";
    [self.navigationController pushViewController:newVisitorVC animated:YES];
}

//设置表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}
//行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VisitorDetailViewController *next = [[VisitorDetailViewController alloc] init];
   next.title = @"访客详情";
    
    visitorsModel *model = [[visitorsModel alloc]init];
    model = self.dataSouce[indexPath.row];
    next.model = model;    
    
    [self.navigationController pushViewController:next animated:YES];
    
}

@end

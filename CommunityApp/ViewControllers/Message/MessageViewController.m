//
//  MessageViewController.m
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageViewCellTableViewCell.h"
#import "MessageDetailViewController.h"
//第三方
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "GDataXMLNode.h"
#define  identify @"MessageViewCellTableViewCell"

#pragma mark - 宏定义区
#define WaresListPageSize                   (20)

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, assign) NSInteger         pageNum;        // 当前页码
@property (strong, nonatomic) IBOutlet UIView *navRightView;
@property (strong,nonatomic)IBOutlet UITableView* tableView;
@property(nonatomic,strong)NSMutableArray*dataSourceArray;
@property(nonatomic,strong)NSMutableArray*objsArray;
//@property(nonatomic,strong)MessageDetailViewController*messageDetailVC;
@end
@implementation MessageViewController
{
    UIImageView *backgroundImg;
}
#pragma mark-懒加载
-(NSMutableArray *)objsArray
{
    if (_objsArray==nil) {
        _objsArray=[[NSMutableArray alloc]init];
    }
    return _objsArray;
}

-(NSMutableArray *)dataSourceArray
{
    if (_dataSourceArray==nil) {
        _dataSourceArray=[[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}
//-(MessageDetailViewController *)messageDetailVC
//{
//    if (_messageDetailVC==nil) {
//        _messageDetailVC=[[MessageDetailViewController alloc]init];
//    }
//    return _messageDetailVC;
//}
-(UITableView *)tableView
{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]init];
    }
    return _tableView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    backgroundImg = [[UIImageView alloc] init];

    self.title=@"物业通知";
    self.view.backgroundColor=[UIColor whiteColor];
    //导航栏左侧按钮
    [self setNavBarLeftItemAsBackArrow];
    //导航栏右侧按钮
    self.navRightView.frame = Rect_CommunityMessage_NavBarRightItem;
    [self setNavBarItemRightView:self.navRightView];

    //设置代理和数据源
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    self.hidesBottomBarWhenPushed = NO;
    //请求数据
//    [self requestData];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageViewCellTableViewCell" bundle:nil] forCellReuseIdentifier:identify];


    // 添加下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self requestData];
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.objsArray.count == self.pageNum*WaresListPageSize) {
            self.pageNum++;
            [self requestData];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;

    self.pageNum = 1;
    [self requestData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self requestData];
}
#pragma -mark 一键已读按钮
- (IBAction)allRead:(UIButton *)sender {
    NSString*urlStr=[[NSString alloc]init];
    NSString *userid = [[LoginConfig Instance]userID];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [[NSString alloc] init];
    projectId = [userDefault objectForKey:KEY_PROJECTID];//获取项目ID

    urlStr=[NSString stringWithFormat:CommunityMessageNewsreadURL,userid,projectId,@"yes"];
    YjqLog(@"一键已读%@",urlStr);
    //XML解析先转化为数据流
    NSData*data=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    YjqLog(@"%@",data);
    
    //刷新tableView数据
    self.pageNum = 1;
    [self requestData];

}
#pragma mark-请求数据
-(void)requestData
{

    NSString *userid = [[LoginConfig Instance]userID];//获得项目的projectId
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];

    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:projectId,@"projectId",userid,@"userId",@"1",@"toModule",[NSString stringWithFormat:@"%ld",(long)self.pageNum],@"pageNum",@"20",@"perSize",nil];

    //显示加载菊花
    if (!self.hudHidden)
    {
        [self.HUD show:YES];
        [self.view bringSubviewToFront:self.HUD];
    }

    [self getArrayFromServer:CommunityMessage_URL path:CommunityMessage_Path method:@"GET" parameters:dic xmlParentNode:@"/msgPushBeans/msgPush" success:^(NSMutableArray *result) {

        if (self.pageNum == 1) {
            [self.objsArray removeAllObjects];
        }

        for (NSDictionary *dic in result) {
            //创建数据模型
            MessageModel*modelData=[[MessageModel alloc]initWithDictionary:dic];
            //数据模型添加到可变数组
            [self.objsArray addObject:modelData];
        }

        //取消加载菊花
        [self.HUD hide:YES afterDelay:0];

        //存储数据模型
        _dataSourceArray=self.objsArray;

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.objsArray.count < self.pageNum*WaresListPageSize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        //没有数据的时候
        if (_dataSourceArray.count==0) {
            self.tableView.hidden=YES;
            backgroundImg.hidden = NO;
            backgroundImg.frame = CGRectMake((Screen_Width-200)/2,50 , 200, 180);
            backgroundImg.image = [UIImage imageNamed:@"noNoticeImg"];

            [self.view addSubview:backgroundImg];

        }
        else{
            backgroundImg.hidden = YES;
            self.tableView.hidden=NO;
        }
        //刷新tableView数据
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];

}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewDidLoad];
//
//    [self requestData];
//}
#pragma mark-tableView代理和数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   tableView.separatorStyle = UITableViewCellSelectionStyleNone;//去掉cell 分割线
    MessageViewCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    //数据放到cell
       [cell setMessageModelData:_dataSourceArray[indexPath.row]];
        return cell;
}
//返回cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 311-160+20+30;
}
-(NSString *)setMessagePicture:(MessageModel *)modelData
{
    return modelData.pictureString;
}
-(NSString *)setMessageUlr:(MessageModel *)modelData{
    return modelData.urlString;
}
-(NSString *)setMessagemsgid:(MessageModel *)modelData
{
    return modelData.msgIdString;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailViewController*messageDetailVC=[[MessageDetailViewController alloc]init];
    messageDetailVC.messageMsgid=[self setMessagemsgid:_dataSourceArray[indexPath.row]];
//    if ([self setMessagePicture:_dataSourceArray[indexPath.row]].length==0) {
//        return;
//    }
//    else{
        [self.navigationController pushViewController:messageDetailVC animated:YES];
//    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end

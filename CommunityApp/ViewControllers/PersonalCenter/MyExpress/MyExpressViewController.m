//
//  MyExpressViewController.m
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/21.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "MyExpressViewController.h"
#import "MyExpressTableViewCell.h"
#import "ExpressOrderTrackViewController.h"
#import "DispBarcodeViewController.h"
#import "WebViewController.h"
#import <MJRefresh.h>

#define MyExpressTableViewCellNibName       @"MyExpressTableViewCell"
#define PerSize     (10)

@interface MyExpressViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic, retain) NSMutableArray    *expressOrderList;  // 快递订单列表
@property (nonatomic, copy) NSString    *type; // 0为未完成；1为已完成
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation MyExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化导航栏信息
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = @"快递订单";

    
    // 初始化 未完成/已完成 选择框样式
    [self initSelectBtnStyle];
    
    // 初始化基本数据
    [self initBasicDataInfo];
    
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getExpressOrderDataFromServer];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.expressOrderList.count == self.pageNum*PerSize) {
            self.pageNum++;
            [self getExpressOrderDataFromServer];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
    self.tableView.footer = footer;
    
    
    // 从服务器加载数据，刷新列表
    [self getExpressOrderDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 初始化 未完成/已完成 选择按钮点击事件处理函数
- (void)initSelectBtnStyle
{
    [Common setRoundBorder:_btnView borderWidth:0.5 cornerRadius:5 borderColor:Color_Gray_RGB];
    [_leftBtn setBackgroundColor: Color_Orange_RGB];
    [_rightBtn setBackgroundColor:[UIColor whiteColor]];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_leftBtn setTitleColor:COLOR_RGB(57, 57, 57) forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_rightBtn setTitleColor:COLOR_RGB(57, 57, 57) forState:UIControlStateNormal];
}

#pragma mark - 初始化基本数据
- (void)initBasicDataInfo
{
    _expressOrderList = [[NSMutableArray alloc] init];
    _type = @"0";
    _pageNum = 1;
    
    // 注册cell
    UINib *nib = [UINib nibWithNibName:MyExpressTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:MyExpressTableViewCellNibName];
}


#pragma mark - 未完成/已完成 选择按钮点击事件处理函数
- (IBAction)selectBtnClickHandler:(UIButton *)sender
{
    if (sender == _leftBtn) {
        [_leftBtn setSelected:YES];
        [_rightBtn setSelected:NO];
        [_leftBtn setBackgroundColor: Color_Orange_RGB];
        [_rightBtn setBackgroundColor:[UIColor whiteColor]];
        _type = @"0";
        
    }else if (sender == _rightBtn) {
        [_leftBtn setSelected:NO];
        [_rightBtn setSelected:YES];
        [_leftBtn setBackgroundColor:[UIColor whiteColor]];
        [_rightBtn setBackgroundColor:Color_Orange_RGB];
        _type = @"1";
    }
    
    // 从服务器加载数据，刷新列表
    [self getExpressOrderDataFromServer];
}


#pragma mark - 从服务器获取快递订单数据
- (void)getExpressOrderDataFromServer
{
    if (![self isGoToLogin]) {  // 是否已登录
        return;
    }
    
    if (![self isGoToBindPhone]) { // 是否绑定手机号
        return;
    }
    
    NSString *userId = [[LoginConfig Instance] userID];
//    userId = @"1750";
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[userId, _type, [NSString stringWithFormat:@"%ld",(long)_pageNum], [NSString stringWithFormat:@"%ld",(long)PerSize]] forKeys:@[@"userId", @"type", @"pageNum", @"perSize"]];

    
    // 请求服务器获取数据
    [self getArrayFromServer:ExpressManageModule_Url path:MyExpressOrder_Path method:@"GET" parameters:dic xmlParentNode:@"express" success:^(NSMutableArray *result) {
        if(_pageNum == 1)
        {
            [_expressOrderList removeAllObjects];
        }
        for (NSDictionary* listData in result) {
            [_expressOrderList addObject:[[ExpressOrderModel alloc] initWithDictionary:listData]];
        }
        
        if (_expressOrderList.count == 0) {
            [Common showBottomToast:@"没有订单信息"];
        }
        
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (_expressOrderList.count < _pageNum*PerSize) {
            [self.tableView.footer noticeNoMoreData];
        }
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


#pragma mark - UITableView DataSource
// Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}


// Cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _expressOrderList.count;
}


// 加载Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyExpressTableViewCell *cell = (MyExpressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyExpressTableViewCellNibName forIndexPath:indexPath];
    
    ExpressOrderModel *model = [_expressOrderList objectAtIndex:indexPath.row];
    [cell LoadCellData:model];
    
    // 订单跟踪
    [cell setOrderTrackBlock:^{
        ExpressOrderTrackViewController *vc = [[ExpressOrderTrackViewController alloc] init];
//        vc.expressId = model.expressId;
        vc.expressOrderModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // 查看二维码
    [cell setBarcodeBlock:^{
        DispBarcodeViewController *vc = [[DispBarcodeViewController alloc] init];
        vc.qrCodeUrl = model.qrcode;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // 查询快递
    [cell setExpressSearchBlock:^{
        WebViewController *vc = [[WebViewController alloc] init];
        vc.navTitle = @"快递查询";
        NSString *url = @"http://m.kuaidi100.com/index_all.html?type=&postid=";
        url = [url stringByAppendingString:model.expressNo];
//        vc.url = @"http://m.kuaidi100.com/index_all.html?type=&postid=116755693434";
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    return cell;
}


@end

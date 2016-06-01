//
//  ExpressOrderTrackViewController.m
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/22.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ExpressOrderTrackViewController.h"
#import "ExpressOrderTrackTableViewCell.h"


#define ExpressOrderTrackTableViewCellNibName       @"ExpressOrderTrackTableViewCell"

@interface ExpressOrderTrackViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray    *orderTrackList;

@end

@implementation ExpressOrderTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_MyOrderTrack_Title;
    [self setNavBarLeftItemAsBackArrow];
    
    // 初始化基本信息
    [self initBasicDataInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 初始化基本信息
- (void)initBasicDataInfo
{
    _orderTrackList = [[NSMutableArray alloc] init];
    
    // 注册cell
    UINib *nib = [UINib nibWithNibName:ExpressOrderTrackTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:ExpressOrderTrackTableViewCellNibName];
    
    
    [_orderId setText:_expressOrderModel.expressId];
    [self setExpressOrderStatus:_expressOrderModel.stateId];
    
    [self getExpressOrderTrackDataFromServer];
}


// 设置订单状态
- (void)setExpressOrderStatus:(NSString *)stateId
{
    if (stateId) {
        NSString *status = @"";
        switch ([stateId integerValue]) {
            case 0:
                status = @"待寄件";
                break;
                
            case 1:
                status = @"待取件";
                break;
                
            case 2:
                status = @"已寄件";
                break;
                
            case 3:
                status = @"已取件";
                break;
                
            case 4:
                status = @"已取消";
                break;
                
            case 5:
                status = @"已完成";
                break;
                
            default:
                break;
        }
        
        [_orderStatus setText:status];
    }
}



#pragma mark - UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 70.0;
    
    OrderTrackModel *model = [_orderTrackList objectAtIndex:indexPath.row];
    height = [Common labelDemandHeightWithText:model.trackDesc font:[UIFont systemFontOfSize:15.0] size:CGSizeMake(Screen_Width-20, CGFLOAT_MAX)];
    if (height < 20) {
        height = 70.0;
    }else {
        height += 50;
    }
    
    return height;
}


// Cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderTrackList.count;
}


// 加载Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressOrderTrackTableViewCell *cell = (ExpressOrderTrackTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ExpressOrderTrackTableViewCellNibName forIndexPath:indexPath];
    
    [cell loadCellData:[_orderTrackList objectAtIndex:indexPath.row]];
    
    return cell;
}


// 从服务器端获取数据
- (void)getExpressOrderTrackDataFromServer
{
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_expressOrderModel.expressId,@"expressId",nil];
    NSString* url = ExpressManageModule_Url;
    NSString* path = ExpressOrderTrackInfo_Path;
    
    [self getArrayFromServer:url   path:path method:@"GET" parameters:dic xmlParentNode:@"express" success:^(NSMutableArray *result) {
        
        [_orderTrackList removeAllObjects];
        
        for (NSDictionary *dicResult in result){
            [_orderTrackList addObject:[[OrderTrackModel alloc] initWithDictionary:dicResult]];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


@end

//
//  BusinessUserEvaluateViewController.m
//  CommunityApp
//
//  Created by iss on 7/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BusinessUserEvaluateViewController.h"
#import "BusinessUserEvaluateEditViewController.h"
#import "BusinessUserEvaluateTableViewCell.H"
#import "SurroundBusinessReviewModel.h"
#import "LoginConfig.h"
#import <MJRefresh.h>

#define pageSize 10

@interface BusinessUserEvaluateViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) NSMutableArray* reviewsData;
@property (assign,nonatomic) NSInteger pageNum;
@end

@implementation BusinessUserEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = Str_Store_UserEvaluate;
    [self setNavBarLeftItemAsBackArrow];
    [self setNavBarItemRightViewForNorImg:Img_EvaluateEditNor andPreImg:Img_EvaluateEditPre];
    _reviewsData = [[NSMutableArray alloc]init];

    // 初始化本地信息
    [self initBasicDataInfo];
    
    // 顶部下拉刷出更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getReviewsFromService];
    }];
    // 底部上拉刷出更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.reviewsData.count == self.pageNum*pageSize) {
            self.pageNum++;
            [self getReviewsFromService];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.table.header = header;
    self.table.footer = footer;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _pageNum = 1;
    [self getReviewsFromService];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self autoSizeCellHeight:indexPath];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reviewsData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"BusinessUserEvaluateTableViewCell";
    BusinessUserEvaluateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identify owner:self options:nil]lastObject];
    }
    [cell loadCellData:(SurroundBusinessReviewModel*) [self.reviewsData objectAtIndex:indexPath.row]];
    return cell;
}

//导航栏右按钮事件
-(void)navBarRightItemClick
{
    if([self isGoToLogin])
    {
        BusinessUserEvaluateEditViewController* vc = [[BusinessUserEvaluateEditViewController alloc]init];
        vc.sellerId = _sellerId;
        [self.navigationController pushViewController:vc animated:TRUE];
    }

}
#pragma mark---other

-(CGFloat) autoSizeCellHeight:(NSIndexPath *)indexPath
{
    SurroundBusinessReviewModel* review = [self.reviewsData objectAtIndex:indexPath.row];
    NSString* tmp = review.desc;
    CGFloat height = [self autoResizeCellHeight:tmp];
    return height>[BusinessUserEvaluateTableViewCell cellFixHeight]?height:[BusinessUserEvaluateTableViewCell cellFixHeight];
}

-(CGFloat)autoResizeCellHeight:(NSString*)s
{
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect tmpRect = [s boundingRectWithSize:CGSizeMake([BusinessUserEvaluateTableViewCell textWidth], 2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return tmpRect.size.height+[BusinessUserEvaluateTableViewCell textOriginY]+[BusinessUserEvaluateTableViewCell textMarginBottom];
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    //NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:self.businessModel.businessPicUrl]];
    // [self.businessPic setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"BusinessIcon"]];
}
// 从服务器上获取商品数据
- (void)getReviewsFromService
{
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.sellerId, [NSString stringWithFormat:@"%ld",(long)_pageNum], [NSString stringWithFormat:@"%ld", (long)pageSize]] forKeys:@[@"sellerId", @"pageNum", @"perSize"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:SurroundBusiness_Url path:SurroundBusinessReviews_Path method:@"GET" parameters:dic xmlParentNode:@"crmReview" success:^(NSMutableArray *result) {
        if (_pageNum == 1) {
            [_reviewsData removeAllObjects];
        }
        
        for (NSDictionary *dic in result) {
            [self.reviewsData addObject:  [[SurroundBusinessReviewModel alloc] initWithDictionary:dic]];
        }
        [_table reloadData];
        [_table.header endRefreshing];
        [_table.footer endRefreshing];
        if (_reviewsData.count < _pageNum*pageSize) {
            [_table.footer noticeNoMoreData];
        }
    } failure:^(NSError *error) {
        [_table reloadData];
        [_table.header endRefreshing];
        [_table.footer endRefreshing];
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

@end

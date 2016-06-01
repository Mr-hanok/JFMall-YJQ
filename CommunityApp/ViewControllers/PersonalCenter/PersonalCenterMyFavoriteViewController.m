//
//  PersonalCenterMyFavoriteViewController.m
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyFavoriteViewController.h"
#import "PersonalCenterMyFavoriteTableViewCell.h"
#import "GrouponDetailViewController.h"
#import "WaresDetailViewController.h"

#define CELLNIBNAME @"PersonalCenterMyFavoriteTableViewCell"

@interface PersonalCenterMyFavoriteViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) IBOutlet UIButton* commodityBtn;
@property (strong,nonatomic) IBOutlet UIButton* limiteBtn;
@property (strong,nonatomic) IBOutlet UIButton* grouponBtn;

@property (nonatomic, retain) NSMutableArray    *favDataArray;

@property (nonatomic, assign) NSInteger         pageNum;
@property (nonatomic ,assign) NSString          *favSelected;
@property (nonatomic, copy) NSString            *favType;

@end

@implementation PersonalCenterMyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = Str_MyFavorites;
    [self setNavBarLeftItemAsBackArrow];
    
    [self initBasicUIView];
    // 初始化基本信息
    [self initBasicDataInfo];
    
}


#pragma mark - TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favDataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalCenterMyFavoriteTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLNIBNAME forIndexPath:indexPath];
    [cell loadCellData:[self.favDataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Favorite *fav = [self.favDataArray objectAtIndex:indexPath.row];
    NSString *goodsId = fav.goodsId;
    
    switch (self.favSelected.intValue) {
    case 7:
    {
        WaresDetailViewController *vc = [[WaresDetailViewController alloc]init];
        vc.waresId = goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    break;
    case 3:
    {
        WaresDetailViewController *vc = [[WaresDetailViewController alloc]init];
        vc.waresId = goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    break;
    case 4:
    {
        GrouponDetailViewController *vc = [[GrouponDetailViewController alloc]init];
        vc.grouponId = goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    break;
    default:
    break;
    }
}

- (void)initBasicUIView {
    _headerView.layer.borderWidth = 1;
    _headerView.layer.cornerRadius = 5;
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.borderColor = Color_Coupon_Border.CGColor;

    _commodityBtn.selected = YES;
    [self setUIBtnClickState];
}
- (IBAction)clickCommodityBtn:(id)sender {
    _commodityBtn.selected = YES;
    _limiteBtn.selected = NO;
    _grouponBtn.selected = NO;
    [self setUIBtnClickState];
    [self getFavDataFromServer];
}
- (IBAction)clickLimiteBtn:(id)sender {
    _commodityBtn.selected = NO;
    _limiteBtn.selected = YES;
    _grouponBtn.selected = NO;
    [self setUIBtnClickState];
    [self getFavDataFromServer];
}
- (IBAction)clickGrouponBtn:(id)sender {
    _commodityBtn.selected = NO;
    _limiteBtn.selected = NO;
    _grouponBtn.selected = YES;
    [self setUIBtnClickState];
    [self getFavDataFromServer];
}



- (void)setUIBtnClickState {
    _commodityBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _limiteBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _grouponBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    if (_commodityBtn.selected){
        _commodityBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
        self.favSelected = @"7";
    }
    else if (_limiteBtn.selected){
        _limiteBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
        self.favSelected = @"3";
    }
    else if (_grouponBtn.selected){
        _grouponBtn.layer.backgroundColor = Color_Button_Selected.CGColor;
        self.favSelected = @"4";
    }
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.pageNum = 1;
    self.favDataArray = [[NSMutableArray alloc] init];
    
    // 注册CollectionViewCell Nib
    UINib* nib = [UINib nibWithNibName:CELLNIBNAME bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:CELLNIBNAME];
    
    self.favSelected = @"7";
    
    [self getFavDataFromServer];
}


#pragma mark - 从服务器获取收藏夹数据
- (void)getFavDataFromServer
{
    NSString *userId = [[LoginConfig Instance] userID];
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[userId, self.favSelected] forKeys:@[@"userId", @"type"]];

    // 请求服务器获取数据
    [self getArrayFromServer:MyFav_Url path:MyFav_Path method:@"GET" parameters:dic xmlParentNode:@"result" success:^(NSMutableArray *result) {
        [self.favDataArray removeAllObjects];
        for (NSDictionary *dic in result) {
            [self.favDataArray addObject:[[Favorite alloc] initWithDictionary:dic]];
        }
        [self.table reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

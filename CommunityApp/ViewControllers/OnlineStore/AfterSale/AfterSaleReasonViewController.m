//
//  AfterSaleReasonViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/4.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AfterSaleReasonViewController.h"
#import "AfterSaleApplyViewController.h"
#import "AfterSaleReasonTableViewCell.h"
#import "AfterSalesReason.h"

#define AfterSaleReasonTableViewCellNibName @"AfterSaleReasonTableViewCell"

@interface AfterSaleReasonViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *asReasonArray;
@end

@implementation AfterSaleReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化数据
    [self initBaseData];
    // 设置页面头部
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_AfterSale_Reason_Ttile;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initBaseData {
    self.asReasonArray = [[NSMutableArray alloc] init];
    [self getReasonDataFromServer];
    
    UINib *nibForAfterSaleReasonService = [UINib nibWithNibName:AfterSaleReasonTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForAfterSaleReasonService forCellReuseIdentifier:AfterSaleReasonTableViewCellNibName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.asReasonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AfterSaleReasonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AfterSaleReasonTableViewCellNibName forIndexPath:indexPath];

    [cell loadCellData:[self.asReasonArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - 选中某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.asReasonModel){
        self.asReasonModel([self.asReasonArray objectAtIndex:indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 从数据库获取售后原因数据
- (void)getReasonDataFromServer {
    [self getArrayFromServer:GoodsModuleInfo_Url path:RefundReasonList_Path method:@"GET" parameters:nil xmlParentNode:@"afterSalesReason" success:^(NSMutableArray *result) {
        for(NSDictionary *dic in result){
            [self.asReasonArray addObject:[[AfterSalesReason alloc] initWithDictionary:dic]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    
}
@end

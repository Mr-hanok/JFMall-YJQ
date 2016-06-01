//
//  JFOrderFollowViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/5/4.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFOrderFollowViewController.h"
#import "JFOrederFollowCell.h"
#import "APIOrderFollowRequest.h"

@interface JFOrderFollowViewController ()<UITableViewDataSource,UITableViewDelegate,APIRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

@property (nonatomic, strong) APIOrderFollowRequest *api;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation JFOrderFollowViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.tableview.backgroundColor = self.headView.backgroundColor=self.view.backgroundColor;
    CGRect newFrame = self.headView.frame;
    newFrame.size.height = 50.f;
    self.headView.frame = newFrame;
    self.tableview.tableHeaderView = self.headView;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    self.array = [NSMutableArray array];
    [HUDManager showLoadingHUDView:kWindow];
    self.api = [[APIOrderFollowRequest alloc]initWithDelegate:self];
    [self.api setApiParamsWithOrderId:self.oid];
    [APIClient execute:self.api];
}
#pragma mark -  APIRequestDelegate

- (void)serverApi_RequestFailed:(APIRequest *)api error:(NSError *)error {
    
    [HUDManager hideHUDView];
    [HUDManager showWarningWithText:kDefaultNetWorkErrorString];
}

- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr {
    
    [HUDManager hideHUDView];
    if (sr.dic == nil || [sr.dic isKindOfClass:[NSNull class]]) {
        return;
    }
    self.orderNumLabel.text = [ValueUtils stringFromObject:[sr.dic objectForKey:@"order_id"]];
    NSString *state = [ValueUtils stringFromObject:[sr.dic objectForKey:@"order_status"]];
    if ([state isEqualToString:@"20"]) {
       self.orderStateLabel.text = @"待发货";
    }else if ([state isEqualToString:@"30"]){
        self.orderStateLabel.text = @"待收货";
    }else if ([state isEqualToString:@"40"]){
        self.orderStateLabel.text = @"已完成";
    }
    self.array = [sr.dic objectForKey:@"logs"];
    [self.tableview reloadData];
    
}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) {
        message = kDefaultServerErrorString;
    }
    [HUDManager showWarningWithText:message];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JFOrederFollowCell *cell = [JFOrederFollowCell tableView:self.tableview cellForRowInTableViewIndexPath:indexPath];
    [cell configCellWith:self.array[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
/**设置cell高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.array[indexPath.row];
    return [JFOrederFollowCell heightOfCellWithText:[dic objectForKey:@"log_info"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - event response
#pragma mark - private methods

@end

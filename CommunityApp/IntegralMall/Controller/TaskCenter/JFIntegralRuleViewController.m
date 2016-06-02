//
//  JFIntegralRuleViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/4/27.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFIntegralRuleViewController.h"
#import "JFIntegralRuleCell.h"
#import "APIIntegralRuleRequest.h"

@interface JFIntegralRuleViewController ()<UITableViewDataSource,UITableViewDelegate,APIRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) APIIntegralRuleRequest *api;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation JFIntegralRuleViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.array = [NSMutableArray array];
    self.tableview.tableFooterView = [[UIView alloc]init];
    [HUDManager showLoadingHUDView:kWindow];
    self.api = [[APIIntegralRuleRequest alloc]initWithDelegate:self];
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
    self.array = [sr.dic objectForKey:@"integralRuleDescList"];
    if (self.array.count == 0) {
        [HUDManager showWarningWithText:@"暂无数据!"];
    }
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
    
    JFIntegralRuleCell *cell = [JFIntegralRuleCell tableView:self.tableview cellForRowInTableViewIndexPath:indexPath];
    [cell configCellWithDic:self.array[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
/**设置cell高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.array[indexPath.row];
    NSString *str = [dic objectForKey:@"content"];;
    return [JFIntegralRuleCell heightOfCellWithText:str];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - event response
#pragma mark - private methods
@end

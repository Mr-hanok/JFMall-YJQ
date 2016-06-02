//
//  JFPrizeListViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/6/2.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFPrizeListViewController.h"
#import "JFPrizeCell.h"
#import "JFPrizeModel.h"
#import "APIPrizeListRequest.h"

@interface JFPrizeListViewController ()<UITableViewDataSource,UITableViewDelegate,APIRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) APIPrizeListRequest *apiPrizeList;

@end

@implementation JFPrizeListViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.array = [NSMutableArray array];
    self.tableview.backgroundColor = self.view.backgroundColor;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    [HUDManager showLoadingHUDView:kWindow];
    self.apiPrizeList = [[APIPrizeListRequest alloc]initWithDelegate:self];
    [self.apiPrizeList setApiParamsWithActivity_type:self.active_type];
    [APIClient execute:self.apiPrizeList];
}
//设置分割线距离0
-(void)viewDidLayoutSubviews
{
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) [self.tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])  [self.tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
}

#pragma mark - 协议名
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
    if (api == self.apiPrizeList) {//中奖列表
        NSArray *myWinList = [sr.dic objectForKey:@"myWinList"];
        for (NSDictionary *dic in myWinList) {
            JFPrizeModel *model = [JFPrizeModel yy_modelWithDictionary:dic];
            [self.array addObject:model];
        }
        
        [self.tableview reloadData];
    }

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
    JFPrizeModel *model = self.array[indexPath.row];
    JFPrizeCell *cell = [JFPrizeCell tableView:self.tableview cellForRowInTableViewIndexPath:indexPath prize_type:model.prize_type];
    [cell configCellWithModel:model];
    return cell;
}
//设置分割线距离0
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])  [cell setLayoutMargins:UIEdgeInsetsZero];
    
}
#pragma mark - UITableViewDelegate
/**设置cell高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [JFPrizeCell cellHeigthWithModel:self.array[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - event response

#pragma mark - private methods

@end

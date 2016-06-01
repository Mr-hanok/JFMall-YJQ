//
//  IntegralDetailViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/4/22.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFIntegralDetailViewController.h"
#import "JFIntegralDetailCell.h"
#import <MJRefresh.h>
#import "APIIntegralDetailRequest.h"
#import "PageManager.h"
#import "JFIntegralLogModel.h"

@interface JFIntegralDetailViewController ()<UITableViewDataSource,UITableViewDelegate,APIRequestDelegate,PageManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageIV;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UIView *slideView;
@property (weak, nonatomic) IBOutlet UIButton *allRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *payRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *outtimeRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *incomeRecordBtn;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) PageManager *pageManager;
@property (nonatomic, strong) APIIntegralDetailRequest *api;
@property (nonatomic, assign) IntegralDetailType integralType;

@end

@implementation JFIntegralDetailViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    CGRect newFrame = self.headView.frame;
    newFrame.size.height = 215.f;
    self.headView.frame = newFrame;
    self.headView.backgroundColor = self.view.backgroundColor;
    self.tableview.tableHeaderView = self.headView;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    self.array = [NSMutableArray array];
    self.integralType = IntegralDetailTypeAll;
    self.api = [[APIIntegralDetailRequest alloc]initWithDelegate:self];
    self.pageManager = [PageManager handlerWithDelegate:self TableView:self.tableview];
    [self.tableview.mj_header beginRefreshing];
    
    [self.allRecordBtn setTitleColor:HEXCOLOR(0x434751) forState:UIControlStateNormal];
    [self.allRecordBtn setTitleColor:HEXCOLOR(0xE87F30) forState:UIControlStateSelected];
    [self.payRecordBtn setTitleColor:HEXCOLOR(0x434751) forState:UIControlStateNormal];
    [self.payRecordBtn setTitleColor:HEXCOLOR(0xE87F30) forState:UIControlStateSelected];
    [self.outtimeRecordBtn setTitleColor:HEXCOLOR(0x434751) forState:UIControlStateNormal];
    [self.outtimeRecordBtn setTitleColor:HEXCOLOR(0xE87F30) forState:UIControlStateSelected];
    [self.incomeRecordBtn setTitleColor:HEXCOLOR(0x434751) forState:UIControlStateNormal];
    [self.incomeRecordBtn setTitleColor:HEXCOLOR(0xE87F30) forState:UIControlStateSelected];
    self.allRecordBtn.selected = YES;

}
-(void)viewDidLayoutSubviews
{
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
#pragma mark -  APIRequestDelegate

- (void)serverApi_RequestFailed:(APIRequest *)api error:(NSError *)error {
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    [HUDManager hideHUDView];
    [HUDManager showWarningWithText:kDefaultNetWorkErrorString];
}

- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr {
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    [HUDManager hideHUDView];
    
    if (sr.dic == nil || [sr.dic isKindOfClass:[NSNull class]]) {
        return;
    }
    if (api == self.api) {
        if (self.api.requestCurrentPage == 1)[self.array removeAllObjects];
        api.requestCurrentPage ++;
        NSArray *IntegralLogs = [sr.dic objectForKey:@"integralLogs"];
        for (NSDictionary *log in IntegralLogs) {
            JFIntegralLogModel *model = [JFIntegralLogModel yy_modelWithDictionary:log];
            [self.array addObject:model];
        }
        //排序
        [self.array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            JFIntegralLogModel *l1 = (JFIntegralLogModel *)obj1;
            JFIntegralLogModel *l2 = (JFIntegralLogModel *)obj2;
            return  [l2.addTime compare:l1.addTime];
        }];

        self.integralLabel.text = [ValueUtils stringFromObject:[sr.dic objectForKey:@"integral"]];

        if (self.array.count ==0){
            double delayInSeconds = .2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [HUDManager showWarningWithText:@"没有记录哦~"];
            });
        }
        [self.tableview reloadData];
    }
    
}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) {
        message = kDefaultServerErrorString;
    }
    [HUDManager showWarningWithText:message];
}
#pragma mark - PageManagerDelegate
- (void)headerRefreshing {
    self.api.requestCurrentPage = 1;
    [self.api setApiParamsWithType:self.integralType];
    [APIClient execute:self.api];
}
- (void)footerRereshing {
    [self.api setApiParamsWithType:self.integralType];
    [APIClient execute:self.api];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JFIntegralDetailCell *cell = [JFIntegralDetailCell tableView:self.tableview cellForRowInTableViewIndexPath:indexPath];
    JFIntegralLogModel *model = self.array[indexPath.row];
    [cell configCellWithIntegralModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - UITableViewDelegate
/**设置cell高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 42;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self pushWithVCClassName:@"JFIntegralOrderViewController" properties:@{@"title":@"积分订单"}];
}

#pragma mark - event response
- (IBAction)slideBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.25f animations:^{
        self.slideView.center = CGPointMake(sender.center.x, self.slideView.center.y);
    }];
    switch (sender.tag) {
        case IntegralDetailTypeAll://全部记录
            self.outtimeRecordBtn.selected = self.payRecordBtn.selected = self.incomeRecordBtn.selected = NO;
            self.integralType = IntegralDetailTypeAll;
            break;
            
        case IntegralDetailTypeIncome://收入记录
            self.outtimeRecordBtn.selected = self.payRecordBtn.selected = self.allRecordBtn.selected = NO;
            self.integralType = IntegralDetailTypeIncome;
            break;
            
        case IntegralDetailTypePayRecord://支出记录
            self.outtimeRecordBtn.selected = self.allRecordBtn.selected = self.incomeRecordBtn.selected = NO;
            self.integralType = IntegralDetailTypePayRecord;
            break;
            
        case IntegralDetailTypeOutTime://过期记录
            self.allRecordBtn.selected = self.payRecordBtn.selected = self.incomeRecordBtn.selected = NO;
            self.integralType = IntegralDetailTypeOutTime;
            break;
    }
    [HUDManager showLoadingHUDView:self.view];
    [self headerRefreshing];
    
}
#pragma mark - private methods

@end
